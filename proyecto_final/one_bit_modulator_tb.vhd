library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;


entity OneBitModulator_tb is
end entity;

architecture Behavioral of OneBitModulator_tb is

    constant clk_period  : time := 1 ns;
    signal clk           : std_logic := '0';
    signal rst           : std_logic := '0';
    signal sample        : unsigned(15 downto 0) := to_unsigned(0, 16);
    signal mono_out      : std_logic := '0';
begin

    uut: entity work.OneBitModulator
    generic map(
        W        => 16
    )
    port map(
        CLK      => clk,
        RST      => rst,
        SAMPLE   => sample,
        MONO_OUT => mono_out
    );

    clk_process: process
    begin
        clk <= '1';
        wait for clk_period/2;
        clk <= '0';
        wait for clk_period/2;
    end process;

    rst_process: process
    begin
      rst <= '1';
      wait for clk_period * 5 + 1 ps;
      rst <= '0';

      sample <= to_unsigned(2**12, 16);
      wait for clk_period * 100;

      sample <= to_unsigned(2**13, 16);
      wait for clk_period * 100;

      sample <= to_unsigned(2**14, 16);
      wait for clk_period * 100;

      sample <= to_unsigned(2**15, 16);
      wait for clk_period * 100;

      sample <= to_unsigned(2**16-1, 16);
      wait for clk_period * 100;

      sample <= to_unsigned(0, 16);
      wait;
    end process;

end architecture;
