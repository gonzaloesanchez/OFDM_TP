-- COMENTARIO: No se porque los valores del primer cuadrante son positivos
-- y los cuadrantes restantes son negativos. Los valores son correctos, pero
-- es un poco molesto. Adaptar el MAPPER

-- CUIDADO CON EL OVERFLOW (valores muy grandes de entrada pueden dar
--  errores en la salida, dado el overflow en las sumas y restas dentro de
-- los elementos cordic)



library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


--Como solo vamos a utilizar el modo de vectorizacion, hacemos un modulo con
-- las entradas de los valores en coordenadas cartesianas y z_in = 0
-- solo nos interesa la salida z_out
entity cordic_completo is
  generic(
    N : natural := 16; --Ancho de la palabra
    ITER : natural := 16);--Numero de iteraciones
  port(
    clk : in std_logic;
    rst : in std_logic;
    en_i : in std_logic;
    x_i  : in std_logic_vector(N-1 downto 0);
    y_i  : in std_logic_vector(N-1 downto 0);
    dv_o : out std_logic;
    z_o  : out std_logic_vector(N-1 downto 0)
    );
end entity;

architecture structural of cordic_completo is

  constant MAX_ITER : natural := 9;  -- Hay que popular la tabla de atan...
                                      --(Se puede automatizar)

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
    ci    : in std_logic_vector (N-1 downto 0);
    dv_o  : out std_logic;
    xip1  : out std_logic_vector (N-1 downto 0);
    yip1  : out std_logic_vector (N-1 downto 0);
    zip1  : out std_logic_vector (N-1 downto 0)
  );
  end component;

  component cordic_compensate is
  generic(
    N     : natural := 8  --Ancho de la palabra
    );
  port(
    clk   : in std_logic;
    rst   : in std_logic;
    en_i  : in std_logic;
    xi    : in std_logic_vector (N-1 downto 0);
    yi    : in std_logic_vector (N-1 downto 0);
    zi    : in std_logic_vector (N-1 downto 0);
    dv_o  : out std_logic;
    x_prima  : out std_logic_vector (N-1 downto 0);
    y_prima  : out std_logic_vector (N-1 downto 0);
    z_prima  : out std_logic_vector (N-1 downto 0)
  );
  end component;

  type handShakeVector is array(ITER downto 0) of std_logic;
  signal en, dv : handShakeVector;
  type ConnectVector is array(ITER downto 0) of std_logic_vector(N-1 downto 0);
  signal wirex, wirey, wirez, wireLUT : ConnectVector;
  type intLUT is array(0 to MAX_ITER) of integer range 0 to 2**N;
  signal atanLUT : intLUT := (3217,1912,1004,510,255,128,64,31,15,7); -- valores para palabra 16 bits
      --los valores han sido calcualdos con 4 bits de parte entera y 12 de decimal
      --los limites para esta representacion son -8 a 8 (aproximadamente)
      --un bit de signo en la parte entera y dos de valor

  signal x_aCompensar  : std_logic_vector (N-1 downto 0);
  signal y_aCompensar  : std_logic_vector (N-1 downto 0);

  signal x_Compensada  : std_logic_vector (N-1 downto 0);
  signal y_Compensada  : std_logic_vector (N-1 downto 0);
  signal z_Compensada  : std_logic_vector (N-1 downto 0);

begin

compensador: cordic_compensate
generic map(
  N     => N
)
port map(
  clk => clk,
  rst => rst,
  en_i  => en_i,
  xi    => x_aCompensar,
  yi    => y_aCompensar,
  zi    => (others => '0'),
  dv_o => en(0),
  x_prima => x_Compensada,
  y_prima => y_Compensada,
  z_prima => z_Compensada
  );

  --wirex(0) <= x_Compensada;   --Salida del compensador a la entrada del cordic
  --wirey(0) <= y_Compensada;
  --wirez(0) <= z_Compensada;

  x_aCompensar <= x_i;    --señales de entrada al modulo
  y_aCompensar <= y_i;

elemento_cordic: for j in 0 to ITER-1 generate
  begin
    wireLUT(j) <= std_logic_vector(to_signed(atanLUT(j),N));


    it0:
		if j = 0 generate
		begin
			iter0: cordic_iter
			generic map(N,0)
			port map(
				clk => clk,
				rst => rst,
        en_i => en(0),
				xi => x_Compensada,
				yi => y_Compensada,
				zi => z_Compensada,
				ci => wireLUT(0),
        dv_o => dv(0),
				xip1 => wirex(0),
				yip1 => wirey(0),
				zip1 => wirez(0)
			);
		end generate;

    itj:
		if j>0 and j<(ITER-1) generate
		begin
			iterj: cordic_iter
			generic map(N,j)
			port map(
				clk => clk,
				rst => rst,
        en_i => dv(j-1),
				xi => wirex(j-1),
				yi => wirey(j-1),
				zi => wirez(j-1),
				ci => wireLUT(j),
        dv_o => dv(j),
				xip1 => wirex(j),
				yip1 => wirey(j),
				zip1 => wirez(j)
			);
		end generate;

    itM_1:
		if j=(ITER-1) generate
		begin
			iterM_1: cordic_iter
			generic map(N,j)
			port map(
				clk => clk,
				rst => rst,
        en_i => dv(j-1),
				xi => wirex(j-1),
				yi => wirey(j-1),
				zi => wirez(j-1),
				ci => wireLUT(j),
        dv_o => dv_o,
				xip1 => open,
				yip1 => open,
				zip1 => z_o
			);
		end generate;
  end generate;

end architecture;
