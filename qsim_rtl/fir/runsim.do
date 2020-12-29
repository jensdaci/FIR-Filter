##################################################
#  Modelsim do file to run simuilation
#  MS 7/2015
##################################################

vlib work 
vmap work work

# Include Netlist and Testbench
vlog +acc -incr ~/Desktop/Project/rtl/fir/fir.v
vlog +acc -incr ~/Desktop/Project/rtl/reg_16/reg_16.v
vlog +acc -incr ~/Desktop/Project/rtl/reg_38/reg_38.v
vlog +acc -incr ~/Desktop/Project/rtl/upcounter_14/upcounter_14.v
vlog +acc -incr ~/Desktop/Project/rtl/upcounter_6/upcounter_6.v
vlog +acc -incr ~/Desktop/Project/rtl/alu/alu.v
vlog +acc -incr ~/Desktop/Project/rtl/cmem/cmem.v
vlog +acc -incr ~/Desktop/Project/mem_comp/cmem_mc/cmem_mc.v
vlog +acc -incr ~/Desktop/Project/rtl/imem/imem.v
vlog +acc -incr ~/Desktop/Project/rtl/imem/mux_16_1.v
vlog +acc -incr ~/Desktop/Project/mem_comp/imem_mc/imem_mc.v

vlog +acc -incr test_fir.v 

# Run Simulator 
vsim +acc -t ps -lib work testbench 
do waveformat.do   
run -all
