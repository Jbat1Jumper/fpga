library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Cordic_tb is
end entity;

architecture Behavioral of Cordic_tb is

component cordic is
  generic(
	 N : natural;
	 ITER : natural
 );--Numero de iteraciones
  port(
	 clk : in std_logic;
	 rst : in std_logic;
	 x_i  : in std_logic_vector(N-1 downto 0);
	 y_i  : in std_logic_vector(N-1 downto 0);
	 z_i  : in std_logic_vector(N-1 downto 0);
	 x_o  : out std_logic_vector(N-1 downto 0);
	 y_o  : out std_logic_vector(N-1 downto 0);
	 z_o  : out std_logic_vector(N-1 downto 0)
	);
end component;


constant N                   : natural := 16;
constant ITER                : natural := 10;
constant DEGREES             : real    := real(2**N) / 360.0;
constant AMPLITUDE           : real    := real(2**N) / 2.0 * 0.5; -- El 0.5 está porque durante el calculo el vector se agranda por ~1.6, TODO: Agrandar el ancho de palabra internamente en el Cordic mientras se computa el valor.
constant MAX_ERROR_DEGREES   : real    := 0.1 * DEGREES;
constant MAX_ERROR_AMPLITUDE : real    := 0.005 * AMPLITUDE;


signal clk  : std_logic;
signal x_i  : std_logic_vector(N-1 downto 0) := (others =>'0');
signal y_i  : std_logic_vector(N-1 downto 0) := (others =>'0');
signal z_i  : std_logic_vector(N-1 downto 0) := (others =>'0');
signal x_o  : std_logic_vector(N-1 downto 0);
signal y_o  : std_logic_vector(N-1 downto 0);
signal z_o  : std_logic_vector(N-1 downto 0);


constant clk_period : time := 20 ns;

begin

CLK_PROC: process
begin
  clk <= '1';
  wait for clk_period/2;
  clk <= '0';
  wait for clk_period/2;
end process;


