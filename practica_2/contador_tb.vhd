LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;


ENTITY mod_m_counter_tb IS
END mod_m_counter_tb;

ARCHITECTURE behavior OF mod_m_counter_tb IS
    CONSTANT M : NATURAL := 6;
    --Inputs
    SIGNAL clk_i : STD_LOGIC := '1';
    SIGNAL reset_i : STD_LOGIC := '1';
    SIGNAL run_i : STD_LOGIC := '0';
    --Outputs
    SIGNAL count_o : STD_LOGIC_VECTOR(NATURAL(ceil(log2(real(M)))) - 1 DOWNTO 0);
    SIGNAL max_o : STD_LOGIC;
    SIGNAL max_count : STD_LOGIC_VECTOR (NATURAL(ceil(log2(real(M)))) - 1 DOWNTO 0);
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
    reset_i <= '1', '0' AFTER 5 us, '1' after 30 us, '0' after 40 us;
    run_i <= '0', '1' AFTER 20 us, '0' AFTER 90 us;

    -- Instantiate the Unit Under Test (UUT)
    uut : entity work.contador
    GENERIC MAP(
        M => M -- Modulo
    )
    PORT MAP(
        clk_i => clk_i,
        reset_i => reset_i,
        run_i => run_i,
        max_count_i => max_count,
        count_o => count_o,
        max_o => max_o
    );
END ARCHITECTURE;