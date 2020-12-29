`timescale 1ns/1ps
`define SD #0.010
`define HALF_CLOCK_PERIOD #5
`define QSIM_OUT_FN "./qsim.out"
`define DATA_IN_COEFF_FN "/user/stud/fall20/jd3693/Desktop/Project/matlab/fir/coefficients.txt"
`define DATA_IN_INPUT_FN "/user/stud/fall20/jd3693/Desktop/Project/matlab/fir/input.txt"
`define DATA_OUT_MATLAB_FN "/user/stud/fall20/jd3693/Desktop/Project/matlab/fir/output.txt"

module testbench();

	// Setting testbench variables
	reg clk;
	reg rstn;
	reg dload;
	reg cload; 
	reg s; 
	reg [15:0] din;
	reg [13:0] addr;

	wire [15:0] dout;
	wire valid;
	wire Done;


	reg [37:0] golden_output_matlab;

	// I-O value variables
	integer read_data_cmem;
	integer read_data_imem;
	integer read_data_matlab;
	
	// I-O filename variables
	integer qsim_out_file;	
	integer data_in_coeff_file;
	integer data_in_input_file;
	integer data_out_matlab_file;

	// Counters
	integer error_count = 0;
	integer i = 0;


	// Instantiating the DUT
	fir fir_0 (.clk(clk), .rstn(rstn), .din(din), .addr(addr), .dload(dload), .cload(cload), 
		   .dout(dout), .valid(valid), .Done(Done), .s(s));
	
	
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

		data_in_coeff_file = $fopen(`DATA_IN_COEFF_FN,"r");
		if (!data_in_coeff_file)
		begin
			$display("Couldn't open the data_in_coeff file.");
			$finish;
		end

		data_in_input_file = $fopen(`DATA_IN_INPUT_FN,"r");
		if (!data_in_input_file)
		begin
			$display("Couldn't open the data_in_input file.");
			$finish;
		end

		data_out_matlab_file = $fopen(`DATA_OUT_MATLAB_FN,"r");
		if (!data_out_matlab_file)
		begin
			$display("Couldn't open the matlab output file.");
			$finish;
		end

		// Register Setup
		clk = 0;
		dload = 0;
		cload = 0;
		rstn = 0;
		s = 0;

		// Writing Data into CMEM (64 coefficients)
		$display("Entering data into CMEM...");
		for(i=0; i<64; i=i+1)
		begin
			@(negedge clk);
			dload = 1'bx;			
			cload = 0;
			addr = i;
			read_data_cmem = $fscanf(data_in_coeff_file, "%d", din);

			@(posedge clk);
			$display("data_in_cmem: %D", din);
			$display(,,);
		end		

		#5.0
		addr = 0;
		// Writing Data into IMEM (16,384 numbers)
		$display("Entering data into IMEM...");
		for(i=0; i<16384; i=i+1)
		begin
			@(negedge clk);
			dload = 0;			
			cload = 1'bx;
			addr = i;
			read_data_imem = $fscanf(data_in_input_file, "%d", din);

			@(posedge clk);
			$display("data_in_imem: %D", din);
			$display(,,);
		end
	
		rstn = 1;
		// Starting the FIR Filter Calculations
		$display("Calculating the Output...");
		for(i=0; i<16500; i=i+1)		
		begin
			@(negedge clk);
			dload = 1;
			cload = 1;
			s = 1;

			@(posedge clk);

			@(negedge clk);
			$display("data_out: %D", dout);
			$display(,,);

			$fwrite(qsim_out_file, "%0d\n", dout);
			
			read_data_matlab = $fscanf(data_out_matlab_file, "%d", golden_output_matlab);

			// Comparing the FIR output to the golden output from MATLAB
			if ((dout != golden_output_matlab)) 
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
		$fclose(data_in_coeff_file);
		$fclose(data_in_input_file);
		$finish;

	end 
	
endmodule // testbench

