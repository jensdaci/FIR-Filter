`timescale 1ns/1ps

module mux_16_1(INPUT0, INPUT1, INPUT2, INPUT3, INPUT4, INPUT5, INPUT6, INPUT7, 
		INPUT8, INPUT9, INPUT10, INPUT11, INPUT12, INPUT13, INPUT14, INPUT15, 
		SEL, DATA_OUT);

	parameter n = 16;
	parameter logn = 4;

	input [15:0] INPUT0;
	input [15:0] INPUT1;
	input [15:0] INPUT2;
	input [15:0] INPUT3;
	input [15:0] INPUT4;
	input [15:0] INPUT5;
	input [15:0] INPUT6;
	input [15:0] INPUT7;
	input [15:0] INPUT8;
	input [15:0] INPUT9;
	input [15:0] INPUT10;
	input [15:0] INPUT11;
	input [15:0] INPUT12;
	input [15:0] INPUT13;
	input [15:0] INPUT14;
	input [15:0] INPUT15;

	input [logn-1:0] SEL;
	output reg [n-1:0] DATA_OUT;

	// MUX Combinational Logic
	always @(*)
	begin
		DATA_OUT = 0;
		case (SEL)
			0: DATA_OUT = INPUT0;
			1: DATA_OUT = INPUT1;
			2: DATA_OUT = INPUT2;
			3: DATA_OUT = INPUT3;
			4: DATA_OUT = INPUT4;
			5: DATA_OUT = INPUT5;
			6: DATA_OUT = INPUT6;
			7: DATA_OUT = INPUT7;
			8: DATA_OUT = INPUT8;
			9: DATA_OUT = INPUT9;
			10: DATA_OUT = INPUT10;
			11: DATA_OUT = INPUT11;
			12: DATA_OUT = INPUT12; 
			13: DATA_OUT = INPUT13;
			14: DATA_OUT = INPUT14;
			15: DATA_OUT = INPUT15;
			default: DATA_OUT = 0;
		endcase
	end

endmodule
		
