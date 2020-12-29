##################################################
#  Modelsim do file to run simuilation
#  MS 7/2015
##################################################

vlib work 
vmap work work

# Include Netlist and Testbench 
vlog +acc -incr /courses/ee6321/share/ibm13rflpvt/verilog/ibm13rflpvt.v
vlog +acc -incr ~/Desktop/Project/dc/fir/fir.nl.v
vlog +acc -incr ~/Desktop/Project/mem_comp/cmem_mc/cmem_mc.v
vlog +acc -incr ~/Desktop/Project/mem_comp/imem_mc/imem_mc.v
vlog +acc -incr test_fir.v 

# Run Simulator 
vsim -voptargs=+acc -t ps -lib work -sdftyp fir_0=../../dc/fir/fir.syn.sdf testbench 
do waveformat.do   
run -all
