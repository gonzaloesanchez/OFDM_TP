#!/bin/sh
# 
# PlanAhead(TM)
# runme.sh: PlanAhead-generated Script for launching ISim application
# Copyright 1986-1999, 2001-2013 Xilinx, Inc. All Rights Reserved.
# 
if [ -z "$PATH" ]; then
  PATH=$XILINX/lib/$PLATFORM:$XILINX/bin/$PLATFORM:/home/gonza/Xilinx/14.7/ISE_DS/EDK/bin/lin64:/home/gonza/Xilinx/14.7/ISE_DS/ISE/bin/lin64:/home/gonza/Xilinx/14.7/ISE_DS/common/bin/lin64
else
  PATH=$XILINX/lib/$PLATFORM:$XILINX/bin/$PLATFORM:/home/gonza/Xilinx/14.7/ISE_DS/EDK/bin/lin64:/home/gonza/Xilinx/14.7/ISE_DS/ISE/bin/lin64:/home/gonza/Xilinx/14.7/ISE_DS/common/bin/lin64:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=$XILINX/lib/$PLATFORM:/home/gonza/Xilinx/14.7/ISE_DS/EDK/lib/lin64:/home/gonza/Xilinx/14.7/ISE_DS/ISE/lib/lin64:/home/gonza/Xilinx/14.7/ISE_DS/common/lib/lin64
else
  LD_LIBRARY_PATH=$XILINX/lib/$PLATFORM:/home/gonza/Xilinx/14.7/ISE_DS/EDK/lib/lin64:/home/gonza/Xilinx/14.7/ISE_DS/ISE/lib/lin64:/home/gonza/Xilinx/14.7/ISE_DS/common/lib/lin64:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

#
# Setup env for Xilinx simulation libraries
#
XILINX_PLANAHEAD=/home/gonza/Xilinx/14.7/ISE_DS/PlanAhead
export XILINX_PLANAHEAD
ExecStep()
{
   "$@"
   RETVAL=$?
   if [ $RETVAL -ne 0 ]
   then
       exit $RETVAL
   fi
}


ExecStep fuse -intstyle pa -incremental -L work -o top_module_tb.exe --prj /home/gonza/Maestria/FPGA_Comms/OFDM_TP/OFDM_TP.sim/sim_1/behav/top_module_tb.prj -top work.top_module_tb
