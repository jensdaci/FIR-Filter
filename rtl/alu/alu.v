module alu(A, B, SELECT, RESETN, CLK, ANS);
	parameter n = 38;
	input [n-1:0] A, B;
	input SELECT; 
	input CLK;
	input RESETN;
	output reg [n-1:0] ANS;		

	reg [n-1:0] ans;

	always @(A, B, SELECT)
	begin
		case(SELECT)
			0: ans = A * B;
			1: ans = A + B;
			default: ans = 38'bx;	
		endcase
	end

	always @(posedge CLK)
		if (RESETN == 0)
			ANS <= 0;
		else
			ANS <= ans;

endmodule

