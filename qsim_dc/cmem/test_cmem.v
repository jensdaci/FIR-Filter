`timescale 1ns/1ps
`define SD #0.010
`define HALF_CLOCK_PERIOD #5
`define QSIM_OUT_FN "./qsim.out"
`define DATA_IN_FN "/user/stud/fall20/jd3693/Desktop/Project/qsim_rtl/cmem/data_in_cmem.txt"

module testbench();

	// Setting testbench variables
	reg clk;
	reg [5:0] a;
	reg [15:0] d;	//data in
	wire [15:0] q;  //data out
	reg cen; 
	reg wen;

	// I-O value variables
	integer read_data;
	
	// I-O filename variables
	integer qsim_out_file;	
	integer data_in_file;  

	// Counters
	integer error_count = 0;
	integer i = 0;

	// Instantiating the DUT
	cmem cmem_0 (.CLK(clk), .CEN(cen), .WEN(wen), .A(a), .D(d), .Q(q));
	
	
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

		$dumpfile("./cmem.vcd");
		$dumpvars(0, testbench.cmem_0);

		// Register Setup
		clk = 0;
		cen = 1;
		wen = 0;
		
		// Initial Input Test
		@(negedge clk);
      		cen = 0; 
		wen = 0;
		a = 6'b00_0001;
		d = 16'd350;

		@(posedge clk);
		// wait for data
		
		@(negedge clk);
		cen = 0; 
		wen = 1;
		a = 6'b00_0001;
		
		@(posedge clk);
		// q outputted here
		

		// Writing and Reading from all 64 entries
		for(i=0; i<64; i=i+1)
		begin
			@(negedge clk);
			wen = 0;
			a = i;
			read_data = $fscanf(data_in_file, "%d", d);
		
			@(posedge clk);

			@(negedge clk);
			wen = 1;
			a = i;

			@(negedge clk);
			
			$display("d: %D", d);
			$display("q: %d", q);
			$display(,,);
			
			$fwrite(qsim_out_file, "%0d\n", q);
			
			// Comparing the input to the output from memory
			if ((q != d)) 
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

		$dumpall;
		$dumpflush;

		$finish;

	end 
	
endmodule // testbench

