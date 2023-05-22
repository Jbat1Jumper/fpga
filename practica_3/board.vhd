library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;


entity Board is
    Generic (
        PERIOD : natural := 25e6
    );
    Port (
        CLK : IN STD_LOGIC;
        RST : IN STD_LOGIC;
		  LEDS : OUT STD_LOGIC_vector(2 downto 0)
    );
end entity;


architecture Board_arch OF Board IS

    type state_t is (idle, first_led, second_led, third_led);

    signal clk_count       : unsigned(25 downto 0);
    signal period_reached  : std_logic := '0';
    signal present_state   : state_t;
    signal next_state      : state_t;

begin
	 
	count_system_clock : process (CLK)
    begin
        if (rising_edge(CLK)) then
            if (RST = '0') then
                clk_count <= (others => '0');
            elsif (period_reached = '1') then 
                clk_count <= (others => '0');
            else
                clk_count <= clk_count + 1;
            end if;
        end if;
    end process;

    period_reached <= '1' when (clk_count = to_unsigned(PERIOD, 26)-1) else '0';

    state_transitions : process (present_state)
    begin
			case present_state is
				 when idle =>
					  next_state <= first_led;
				 
				 when first_led =>
					  next_state <= second_led;

				 when second_led =>
					  next_state <= third_led;

				 when third_led =>
					  next_state <= idle;
			end case;
    end process;

    change_state : process (period_reached)
    begin
        if (falling_edge(period_reached)) then
            if (RST = '0') then
                present_state <= idle;
            else
                present_state <= next_state;
            end if;
        end if;
    end process;

    led_output : process (present_state)
    begin
        case present_state is
            when idle =>
                LEDS <= "111";

            when first_led =>
			       LEDS <= "011";

            when second_led =>
			       LEDS <= "101";

            when third_led =>
			       LEDS <= "110";
					 
        end case;
    end process;

end architecture;
