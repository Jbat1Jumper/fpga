library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;


entity SampleClock is
    Generic (
		CLK_FREQ : natural := 50e6;
        SAMPLE_FREQ : natural := 44100e3;
        T_WORD_WIDTH : natural := 16
    );
    Port (
        CLK : IN STD_LOGIC;
        RST : IN STD_LOGIC;
        T : OUT std_logic_vector(T_WORD_WIDTH-1 downto 0) := (others => '0')
    );
end entity;


architecture SampleClock_arch OF SampleClock IS

    constant CLK_PER_SAMPLE : natural := CLK_FREQ / SAMPLE_FREQ;
    constant CLK_COUNT_WORD_WIDTH : natural := NATURAL(ceil(log2(real(CLK_PER_SAMPLE))));

    signal clk_count : unsigned(CLK_COUNT_WORD_WIDTH - 1 downto 0) := (others => '0');
    signal period_reached    : std_logic := '0';
    signal sample_count     : unsigned(T_WORD_WIDTH - 1 downto 0) := (others => '0');

begin

    count_system_clock : process (CLK)
    begin
        if (rising_edge(CLK)) then
            if (RST = '1') then
                clk_count <= (others => '0');
            else
                if (period_reached = '1') then 
                    clk_count <= (others => '0');
                else
                    clk_count <= clk_count + 1;
                end if;
            end if;
        end if;
    end process;

    period_reached <= '1' when (clk_count = to_unsigned(CLK_PER_SAMPLE-1, CLK_COUNT_WORD_WIDTH)) else '0';

    count_samples : process (CLK)
    begin
        if (rising_edge(CLK)) then
            if (RST = '1') then
                sample_count <= (others => '0');
            else
                if (period_reached = '1') then 
                    sample_count <= sample_count + 1;
                else
                    sample_count <= sample_count;
                end if;
            end if;
        end if;
    end process;

    T <= std_logic_vector(sample_count);

end architecture;
