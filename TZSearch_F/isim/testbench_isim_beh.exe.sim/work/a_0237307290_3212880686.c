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
static const char *ng0 = "C:/Users/Brunno/Desktop/TZSearch_F/TZSearch_F/blck4x4.vhd";



static void work_a_0237307290_3212880686_p_0(char *t0)
{
    char *t1;
    char *t2;
    unsigned char t3;
    unsigned char t4;
    char *t5;
    unsigned int t6;
    char *t7;
    unsigned char t8;
    unsigned int t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    unsigned char t15;
    int t16;
    int t17;
    int t18;
    int t19;
    unsigned int t20;
    int t21;
    int t22;
    unsigned int t23;
    unsigned int t24;
    unsigned int t25;
    char *t26;
    char *t27;

LAB0:    xsi_set_current_line(81, ng0);
    t1 = (t0 + 15768U);
    t2 = *((char **)t1);
    t3 = *((unsigned char *)t2);
    t4 = (t3 == (unsigned char)2);
    if (t4 != 0)
        goto LAB2;

LAB4:    t1 = (t0 + 15568U);
    t4 = xsi_signal_has_event(t1);
    if (t4 == 1)
        goto LAB15;

LAB16:    t3 = (unsigned char)0;

LAB17:    if (t3 != 0)
        goto LAB13;

LAB14:
LAB3:    t1 = (t0 + 23936);
    *((int *)t1) = 1;

LAB1:    return;
LAB2:    xsi_set_current_line(82, ng0);
    t1 = xsi_get_transient_memory(128U);
    memset(t1, 0, 128U);
    t5 = t1;
    t6 = (8U * 1U);
    t7 = t5;
    memset(t7, (unsigned char)2, t6);
    t8 = (t6 != 0);
    if (t8 == 1)
        goto LAB5;

LAB6:    t10 = (t0 + 24032);
    t11 = (t10 + 56U);
    t12 = *((char **)t11);
    t13 = (t12 + 56U);
    t14 = *((char **)t13);
    memcpy(t14, t1, 128U);
    xsi_driver_first_trans_fast(t10);
    xsi_set_current_line(83, ng0);
    t1 = xsi_get_transient_memory(72U);
    memset(t1, 0, 72U);
    t2 = t1;
    t6 = (9U * 1U);
    t5 = t2;
    memset(t5, (unsigned char)2, t6);
    t3 = (t6 != 0);
    if (t3 == 1)
        goto LAB7;

LAB8:    t7 = (t0 + 24096);
    t10 = (t7 + 56U);
    t11 = *((char **)t10);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    memcpy(t13, t1, 72U);
    xsi_driver_first_trans_fast(t7);
    xsi_set_current_line(84, ng0);
    t1 = xsi_get_transient_memory(40U);
    memset(t1, 0, 40U);
    t2 = t1;
    t6 = (10U * 1U);
    t5 = t2;
    memset(t5, (unsigned char)2, t6);
    t3 = (t6 != 0);
    if (t3 == 1)
        goto LAB9;

LAB10:    t7 = (t0 + 24160);
    t10 = (t7 + 56U);
    t11 = *((char **)t10);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    memcpy(t13, t1, 40U);
    xsi_driver_first_trans_fast(t7);
    xsi_set_current_line(85, ng0);
    t1 = xsi_get_transient_memory(22U);
    memset(t1, 0, 22U);
    t2 = t1;
    t6 = (11U * 1U);
    t5 = t2;
    memset(t5, (unsigned char)2, t6);
    t3 = (t6 != 0);
    if (t3 == 1)
        goto LAB11;

LAB12:    t7 = (t0 + 24224);
    t10 = (t7 + 56U);
    t11 = *((char **)t10);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    memcpy(t13, t1, 22U);
    xsi_driver_first_trans_fast(t7);
    xsi_set_current_line(86, ng0);
    t1 = xsi_get_transient_memory(12U);
    memset(t1, 0, 12U);
    t2 = t1;
    memset(t2, (unsigned char)2, 12U);
    t5 = (t0 + 24288);
    t7 = (t5 + 56U);
    t10 = *((char **)t7);
    t11 = (t10 + 56U);
    t12 = *((char **)t11);
    memcpy(t12, t1, 12U);
    xsi_driver_first_trans_fast(t5);
    goto LAB3;

LAB5:    t9 = (128U / t6);
    xsi_mem_set_data(t5, t5, t6, t9);
    goto LAB6;

LAB7:    t9 = (72U / t6);
    xsi_mem_set_data(t2, t2, t6, t9);
    goto LAB8;

LAB9:    t9 = (40U / t6);
    xsi_mem_set_data(t2, t2, t6, t9);
    goto LAB10;

LAB11:    t9 = (22U / t6);
    xsi_mem_set_data(t2, t2, t6, t9);
    goto LAB12;

LAB13:    xsi_set_current_line(88, ng0);
    t2 = (t0 + 16248U);
    t7 = *((char **)t2);
    t2 = (t0 + 24032);
    t10 = (t2 + 56U);
    t11 = *((char **)t10);
    t12 = (t11 + 56U);
    t13 = *((char **)t12);
    memcpy(t13, t7, 128U);
    xsi_driver_first_trans_fast(t2);
    xsi_set_current_line(89, ng0);
    t1 = (t0 + 17528U);
    t2 = *((char **)t1);
    t1 = (t0 + 24288);
    t5 = (t1 + 56U);
    t7 = *((char **)t5);
    t10 = (t7 + 56U);
    t11 = *((char **)t10);
    memcpy(t11, t2, 12U);
    xsi_driver_first_trans_fast(t1);
    xsi_set_current_line(90, ng0);
    t1 = (t0 + 39016);
    *((int *)t1) = 0;
    t2 = (t0 + 39020);
    *((int *)t2) = 7;
    t16 = 0;
    t17 = 7;

LAB18:    if (t16 <= t17)
        goto LAB19;

LAB21:    xsi_set_current_line(93, ng0);
    t1 = (t0 + 39024);
    *((int *)t1) = 0;
    t2 = (t0 + 39028);
    *((int *)t2) = 3;
    t16 = 0;
    t17 = 3;

LAB23:    if (t16 <= t17)
        goto LAB24;

LAB26:    xsi_set_current_line(96, ng0);
    t1 = (t0 + 39032);
    *((int *)t1) = 0;
    t2 = (t0 + 39036);
    *((int *)t2) = 1;
    t16 = 0;
    t17 = 1;

LAB28:    if (t16 <= t17)
        goto LAB29;

LAB31:    goto LAB3;

LAB15:    t2 = (t0 + 15608U);
    t5 = *((char **)t2);
    t8 = *((unsigned char *)t5);
    t15 = (t8 == (unsigned char)3);
    t3 = t15;
    goto LAB17;

LAB19:    xsi_set_current_line(91, ng0);
    t5 = (t0 + 16568U);
    t7 = *((char **)t5);
    t5 = (t0 + 39016);
    t18 = *((int *)t5);
    t19 = (t18 - 0);
    t6 = (t19 * 1);
    xsi_vhdl_check_range_of_index(0, 7, 1, *((int *)t5));
    t9 = (9U * t6);
    t20 = (0 + t9);
    t10 = (t7 + t20);
    t11 = (t0 + 39016);
    t21 = *((int *)t11);
    t22 = (t21 - 0);
    t23 = (t22 * 1);
    t24 = (9U * t23);
    t25 = (0U + t24);
    t12 = (t0 + 24096);
    t13 = (t12 + 56U);
    t14 = *((char **)t13);
    t26 = (t14 + 56U);
    t27 = *((char **)t26);
    memcpy(t27, t10, 9U);
    xsi_driver_first_trans_delta(t12, t25, 9U, 0LL);

LAB20:    t1 = (t0 + 39016);
    t16 = *((int *)t1);
    t2 = (t0 + 39020);
    t17 = *((int *)t2);
    if (t16 == t17)
        goto LAB21;

LAB22:    t18 = (t16 + 1);
    t16 = t18;
    t5 = (t0 + 39016);
    *((int *)t5) = t16;
    goto LAB18;

LAB24:    xsi_set_current_line(94, ng0);
    t5 = (t0 + 16888U);
    t7 = *((char **)t5);
    t5 = (t0 + 39024);
    t18 = *((int *)t5);
    t19 = (t18 - 0);
    t6 = (t19 * 1);
    xsi_vhdl_check_range_of_index(0, 3, 1, *((int *)t5));
    t9 = (10U * t6);
    t20 = (0 + t9);
    t10 = (t7 + t20);
    t11 = (t0 + 39024);
    t21 = *((int *)t11);
    t22 = (t21 - 0);
    t23 = (t22 * 1);
    t24 = (10U * t23);
    t25 = (0U + t24);
    t12 = (t0 + 24160);
    t13 = (t12 + 56U);
    t14 = *((char **)t13);
    t26 = (t14 + 56U);
    t27 = *((char **)t26);
    memcpy(t27, t10, 10U);
    xsi_driver_first_trans_delta(t12, t25, 10U, 0LL);

LAB25:    t1 = (t0 + 39024);
    t16 = *((int *)t1);
    t2 = (t0 + 39028);
    t17 = *((int *)t2);
    if (t16 == t17)
        goto LAB26;

LAB27:    t18 = (t16 + 1);
    t16 = t18;
    t5 = (t0 + 39024);
    *((int *)t5) = t16;
    goto LAB23;

LAB29:    xsi_set_current_line(97, ng0);
    t5 = (t0 + 17208U);
    t7 = *((char **)t5);
    t5 = (t0 + 39032);
    t18 = *((int *)t5);
    t19 = (t18 - 0);
    t6 = (t19 * 1);
    xsi_vhdl_check_range_of_index(0, 1, 1, *((int *)t5));
    t9 = (11U * t6);
    t20 = (0 + t9);
    t10 = (t7 + t20);
    t11 = (t0 + 39032);
    t21 = *((int *)t11);
    t22 = (t21 - 0);
    t23 = (t22 * 1);
    t24 = (11U * t23);
    t25 = (0U + t24);
    t12 = (t0 + 24224);
    t13 = (t12 + 56U);
    t14 = *((char **)t13);
    t26 = (t14 + 56U);
    t27 = *((char **)t26);
    memcpy(t27, t10, 11U);
    xsi_driver_first_trans_delta(t12, t25, 11U, 0LL);

LAB30:    t1 = (t0 + 39032);
    t16 = *((int *)t1);
    t2 = (t0 + 39036);
    t17 = *((int *)t2);
    if (t16 == t17)
        goto LAB31;

LAB32:    t18 = (t16 + 1);
    t16 = t18;
    t5 = (t0 + 39032);
    *((int *)t5) = t16;
    goto LAB28;

}

static void work_a_0237307290_3212880686_p_1(char *t0)
{
    char *t1;
    char *t2;
    char *t3;
    char *t4;
    char *t5;
    char *t6;
    char *t7;

LAB0:    xsi_set_current_line(135, ng0);

LAB3:    t1 = (t0 + 17368U);
    t2 = *((char **)t1);
    t1 = (t0 + 24352);
    t3 = (t1 + 56U);
    t4 = *((char **)t3);
    t5 = (t4 + 56U);
    t6 = *((char **)t5);
    memcpy(t6, t2, 12U);
    xsi_driver_first_trans_fast_port(t1);

LAB2:    t7 = (t0 + 23952);
    *((int *)t7) = 1;

LAB1:    return;
LAB4:    goto LAB2;

}


extern void work_a_0237307290_3212880686_init()
{
	static char *pe[] = {(void *)work_a_0237307290_3212880686_p_0,(void *)work_a_0237307290_3212880686_p_1};
	xsi_register_didat("work_a_0237307290_3212880686", "isim/testbench_isim_beh.exe.sim/work/a_0237307290_3212880686.didat");
	xsi_register_executes(pe);
}
