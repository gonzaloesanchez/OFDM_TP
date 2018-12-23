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

char *UNISIM_P_0947159679;
char *IEEE_P_2592010699;
char *STD_STANDARD;
char *UNISIM_P_3222816464;
char *STD_TEXTIO;
char *IEEE_P_2717149903;
char *IEEE_P_1367372525;
char *IEEE_P_3620187407;
char *IEEE_P_3499444699;
char *XILINXCORELIB_P_1003066856;
char *XILINXCORELIB_P_1837083571;
char *IEEE_P_1242562249;


int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    ieee_p_2592010699_init();
    ieee_p_1242562249_init();
    unisim_p_0947159679_init();
    std_textio_init();
    ieee_p_2717149903_init();
    ieee_p_1367372525_init();
    unisim_p_3222816464_init();
    ieee_p_3499444699_init();
    ieee_p_3620187407_init();
    xilinxcorelib_a_0596749275_3212880686_init();
    xilinxcorelib_a_2348083911_3212880686_init();
    xilinxcorelib_a_1449852800_3212880686_init();
    xilinxcorelib_a_3963207662_3212880686_init();
    work_a_1488956453_0643775295_init();
    xilinxcorelib_p_1837083571_init();
    xilinxcorelib_p_1003066856_init();
    xilinxcorelib_a_3272429799_3212880686_init();
    work_a_1881823395_0207835417_init();
    unisim_a_2562466605_1496654361_init();
    unisim_a_1717296735_4086321779_init();
    unisim_a_2809486315_3391448174_init();
    unisim_a_2933147246_3291887062_init();
    unisim_a_3441652288_1981213126_init();
    unisim_a_1654306579_0464044125_init();
    unisim_a_3055263662_1392679692_init();
    unisim_a_3021130211_3676810390_init();
    unisim_a_3032969004_3676810390_init();
    unisim_a_2729128116_3676810390_init();
    unisim_a_3738318759_3676810390_init();
    unisim_a_2863620592_3676810390_init();
    unisim_a_1189222326_3676810390_init();
    unisim_a_3333324666_3676810390_init();
    unisim_a_2615011483_3676810390_init();
    unisim_a_1704807036_3676810390_init();
    unisim_a_1451604616_3676810390_init();
    unisim_a_2721836395_3676810390_init();
    unisim_a_1567098837_3676810390_init();
    unisim_a_1621540565_3676810390_init();
    unisim_a_3025646323_3676810390_init();
    unisim_a_3163574381_0086195937_init();
    unisim_a_3208337549_3731405331_init();
    unisim_a_4067155809_3731405331_init();
    unisim_a_1358508979_3731405331_init();
    unisim_a_3343801509_3731405331_init();
    unisim_a_1775145742_3731405331_init();
    unisim_a_3522090112_3731405331_init();
    unisim_a_0900199298_3731405331_init();
    unisim_a_1976997195_3731405331_init();
    unisim_a_4068704603_3731405331_init();
    unisim_a_3600803327_3731405331_init();
    unisim_a_0371390563_3731405331_init();
    unisim_a_2261302797_3723259517_init();
    unisim_a_3519694068_2693788048_init();
    unisim_a_2545276020_3752513572_init();
    unisim_a_1446710196_3752513572_init();
    unisim_a_4104775526_3752513572_init();
    unisim_a_3120128138_3752513572_init();
    unisim_a_3449702363_3752513572_init();
    unisim_a_1863101193_3752513572_init();
    unisim_a_3586452736_3089378898_init();
    unisim_a_1646226234_1266530935_init();
    unisim_a_3484885994_2523279426_init();
    unisim_a_0868425105_1864968857_init();
    unisim_a_3870564484_3219970547_init();
    unisim_a_1398595224_1990404599_init();
    work_a_1184239711_0632001823_init();
    xilinxcorelib_a_0500574322_3212880686_init();
    xilinxcorelib_a_2570771257_3212880686_init();
    xilinxcorelib_a_3930484859_3212880686_init();
    xilinxcorelib_a_0371290630_3212880686_init();
    work_a_2404459771_0614359745_init();
    work_a_1518633648_3746769118_init();
    work_a_2388550197_2372691052_init();


    xsi_register_tops("work_a_2388550197_2372691052");

    UNISIM_P_0947159679 = xsi_get_engine_memory("unisim_p_0947159679");
    IEEE_P_2592010699 = xsi_get_engine_memory("ieee_p_2592010699");
    xsi_register_ieee_std_logic_1164(IEEE_P_2592010699);
    STD_STANDARD = xsi_get_engine_memory("std_standard");
    UNISIM_P_3222816464 = xsi_get_engine_memory("unisim_p_3222816464");
    STD_TEXTIO = xsi_get_engine_memory("std_textio");
    IEEE_P_2717149903 = xsi_get_engine_memory("ieee_p_2717149903");
    IEEE_P_1367372525 = xsi_get_engine_memory("ieee_p_1367372525");
    IEEE_P_3620187407 = xsi_get_engine_memory("ieee_p_3620187407");
    IEEE_P_3499444699 = xsi_get_engine_memory("ieee_p_3499444699");
    XILINXCORELIB_P_1003066856 = xsi_get_engine_memory("xilinxcorelib_p_1003066856");
    XILINXCORELIB_P_1837083571 = xsi_get_engine_memory("xilinxcorelib_p_1837083571");
    IEEE_P_1242562249 = xsi_get_engine_memory("ieee_p_1242562249");

    return xsi_run_simulation(argc, argv);

}