STIM_PROC: process
begin
  wait for clk_period;
  x_i <= std_logic_vector(to_signed(integer(0.1 * AMPLITUDE), N));
  y_i <= std_logic_vector(to_signed(0, N));
  z_i <= std_logic_vector(to_signed(integer(30.0 * DEGREES), N));
  wait for 10 ps;
  assert abs(signed(z_o)) < integer(MAX_ERROR_DEGREES);
  assert abs(signed(x_o) - to_signed(integer(0.086 * AMPLITUDE), N)) < integer(MAX_ERROR_AMPLITUDE);
  assert abs(signed(y_o) - to_signed(integer(0.050 * AMPLITUDE), N)) < integer(MAX_ERROR_AMPLITUDE);

  wait for clk_period;    
  x_i <= std_logic_vector(to_signed(integer(0.1 * AMPLITUDE), N));
  y_i <= std_logic_vector(to_signed(integer(0.1 * AMPLITUDE), N));
  z_i <= std_logic_vector(to_signed(integer(45.0 * DEGREES), N));
  wait for 10 ps;
  assert abs(signed(z_o)) < integer(MAX_ERROR_DEGREES);
  assert abs(signed(x_o) - to_signed(integer(0.0 * AMPLITUDE), N)) < integer(MAX_ERROR_AMPLITUDE);
  assert abs(signed(y_o) - to_signed(integer(0.141 * AMPLITUDE), N)) < integer(MAX_ERROR_AMPLITUDE);

  wait for clk_period;    
  x_i <= std_logic_vector(to_signed(integer(0.1 * AMPLITUDE), N));
  y_i <= std_logic_vector(to_signed(integer(0.1 * AMPLITUDE), N));
  z_i <= std_logic_vector(to_signed(integer(-45.0 * DEGREES), N));
  wait for 10 ps;
  assert abs(signed(z_o)) < integer(MAX_ERROR_DEGREES);
  assert abs(signed(x_o) - to_signed(integer(0.141 * AMPLITUDE), N)) < integer(MAX_ERROR_AMPLITUDE);
  assert abs(signed(y_o) - to_signed(integer(0.0 * AMPLITUDE), N)) < integer(MAX_ERROR_AMPLITUDE);

  wait for clk_period;    
  x_i <= std_logic_vector(to_signed(integer(0.2 * AMPLITUDE), N));
  y_i <= std_logic_vector(to_signed(integer(0.2 * AMPLITUDE), N));
  z_i <= std_logic_vector(to_signed(integer(-45.0 * DEGREES), N));
  wait for 10 ps;
  assert abs(signed(z_o)) < integer(MAX_ERROR_DEGREES);
  assert abs(signed(x_o) - to_signed(integer(0.282 * AMPLITUDE), N)) < integer(MAX_ERROR_AMPLITUDE);
  assert abs(signed(y_o) - to_signed(integer(0.0 * AMPLITUDE), N)) < integer(MAX_ERROR_AMPLITUDE);

  wait for clk_period;    
  x_i <= std_logic_vector(to_signed(integer(0.25 * AMPLITUDE), N));
  y_i <= std_logic_vector(to_signed(integer(0.13 * AMPLITUDE), N));
  z_i <= std_logic_vector(to_signed(integer(-81.0 * DEGREES), N));
  wait for 10 ps;
  assert abs(signed(z_o)) < integer(MAX_ERROR_DEGREES);
  assert abs(signed(x_o) - to_signed(integer(0.1675 * AMPLITUDE), N)) < integer(MAX_ERROR_AMPLITUDE);
  assert abs(signed(y_o) - to_signed(integer(-0.2265 * AMPLITUDE), N)) < integer(MAX_ERROR_AMPLITUDE);

  wait for clk_period;
  x_i <= std_logic_vector(to_signed(integer(1.0 * AMPLITUDE), N));
  y_i <= std_logic_vector(to_signed(integer(0.0 * AMPLITUDE), N));
  z_i <= std_logic_vector(to_signed(integer(90.0 * DEGREES), N));
  wait for 10 ps;
  assert abs(signed(z_o)) < integer(MAX_ERROR_DEGREES);
  assert abs(signed(x_o) - to_signed(integer(0.0 * AMPLITUDE), N)) < integer(MAX_ERROR_AMPLITUDE);
  assert abs(signed(y_o) - to_signed(integer(1.0 * AMPLITUDE), N)) < integer(MAX_ERROR_AMPLITUDE);

  wait for clk_period;
  x_i <= std_logic_vector(to_signed(integer(-0.4 * AMPLITUDE), N));
  y_i <= std_logic_vector(to_signed(integer(-0.6 * AMPLITUDE), N));
  z_i <= std_logic_vector(to_signed(integer(-37.0 * DEGREES), N));
  wait for 10 ps;
  assert abs(signed(z_o)) < integer(MAX_ERROR_DEGREES);
  assert abs(signed(x_o) - to_signed(integer(-0.680 * AMPLITUDE), N)) < integer(MAX_ERROR_AMPLITUDE);
  assert abs(signed(y_o) - to_signed(integer(-0.238 * AMPLITUDE), N)) < integer(MAX_ERROR_AMPLITUDE);

  -- correciones por cuadrante
  wait for clk_period;
  x_i <= std_logic_vector(to_signed(integer(0.9 * AMPLITUDE), N));
  y_i <= std_logic_vector(to_signed(integer(0.0 * AMPLITUDE), N));
  z_i <= std_logic_vector(to_signed(integer(179.99 * DEGREES), N));
  wait for 10 ps;
  assert abs(signed(z_o)) < integer(MAX_ERROR_DEGREES);
  assert abs(signed(x_o) - to_signed(integer(-0.9 * AMPLITUDE), N)) < integer(MAX_ERROR_AMPLITUDE);
  assert abs(signed(y_o) - to_signed(integer(0.0 * AMPLITUDE), N)) < integer(MAX_ERROR_AMPLITUDE);

  wait for clk_period;
  x_i <= std_logic_vector(to_signed(integer(-0.9 * AMPLITUDE), N));
  y_i <= std_logic_vector(to_signed(integer(0.0 * AMPLITUDE), N));
  z_i <= std_logic_vector(to_signed(integer(179.99 * DEGREES), N));
  wait for 10 ps;
  assert abs(signed(z_o)) < integer(MAX_ERROR_DEGREES);
  assert abs(signed(x_o) - to_signed(integer(0.9 * AMPLITUDE), N)) < integer(MAX_ERROR_AMPLITUDE);
  assert abs(signed(y_o) - to_signed(integer(0.0 * AMPLITUDE), N)) < integer(MAX_ERROR_AMPLITUDE);

  wait for clk_period;
  x_i <= std_logic_vector(to_signed(integer(0.3 * AMPLITUDE), N));
  y_i <= std_logic_vector(to_signed(integer(-0.2 * AMPLITUDE), N));
  z_i <= std_logic_vector(to_signed(integer((329.0 - 360.0) * DEGREES), N));
  wait for 10 ps;
  assert abs(signed(z_o)) < integer(MAX_ERROR_DEGREES);
  assert abs(signed(x_o) - to_signed(integer(0.154 * AMPLITUDE), N)) < integer(MAX_ERROR_AMPLITUDE);
  assert abs(signed(y_o) - to_signed(integer(-0.325 * AMPLITUDE), N)) < integer(MAX_ERROR_AMPLITUDE);

  wait for clk_period;
  x_i <= std_logic_vector(to_signed(integer(0.3 * AMPLITUDE), N));
  y_i <= std_logic_vector(to_signed(integer(-0.2 * AMPLITUDE), N));
  z_i <= std_logic_vector(to_signed(integer(110.0 * DEGREES), N));
  wait for 10 ps;
  assert abs(signed(z_o)) < integer(MAX_ERROR_DEGREES);
  assert abs(signed(x_o) - to_signed(integer(0.085 * AMPLITUDE), N)) < integer(MAX_ERROR_AMPLITUDE);
  assert abs(signed(y_o) - to_signed(integer(0.350 * AMPLITUDE), N)) < integer(MAX_ERROR_AMPLITUDE);

  wait for clk_period;
  x_i <= std_logic_vector(to_signed(integer(0.3 * AMPLITUDE), N));
  y_i <= std_logic_vector(to_signed(integer(-0.2 * AMPLITUDE), N));
  z_i <= std_logic_vector(to_signed(integer(-115.0 * DEGREES), N));
  wait for 10 ps;
  assert abs(signed(z_o)) < integer(MAX_ERROR_DEGREES);
  assert abs(signed(x_o) - to_signed(integer(-0.308 * AMPLITUDE), N)) < integer(MAX_ERROR_AMPLITUDE);
  assert abs(signed(y_o) - to_signed(integer(-0.187 * AMPLITUDE), N)) < integer(MAX_ERROR_AMPLITUDE);

  wait;
end process;

UUT: entity work.cordic
  generic map(
    N     => N,
    ITER  => ITER
  )
  port map(
    x_i   =>  x_i,
    y_i   =>  y_i,
    z_i   =>  z_i,
    x_o  =>  x_o,
    y_o  =>  y_o,
    z_o  =>  z_o
  );

-- Se pueden agregar asserts para que la simulación termine si el resultado no
-- es el esperado.

end architecture;
