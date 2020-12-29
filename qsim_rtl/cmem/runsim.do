##################################################
#  Modelsim do file to run simuilation
#  MS 7/2015
##################################################

vlib work 
vmap work work

# Include Netlist and Testbench 
vlog +acc -incr ~/Desktop/Project/rtl/cmem/cmem.v
vlog +acc -incr ~/Desktop/Project/mem_comp/cmem_mc/cmem_mc.v
vlog +acc -incr test_cmem.v 

# Run Simulator 
vsim +acc -t ps -lib work testbench 
do waveformat.do   
run -all
