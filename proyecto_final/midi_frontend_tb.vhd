library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity MidiFrontend_tb is
end entity;

architecture Behavioral of MidiFrontend_tb is

    constant clk_period  : time := 20 ns;
    signal clk           : std_logic := '0';
    signal midi_data     : std_logic_vector(7 downto 0) := "00000000";
    signal midi_data_en  : std_logic := '0';
    signal frequency     : std_logic_vector(3 downto 0);
    signal amplitude     : std_logic_vector(3 downto 0);

begin

    rst_process: process
    begin
      wait for 1 ps;
      -- TESTING INITIAL VALUES
      assert unsigned(frequency) = 0 report "la frecuencia deberia ser 0 al comienzo" severity error;
      assert unsigned(amplitude) = 0 report "la amplitud deberia ser 0 al comienzo" severity error;
      wait for clk_period * 2;

      -- TESTING NOTE ON
      midi_data <= "10010000"; -- status byte: note on, channel 0
      midi_data_en <= '1';
      clk <= '1';
      wait for 1 ps;
      clk <= '0';
      midi_data_en <= '0';
      wait for clk_period * 2;
      midi_data <= "01111111"; -- pitch value: 127 
      midi_data_en <= '1';
      clk <= '1';
      wait for 1 ps;
      clk <= '0';
      midi_data_en <= '0';
      wait for clk_period * 2;
      midi_data <= "00111111"; -- velocity value: 63 
      midi_data_en <= '1';
      clk <= '1';
      wait for 1 ps;
      clk <= '0';
      midi_data_en <= '0';
      assert unsigned(frequency) /= 0 report "Frequency should've changed" severity error;
      assert unsigned(amplitude) /= 0 report "Amplitude should've changed" severity error;
      wait for clk_period * 2 * 14;

      -- TESTING SECOND NOTE ON WITH DIFFERENT PITCH
      -- midi_data <= "10010000" -- status byte: note on, channel 0
      -- midi_data_en <= '1'
      -- clk <= '1';
      -- wait for 1 ps;
      -- clk <= '0';
      -- midi_data_en <= '0';
      -- wait for clk_period * 2;
      -- midi_data <= "01111101"; -- pitch value: 125
      -- midi_data_en <= '1';
      -- clk <= '1';
      -- wait for 1 ps;
      -- clk <= '0';
      -- midi_data_en <= '0';
      -- wait for clk_period * 2;
      -- midi_data <= "00000111"; -- velocity value: 7
      -- midi_data_en <= '1';
      -- clk <= '1';
      -- wait for 1 ps;
      -- clk <= '0';
      -- midi_data_en <= '0';
      -- assert unsigned(frequency) /= 0 report "Frequency should've changed" severity error;
      -- assert unsigned(amplitude) /= 0 report "Amplitude should've changed" severity error;
      -- wait for clk_period * 2 * 14;

      -- TESTING NOTE OFF
      -- midi_data <= "10000000"; -- status byte: note off, channel 0
      -- midi_data_en <= '1';
      -- clk <= '1';
      -- wait for 1 ps;
      -- clk <= '0';
      -- midi_data_en <= '0';
      -- wait for clk_period * 2;
      -- midi_data <= "01111101"; -- pitch value: 125 (same as last frequency)
      -- midi_data_en <= '1';
      -- clk <= '1';
      -- wait for 1 ps;
      -- clk <= '0';
      -- midi_data_en <= '0';
      -- wait for clk_period * 2;
      -- midi_data <= "00000000"; -- velocity value: 0 (default value for note off)
      -- midi_data_en <= '1';
      -- clk <= '1';
      -- wait for 1 ps;
      -- clk <= '0';
      -- midi_data_en <= '0';
      -- assert unsigned(frequency) = 0 report "Frequency should've been set to 0" severity error;
      -- assert unsigned(amplitude) = 0 report "Amplitude should've been set to 0" severity error;
      -- wait for clk_period * 2 * 14;

      -- TESTING NOTE ON AFTER NOTE OFF
      -- midi_data <= "10010000"; -- status byte: note on, channel 0
      -- midi_data_en <= '1';
      -- clk <= '1';
      -- wait for 1 ps;
      -- clk <= '0';
      -- midi_data_en <= '0';
      -- wait for clk_period * 2;
      -- midi_data <= "01000101"; -- pitch value: 69
      -- midi_data_en <= '1';
      -- clk <= '1';
      -- wait for 1 ps;
      -- clk <= '0';
      -- midi_data_en <= '0';
      -- wait for clk_period * 2;
      -- midi_data <= "01111111"; -- velocity value: 127
      -- midi_data_en <= '1';
      -- clk <= '1';
      -- wait for 1 ps;
      -- clk <= '0';
      -- midi_data_en <= '0';
      -- assert unsigned(frequency) /= 0 report "Frequency should've changed" severity error;
      -- assert unsigned(amplitude) /= 0 report "Amplitude should've changed" severity error;
      -- wait for clk_period * 2 * 14;

      -- TESTING LAST NOTE OFF
      -- midi_data <= "10010000"; -- status byte: note on, channel 0
      -- midi_data_en <= '1';
      -- clk <= '1';
      -- wait for 1 ps;
      -- clk <= '0';
      -- midi_data_en <= '0';
      -- wait for clk_period * 2;
      -- midi_data <= "01000101"; -- pitch value: 69
      -- midi_data_en <= '1';
      -- clk <= '1';
      -- wait for 1 ps;
      -- clk <= '0';
      -- midi_data_en <= '0';
      -- wait for clk_period * 2;
      -- midi_data <= "01111111"; -- velocity value: 7
      -- midi_data_en <= '1';
      -- clk <= '1';
      -- wait for 1 ps;
      -- clk <= '0';
      -- midi_data_en <= '0';
      -- assert unsigned(frequency) = 0 report "Frequency should've been set to 0" severity error;
      -- assert unsigned(amplitude) = 0 report "Amplitude should've been set to 0" severity error;
      -- wait for clk_period * 2 * 14;

      wait;
    end process;

    uut: entity work.MidiFrontend
    generic map(
        T_WORD_WIDTH => 4
    )
    port map(
        MIDI_DATA => midi_data,
        MIDI_DATA_EN => midi_data_en,
        FREQ => frequency,
        AMP => amplitude,
        CLK => clk
    );

end architecture;
