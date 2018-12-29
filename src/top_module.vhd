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

	--FIFO IN 16 BYTES 8 A 1

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

	--CODIFICADOR CONVOLUCIONAL

	component encoder
		port(
			data_in    : in  std_logic;
			data_out_v : out std_logic_vector(1 downto 0);
			rdy        : out std_logic;
			nd			  : in std_logic;
			ce         : in  std_logic;
			sclr       : in  std_logic;
			clk        : in  std_logic);
	end component;


	--FIFO 2 A 4

	COMPONENT fifo_2a4
		PORT(
			rst    : IN  STD_LOGIC;
			wr_clk : IN  STD_LOGIC;
			rd_clk : IN  STD_LOGIC;
			din    : IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
			wr_en  : IN  STD_LOGIC;
			rd_en  : IN  STD_LOGIC;
			dout   : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
			full   : OUT STD_LOGIC;
			empty  : OUT STD_LOGIC;
			valid  : OUT STD_LOGIC
		);
	END COMPONENT;

	-- MAPPER
	COMPONENT mapper
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
	END COMPONENT;

	-- Delay para ingreso a IFFT (e ingreso a FFT tambien)

	COMPONENT delay is
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
	END COMPONENT;

	-- IFFT
	COMPONENT ifft
  	PORT (
	    clk : IN STD_LOGIC;
	    ce : IN STD_LOGIC;
	    sclr : IN STD_LOGIC;
	    start : IN STD_LOGIC;
	    unload : IN STD_LOGIC;
	    xn_re : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	    xn_im : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
	    fwd_inv : IN STD_LOGIC;
	    fwd_inv_we : IN STD_LOGIC;
	    rfd : OUT STD_LOGIC;
	    xn_index : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
	    busy : OUT STD_LOGIC;
	    edone : OUT STD_LOGIC;
	    done : OUT STD_LOGIC;
	    dv : OUT STD_LOGIC;
	    xk_index : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
	    xk_re : OUT STD_LOGIC_VECTOR(22 DOWNTO 0);
	    xk_im : OUT STD_LOGIC_VECTOR(22 DOWNTO 0)
	  );
	END COMPONENT;

--FFT
	COMPONENT fft
  PORT (
    clk : IN STD_LOGIC;
    ce : IN STD_LOGIC;
    sclr : IN STD_LOGIC;
    start : IN STD_LOGIC;
    unload : IN STD_LOGIC;
    xn_re : IN STD_LOGIC_VECTOR(22 DOWNTO 0);
    xn_im : IN STD_LOGIC_VECTOR(22 DOWNTO 0);
    fwd_inv : IN STD_LOGIC;
    fwd_inv_we : IN STD_LOGIC;
    rfd : OUT STD_LOGIC;
    xn_index : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
    busy : OUT STD_LOGIC;
    edone : OUT STD_LOGIC;
    done : OUT STD_LOGIC;
    dv : OUT STD_LOGIC;
    xk_index : OUT STD_LOGIC_VECTOR(5 DOWNTO 0);
    xk_re : OUT STD_LOGIC_VECTOR(29 DOWNTO 0);
    xk_im : OUT STD_LOGIC_VECTOR(29 DOWNTO 0)
  );
