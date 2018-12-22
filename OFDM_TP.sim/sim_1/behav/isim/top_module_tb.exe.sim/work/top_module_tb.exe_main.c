/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

#include "xsi.h"

struct XSI_INFO xsi_info;

char *IEEE_P_2592010699;
char *IEEE_P_0774719531;
char *IEEE_P_1242562249;
char *IEEE_P_3499444699;
char *STD_STANDARD;
char *IEEE_P_3620187407;


int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    ieee_p_2592010699_init();
    ieee_p_1242562249_init();
    ieee_p_3499444699_init();
    ieee_p_0774719531_init();
    ieee_p_3620187407_init();
    xilinxcorelib_a_0596749275_3212880686_init();
    xilinxcorelib_a_2348083911_3212880686_init();
    xilinxcorelib_a_1449852800_3212880686_init();
    xilinxcorelib_a_3963207662_3212880686_init();
    work_a_1488956453_0643775295_init();
    work_a_1508009627_0898276698_init();
    work_a_3920725739_1738117658_init();
    xilinxcorelib_a_0500574322_3212880686_init();
    xilinxcorelib_a_2570771257_3212880686_init();
    xilinxcorelib_a_3930484859_3212880686_init();
    xilinxcorelib_a_0371290630_3212880686_init();
    work_a_2404459771_0614359745_init();
    work_a_3225011129_3746769118_init();
    work_a_2388550197_2372691052_init();


    xsi_register_tops("work_a_2388550197_2372691052");

    IEEE_P_2592010699 = xsi_get_engine_memory("ieee_p_2592010699");
    xsi_register_ieee_std_logic_1164(IEEE_P_2592010699);
    IEEE_P_0774719531 = xsi_get_engine_memory("ieee_p_0774719531");
    IEEE_P_1242562249 = xsi_get_engine_memory("ieee_p_1242562249");
    IEEE_P_3499444699 = xsi_get_engine_memory("ieee_p_3499444699");
    STD_STANDARD = xsi_get_engine_memory("std_standard");
    IEEE_P_3620187407 = xsi_get_engine_memory("ieee_p_3620187407");

    return xsi_run_simulation(argc, argv);

}
