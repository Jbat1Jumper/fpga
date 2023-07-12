library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Board_tb is
end entity;

architecture Behavioral of Board_tb is

    constant clk_period : time := 20 ns;

    signal clk   : std_logic := '1';
    signal rst   : std_logic := '0';
    signal mono_out   : std_logic;
    signal uart_rxd   : std_logic;
    signal leds  : std_logic_vector(2 downto 0) := (others =>'0');

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
      wait for clk_period * 5 + 1 ps;
      rst <= '1';
      wait;
    end process;

    uut: entity work.Board
    port map(
        CLK => clk,
        NOT_RST =>  not rst,
        MONO_OUT   => mono_out,
        UART_RXD   => uart_rxd,
        LED_A => leds(2),
        LED_B => leds(1),
        LED_C => leds(0)
    );


end architecture;
