onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testbench/clk
add wave -noupdate /testbench/rstn
add wave -noupdate /testbench/cload
add wave -noupdate /testbench/dload
add wave -noupdate /testbench/s
add wave -noupdate -radix unsigned /testbench/addr
add wave -noupdate -radix unsigned /testbench/din
add wave -noupdate -radix unsigned /testbench/golden_output_matlab
add wave -noupdate -radix unsigned /testbench/dout
add wave -noupdate /testbench/valid
add wave -noupdate /testbench/Done
add wave -noupdate -radix unsigned /testbench/error_count

TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 223
configure wave -valuecolwidth 89
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ns} {12 ns}