END COMPONENT;


	-- CORDIC
	COMPONENT cordic_completo
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
	END COMPONENT;

	-- Conversor de angulo
	COMPONENT conv_angulo
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
	END COMPONENT;

	--FIFO 4 A 2

	COMPONENT fifo_4a2
		PORT(
			rst    : IN  STD_LOGIC;
			wr_clk : IN  STD_LOGIC;
			rd_clk : IN  STD_LOGIC;
			din    : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
			wr_en  : IN  STD_LOGIC;
			rd_en  : IN  STD_LOGIC;
			dout   : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
			full   : OUT STD_LOGIC;
			empty  : OUT STD_LOGIC;
			valid  : OUT STD_LOGIC
		);
	END COMPONENT;

	--DECODIFICADOR VITERBI

	component viterbi
		port(
			data_in0 : in  std_logic_vector(0 downto 0);
			data_in1 : in  std_logic_vector(0 downto 0);
			data_out : out std_logic;
			rdy      : out std_logic;
			ce       : in  std_logic;
			sclr     : in  std_logic;
			clk      : in  std_logic);
	end component;


	--FIFO OUT 16 BYTES 1 A 8

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
	constant N_tb: integer:= 16;
  constant B_tb: integer:= 4;
	constant  ITER : natural := 7;--Numero de iteraciones del cordic

	--FIFO ENTRADA
	signal fifo_in_data_out : std_logic_vector(0 downto 0);
	signal fifo_in_rd_en_s,fifo_in_empty_s : std_logic;
	signal fifo_in_do_v : std_logic;

	--ENCODER
	signal encoder_data_in : std_logic;
	signal encoder_data_out : std_logic_vector(1 downto 0);
	signal encoder_do_v,encoder_new_data_in : std_logic;

	-- FIFO 2 A 4
	signal fifo_2a4_data_in : std_logic_vector(1 downto 0);
	signal fifo_2a4_data_out : std_logic_vector(3 downto 0);
	signal fifo_2a4_rd_en_s,fifo_2a4_wr_en_s,fifo_2a4_empty_s : std_logic;
	signal fifo_2a4_do_v : std_logic;

	-- FIFO 4 A 2
	signal fifo_4a2_data_in : std_logic_vector(3 downto 0);
	signal fifo_4a2_data_out : std_logic_vector(1 downto 0);
	signal fifo_4a2_rd_en_s,fifo_4a2_wr_en_s,fifo_4a2_empty_s : std_logic;
	signal fifo_4a2_do_v : std_logic;

	--MAPPER
	signal mapper_data_in : std_logic_vector(3 downto 0);
	signal mapper_real_out,mapper_img_out : std_logic_vector(15 downto 0);
	signal mapper_en_s : std_logic;
	signal mapper_dv_s : std_logic;

	-- anchos de palabra para IFFT y FFT

	constant N_IFFT: integer:= 16;		--ancho de palabra de entrada para FFT
	constant N_FFT: integer:= 23;		--ancho de palabra de entrada para FFT
	constant N_OUT_FFT: integer:= 30;		--ancho de palabra de salida para FFT

	-- Delay para ifft
	signal delay_ifft_in_re,delay_ifft_in_im : std_logic_vector(N_IFFT-1 downto 0);
	signal delay_ifft_out_re,delay_ifft_out_im : std_logic_vector(N_IFFT-1 downto 0);
	signal delay_ifft_start_out_s : std_logic;
	signal delay_ifft_en_s : std_logic;

	--IFFT
	signal ifft_in_re,ifft_in_im : std_logic_vector(N_IFFT-1 downto 0);
	signal ifft_out_re,ifft_out_im : std_logic_vector(N_FFT-1 downto 0);
	signal ifft_start_s : std_logic;
	signal ifft_we_s : std_logic;
	signal ifft_done_s : std_logic;
	signal ifft_dv_s : std_logic;

	--Delay para FFT
	signal delay_fft_in_re,delay_fft_in_im : std_logic_vector(N_FFT-1 downto 0);
	signal delay_fft_out_re,delay_fft_out_im : std_logic_vector(N_FFT-1 downto 0);
	signal delay_fft_start_out_s : std_logic;
	signal delay_fft_en_s : std_logic;

	--FFT
	signal fft_in_re,fft_in_im : std_logic_vector(N_FFT-1 downto 0);
	signal fft_out_re,fft_out_im : std_logic_vector(N_OUT_FFT-1 downto 0);
	signal fft_start_s : std_logic;
	signal fft_we_s : std_logic;
	signal fft_done_s : std_logic;
	signal fft_dv_s : std_logic;

	--CORDIC
	signal cordic_real_in,cordic_img_in : std_logic_vector(15 downto 0);
	signal cordic_en_s : std_logic;
	signal cordic_dv_s : std_logic;
	signal cordic_data_out : std_logic_vector(15 downto 0);

	--CONVERSOR DE ANGULO
	signal conv_en_s : std_logic;
	signal conv_dv_s : std_logic;
	signal conv_data_in : std_logic_vector(15 downto 0);
	signal conv_data_out : std_logic_vector(3 downto 0);



 --VITERBI
	signal viterbi_data_out,viterbi_data_in0,viterbi_data_in1: std_logic_vector(0 downto 0);
	signal viterbi_rdy_s,viterbi_ce : std_logic;

	--FIFO SALIDA
	signal fifo_out_empty_s, fifo_out_rd_en_s, fifo_out_wr_en_s : std_logic;
	signal fifo_out_data_in_s: std_logic_vector(0 downto 0);



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
			rd_clk => clk2x_s,
			din    => h2fData_out,
			wr_en  => h2fValid_out,
			rd_en  => fifo_in_rd_en_s,
			dout   => fifo_in_data_out,
			full   => open,
			empty  => fifo_in_empty_s,
			valid  => fifo_in_do_v
		);

		fifo_in_rd_en_s<=not fifo_in_empty_s;

		--Conexiones desde FIFO IN a ENCODER
		encoder_data_in <= fifo_in_data_out(0);
		encoder_new_data_in <= fifo_in_do_v;


		--Encoder
		encoder0 : encoder
		PORT MAP(
			data_in    => encoder_data_in,
			data_out_v => encoder_data_out,
			rdy        => encoder_do_v,
			nd 				 => encoder_new_data_in,
			ce         => '1',
			sclr       => rst_s,
			clk        => clk2x_s
		);

		--Conexiones desde ENCODER a FIFO 2a4
		fifo_2a4_data_in <= encoder_data_out;
		fifo_2a4_wr_en_s <= encoder_do_v;

		-- FIFO 2 a 4
		fifo_2a4_0 : fifo_2a4
			PORT MAP(
				rst    => rst_s,
				wr_clk => clk2x_s,
				rd_clk => clk_s,
				din    => fifo_2a4_data_in,
				wr_en  => fifo_2a4_wr_en_s,
				rd_en  => fifo_2a4_rd_en_s,
				dout   => fifo_2a4_data_out,
				full   => open,
				empty  => fifo_2a4_empty_s,
				valid  => fifo_2a4_do_v
			);

		fifo_2a4_rd_en_s<=not fifo_2a4_empty_s;

		--Conexiones desde FIFO 2a4 a MAPPER
		mapper_en_s <= fifo_2a4_do_v;
		mapper_data_in <= fifo_2a4_data_out;

		--MAPPER
		mapper0: mapper
		generic map(
		  N => N_tb,
		  B => B_tb
		)
	  port map(
	    clk =>  clk_s,
	    rst =>  rst_s,
	    en_i =>  mapper_en_s,
	    data_in  =>  mapper_data_in,
	    dv_o   =>  mapper_dv_s,
	    real_o   =>  mapper_real_out,
	    img_o   => mapper_img_out
	  );


		--Conexiones desde MAPPER a DELAY IFFT
		delay_ifft_en_s <= mapper_dv_s;
		delay_ifft_in_re <= mapper_real_out;
		delay_ifft_in_im <= mapper_img_out;

		-- DELAY IFFT
		delay_ifft:delay
		generic map(N => N_IFFT)
		port map(
			clk => clk_s,
			rst =>  rst_s,
			ce => delay_ifft_en_s,
			data_in_re => delay_ifft_in_re,
			data_in_img => delay_ifft_in_im,
			start_o => delay_ifft_start_out_s,
			data_out_re => delay_ifft_out_re,
			data_out_img=> delay_ifft_out_im
		);

		--Conexiones desde DELAY IFFT a IFFT
		ifft_start_s <= delay_ifft_start_out_s;
		ifft_in_re <= delay_ifft_out_re;
		ifft_in_im <= delay_ifft_out_im;

		-- IFFT
		ifft0: ifft
		PORT MAP (
			clk => clk_s,
			ce => '1',
			sclr => rst_s,
			start => ifft_start_s,
	    unload => ifft_done_s,
			xn_re => ifft_in_re,
			xn_im => ifft_in_im,
			fwd_inv => '0',						--IFFT
			fwd_inv_we => ifft_we_s,
			rfd => open,
			xn_index => open,
			busy => open,
			edone => open,
			done => ifft_done_s,
			dv => ifft_dv_s,
			xk_index => open,
			xk_re => ifft_out_re,
			xk_im => ifft_out_im
		);


		--Conexiones desde IFFT a DELAY FFT
		delay_fft_en_s <= ifft_dv_s;
		delay_fft_in_re <= ifft_out_re;
		delay_fft_in_im <= ifft_out_im;

		--DELAY FFT
		delay_fft:delay
		generic map(N => N_FFT)
		port map(
			clk => clk_s,
			rst =>  rst_s,
			ce => delay_fft_en_s,
			data_in_re => delay_fft_in_re,
			data_in_img => delay_fft_in_im,
			start_o => delay_fft_start_out_s,
			data_out_re => delay_fft_out_re,
			data_out_img=> delay_fft_out_im
		);

		--Conexiones desde DELAY FFT a FFT
		fft_start_s <= delay_fft_start_out_s;
		fft_in_re <= delay_fft_out_re;
		fft_in_im <= delay_fft_out_im;

		--FFT
		fft0: fft
		PORT MAP (
			clk => clk_s,
			ce => '1',
			sclr => rst_s,
			start => fft_start_s,
	    unload => fft_done_s,
			xn_re => fft_in_re,
			xn_im => fft_in_im,
			fwd_inv => '1',						--IFFT
			fwd_inv_we => fft_we_s,
			rfd => open,
			xn_index => open,
			busy => open,
			edone => open,
			done => fft_done_s,
			dv => fft_dv_s,
			xk_index => open,
			xk_re => fft_out_re,
			xk_im => fft_out_im
		);

		--Conexiones desde FFT a CORDIC
		cordic_en_s <= fft_dv_s;
		cordic_real_in <= fft_out_re;
		cordic_img_in <= fft_out_im;


		--CORDIC
		cordic0: cordic_completo
		generic map(
	    N     => N_tb,
	    ITER  => ITER
	  )
	  port map(
	    clk =>  clk_s,
	    rst =>  rst_s,
	    en_i  => cordic_en_s ,
	    x_i   => cordic_real_in ,
	    y_i   => cordic_img_in ,
	    dv_o => cordic_dv_s,
	    z_o  => cordic_data_out
	  );


		--Conexiones desde CORDIC a CONVERSOR DE ANGULO
		conv_en_s <= cordic_dv_s;
		conv_data_in <= cordic_data_out;

		--CONVERSOR DE ANGULO
		conv0 : conv_angulo
		generic map(
		  N => N_tb,
		  B => B_tb
		)
	  port map(
	    clk =>  clk_s,
	    rst =>  rst_s,
	    en_i => conv_en_s ,
	    data_in  => conv_data_in ,
	    dv_o   => conv_dv_s ,
	    data_out   => conv_data_out
	  );


		--Conexiones desde CONVERSOR DE ANGULO a FIFO 4a2
		fifo_4a2_data_in <= conv_data_out;
		fifo_4a2_wr_en_s <= conv_dv_s;

		--FIFO 4a2
		fifo_4a2_0 : fifo_4a2
			PORT MAP(
				rst    => rst_s,
				wr_clk => clk_s,
				rd_clk => clk2x_s,
				din    => fifo_4a2_data_in,
				wr_en  => fifo_4a2_wr_en_s,
				rd_en  => fifo_4a2_rd_en_s,
				dout   => fifo_4a2_data_out,
				full   => open,
				empty  => fifo_4a2_empty_s,
				valid  => fifo_4a2_do_v
			);

		fifo_4a2_rd_en_s<=not fifo_4a2_empty_s;

		--Conexiones de FIFO 4a2 a VITERBI
		viterbi_data_in0(0) <= fifo_4a2_data_out(0);
		viterbi_data_in1(0) <= fifo_4a2_data_out(1);


		--DECODIFICADOR VITERBI
	viterbi0 : viterbi
		PORT MAP(
			data_in0 => viterbi_data_in0,
			data_in1 => viterbi_data_in1,
			data_out => viterbi_data_out(0),
			rdy      => viterbi_rdy_s,
			ce       => viterbi_ce,
			sclr     => rst_s,
			clk      => clk2x_s
		);

		viterbi_ce <= '1' when fifo_4a2_do_v = '1' or viterbi_rdy_s = '1' else
						  '0';

		--viterbi_data_in0(0) <= encoder_data_out(0) when encoder_do_v = '1' else
		--							 '0'; -- padding
		--viterbi_data_in1(0) <= encoder_data_out(1) when encoder_do_v = '1' else
		--							 '0'; -- padding

--Conexiones desde VITERBI a FIFO OUT
	fifo_out_data_in_s <= viterbi_data_out;
	fifo_out_wr_en_s <= viterbi_rdy_s;

		--FIFO DE SALIDA
	fifo_out0 : fifo_16_1a8
		PORT MAP(
			rst    => rst_s,
			wr_clk => clk2x_s,
			rd_clk => fx2_clk,
			din    => fifo_out_data_in_s,
			wr_en  => fifo_out_wr_en_s,
			rd_en  => fifo_out_rd_en_s,
			dout   => f2hData_in,
			full   => open,
			empty  => fifo_out_empty_s,
			valid  => f2hValid_in
		);

		fifo_out_rd_en_s<=not fifo_out_empty_s;

end top_module_arch;
