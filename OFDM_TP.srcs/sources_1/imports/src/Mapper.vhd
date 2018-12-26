library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity mapper is
  generic(
    N : natural := 16; --Ancho de la palabra
    B : natural := 4 --Cantidad de bits de entrada
    );
  port(
    clk : in std_logic;
    rst : in std_logic;
    en_i : in std_logic;
    data_in  : in std_logic_vector(B-1 downto 0);
    dv_o : out std_logic;
    real_o  : out std_logic_vector(N-1 downto 0);
    img_o  : out std_logic_vector(N-1 downto 0)
    );
end entity;

--------------------------------------------------------------------
-- Arquitectura
--------------------------------------------------------------------

architecture mapper_arq of mapper is

  type intLUT is array(0 to N-1) of integer range -2**(N-1) to 2**(N-1)-1;

      signal realLUT : intLUT := (4017,3406,2276,799,-799,-2276,-3406,-4017,
                                  -4017,-3406,-2276,-799,799,2276,3406,4017);
          -- valores para palabra 16 bits
          --los valores han sido calcualdos con 4 bit de parte entera y 12 de decimal
          --los limites para esta representacion son -1 a 1 (aproximadamente)

      signal imgLUT : intLUT := (799,2276,3406,4017,4017,3406,2276,799,-799,
                                -2276,-3406,-4017,-4017,-3406,-2276,-799);
           -- valores para palabra 16 bits
          --los valores han sido calcualdos con 4 bit de parte entera y 12 de decimal
          --los limites para esta representacion son -1 a 1 (aproximadamente)



begin
  process(clk)
  begin
    if rising_edge(clk) then
      if(rst='1') then
        dv_o <= '0';        --data valid y salidas a cero
        real_o <= (others =>'0');
        img_o <= (others =>'0');
      else
        if (en_i = '1') then
					dv_o <= en_i;
          real_o <= std_logic_vector(to_signed(realLUT(to_integer(unsigned(data_in))),N));  --valores de memoria
          img_o  <= std_logic_vector(to_signed(imgLUT(to_integer(unsigned(data_in))),N));   --valores de memoria
        else
          dv_o <= '0';    --no puede haber indicacion de data valid si no tenemos enable input
        end if;
      end if;
    end if;
  end process;
end architecture;
