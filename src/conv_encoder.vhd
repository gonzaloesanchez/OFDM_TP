--------------------------------------------------------------------
-- Nombre del componente: conv_encoder
--
-- Descripcion: Codificador convolucional
--
-- Autor: Gonzalo Sanchez
-- Fecha: 17/08/18

--------------------------------------------------------------------

--------------------------------------------------------------------
-- Inclusion de librerias y paquetes
--------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity conv_encoder is
    port(
  clk   : in std_logic;
  rst   : in std_logic;
  ce    : in std_logic;
  data_in: in std_logic_vector (0 downto 0);
  data_out  : out std_logic_vector(1 downto 0);
  dv_o  : out std_logic
  );
end;

--------------------------------------------------------------------
-- Arquitectura
--------------------------------------------------------------------
architecture conv_encoder_arq of conv_encoder is

  -- Insertar signals aca
  signal m1: std_logic;             --elementos de memoria
  signal m2: std_logic;
  signal u1: std_logic;             --primer rama
  signal u2: std_logic;             --segunda rama
  signal coded: std_logic_vector(1 downto 0);
  -------------------------------------------------

  begin

    process(clk)
    begin
      if rising_edge(clk) then
        if(rst='1') then
          m1 <= '0';
          m2 <= '0';
          data_out <= (others =>'0');
        else
          m1 <= data_in(0);        --primer elemento de memoria
          m2 <= m1;             --segundo elemento de memoria
          data_out <= coded;
        end if;
      end if;
    end process;


    u1 <= data_in(0) xor m1 xor m2;
    u2 <= data_in(0) xor m2;
    coded <= u1 & u2;
    dv_o <= ce;         --solamente tendremos datos validos si habilitamos el modulo

  end;
