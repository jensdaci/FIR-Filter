`timescale 1ns/1ps

module reg_16 (CLK, EN, RESETN, DATA_IN, DATA_OUT);	
	parameter n = 16;	
	input CLK; 										 
	input EN;
	input RESETN;
	input [n-1:0] DATA_IN; 		// 16-bit input data
	output reg [n-1:0] DATA_OUT;	// 16-bit output data

	always @(posedge CLK)
	begin
		if(RESETN == 0)
			DATA_OUT <= 0;
		else if (EN == 1)
			DATA_OUT <= DATA_IN;

	end
	
endmodule
		
