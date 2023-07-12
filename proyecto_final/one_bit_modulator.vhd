library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;


entity OneBitModulator is
    Generic (
                W : natural := 16
            );
    Port (
             CLK : IN STD_LOGIC;
             RST : IN STD_LOGIC;

             SAMPLE : IN unsigned(W-1 downto 0);

             MONO_OUT : OUT STD_LOGIC
         );
end entity;

architecture OneBitModulator_arch OF OneBitModulator IS
    signal noise_signal : unsigned(15 downto 0) := (others => '0');
    signal r_lfsr       : std_logic_vector (15 downto 0) := std_logic_vector(to_unsigned(7, 16));
begin

    p_lfsr : process (CLK, RST) begin 
        if rising_edge(CLK) then 
            if(RST='1') then
                r_lfsr   <= std_logic_vector(to_unsigned(7, 16));
            else 
                r_lfsr(15) <= r_lfsr(1);
                r_lfsr(14) <= r_lfsr(15) xor r_lfsr(1);
                r_lfsr(13) <= r_lfsr(14) xor r_lfsr(1);
                r_lfsr(12) <= r_lfsr(13);
                r_lfsr(11) <= r_lfsr(12) xor r_lfsr(1);
                r_lfsr(10) <= r_lfsr(11);
                r_lfsr(9) <= r_lfsr(10);
                r_lfsr(8) <= r_lfsr(9);
                r_lfsr(7) <= r_lfsr(8);
                r_lfsr(6) <= r_lfsr(7);
                r_lfsr(5) <= r_lfsr(6);
                r_lfsr(4) <= r_lfsr(5);
                r_lfsr(3) <= r_lfsr(4);
                r_lfsr(2) <= r_lfsr(3);
                r_lfsr(1) <= r_lfsr(2);
            end if; 
        end if; 
    end process p_lfsr; 

    noise_signal  <= unsigned(r_lfsr(W-1 downto 0));


    -- generate_noise_signal : process (CLK)
    -- begin
    --     if (rising_edge(CLK)) then
    --         if (RST = '1') then
    --             noise_signal <= (others => '0');
    --         else
    --             noise_signal <= noise_signal + (2**9)-(2**3)-1;
    --         end if;
    --     end if;
    -- end process;


    MONO_OUT <= '1' when (noise_signal < SAMPLE) else '0';

end architecture;
