LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;

ENTITY dimmer IS
    GENERIC (
        N : NATURAL
    );
    PORT (
        clk_i : IN STD_LOGIC;
        duty_cycle_i : IN STD_LOGIC_VECTOR (N - 1 DOWNTO 0);
        out_o : OUT STD_LOGIC
    );
END ENTITY;



ARCHITECTURE dimmer_arch OF dimmer IS
    CONSTANT MAX_COUNT : NATURAL := NATURAL(2 ** N);
    SIGNAL count_o : STD_LOGIC_VECTOR(N - 1 DOWNTO 0);
begin

    C1 : entity work.mod_m_counter_prog
    GENERIC MAP(
        M => MAX_COUNT
    )
    PORT MAP(
        clk_i => clk_i,
        reset_i => '0',
        run_i => '1',
        max_count_i => STD_LOGIC_VECTOR(to_unsigned(MAX_COUNT, N)),
        count_o => count_o,
        max_o => open
    );

    out_o <= '1' when unsigned(count_o) < unsigned(duty_cycle_i) else '0';

END ARCHITECTURE;