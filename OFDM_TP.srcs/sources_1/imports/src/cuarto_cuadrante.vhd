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

entity cordic_compensate is
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
end;

--------------------------------------------------------------------
-- Arquitectura
--------------------------------------------------------------------
architecture cordic_compensate_arq of cordic_compensate is

  -- Insertar signals aca
  signal x_integer : integer;-- range -2**(N-1) to 2**(N-1)-1;
  signal y_integer : integer;-- range -2**(N-1) to 2**(N-1)-1;
  signal z_integer : integer;-- range -2**(N-1) to 2**(N-1)-1;
  signal cuadrante : std_logic_vector (1 downto 0);
  --signal z_i_prima : signed (N-1 downto 0);
  -------------------------------------------------

  begin
    ------------------------------------------------------------------------------
    --Rotacion inicial para angulos mayores a pi/2 o menores a -Pi/2

    -- la señal cuadrante contiene donde esta ubicado el punto
    --  cuadrante = "00" ==> Primer cuadrante
    --  cuadrante = "01" ==> Segundo cuadrante
    --  cuadrante = "10" ==> Cuarto cuadrante
    --  cuadrante = "11" ==> Tercer cuadrante

    cuadrante(0) <= xi(N-1);
    cuadrante(1) <= yi(N-1);

    process(clk)
    begin
      if rising_edge(clk) then
        if(rst='1') then
          x_prima <= (others => '0');
          y_prima <= (others => '0');
          z_prima <= (others => '0');
          dv_o <= '0';  --salida invalida hasta que entre un dato nuevo
        else
          dv_o <= en_i;   --siempre que tengamos enable, tendremos una salida calculada
          if(en_i ='1') then
            --las entradas tienen signo, por lo que el bit mas a la izquierda
            --es el bit de signo
            if cuadrante = "00" or cuadrante = "10" then    --Primer y cuarto cuadrante, no corregimos nada
              x_prima <= xi;
              y_prima <= yi;
              z_prima <= zi;
            else    --Tercer cuadrante, llevamos al primero, segundo, llevamos al cuarto
              x_prima <= std_logic_vector(to_signed(-to_integer(signed(xi)),N));
              y_prima <= std_logic_vector(to_signed(-to_integer(signed(yi)),N));
              z_prima <= std_logic_vector(to_signed(to_integer(signed(zi)) + 12868,N)); --valor correspondiente a pi
            end if;
          else
            x_prima <= (others => '0');
            y_prima <= (others => '0');
            z_prima <= (others => '0');
            dv_o <= '0';  --salida invalida hasta que entre un dato nuevo
          end if;
        end if;
      end if;
    end process;




    ---------------------------------------------------------------------------
  end;
