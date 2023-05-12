library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
use IEEE.math_real.all;

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
  function maybe_shift(i1:unsigned) 
      return unsigned is
  begin
      if SHIFT = 0 then
          return i1;
      else
          return (SHIFT-1 downto 0 => '0') & i1(N-1 downto SHIFT);
      end if;
  end function;

  constant ARCTAN_VALUE : REAL := ARCTAN(real(2) ** real(-SHIFT));
  constant SCALE : REAL := real(2**N) / MATH_2_PI;
  constant a : unsigned(N-1 downto 0) := to_unsigned(natural(ARCTAN_VALUE * SCALE), N);

  begin
    dv_o <= en_i;

    xip1 <= std_logic_vector(maybe_shift(unsigned(yi)));
    yip1 <= std_logic_vector(maybe_shift(unsigned(xi)));
    zip1 <= std_logic_vector(signed(zi) - signed(a)) when zi(zi'left) = '1' else std_logic_vector(signed(zi) + signed(a));

end architecture;
