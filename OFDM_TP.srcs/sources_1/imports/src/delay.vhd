--------------------------------------------------------------------
-- Nombre del componente: IFFT
--
-- Descripcion: Bloque de FFT inversa
--
-- Autor: Gonzalo Sanchez
-- Fecha: 29/12/18
--------------------------------------------------------------------
-- Este modulo demora un clock los datos a la salida, para cumplir con
-- el timing de la XFFT
--------------------------------------------------------------------
-- Inclusion de librerias y paquetes
--------------------------------------------------------------------
library IEEE;
use IEEE.std_logic_1164.all;

entity delay is
	generic(
		N : natural := 16 --Ancho de la palabra
	);
	port(
		clk: in std_logic;
		rst: in std_logic;
		ce:  in std_logic;
		rfd_in : in std_logic;
		data_in_re: in STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		data_in_img: in STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		start_o : out std_logic;
		data_out_re: out STD_LOGIC_VECTOR(N-1 DOWNTO 0);
		data_out_img: out STD_LOGIC_VECTOR(N-1 DOWNTO 0)
	);
end;

architecture delay_arq of delay is

	signal memoria_re_out, memoria_img_out : STD_LOGIC_VECTOR(N-1 DOWNTO 0);
-------------------------------------------------

begin
process(clk)
	begin
		if rising_edge(clk) then
      if(rst='1') then
        start_o <= '0';        --data valid y salidas a cero
        data_out_re <= (others =>'0');
        data_out_re <= (others =>'0');
				memoria_re_out <= (others =>'0');
				memoria_img_out <= (others =>'0');
      else
				start_o <= ce;
				memoria_re_out <= data_in_re;
				memoria_img_out <= data_in_img;

				data_out_re <= memoria_re_out;
				data_out_img <= memoria_img_out;
			end if;
		end if;
end process;



end;
