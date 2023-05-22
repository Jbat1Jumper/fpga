library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Board_tb is
end entity;

architecture Behavioral of Board_tb is

    constant clk_period : time := 20 ns;

    signal clk   : std_logic := '1';
    signal rst   : std_logic := '0';
    signal leds  : std_logic_vector(3 downto 0) := (others =>'0');

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
      rst <= '0';
      wait for clk_period * 20 + 1 ps;
      rst <= '1';
      wait;
    end process;

    uut: entity work.Board
    generic map(
        PERIOD => 2
    )
    port map(
        CLK => clk,
        RST =>  rst,
        LEDS => leds
    );


end architecture;