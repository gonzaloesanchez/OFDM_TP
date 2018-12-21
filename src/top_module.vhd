----------------------------------------------------------------------------------
-- Company: 				MSE - FPGA Comms
-- Engineer: 				Gonzalo Sanchez
--
-- Create Date:    21/12/2018
-- Design Name:
-- Module Name:    top_module - top_module_arch
-- Project Name: 		OFDM_TP
-- Target Devices:
-- Tool versions:
-- Description:
--
-- Dependencies:
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_module is
	port(
		fx2_clk, fx2_rst, clk_system,clk2x_system : in  std_logic;
		-- Host >> FPGA pipe:
		h2fData_out                  : in  std_logic_vector(7 downto 0); -- data lines used when the host writes to a channel
		h2fValid_out                 : in  std_logic; -- '1' means "on the next clock rising edge, please accept the data on h2fData_out"
		h2fReady_in                  : out std_logic; -- channel logic can drive this low to say "I'm not ready for more data yet"

		-- Host << FPGA pipe:
		f2hData_in                   : out std_logic_vector(7 downto 0); -- data lines used when the host reads from a channel
		f2hValid_in                  : out std_logic; -- channel logic can drive this low to say "I don't have data ready for you"
		f2hReady_out                 : in  std_logic -- '1' means "on the next clock rising edge, put your next byte of data on f2hData_in"
	);
end top_module;

architecture top_module_arch of top_module is

	--DECLARACION DE COMPONENTES

	--FIFO 16 BYTES 8 A 1

	COMPONENT fifo_16_8a1
		PORT(
			rst    : IN  STD_LOGIC;
			wr_clk : IN  STD_LOGIC;
			rd_clk : IN  STD_LOGIC;
			din    : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			wr_en  : IN  STD_LOGIC;
			rd_en  : IN  STD_LOGIC;
			dout   : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
			full   : OUT STD_LOGIC;
			empty  : OUT STD_LOGIC;
			valid  : OUT STD_LOGIC
		);
	END COMPONENT;

	--FIFO 16 BYTES 1 A 8

	COMPONENT fifo_16_1a8
		PORT(
			rst    : IN  STD_LOGIC;
			wr_clk : IN  STD_LOGIC;
			rd_clk : IN  STD_LOGIC;
			din    : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
			wr_en  : IN  STD_LOGIC;
			rd_en  : IN  STD_LOGIC;
			dout   : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			full   : OUT STD_LOGIC;
			empty  : OUT STD_LOGIC;
			valid  : OUT STD_LOGIC
		);
	END COMPONENT;

	--DECLARACION DE SEÑALES

	--GENERALES
	signal clk_s,clk2x_s, rst_s : std_logic;

	--FIFO ENTRADA -> FIFO SALIDA
	signal fifo_in_rd_en_s,fifo_in_empty_s, conv_ce_s : std_logic;
	signal conv_in_s: std_logic_vector(0 downto 0);


 --VITERBI -> FIFO SALIDA
--	signal decoder_out_s: std_logic_vector(0 downto 0);
--	signal decoder_ready_s, fifo_out_empty_s, fifo_out_rd_en_s : std_logic;
--	signal out_s : std_logic;

begin

	clk_s<=clk_system;
	clk2x_s<=clk2x_system;
	rst_s<=fx2_rst;
	-- INSTANCIACION DE COMPONENTES

	--FIFO DE ENTRADA

	fifo_in0 : fifo_16_8a1
		PORT MAP(
			rst    => fx2_rst,
			wr_clk => fx2_clk,
			rd_clk => clk_s,
			din    => h2fData_out,
			wr_en  => h2fValid_out,
			rd_en  => fifo_in_rd_en_s,
			dout   => conv_in_s,
			full   => open,
			empty  => fifo_in_empty_s,
			valid  => conv_ce_s
		);

		fifo_in_rd_en_s<=not fifo_in_empty_s;


		--FIFO DE SALIDA
	fifo_out0 : fifo_16_1a8
		PORT MAP(
			rst    => rst_s,
			wr_clk => clk2x_s,
			rd_clk => fx2_clk,
			din    => decoder_out_s,
			wr_en  => decoder_ready_s,
			rd_en  => fifo_out_rd_en_s,
			dout   => f2hData_in,
			full   => open,
			empty  => fifo_out_empty_s,
			valid  => f2hValid_in
		);

		fifo_out_rd_en_s<=(not fifo_out_empty_s) and f2hReady_out;

end top_module_arch;
