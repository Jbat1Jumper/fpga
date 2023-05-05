library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;
use IEEE.fixed_pkg.all;

entity cordic_iter is
  generic(
    N     : natural := 8;  --Ancho de la palabra
    SHIFT : natural := 1); --Desplazamiento
  port(
    clk   : in std_logic;
    rst   : in std_logic;
    en_i  : in std_logic;
    xi    : in std_logic_vector (N-1 downto 0);
    yi    : in std_logic_vector (N-1 downto 0);
    zi    : in std_logic_vector (N-1 downto 0);
    ci    : in std_logic_vector (N-1 downto 0);
    dv_o  : out std_logic;
    xip1  : out std_logic_vector (N-1 downto 0);
    yip1  : out std_logic_vector (N-1 downto 0);
    zip1  : out std_logic_vector (N-1 downto 0)
  );
end entity;

architecture strcutural of cordic_iter is

  constant ARCTAN_VALUE : REAL := ARCTAN(real(2) ** real(-SHIFT));
  constant a : signed(N-1 downto 0) := signed(to_sfixed(ARCTAN_VALUE, 4, 5 - N));

  begin
    dv_o <= en_i;

    xip1 <= (SHIFT-1 downto 0 => '0') & yi(N downto SHIFT);
    yip1 <= (SHIFT-1 downto 0 => '0') & xi(N downto SHIFT);
    zip1 <= std_logic_vector(signed(zi) - a) when zi(zi'left) = '1' else std_logic_vector(signed(zi) + a);

end architecture;
