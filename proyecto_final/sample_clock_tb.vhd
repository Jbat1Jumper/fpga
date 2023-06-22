library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity SampleClock_tb is
end entity;

architecture Behavioral of SampleClock_tb is

    constant clk_period : time := 20 ns;

    signal clk   : std_logic := '1';
    signal rst   : std_logic := '0';
    signal t     : std_logic_vector(3 downto 0);

begin

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
      wait for 1 ps;
      assert unsigned(t) = 0 report "T deberia ser 0 al comienzo" severity error;
      wait for clk_period * 2;
      assert unsigned(t) = 1 report "T deberia ser 1 al pasar dos ciclos de clock" severity error;
      wait for clk_period * 2 * 14;
      assert unsigned(t) = 15 report "T deberia ser 15 al pasar 30 ciclos de clock" severity error;
      wait for clk_period * 2;
      assert unsigned(t) = 0 report "T deberia ser 0 al llegar al maximo" severity error;

      wait;
    end process;

    uut: entity work.SampleClock
    generic map(
        CLK_FREQ => 50e6,
        SAMPLE_FREQ => 25e6,
        T_WORD_WIDTH => 4
    )
    port map(
        CLK => clk,
        RST =>  rst,
        T => t
    );

end architecture;
