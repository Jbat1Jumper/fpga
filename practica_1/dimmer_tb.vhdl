LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;


ENTITY dimmer_tb IS
END dimmer_tb;

ARCHITECTURE behavior OF dimmer_tb IS
    CONSTANT N : NATURAL := 3;
    --Inputs
    SIGNAL clk_i : STD_LOGIC := '1';
    SIGNAL reset_i : STD_LOGIC := '1';
    SIGNAL duty_cycle_i : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
    SIGNAL out_o : STD_LOGIC;
    -- Clock period definitions
    CONSTANT clk_period : TIME := 1 us;
BEGIN
    -- Clock process definitions
    clk_process : PROCESS
    BEGIN
        clk_i <= '0';
        WAIT FOR clk_period/2;
        clk_i <= '1';
        WAIT FOR clk_period/2;
    END PROCESS;

    duty_cycle_i <= "000", "111" AFTER 15 us, "011" after 30 us, "000" after 45 us;
    reset_i <= '1', '0' AFTER 5 us;

    -- Instantiate the Unit Under Test (UUT)
    uut : entity work.dimmer
    GENERIC MAP(
        N => N
    )
    PORT MAP(
        clk_i => clk_i,
        reset_i => reset_i,
        duty_cycle_i => duty_cycle_i,
        out_o => out_o
    );
END ARCHITECTURE;
