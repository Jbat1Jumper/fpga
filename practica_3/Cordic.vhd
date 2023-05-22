library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity cordic is
  generic(
    N : natural := 16; --Ancho de la palabra
    ITER : natural := 16);--Numero de iteraciones
  port(
    clk : in std_logic;
    rst : in std_logic;
    en_i : in std_logic;
    x_i  : in std_logic_vector(N-1 downto 0);
    y_i  : in std_logic_vector(N-1 downto 0);
    z_i  : in std_logic_vector(N-1 downto 0);
    dv_o : out std_logic;
    x_o  : out std_logic_vector(N-1 downto 0);
    y_o  : out std_logic_vector(N-1 downto 0);
    z_o  : out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture structural of cordic is

  constant MAX_ITER : natural := 10;  -- Hay que popular la tabla de atan...
                                      --(Se puede automatizar)

  constant GAIN : real := 1.647;  -- OJO! Vale si ITER > 5, para valores menores se podría tabular

  component cordic_iter is
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
    dv_o  : out std_logic;
    xip1  : out std_logic_vector (N-1 downto 0);
    yip1  : out std_logic_vector (N-1 downto 0);
    zip1  : out std_logic_vector (N-1 downto 0)
  );
  end component;

  type handShakeVector is array(ITER downto 0) of std_logic;
  signal en, dv : handShakeVector;
  type ConnectVector is array(ITER downto 0) of std_logic_vector(N-1 downto 0);
  signal wirex, wirey, wirez : ConnectVector;

  signal pre_x_o : std_logic_vector(N-1 downto 0);
  signal pre_y_o : std_logic_vector(N-1 downto 0);
  
  signal correction_x_o_1 : std_logic_vector(N-1 downto 0);
  signal correction_x_o_2 : std_logic_vector(N-1 downto 0);
  signal correction_x_o_3 : std_logic_vector(N-1 downto 0);
  signal correction_y_o_1 : std_logic_vector(N-1 downto 0);
  signal correction_y_o_2 : std_logic_vector(N-1 downto 0);
  signal correction_y_o_3 : std_logic_vector(N-1 downto 0);

begin

en(0) <= en_i;
wirex(0) <= x_i;
wirey(0) <= y_i;
wirez(0) <= z_i;

CONNECTION_INSTANCE: for j in 0 to ITER-1 generate
  begin

    ITERATION: cordic_iter
      generic map(N, j)
      port map(
        clk => clk,
        rst => rst,
        en_i  => en(j),
        xi    => wirex(j),
        yi    => wirey(j),
        zi    => wirez(j),
        dv_o => dv(j),
        xip1 => wirex(j+1),
        yip1 => wirey(j+1),
        zip1 => wirez(j+1)
        );

    en(j+1) <= dv(j);

  end generate;

  

dv_o <= dv(ITER-1);

pre_y_o <= wirey(ITER);
correction_y_o_1 <= (2-1 downto 0 => pre_y_o(pre_y_o'left)) & pre_y_o(N-1 downto 2);
correction_y_o_2 <= (3-1 downto 0 => pre_y_o(pre_y_o'left)) & pre_y_o(N-1 downto 3);
correction_y_o_3 <= (6-1 downto 0 => pre_y_o(pre_y_o'left)) & pre_y_o(N-1 downto 6);
y_o <= std_logic_vector(
       signed(pre_y_o) - signed(correction_y_o_1) - signed(correction_y_o_2) - signed(correction_y_o_3)
   );

pre_x_o <= wirex(ITER);
correction_x_o_1 <= (2-1 downto 0 => pre_x_o(pre_x_o'left)) & pre_x_o(N-1 downto 2);
correction_x_o_2 <= (3-1 downto 0 => pre_x_o(pre_x_o'left)) & pre_x_o(N-1 downto 3);
correction_x_o_3 <= (6-1 downto 0 => pre_x_o(pre_x_o'left)) & pre_x_o(N-1 downto 6);
x_o <= std_logic_vector(
       signed(pre_x_o) - signed(correction_x_o_1) - signed(correction_x_o_2) - signed(correction_x_o_3)
   );

z_o <= wirez(ITER);

end architecture;
