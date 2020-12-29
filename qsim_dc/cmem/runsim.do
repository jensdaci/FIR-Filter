##################################################
#  Modelsim do file to run simuilation
#  MS 7/2015
##################################################

vlib work 
vmap work work

# Include Netlist and Testbench 
vlog +acc -incr /courses/ee6321/share/ibm13rflpvt/verilog/ibm13rflpvt.v
vlog +acc -incr ~/Desktop/Project/dc/cmem/cmem.nl.v
vlog +acc -incr ~/Desktop/Project/mem_comp/cmem_mc/cmem_mc.v
vlog +acc -incr test_cmem.v 

# Run Simulator 
vsim -voptargs=+acc -t ps -lib work -sdftyp cmem_0=../../dc/cmem/cmem.syn.sdf testbench 
do waveformat.do   
run -all
