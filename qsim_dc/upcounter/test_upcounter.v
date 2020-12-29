`timescale 1ns/1ps
`define SD #0.010
`define HALF_CLOCK_PERIOD #5
`define QSIM_OUT_FN "./qsim.out"

module testbench();

	// Setting testbench variables
	reg clk;
	reg enable;
	reg load;
	wire [13:0] count;  	// count output

	// I-O value variables
	reg [13:0] golden_counter;
	
	// I-O filename variables
	integer qsim_out_file;	 

	// Counters
	integer error_count = 0;
	integer i = 0;

	// Instantiating the DUT
	upcounter upcounter_0 (.CLK(clk), .ENABLE(enable), .LOAD(load), .COUNT(count));
	
	
	always begin
		`HALF_CLOCK_PERIOD;
		clk = ~clk;
	end
	
	
	initial 
	begin
		// File IO
		qsim_out_file = $fopen(`QSIM_OUT_FN,"w");
		if (!qsim_out_file) 
		begin
			$display("Couldn't create the output file.");
			$finish;
		end

		$dumpfile("./upcounter.vcd");
		$dumpvars(0, testbench.upcounter_0);

		// Register Setup
		clk = 0;
		enable = 0;
		load = 0;
		
		// Initial Setup
		@(negedge clk);
		load = 1;

		@(negedge clk);
		load = 0;
		enable = 1;
		golden_counter = 14'b0;
		
		// Writing and Reading from all 64 entries
		for(i=0; i<16387; i=i+1)
		begin
			@(negedge clk);
			golden_counter = golden_counter + 1'b1;	
			
			@(posedge clk);			

			$display("count: %D", count);
			$display("golden_counter: %d", golden_counter);
			$display(,,);
			
			$fwrite(qsim_out_file, "%0d\n", count);
			
			// Comparing the input to the output of register
			if ((count != golden_counter)) 
			begin
				error_count = error_count + 1;
			end
		end		


		// Displaying the result on transcript based on error
		if (error_count > 0) begin
			$display("The results DO NOT match! ");
		end
		else begin
			$display("The results DO match! ");
		end
 
		// Finishing the Testbench
		$fclose(qsim_out_file);
		
		$dumpall;
		$dumpflush;

		$finish;

	end 
	
endmodule // testbench

