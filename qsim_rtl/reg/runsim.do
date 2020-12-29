##################################################
#  Modelsim do file to run simuilation
#  MS 7/2015
##################################################

vlib work 
vmap work work

# Include Netlist and Testbench 
vlog +acc -incr ~/Desktop/Project/rtl/reg_16/reg_16.v
vlog +acc -incr test_reg.v 

# Run Simulator 
vsim +acc -t ps -lib work testbench 
do waveformat.do   
run -all
