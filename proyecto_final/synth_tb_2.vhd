library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;


entity Synth_tb_2 is
end entity;

architecture Behavioral of Synth_tb_2 is

    constant clk_period  : time := 22.6757 us;
    signal clk           : std_logic := '0';
    signal rst           : std_logic := '0';
    signal freq          : unsigned(15 downto 0) := to_unsigned(0, 16);
    signal amp           : unsigned(15 downto 0) := to_unsigned(0, 16);
begin

    uut: entity work.Synth
    generic map(
        W => 16,
        SAMPLE_FREQ => 44100.0
    )
    port map(
        CLK => clk,
        RST => rst,

        FREQ => freq,
        AMP => amp
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

      freq <= to_unsigned(440*4, 16);
      amp <= to_unsigned(100, 16);
      wait for clk_period * 200;

      freq <= to_unsigned(220*4, 16);
      amp <= to_unsigned(100, 16);
      wait for clk_period * 200;

      freq <= to_unsigned(110*4, 16);
      amp <= to_unsigned(100, 16);
      wait for clk_period * 400;

      freq <= to_unsigned(440*4, 16);
      amp <= to_unsigned(100, 16);
      wait for clk_period * 200;

      freq <= to_unsigned(880*4, 16);
      amp <= to_unsigned(100, 16);
      wait for clk_period * 200;

      freq <= to_unsigned(0*4, 16);
      amp <= to_unsigned(100, 16);
      wait;
    end process;

end architecture;
