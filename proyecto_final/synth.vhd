library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;


entity Synth is
    Generic (
                W : natural := 16;
                SAMPLE_FREQ : real := 44100.0
            );
    Port (
             CLK : IN STD_LOGIC;
             RST : IN STD_LOGIC;

             FREQ : IN unsigned(W-1 downto 0);
             AMP : IN unsigned(W-1 downto 0);

             SAMPLE : OUT unsigned(W-1 downto 0)
        );
end entity;

architecture Synth_arch OF Synth IS
	 
	 signal phase_delta_tmp : unsigned((W*4)-1 downto 0) := (others => '0');
	 signal phase_delta : unsigned((W*2)-1 downto 0) := (others => '0');
	 
	 signal phase_signal : unsigned((W*2)-1 downto 0) := (others => '0');
	 
begin

    -- TODO: Incrementar phase a 32 bits
    phase_delta_tmp <= "0000000000000000"&unsigned(FREQ) * to_unsigned(natural(real(2**(W*2)) / SAMPLE_FREQ / 4.0), W*2);
    phase_delta <= phase_delta_tmp(W*2-1 downto 0);

    rotate_phase : process (CLK)
    begin
        if (rising_edge(CLK)) then
            if (RST = '1') then
                phase_signal <= (others => '0');
            else
                phase_signal <= phase_signal + phase_delta;
            end if;
        end if;
    end process;

    SAMPLE <= phase_signal((W*2)-1 downto (W)) when (AMP>0) else to_unsigned(0, W);

end architecture;
