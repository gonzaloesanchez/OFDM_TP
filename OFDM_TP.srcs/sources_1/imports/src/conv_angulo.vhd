library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity conv_angulo is
  generic(
    N : natural := 16; --Ancho de la palabra
    B : natural := 4 --Cantidad de bits de salida
    );
  port(
    clk : in std_logic;
    rst : in std_logic;
    en_i : in std_logic;
    data_in  : in std_logic_vector(N-1 downto 0);
    dv_o : out std_logic;
    data_out  : out std_logic_vector(B-1 downto 0)
    );
end entity;

--------------------------------------------------------------------
-- Arquitectura
--------------------------------------------------------------------

architecture conv_angulo_arq of conv_angulo is
  --signal out_packet: std_logic_vector(B-1 downto 0);
  --signal half_packet: std_logic_vector(1 downto 0);
  --signal packet_marker : std_logic;
  signal err_s : std_logic;
  --signal conv_angulo_ce_s : std_logic;
  --signal get_data_in_s : std_logic := '0';
  signal value : integer range -2**(N-1) to 2**(N-1)-1;


begin
  value <= to_integer(signed(data_in)); --solo actualizamos aca los datos de entrada

  process(clk)
  begin
    if rising_edge(clk) then
      if(rst='1') then
        dv_o <= '0';        --data valid y salidas a cero
        data_out <= (others =>'0');
      else
        if en_i = '1' then
          dv_o <= en_i;
          if (value > 0 and value <= 1609) then    --1º slice, angulo 11.25º, inferior 0º superior 22.5º
            data_out <= "0000";
          elsif (value > 1609 and value <= 3217) then --2º slice, angulo 33.75º, inferior 22.5º superior 45º
            data_out <= "0001";
          elsif (value > 3217 and value <= 4826) then   --3º slice, angulo 56.25º, inferior 45º superior 67.5º
            data_out <= "0010";
          elsif (value > 4826 and value <= 6434) then   --4º slice, angulo 78.75º, inferior 67.5 superior 90º
            data_out <= "0011";
          elsif (value > 6434 and value <= 8043) then   --5º  slice, angulo 101.25º, inferior 90 superior 112.5º
            data_out <= "0100";
          elsif (value > 8043 and value <= 9651) then   --6º slice, angulo 123.75º, inferior 112.5 superior 135º
            data_out <= "0101";
          elsif (value > 9651 and value <= 11260) then   --7º slice, angulo 146.25º, inferior 135º superior 157.5º
            data_out <= "0110";
          elsif (value > 11260 and value <= 12868) then   --8º slice, angulo 168.75º, inferior 157.5º superior 180º
            data_out <= "0111";
          elsif (value > 12868 and value <= 14477) then   --9º slice, angulo 191.25º, inferior 180º superior 202.5º
            data_out <= "1000";
          elsif (value > 14477 and value <= 16085) then   --10º slice, angulo 213.75º, inferior 202.5º superior 225º
            data_out <= "1001";
          elsif (value > 16085 and value <= 17694) then   --11º slice, angulo 236.25º, inferior 225º superior 247.5º
            data_out <= "1010";
          elsif (value > 17694 and value <= 19302) then   --12º slice, angulo 258.75º, inferior 247.5º superior 270º
            data_out <= "1011";
          elsif (value > -6434 and value <= -4826) then   --13º slice, angulo 281.25º, inferior -90º superior -67,5º
            data_out <= "1100";
          elsif (value > -4826 and value <= -3217) then   --14º slice, angulo 303.75º, inferior -67,5º superior -45º
            data_out <= "1101";
          elsif (value > -3217 and value <= -1609) then   --14º slice, angulo 326.25º, inferior -45º superior -22.5º
            data_out <= "1110";
          elsif (value > -1609 and value <= -0) then   --14º slice, angulo 348.75º, inferior -22.5º superior 0º
            data_out <= "1111";
          else
            data_out <= "0000";   --ningun valor valido, es un error
            err_s <= '1';
          end if;
        else
          dv_o <= '0';    --no puede haber indicacion de data valid si no tenemos enable input
        end if;
      end if;
    end if;
  end process;

  process (value)
  begin

  end process;

end architecture;
