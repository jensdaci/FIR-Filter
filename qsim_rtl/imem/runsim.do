##################################################
#  Modelsim do file to run simuilation
#  MS 7/2015
##################################################

vlib work 
vmap work work

# Include Netlist and Testbench 
vlog +acc -incr ~/Desktop/Project/rtl/imem/imem.v
vlog +acc -incr ~/Desktop/Project/rtl/imem/mux_16_1.v
vlog +acc -incr ~/Desktop/Project/mem_comp/imem_mc/imem_mc.v
vlog +acc -incr test_imem.v 

# Run Simulator 
vsim +acc -t ps -lib work testbench 
do waveformat.do   
run -all
