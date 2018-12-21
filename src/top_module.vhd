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
        fx2_rst, clk_system,clk2x_system : in  std_logic;
	);
end top_module;

architecture top_module_arch of top_module is

	--DECLARACION DE COMPONENTES


	--DECLARACION DE SEÑALES

	--GENERALES
	signal clk_s,clk2x_s, rst_s : std_logic;

begin

	clk_s<=clk_system;
	clk2x_s<=clk2x_system;
	rst_s<=fx2_rst;


	-- INSTANCIACION DE COMPONENTES


end top_module_arch;
