--------------------------------------------------------------------
-- Nombre del componente: cordic_iter
--
-- Descripcion: Celda unitaria para iteracion cordic
--
-- Autor: Gonzalo Sanchez
-- Fecha: 04/08/18

-- NOTAS: Agregar correccion para extender a los 4 cuadrantes
--la resolucion debera ser entonces extendida. Ahora esta entre -2 y 2
-- y los valores de atanLUT estan calculados para este rango de punto
--fijo, por lo que hay que llevarlo a -4,4 y recalcular los valores
--de atanLUT
--------------------------------------------------------------------

--------------------------------------------------------------------
-- Inclusion de librerias y paquetes
--------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

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
end;

--------------------------------------------------------------------
-- Arquitectura
--------------------------------------------------------------------
architecture cordic_iter_arq of cordic_iter is

  -- Insertar signals aca
  signal xi_shifted: signed(N-1 downto 0);
  signal yi_shifted: signed(N-1 downto 0);
  signal xi_s: signed(N-1 downto 0);
  signal yi_s: signed(N-1 downto 0);
  signal zi_s: signed(N-1 downto 0);
  signal ci_s: signed(N-1 downto 0);
  -------------------------------------------------

  begin
    xi_s <= signed(xi);
    yi_s <= signed(yi);
    zi_s <= signed(zi);
    ci_s <= signed(ci);

    xi_shifted <= shift_right(xi_s,SHIFT);
    yi_shifted <= shift_right(yi_s,SHIFT);

    process(clk)
    begin
      if rising_edge(clk) then
        if(rst='1') then
          xip1 <= (others => '0');
          yip1 <= (others => '0');
          zip1 <= (others => '0');
          dv_o <= '0';  --salida invalida hasta que entre un dato nuevo
        else
          dv_o <= en_i;   --siempre que tengamos enable, tendremos una salida calculada
          if(en_i ='1') then
            --los enable input no son otra cosa que los data valid output
            --las entradas tienen signo, por lo que el bit mas a la izquierda
            --es el bit de signo
            if(yi(N-1) = '1') then
              --Caso d = 1
              xip1 <= std_logic_vector(xi_s - yi_shifted);  --siguiente X
              yip1 <= std_logic_vector(yi_s + xi_shifted);  --siguiente Y
              zip1 <= std_logic_vector(zi_s - ci_s);
                  --ci es la entrada atanLUT, esta en radianes
            else
              --Caso d = -1
              xip1 <= std_logic_vector(xi_s + yi_shifted);  --siguiente X
              yip1 <= std_logic_vector(yi_s - xi_shifted);  --siguiente Y
              zip1 <= std_logic_vector(zi_s + ci_s);
                  --ci es la entrada atanLUT, esta en radianes
            end if;
          end if;
        end if;
      end if;
    end process;
  end;
