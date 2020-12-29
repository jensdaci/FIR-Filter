`timescale 1ns/1ps
`define SD #0.010
`define HALF_CLOCK_PERIOD #5
`define QSIM_OUT_FN "./qsim.out"
`define DATA_IN_FN "/user/stud/fall20/jd3693/Desktop/Project/qsim_rtl/reg/data_in_reg.txt"

module testbench();

	// Setting testbench variables
	reg clk;
	reg en;
	reg resetn;
	reg [15:0] data_in;	//data in
	wire [15:0] data_out;  //data out

	// I-O value variables
	integer read_data;
	
	// I-O filename variables
	integer qsim_out_file;	
	integer data_in_file;  

	// Counters
	integer error_count = 0;
	integer i = 0;

	// Instantiating the DUT
	reg_16 reg_16_0 (.CLK(clk), .EN(en), .RESETN(resetn), .DATA_IN(data_in), .DATA_OUT(data_out));
	
	
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

		data_in_file = $fopen(`DATA_IN_FN,"r");
		if (!data_in_file)
		begin
			$display("Couldn't open the data_in file.");
			$finish;
		end

		// Register Setup
		clk = 0;
		resetn = 0;
		en = 0;
		
		// Testing Enable Signal
		@(negedge clk);			// data should NOT be outputted (en = 0)
      		resetn = 1;	
		en = 0;
		data_in = 16'd350;
		
	
		@(negedge clk);			// data should be outputted
		resetn = 1; 
		en = 1;
		data_in = 16'd350;
		
		// Testing Reset Signal
		@(negedge clk);			// data should be RESETTED (resetn = 0)
		resetn = 0; 
		en = 1;
		

		// Initial Setup
		@(negedge clk);
		resetn = 1;
		en = 1;
		
		// Writing and Reading from all 64 entries
		for(i=0; i<100; i=i+1)
		begin
			@(negedge clk);

			read_data = $fscanf(data_in_file, "%d", data_in);
			
			@(negedge clk);			

			$display("data_in: %D", data_in);
			$display("data_out: %d", data_out);
			$display(,,);
			
			$fwrite(qsim_out_file, "%0d\n", data_out);
			
			// Comparing the input to the output of register
			if ((data_in != data_out)) 
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
		$fclose(data_in_file);
		$finish;

	end 
	
endmodule // testbench

