library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;


entity Board is
    Generic (
        PERIOD : natural := 25e5;
        N : natural := 3;
		  B : natural := 9
    );
    Port (
        CLK : IN STD_LOGIC;
        RST : IN STD_LOGIC;
		  LEDS : OUT STD_LOGIC_vector(3 downto 0)
    );
end entity;


architecture Board_arch OF Board IS

	 signal digit_to_show : unsigned(1 downto 0) := to_unsigned(0, 2); 

    signal clk_count         : unsigned(25 downto 0) := to_unsigned(0, 26);
    signal period_reached    : std_logic := '0';
	 
	 type ConnectVector is array(N-1 downto 0) of std_logic_vector(NATURAL(ceil(log2(real(B))))-1 downto 0);
	 signal count : ConnectVector;
	 
	 type HandshakeVector is array(N downto 0) of std_logic;
	 signal run : HandshakeVector;
		 
		 
	component contador IS
		 GENERIC (
			  M : NATURAL
		 );
		 PORT (
			  clk_i : IN STD_LOGIC;
			  reset_i : IN STD_LOGIC;
			  run_i : IN STD_LOGIC;
			  max_count_i : IN STD_LOGIC_VECTOR (NATURAL(ceil(log2(real(M)))) - 1 DOWNTO 0);
			  count_o : OUT STD_LOGIC_VECTOR (NATURAL(ceil(log2(real(M)))) - 1
			  DOWNTO 0);
			  max_o : OUT STD_LOGIC
		 );
	END component;

begin
	 
	count_system_clock : process (CLK)
   begin
        if (rising_edge(CLK)) then
            if (period_reached = '1') then 
                clk_count <= (others => '0');
            else
                clk_count <= clk_count + 1;
            end if;
        end if;
   end process;

   period_reached <= '1' when (clk_count = to_unsigned(PERIOD-1, 26)) else '0';

	
	counter_instances: for j in 0 to N-1 generate
	begin
		ITERATION: contador
			generic map(B)
			port map(
			  clk_i => period_reached,
			  reset_i => '0',
			  run_i => run(j),
			  max_count_i => std_LOGIC_vEcToR(to_unsigned(B, NATURAL(ceil(log2(real(B)))))),
			  count_o => count(j),
			  max_o => run(j+1)
			);
	 end generate;

	 run(0) <= '1';
	 
	change_digit_to_show : process (RST)
   begin
       if (rising_edge(RST)) then
			digit_to_show <= digit_to_show + 1;
       end if;
   end process;
	
	 led_output : process (CLK)
    begin
        case digit_to_show is
            when "00" =>
					LEDS <= not count(0);
            
            when "01" =>
					LEDS <= not count(1);

            when "10" =>
					LEDS <= not count(2);

            when oThErs =>
               LEDS <= (others => '0');
        end case;
    end process;

	
	 
end architecture;
