library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

entity MidiFrontend_tb is
end entity;

architecture Behavioral of MidiFrontend_tb is

    constant clk_period  : time := 20 ns;
    signal clk           : std_logic := '0';
    signal midi_data     : std_logic_vector(7 downto 0) := "00000000";
    signal midi_data_en  : std_logic := '0';
    signal frequency     : std_logic_vector(15 downto 0);
    signal amplitude     : std_logic_vector(15 downto 0);

    type frequencyTable is array(127 downto 0) of unsigned(15 downto 0);
    signal freqTable : frequencyTable;
begin
    FREQUENCY_TABLE: for j in 0 to 127 generate
    begin
      -- formula for frequency based on the midi note: 2**(d-64)/12 * 440hz
      -- the multiplication by 4 is the same as shifting 2 bits for the decimals in the frequency
      -- Hence, 0,25 will be represented by 1, 0,50 by 2, 0,75 by 4
      freqTable(j) <= to_unsigned(natural((2.0**((real(j)-64.0)/12.0)*440.0*4.0)),16);
    end generate;

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
      assert unsigned(frequency) = freqTable(127) report "Frequency not matching" severity error;
      assert unsigned(amplitude) = 63 report "Amplitude not matching" severity error;
      wait for clk_period * 2;

      -- TESTING SECOND NOTE ON WITH DIFFERENT PITCH
      midi_data <= "10010000"; -- status byte: note on, channel 0
      midi_data_en <= '1';
      clk <= '1';
      wait for 1 ps;
      clk <= '0';
      midi_data_en <= '0';
      wait for clk_period * 2;
      midi_data <= "01111101"; -- pitch value: 125
      midi_data_en <= '1';
      clk <= '1';
      wait for 1 ps;
      clk <= '0';
      midi_data_en <= '0';
      wait for clk_period * 2;
      midi_data <= "00000111"; -- velocity value: 7
      midi_data_en <= '1';
      clk <= '1';
      wait for 1 ps;
      clk <= '0';
      midi_data_en <= '0';
      assert unsigned(frequency) = freqTable(125) report "Frequency not matching" severity error;
      assert unsigned(amplitude) = 7 report "Amplitude not matching" severity error;
      wait for clk_period * 2;

      -- TESTING NOTE OFF
      midi_data <= "10000000"; -- status byte: note off, channel 0
      midi_data_en <= '1';
      clk <= '1';
      wait for 1 ps;
      clk <= '0';
      midi_data_en <= '0';
      wait for clk_period * 2;
      midi_data <= "01111101"; -- pitch value: 125 (same as last frequency)
      midi_data_en <= '1';
      clk <= '1';
      wait for 1 ps;
      clk <= '0';
      midi_data_en <= '0';
      wait for clk_period * 2;
      midi_data <= "00000000"; -- velocity value: 0 (default value for note off)
      midi_data_en <= '1';
      clk <= '1';
      wait for 1 ps;
      clk <= '0';
      midi_data_en <= '0';
      assert unsigned(amplitude) = 0 report "Amplitude should be 0" severity error;
      wait for clk_period * 2;

      -- TESTING NOTE ON AFTER NOTE OFF
      midi_data <= "10010000"; -- status byte: note on, channel 0
      midi_data_en <= '1';
      clk <= '1';
      wait for 1 ps;
      clk <= '0';
      midi_data_en <= '0';
      wait for clk_period * 2;
      midi_data <= "01000101"; -- pitch value: 69
      midi_data_en <= '1';
      clk <= '1';
      wait for 1 ps;
      clk <= '0';
      midi_data_en <= '0';
      wait for clk_period * 2;
      midi_data <= "01111111"; -- velocity value: 127
      midi_data_en <= '1';
      clk <= '1';
      wait for 1 ps;
      clk <= '0';
      midi_data_en <= '0';
      assert unsigned(frequency) = freqTable(69) report "Frequency not matching" severity error;
      assert unsigned(amplitude) = 127 report "Amplitude not matching" severity error;
      wait for clk_period * 2;

      -- TESTING NOTE OFF NOT MATCHING CURRENT NOTE
      midi_data <= "10000000"; -- status byte: note off, channel 0
      midi_data_en <= '1';
      clk <= '1';
      wait for 1 ps;
      clk <= '0';
      midi_data_en <= '0';
      wait for clk_period * 2;
      midi_data <= "01000111"; -- pitch value: 71
      midi_data_en <= '1';
      clk <= '1';
      wait for 1 ps;
      clk <= '0';
      midi_data_en <= '0';
      wait for clk_period * 2;
      midi_data <= "00000000"; -- velocity value: 0
      midi_data_en <= '1';
      clk <= '1';
      wait for 1 ps;
      clk <= '0';
      midi_data_en <= '0';
      assert unsigned(frequency) = freqTable(69) report "Frequency shouldn't have changed" severity error;
      assert unsigned(amplitude) = 127 report "Amplitude shouldn't have changed" severity error;
      wait for clk_period * 2;

      -- TESTING LAST NOTE OFF
      midi_data <= "10000000"; -- status byte: note off, channel 0
      midi_data_en <= '1';
      clk <= '1';
      wait for 1 ps;
      clk <= '0';
      midi_data_en <= '0';
      wait for clk_period * 2;
      midi_data <= "01000101"; -- pitch value: 69
      midi_data_en <= '1';
      clk <= '1';
      wait for 1 ps;
      clk <= '0';
      midi_data_en <= '0';
      wait for clk_period * 2;
      midi_data <= "00000000"; -- velocity value: 7
      midi_data_en <= '1';
      clk <= '1';
      wait for 1 ps;
      clk <= '0';
      midi_data_en <= '0';
      assert unsigned(amplitude) = 0 report "Amplitude should've been set to 0" severity error;
      wait for clk_period * 2;

      wait;
    end process;

    uut: entity work.MidiFrontend
    generic map(
        T_WORD_WIDTH => 16
    )
    port map(
        MIDI_DATA => midi_data,
        MIDI_DATA_EN => midi_data_en,
        FREQ => frequency,
        AMP => amplitude,
        CLK => clk
    );

end architecture;
