`timescale 1ns/1ps

module upcounter_14(CLK, ENABLE, LOAD, COUNT);
	parameter n = 14;
	input CLK, ENABLE, LOAD;
	output[n-1:0] COUNT; 
	reg[n-1:0] COUNT;
	
	always @(posedge CLK)
	begin
		if (LOAD == 1)
			COUNT <= {n{1'b0}};
		else if (ENABLE == 1)
			COUNT <= COUNT + 1'b1;
		else
			COUNT <= {n{1'b0}};
	end
endmodule 
		
