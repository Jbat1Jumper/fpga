library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;


entity PulseGenerator is
    Generic (
		  CLK_FREQ : real := 50.0e6;
        PULSE_FREQ : real := 44100.0e3
    );
    Port (
        CLK : IN STD_LOGIC;
        RST : IN STD_LOGIC;
        PULSE_OUT : OUT STD_LOGIC
    );
end entity;

architecture PulseGenerator_Arch OF PulseGenerator IS
	 
    constant CLK_PER_PULSE : real := CLK_FREQ / PULSE_FREQ;
    constant CLK_COUNT_WORD_WIDTH : natural := NATURAL(ceil(log2(CLK_PER_PULSE)));
	 signal clk_count       : unsigned(CLK_COUNT_WORD_WIDTH- 1 downto 0);
    signal pulse_enable : STD_LOGIC := '0';
	 
begin

    count_system_clocks_per_pulse: process (CLK)
    begin
        if (rising_edge(CLK)) then
            if (RST = '0') then
                clk_count <= (others => '0');
            else
                if (pulse_enable = '1') then
                    clk_count <= (others => '0');
                else
                    clk_count <= clk_count + 1;
                end if;
            end if;
        end if;
    end process;
	 
    pulse_enable <= '1' when (clk_count = to_unsigned(natural(CLK_PER_PULSE)-1, CLK_COUNT_WORD_WIDTH)) else '0';
    PULSE_OUT <= pulse_enable;
	 
end architecture;
