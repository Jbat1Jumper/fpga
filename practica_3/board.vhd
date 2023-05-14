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

        LED_A : OUT STD_LOGIC;
        LED_B : OUT STD_LOGIC;
        LED_C : OUT STD_LOGIC
    );
end entity;


architecture Board_arch OF Board IS

    type state_t is (turned_off, first_led, second_led, third_led);

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

    period_reached <= '1' when (clk_count = to_unsigned(PERIOD, 26)) else '0';

    state_transitions : process (CLK)
    begin
        if (falling_edge(CLK) and period_reached = '1') then
            case present_state is
                when turned_off =>
                    next_state <= first_led;
                
                when first_led =>
                    next_state <= second_led;

                when second_led =>
                    next_state <= third_led;

                when third_led =>
                    next_state <= turned_off;
                
                when others =>
                    next_state <= turned_off;
            end case;
        end if;
    end process;

    change_state : process (CLK)
    begin
        if (rising_edge(CLK)) then
            if (RST = '0') then
                present_state <= turned_off;
            else
                present_state <= next_state;
            end if;
        end if;
    end process;

    led_output : process (CLK)
    begin
        case present_state is
            when turned_off =>
                LED_A <= '1';
                LED_B <= '1';
                LED_C <= '1';
            
            when first_led =>
                LED_A <= '0';
                LED_B <= '1';
                LED_C <= '1';

            when second_led =>
                LED_A <= '1';
                LED_B <= '0';
                LED_C <= '1';

            when third_led =>
                LED_A <= '1';
                LED_B <= '1';
                LED_C <= '0';
        end case;
    end process;

end architecture;
