/*
 *      CONFIDENTIAL  AND  PROPRIETARY SOFTWARE OF ARM Physical IP, INC.
 *      
 *      Copyright (c) 1993-2020  ARM Physical IP, Inc.  All  Rights Reserved.
 *      
 *      Use of this Software is subject to the terms and conditions  of the
 *      applicable license agreement with ARM Physical IP, Inc.  In addition,
 *      this Software is protected by patents, copyright law and international
 *      treaties.
 *      
 *      The copyright notice(s) in this Software does not indicate actual or
 *      intended publication of this Software.
 *      
 *      name:			High Speed/Density Single Port Register File Generator
 *           			IBM CMRF8SF-LPVT Process
 *      version:		2008Q3V1
 *      comment:		
 *      configuration:	 -instname "imem_mc" -words 256 -bits 16 -frequency 1 -ring_width 2.0 -mux 2 -write_mask off -wp_size 8 -top_layer "m6-m8_m4" -power_type rings -horiz met3 -vert met2 -cust_comment "" -bus_notation on -left_bus_delim "[" -right_bus_delim "]" -pwr_gnd_rename "VDD:VDD,GND:VSS" -prefix "" -pin_space 0.0 -name_case upper -check_instname on -diodes on -inside_ring_type GND -drive 4 -asvm on -corners ff_1p32v_m55c,ff_1p65v_125c,tt_1p2v_25c,ss_1p08v_m55c
 *
 *      Synopsys model for Synchronous Single-Port Register File
 *
 *      Library Name:   aci
 *      Instance Name:  imem_mc
 *      Words:          256
 *      Word Width:     16
 *      Mux:            2
 *
 *      Creation Date:  2020-11-20 21:18:51Z
 *      Version:        2008Q3V1
 *
 *      Verified With: Synopsys Primetime
 *
 *      Modeling Assumptions: This library contains a black box description
 *          for a memory element.  At the library level, a
 *          default_max_transition constraint is set to the maximum
 *          characterized input slew.  Each output has a max_capacitance
 *          constraint set to the highest characterized output load.
 *          Different modes are defined in order to disable false path
 *          during the specific mode activation when doing static timing analysis. 
 *
 *
 *      Modeling Limitations: This stamp does not include power information.
 *          Due to limitations of the stamp modeling, some data reduction was
 *          necessary.  When reducing data, minimum values were chosen for the
 *          fast case corner and maximum values were used for the typical and
 *          best case corners.  It is recommended that critical timing and
 *          setup and hold times be checked at all corners.
 *
 *      Known Bugs: None.
 *
 *      Known Work Arounds: N/A
 *
 */

MODEL
MODEL_VERSION "1.0";
DESIGN "imem_mc";
INPUT A[7:0];
INPUT D[15:0];
INPUT WEN;
INPUT CEN;
INPUT CLK;
OUTPUT Q[15:0];
MODE mem_mode_2_A =
                        ChipEnabled_A  COND(CEN==0),
                        DMYChipEnabled_A  COND(!(CEN==0));
MODE mem_mode_5_A =
                        ChipEnabled_WEN_0_A COND((CEN==0) && 
                        (WEN==0) 
                        ),
                        DMYChipEnabled_WEN_0_A COND(!((CEN==0) && 
                        (WEN==0) 
                        ));
setup_a_A: SETUP(POSEDGE) A CLK MODE(mem_mode_2_A=ChipEnabled_A);
hold_a_A:  HOLD(POSEDGE) A CLK MODE(mem_mode_2_A=ChipEnabled_A);

setup_cen_A: SETUP(POSEDGE) CEN CLK ;
hold_cen_A:  HOLD(POSEDGE) CEN CLK ;

setup_d_A: SETUP(POSEDGE) D CLK MODE(mem_mode_5_A=ChipEnabled_WEN_0_A);
hold_d_A:  HOLD(POSEDGE) D CLK MODE(mem_mode_5_A=ChipEnabled_WEN_0_A);

setup_wen_A: SETUP(POSEDGE) WEN CLK MODE(mem_mode_2_A=ChipEnabled_A);
hold_wen_A:  HOLD(POSEDGE) WEN CLK MODE(mem_mode_2_A=ChipEnabled_A);




period_clk_0_A: PERIOD(POSEDGE) CLK;
pulsewidth_clk_h_0_A: WIDTH(POSEDGE) CLK;
pulsewidth_clk_l_0_A: WIDTH(NEGEDGE) CLK;

dly_clk_q_0_A: DELAY(POSEDGE) CLK Q ;

ENDMODEL
