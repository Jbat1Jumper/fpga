library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;


entity Board is
    Generic (
		  CLK_FREQ : real := 50.0e6;
        SAMPLE_FREQ : real := 44100.0e3
    );
    Port (
        CLK : IN STD_LOGIC;
        RST : IN STD_LOGIC;
		  
		  UART_RXD : IN STD_LOGIC;
		  MONO_OUT : OUT STD_LOGIC;

		  LED_A : OUT STD_LOGIC;
		  LED_B : OUT STD_LOGIC;
        LED_C : OUT STD_LOGIC
    );
end entity;

architecture Board_arch OF Board IS
    constant W : natural := 16;
	 
    signal sample_enable    : std_logic := '0';

    type state_t is (turned_off, first_led, second_led, third_led);

    signal led_on : std_logic := '0';
    signal present_state   : state_t := turned_off;
    signal next_state      : state_t := turned_off;
	 
	 signal midi_data_in : std_logic_vector(7 downto 0);
	 signal midi_data_in_valid : std_logic;
	 signal FRAME_ERROR : std_logic;
	 signal PARITY_ERROR : std_logic;
	 
	 
	 
    signal note_change_enable    : std_logic := '0';
    signal current_note    : unsigned(1 downto 0) := (others => '0');
	 
	  
    constant MAX_FREQ : natural := 2**(W-2);
	 signal freq : unsigned(W-1 downto 0) := (others => '0');
	 
	 signal phase_delta : unsigned(W-1 downto 0) := (others => '0');
	 
	 signal phase_signal : unsigned(W-1 downto 0) := (others => '0');
	 
	 signal output_signal : unsigned(W-1 downto 0) := (others => '0');
	 
	 signal noise_signal : unsigned(W-1 downto 0) := (others => '0');
	 
begin

	 note_change_pulse : entity work.PulseGenerator
    generic map (
        CLK_FREQ    => CLK_FREQ,
        PULSE_FREQ  => 1.0
    )
    port map (
        CLK          => CLK,
        RST          => RST,
		  PULSE_OUT    => note_change_enable
	 );
	 
	 note_change_update_freq : process (CLK)
	 begin
        if (rising_edge(CLK)) then
            if (RST = '0') then
                current_note <= (others => '0');
            else
                if (note_change_enable = '1') then
                    current_note <= current_note + 1;
							case current_note is
								 when to_unsigned(0, 2) =>
									  freq <= to_unsigned(natural(261.63 * 4.0), W);

								 when to_unsigned(1, 2) =>
									  freq <= to_unsigned(natural(329.63 * 4.0), W);

								 when to_unsigned(2, 2) =>
									  freq <= to_unsigned(natural(392.00 * 4.0), W);
								 
								 when to_unsigned(3, 2) =>
									  freq <= to_unsigned(natural(493.88 * 4.0), W);
							end case;
                end if;
            end if;
        end if;
	 end process;
	
	
	 


	 sample_pulse : entity work.PulseGenerator
    generic map (
        CLK_FREQ    => CLK_FREQ,
        PULSE_FREQ  => SAMPLE_FREQ
    )
    port map (
        CLK          => CLK,
        RST          => RST,
		  PULSE_OUT    => sample_enable
	 );
	 
	 phase_delta <= freq;
	 
	 
    rotate_phase : process (CLK)
    begin
        if (rising_edge(CLK)) then
            if (RST = '0') then
                phase_signal <= (others => '0');
            else
                if (sample_enable = '1') then 
                    phase_signal <= phase_signal + phase_delta;
                end if;
            end if;
        end if;
    end process;
	 
	 output_signal <= phase_signal;
	 
	
	 
    generate_noise_signal : process (CLK)
    begin
        if (rising_edge(CLK)) then
            if (RST = '0') then
                noise_signal <= (others => '0');
            else
					 noise_signal <= noise_signal + (2**9);
            end if;
        end if;
    end process;
	 
	 
	 MONO_OUT <= '1' when (noise_signal < output_signal) else '0';
	 


	 midi_uart : entity work.UART
    generic map (
        CLK_FREQ    => natural(CLK_FREQ),
        BAUD_RATE   => 115200,
        PARITY_BIT  => "none",
		  USE_DEBOUNCER => False
    )
    port map (
        CLK          => CLK,
        RST          => not RST,
        -- UART INTERFACE
        UART_TXD     => open,
        UART_RXD     => UART_RXD,
        -- USER DATA INPUT INTERFACE
        DIN          => (others => '0'),
        DIN_VLD      => '0',
        DIN_RDY      => open,
        -- USER DATA OUTPUT INTERFACE
        DOUT         => midi_data_in,
        DOUT_VLD     => midi_data_in_valid,
        FRAME_ERROR  => FRAME_ERROR,
        PARITY_ERROR => PARITY_ERROR
    );
	 
    debug_led : process (FRAME_ERROR)
    begin
		if (rising_edge(FRAME_ERROR)) then
			led_on <= not led_on;
		end if;
    end process;
	 
	 LED_C <= led_on;

    state_transitions : process (midi_data_in_valid)
    begin
        if (midi_data_in_valid = '1') then
            case midi_data_in is
                when "00000001" =>
                    next_state <= first_led;

                when "00000010" =>
                    next_state <= second_led;

                when "00000011" =>
                    next_state <= third_led;
                
                when others =>
                    next_state <= turned_off;
            end case;
        end if;
    end process;

    change_state : process (CLK)
    begin
        if (rising_edge(CLK)) then
            if (RST = '0') then
                present_state <= turned_off;
            else
                present_state <= next_state;
            end if;
        end if;
    end process;

    led_output : process (CLK)
    begin
        case present_state is
            when turned_off =>
                LED_A <= '1';
                LED_B <= '1';
                --LED_C <= '1';
            
            when first_led =>
                LED_A <= '0';
                LED_B <= '1';
                --LED_C <= '1';

            when second_led =>
                LED_A <= '1';
                LED_B <= '0';
                --LED_C <= '1';

            when third_led =>
                LED_A <= '0';
                LED_B <= '0';
                --LED_C <= '0';
        end case;
    end process;

end architecture;
