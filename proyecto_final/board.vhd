library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;


entity Board is
    Generic (
		  CLK_FREQ : natural := 50e6
    );
    Port (
        CLK : IN STD_LOGIC;
        RST : IN STD_LOGIC;
		  
		  UART_RXD : IN STD_LOGIC;
		  UART_TXD : OUT STD_LOGIC;

		  LED_A : OUT STD_LOGIC;
		  LED_B : OUT STD_LOGIC;
        LED_C : OUT STD_LOGIC
    );
end entity;


architecture Board_arch OF Board IS

    type state_t is (turned_off, first_led, second_led, third_led);

	signal clk_count       : unsigned(25 downto 0);
    signal led_on : std_logic := '0';
    signal present_state   : state_t := turned_off;
    signal next_state      : state_t := turned_off;
	 
	 signal midi_data_in : std_logic_vector(7 downto 0);
	 signal midi_data_in_valid : std_logic;
	 signal FRAME_ERROR : std_logic;
	 signal PARITY_ERROR : std_logic;

begin


	 midi_uart : entity work.UART
    generic map (
        CLK_FREQ    => CLK_FREQ,
        BAUD_RATE   => 115200,
        PARITY_BIT  => "none",
		  USE_DEBOUNCER => False
    )
    port map (
        CLK          => CLK,
        RST          => not RST,
        -- UART INTERFACE
        UART_TXD     => UART_TXD,
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
