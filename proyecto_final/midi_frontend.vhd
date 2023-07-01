library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;


entity MidiFrontend is
    Generic (
        T_WORD_WIDTH : natural := 16
    );
    Port (
        MIDI_DATA : IN std_logic_vector(7 downto 0);
        MIDI_DATA_EN : IN std_logic;
        CLK  : IN std_logic;
        FREQ : OUT std_logic_vector(T_WORD_WIDTH-1 downto 0) := (others => '0');
        AMP  : OUT std_logic_vector(T_WORD_WIDTH-1 downto 0) := (others => '0')
    );
end entity;


architecture MidiFrontend_arch OF MidiFrontend IS
    type State_Type is (IDLE, STAT_BYTE, FIRST_DATA_BYTE_OF_TWO, FIRST_DATA_BYTE, SECOND_DATA_BYTE);
    signal current_state : State_Type := IDLE;

    type OP_TYPE is (NONE, NOTE_ON, NOTE_OFF);
    signal current_op : OP_TYPE := NONE;

    signal status_byte : std_logic_vector(7 downto 0) := (others => '0');
    signal data_byte_1 : std_logic_vector(7 downto 0) := (others => '0'); 
    signal data_byte_2 : std_logic_vector(7 downto 0) := (others => '0');

    signal frequency : std_logic_vector(T_WORD_WIDTH-1 downto 0) := (others => '0');
    signal amplitude : std_logic_vector(T_WORD_WIDTH-1 downto 0) := (others => '0');

    type frequencyTable is array(127 downto 0) of unsigned(T_WORD_WIDTH-1 downto 0);
    signal freqTable : frequencyTable;
begin

    FREQUENCY_TABLE: for j in 0 to 127 generate
    begin
      -- formula for frequency based on the midi note: 2**(d-64)/12 * 440hz
      -- the multiplication by 4 is the same as shifting 2 bits for the decimals in the frequency
      -- Hence, 0,25 will be represented by 1, 0,50 by 2, 0,75 by 4
      freqTable(j) <= to_unsigned(natural((2.0**((real(j)-64.0)/12.0)*440.0*4.0)),T_WORD_WIDTH);
    end generate;

    FREQ <= frequency;
    AMP <= amplitude;

    new_midi_data : process (CLK)
    begin
      if (rising_edge(CLK) AND MIDI_DATA_EN = '1') then
        case current_state is
          when IDLE | STAT_BYTE =>
            case MIDI_DATA(7 downto 4) is
              when "1001" =>
                -- note on
                status_byte <= MIDI_DATA;
                current_state <= FIRST_DATA_BYTE_OF_TWO;
                current_op <= NOTE_ON;
              when "1000" =>
                -- note off
                status_byte <= MIDI_DATA;
                current_state <= FIRST_DATA_BYTE_OF_TWO;
                current_op <= NOTE_OFF;
              when others =>
                -- unknown instruction
            end case;
          when FIRST_DATA_BYTE_OF_TWO =>
            data_byte_1 <= MIDI_DATA;
            current_state <= SECOND_DATA_BYTE;

          when SECOND_DATA_BYTE =>
            data_byte_2 <= MIDI_DATA;
            current_state <= STAT_BYTE;
            case status_byte(7 downto 4) is
              when "1001" =>
                frequency <= std_logic_vector(unsigned(freqTable(to_integer(unsigned(data_byte_1)))));
                amplitude <= x"00" & MIDI_DATA;
              when "1000" =>
                if (frequency = std_logic_vector(unsigned(freqTable(to_integer(unsigned(data_byte_1)))))) then
                  amplitude <= (others => '0');
                end if;
              when others =>
                -- unknown instruction
            end case;

          when FIRST_DATA_BYTE =>
            data_byte_1 <= MIDI_DATA;
            current_state <= STAT_BYTE;
        end case;
      end if;
    end process;
end architecture;
