`timescale 1ns/1ps
`define SD #0.010
`define HALF_CLOCK_PERIOD #5.00
`define QSIM_OUT_M_FN "./qsim_m.out"
`define QSIM_OUT_A_FN "./qsim_a.out"
`define DATA_INA_FN "/user/stud/fall20/jd3693/Desktop/Project/qsim_rtl/alu/inputA.txt"
`define DATA_INB_FN "/user/stud/fall20/jd3693/Desktop/Project/qsim_rtl/alu/inputB.txt"

module testbench();

	// Setting testbench variables
	reg clk;
	reg resetn;
	reg [37:0] a;
	reg [37:0] b;
	reg select;

	wire [37:0] alu_out;	

	reg[37:0] alu_out_m_gold;
	reg[37:0] alu_out_a_gold;
	reg[37:0] alu_out_qsim_m;
	reg[37:0] alu_out_qsim_a;

	// I-O value variables
	integer i;
	integer ret_write; 
	integer ret_read;
	integer read_A_m;	// Reading for the multiplier
	integer read_B_m;
	integer read_A_a;	// Reading for the adder
	integer read_B_a;
	
	// I-O filename variables
	integer qsim_out_m_file;	
	integer qsim_out_a_file;  
	integer data_inA_m_file;  
	integer data_inB_m_file;  
	integer data_inA_a_file;  
	integer data_inB_a_file;  

	integer error_count = 0;

	// Instantiating the DUT
	alu alu_0 (.A(a), .B(b), .SELECT(select), .RESETN(resetn), .CLK(clk), .ANS(alu_out));

	always begin
		`HALF_CLOCK_PERIOD;
		clk = ~clk;
	end

	initial 
	begin
		// File IO for the Multiplier------------------------------------------------------
		qsim_out_m_file = $fopen(`QSIM_OUT_M_FN,"w");
		if (!qsim_out_m_file) 
		begin
			$display("Couldn't create the multiplier output file.");
			$finish;
		end

		data_inA_m_file = $fopen(`DATA_INA_FN,"r");
		if (!data_inA_m_file)
		begin
			$display("Couldn't open the inputA file.");
			$finish;
		end

		data_inB_m_file = $fopen(`DATA_INB_FN,"r");
		if (!data_inB_m_file)
		begin
			$display("Couldn't open the inputB file.");
			$finish;
		end
	

		// Register Setup
		clk = 0;
		resetn = 0;

		@(negedge clk);
		resetn = 1;
		select = 0;
      
		@(posedge clk);   // First 100 Cycles
		for (i=0 ; i<100; i=i+1) 
		begin 
			// Reading inputs generated from MATLAB
			read_A_m = $fscanf(data_inA_m_file, "%d", a);
			read_B_m = $fscanf(data_inB_m_file, "%d", b);		
			
			#10.00
			alu_out_m_gold = a * b;

			#10.00
			$fwrite(qsim_out_m_file, "%0d\n", alu_out);

			// Displaying output values
			$display("alu_out: %D", alu_out);
			$display("alu_out_m_gold: %d", alu_out_m_gold);
			$display(,,);

			// Comparing the MATLAB and RTL output
			if ((alu_out != alu_out_m_gold)) 
			begin
				error_count = error_count + 1;
			end

			@(posedge clk);  // next cycle
		end
		
		// Finishing the Multiplier Test
		$fclose(qsim_out_m_file);
		$fclose(data_inA_m_file);
		$fclose(data_inB_m_file);


		// File IO for the Adder---------------------------------------------------------
		qsim_out_a_file = $fopen(`QSIM_OUT_A_FN,"w");
		if (!qsim_out_a_file) 
		begin
			$display("Couldn't create the adder output file.");
			$finish;
		end

		data_inA_a_file = $fopen(`DATA_INA_FN,"r");
		if (!data_inA_a_file)
		begin
			$display("Couldn't open the inputA file.");
			$finish;
		end

		data_inB_a_file = $fopen(`DATA_INB_FN,"r");
		if (!data_inB_a_file)
		begin
			$display("Couldn't open the inputB file.");
			$finish;
		end
	

		@(negedge clk);
		resetn = 1;
		select = 1;
		alu_out_m_gold = 38'bx;
		a = 38'bx;		
		b = 38'bx;
				
		@(posedge clk);   // Second 100 Cycles
		for (i=0 ; i<100; i=i+1) 
		begin 
			// Reading inputs generated from MATLAB
			read_A_a= $fscanf(data_inA_a_file, "%d", a);
			read_B_a = $fscanf(data_inB_a_file, "%d", b);		
			
			#10.00
			alu_out_a_gold = a + b;
	
			#10.00
			$fwrite(qsim_out_a_file, "%0d\n", alu_out);

			// Displaying output values
			$display("alu_out: %D", alu_out);
			$display("alu_out_a_gold: %d", alu_out_a_gold);
			$display(,,);

			// Comparing the MATLAB and RTL output
			if ((alu_out != alu_out_a_gold)) 
			begin
				error_count = error_count + 1;
			end

			@(posedge clk);  // next cycle
		end
		
		// Displaying the result on transcript based on error
		if (error_count > 0) begin
			$display("The results DO NOT match! ");
		end
		else begin
			$display("The results DO match! ");
		end
 
		// Finishing the Testbench
		$fclose(qsim_out_a_file);
		$fclose(data_inA_a_file);
		$fclose(data_inB_a_file);
		$finish;
	end 

endmodule // testbench

