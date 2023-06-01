library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;


entity Board is
    Generic (
		  N : natural := 8
    );
    Port (
        CLK : IN STD_LOGIC;
        RST : IN STD_LOGIC;
		  LEDS : OUT STD_LOGIC_vector(2 downto 0);
        -- UART INTERFACE
        UART_TXD     : out std_logic; -- serial transmit data
        UART_RXD     : in  std_logic
    );
end entity;


architecture Board_arch OF Board IS

	constant AMP : signed(N-1 downto 0) := to_signed(2**(N-3), N);

    signal clk_count       : unsigned(25 downto 0);
	 
	 signal x_i  : std_logic_vector(N-1 downto 0) := std_logic_vector(AMP);
	 signal y_i  : std_logic_vector(N-1 downto 0) := (others =>'0');
	 signal z_i  : std_logic_vector(N-1 downto 0) := (others =>'0');
	 signal x_o  : std_logic_vector(N-1 downto 0);
	 signal y_o  : std_logic_vector(N-1 downto 0);
	 signal z_o  : std_logic_vector(N-1 downto 0);
	 
	 
    signal request_data_in       : std_logic_vector(7 downto 0);
    signal request_data_in_valid : std_logic;
	 
    signal response_data_out       : std_logic_vector(7 downto 0);
    signal response_data_out_valid : std_logic;
    signal can_send_data_now   : std_logic;

begin
	 
	count_system_clock : process (CLK)
    begin
        if (rising_edge(CLK)) then
            if (RST = '0') then
                clk_count <= (others => '0');
            else
                clk_count <= clk_count + 1;
            end if;
        end if;
    end process;
		 
	 cordic_instance: entity work.cordic
	  generic map(
		 N     => N,
		 ITER  => 10
	  )
	  port map(
		 x_i   =>  x_i,
		 y_i   =>  y_i,
		 z_i   =>  z_i,
		 x_o  =>  x_o,
		 y_o  =>  y_o,
		 z_o  =>  z_o
	  );
	  
	 z_i <= std_logic_vector(clk_count)(25 downto (25-N+1));
	 
    led_output : process (y_o)
    begin
			if signed(y_o) > AMP / 2 then
            LEDS <= "110";
			elsif signed(y_o) < -AMP/2 then
            LEDS <= "011";
			else
            LEDS <= "101";
         end if;
    end process;
	 
	 
	 
	 uart_instance: entity work.UART
	 generic map(
        CLK_FREQ      : integer := 25e6;
        BAUD_RATE     : integer := 9600;
        PARITY_BIT    : string  := "none";
        USE_DEBOUNCER : boolean := True
	 )
	 port map(
        -- CLOCK AND RESET
        CLK          => CLK;
        RST          => not RST; -- 'not' pq el reset del board es low-active
		  
        -- UART INTERFACE
        UART_TXD     => UART_TXD;
        UART_RXD     => UART_RXD;
		  
		  -- datos que vienen del puerto serie
        DOUT         => request_data_in;
        DOUT_VLD     => request_data_in_valid;
        FRAME_ERROR  => open;
        PARITY_ERROR => open;
		  
        -- datos que mandamos al puerto serie
        DIN          => response_data_out;
        DIN_VLD      => response_data_out_valid;
        DIN_RDY      => can_send_data_now;
        
	 );
	 

end architecture;
