@echo off


rem  PlanAhead(TM)
rem  runme.bat: a PlanAhead-generated ISim simulation Script
rem  Copyright 1986-1999, 2001-2013 Xilinx, Inc. All Rights Reserved.


set PATH=$XILINX/lib/$PLATFORM:$XILINX/bin/$PLATFORM;/home/gonza/Xilinx/14.7/ISE_DS/EDK/bin/lin64:/home/gonza/Xilinx/14.7/ISE_DS/ISE/bin/lin64:/home/gonza/Xilinx/14.7/ISE_DS/common/bin/lin64;/home/gonza/Xilinx/14.7/ISE_DS/EDK/lib/lin64:/home/gonza/Xilinx/14.7/ISE_DS/ISE/lib/lin64:/home/gonza/Xilinx/14.7/ISE_DS/common/lib/lin64;/home/gonza/Xilinx/14.7/ISE_DS/PlanAhead/bin;%PATH%

set XILINX_PLANAHEAD=/home/gonza/Xilinx/14.7/ISE_DS/PlanAhead

fuse -intstyle pa -incremental -L work -o top_module_tb.exe --prj /home/gonza/Maestria/FPGA_Comms/OFDM_TP/OFDM_TP.sim/sim_1/behav/top_module_tb.prj -top work.top_module_tb
if errorlevel 1 (
   cmd /c exit /b %errorlevel%
)
