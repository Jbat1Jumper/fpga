library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;


entity Board is
    Generic (
        PERIOD : natural := 25e4;
        N : natural := 10
    );
    Port (
        CLK : IN STD_LOGIC;
        RST : IN STD_LOGIC;

		  LED_A : OUT STD_LOGIC;
		  LED_B : OUT STD_LOGIC;
        LED_C : OUT STD_LOGIC
    );
end entity;


architecture Board_arch OF Board IS

    signal clk_count         : unsigned(25 downto 0);
    signal duty_cycle_a      : unsigned(N downto 0) := to_unsigned(0, N+1);
    signal duty_cycle_b      : unsigned(N downto 0) := to_unsigned(0, N+1);
    signal duty_cycle_c      : unsigned(N downto 0) := to_unsigned(0, N+1);
    signal period_reached    : std_logic := '0';

begin
	 
	count_system_clock : process (CLK)
   begin
        if (rising_edge(CLK)) then
            if (RST = '0') then
                clk_count <= (others => '0');
            elsif (period_reached = '1') then 
                clk_count <= (others => '0');
            else
                clk_count <= clk_count + 1;
            end if;
        end if;
   end process;

   period_reached <= '1' when (clk_count = to_unsigned(PERIOD, 26)) else '0';

	
	vary_duty_cycle : process (CLK)
   begin
        if (rising_edge(CLK) and period_reached = '1') then
            duty_cycle_a <= duty_cycle_a + 1;
            duty_cycle_b <= duty_cycle_b + 2;
            duty_cycle_c <= duty_cycle_c + 3;
        end if;
   end process;
	
    dimmer_led_a : entity work.dimmer
    GENERIC MAP(
        N => N
    )
    PORT MAP(
        clk_i => CLK,
        reset_i => not RST,
        duty_cycle_i => std_logic_vector(duty_cycle_a),
        out_o => LED_A
    );
	 
    dimmer_led_b : entity work.dimmer
    GENERIC MAP(
        N => N
    )
    PORT MAP(
        clk_i => CLK,
        reset_i => not RST,
        duty_cycle_i => std_logic_vector(duty_cycle_b),
        out_o => LED_B
    );
    
	 dimmer_led_c : entity work.dimmer
    GENERIC MAP(
        N => N
    )
    PORT MAP(
        clk_i => CLK,
        reset_i => not RST,
        duty_cycle_i => std_logic_vector(duty_cycle_c),
        out_o => LED_C
    );
	 
end architecture;
