# Tcl script generated by PlanAhead

set reloadAllCoreGenRepositories true

set tclUtilsPath "/home/gonza/Xilinx/14.7/ISE_DS/PlanAhead/scripts/pa_cg_utils.tcl"

set repoPaths ""

set cgIndexMapPath "/home/gonza/Maestria/FPGA_Comms/OFDM_TP/OFDM_TP.srcs/sources_1/ip/cg_lin_index_map.xml"

set cgProjectPath "/home/gonza/Maestria/FPGA_Comms/OFDM_TP/OFDM_TP.srcs/sources_1/ip/xfft_v7_1_0/coregen.cgc"

set ipFile "/home/gonza/Maestria/FPGA_Comms/OFDM_TP/OFDM_TP.srcs/sources_1/ip/xfft_v7_1_0/xfft_v7_1_0.xco"

set ipName "xfft_v7_1_0"

set vlnv "xilinx.com:ip:xfft:7.1"

set cgPartSpec "xc3s500e-4fg320"

set bomFilePath "/home/gonza/Maestria/FPGA_Comms/OFDM_TP/OFDM_TP.srcs/sources_1/ip/xfft_v7_1_0/pa_cg_bom.xml"

set hdlType "VHDL"

set chains "CUSTOMIZE_CURRENT_CHAIN INSTANTIATION_TEMPLATES_CHAIN"

# configure the IP
set result [source "/home/gonza/Xilinx/14.7/ISE_DS/PlanAhead/scripts/pa_cg_config_core.tcl"]

exit $result
