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
char *STD_STANDARD;
char *IEEE_P_3620187407;
char *IEEE_P_3499444699;
char *WORK_P_0398875704;
char *IEEE_P_1242562249;


int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    ieee_p_2592010699_init();
    ieee_p_1242562249_init();
    ieee_p_3499444699_init();
    ieee_p_3620187407_init();
    work_p_0398875704_init();
    work_a_3892918792_3212880686_init();
    work_a_0665108037_3212880686_init();
    work_a_0644273266_3212880686_init();
    work_a_2994572250_3212880686_init();
    work_a_3015696877_3212880686_init();
    work_a_0237307290_3212880686_init();
    work_a_2985910196_3212880686_init();
    work_a_2956670339_3212880686_init();
    work_a_2399776393_3212880686_init();
    work_a_4074720922_3212880686_init();
    work_a_2587235664_3212880686_init();
    work_a_0345076465_3212880686_init();
    work_a_2682122952_3212880686_init();
    work_a_1299842048_3212880686_init();
    work_a_2816320319_3212880686_init();
    work_a_2086327694_3212880686_init();
    work_a_2730001895_3212880686_init();
    work_a_0438437946_3212880686_init();
    work_a_1949178628_2372691052_init();


    xsi_register_tops("work_a_1949178628_2372691052");

    IEEE_P_2592010699 = xsi_get_engine_memory("ieee_p_2592010699");
    xsi_register_ieee_std_logic_1164(IEEE_P_2592010699);
    STD_STANDARD = xsi_get_engine_memory("std_standard");
    IEEE_P_3620187407 = xsi_get_engine_memory("ieee_p_3620187407");
    IEEE_P_3499444699 = xsi_get_engine_memory("ieee_p_3499444699");
    WORK_P_0398875704 = xsi_get_engine_memory("work_p_0398875704");
    IEEE_P_1242562249 = xsi_get_engine_memory("ieee_p_1242562249");

    return xsi_run_simulation(argc, argv);

}
