`timescale 1ns/1ps

module cmem (CLK, CEN, WEN, A, D, Q);		
	input CLK; 										 
	input CEN;
	input WEN;
	input [5:0] A;		// 2^6 = 64 words
	input [15:0] D; 	// 16-bit input data
	output reg [15:0] Q;	// 16-bit output data

	wire [15:0] Q_0;

	cmem_mc cmem_mc_0 (.CLK(CLK), .CEN(CEN), .WEN(WEN), .A(A), .D(D), .Q(Q_0));
	
	always @(*)
	begin
		if (CEN == 0)
			Q = Q_0;
		else
			Q = 0;
	end

endmodule
		
