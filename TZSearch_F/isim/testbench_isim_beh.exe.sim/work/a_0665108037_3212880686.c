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

/* This file is designed for use with ISim build 0x7708f090 */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "C:/Users/Brunno/Desktop/TZSearch_Github/TZSearch/TZSearch_F/genericAdder.vhd";
extern char *IEEE_P_3620187407;
extern char *IEEE_P_2592010699;

char *ieee_p_3620187407_sub_767668596_3965413181(char *, char *, char *, char *, char *, char *);


static void work_a_0665108037_3212880686_p_0(char *t0)
{
    char t1[16];
    char t4[16];
    char t9[16];
    char *t2;
    char *t3;
    char *t5;
    char *t6;
    char *t7;
    char *t8;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    unsigned int t14;
    unsigned int t15;
    unsigned char t16;
    char *t17;
    char *t18;
    char *t19;
    char *t20;
    char *t21;
    char *t22;

LAB0:    xsi_set_current_line(47, ng0);

LAB3:    t2 = (t0 + 1032U);
    t3 = *((char **)t2);
    t5 = ((IEEE_P_2592010699) + 4024);
    t6 = (t0 + 4880U);
    t2 = xsi_base_array_concat(t2, t4, t5, (char)99, (unsigned char)2, (char)97, t3, t6, (char)101);
    t7 = (t0 + 1192U);
    t8 = *((char **)t7);
    t10 = ((IEEE_P_2592010699) + 4024);
    t11 = (t0 + 4896U);
    t7 = xsi_base_array_concat(t7, t9, t10, (char)99, (unsigned char)2, (char)97, t8, t11, (char)101);
    t12 = ieee_p_3620187407_sub_767668596_3965413181(IEEE_P_3620187407, t1, t2, t4, t7, t9);
    t13 = (t1 + 12U);
    t14 = *((unsigned int *)t13);
    t15 = (1U * t14);
    t16 = (9U != t15);
    if (t16 == 1)
        goto LAB5;

LAB6:    t17 = (t0 + 3032);
    t18 = (t17 + 56U);
    t19 = *((char **)t18);
    t20 = (t19 + 56U);
    t21 = *((char **)t20);
    memcpy(t21, t12, 9U);
    xsi_driver_first_trans_fast_port(t17);

LAB2:    t22 = (t0 + 2952);
    *((int *)t22) = 1;

LAB1:    return;
LAB4:    goto LAB2;

LAB5:    xsi_size_not_matching(9U, t15, 0);
    goto LAB6;

}


extern void work_a_0665108037_3212880686_init()
{
	static char *pe[] = {(void *)work_a_0665108037_3212880686_p_0};
	xsi_register_didat("work_a_0665108037_3212880686", "isim/testbench_isim_beh.exe.sim/work/a_0665108037_3212880686.didat");
	xsi_register_executes(pe);
}
