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

begin

    new_midi_data : process (MIDI_DATA)
    begin
      case current_state is
        when IDLE | STAT_BYTE =>
          case MIDI_DATA(7 downto 4) is
            when "1001" =>
              -- note on
              status_byte <= MIDI_DATA(7 downto 4);
              current_state <= FIRST_DATA_BYTE_OF_TWO;
              current_op <= NOTE_ON;
            when "1000" =>
              -- note off
              status_byte <= MIDI_DATA(7 downto 4);
              current_state <= FIRST_DATA_BYTE_OF_TWO;
              current_op <= NOTE_OFF;
          end case;
        when FIRST_DATA_BYTE_OF_TWO =>
          data_byte_1 <= MIDI_DATA;
          current_state <= SECOND_DATA_BYTE;

        when SECOND_DATA_BYTE =>
          data_byte_2 <= MIDI_DATA;
          current_state <= STAT_BYTE;

        when FIRST_DATA_BYTE =>
          data_byte_1 <= MIDI_DATA;
          current_state <= STAT_BYTE;
      end case;
    end process;
end architecture;
