LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.math_real.ALL;

ENTITY mod_m_counter_prog IS
    GENERIC (
        M : NATURAL -- Modulo
    );
    PORT (
        clk_i : IN STD_LOGIC;
        reset_i : IN STD_LOGIC;
        run_i : IN STD_LOGIC;
        max_count_i : IN STD_LOGIC_VECTOR (NATURAL(ceil(log2(real(M)))) - 1
        DOWNTO 0);
        count_o : OUT STD_LOGIC_VECTOR (NATURAL(ceil(log2(real(M)))) - 1
        DOWNTO 0);
        max_o : OUT STD_LOGIC
    );
END ENTITY;

ARCHITECTURE mod_m_counter_prog_arch OF mod_m_counter_prog IS
    CONSTANT NUM_BITS : NATURAL := NATURAL(ceil(log2(real(M))));
    SIGNAL r_reg : unsigned(NUM_BITS - 1 DOWNTO 0);
    SIGNAL r_next : unsigned(NUM_BITS - 1 DOWNTO 0);
BEGIN
    NXT_STATE_PROC : PROCESS (clk_i)
    BEGIN
        IF rising_edge(clk_i) THEN
            IF (reset_i = '1') THEN
                r_reg <= (OTHERS => '0');
            ELSIF run_i = '1' THEN
                r_reg <= r_next;
            END IF;
        END IF;
    END PROCESS;
    r_next <= (OTHERS => '0') WHEN r_reg = unsigned(max_count_i) ELSE
        r_reg + 1;
    max_o <= '1' WHEN r_reg = unsigned(max_count_i) AND (run_i = '1') ELSE
        '0';
    count_o <= STD_LOGIC_VECTOR(r_reg);
END ARCHITECTURE;
