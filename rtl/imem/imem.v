`timescale 1ns/1ps

module imem (CLK, CEN, WEN, A, D, Q);
	parameter MEM_BANKS = 64;
		
	input CLK; 										  
	input CEN;
	input WEN;
	input [13:0] A;		// 2^14 = 16,384 words
	input [15:0] D; 	// 16-bit data in
	output reg [15:0] Q;	// 16-bit data out

	wire [5:0] bank_select;
	assign bank_select = A[13:8];

	wire [7:0] address; 
	assign address = A[7:0];

	reg [MEM_BANKS - 1:0] cen_med;   	// intermediate cen

	wire [63:0] mux_out;

	// Instantiating the imem_mc module 64 times
	genvar i;
	generate
		for (i = 0; i<64; i = i+1) 
		begin: mem
			wire [15:0] q_mem;
			imem_mc imem_0 (.CLK(CLK), .CEN(cen_med[i]), .WEN(WEN), .A(address), .D(D), .Q(q_mem));
		end
	endgenerate

	// Enable Signals
	always @(*)
	begin
		if (CEN == 0)
		begin
			cen_med = {{MEM_BANKS{1'b1}}};
			cen_med[bank_select] = 1'b0;
		end 
		else
			cen_med = {{MEM_BANKS{1'b1}}};

	end
	
	// Instantiating the 16-to-1 MUX 4 times
	genvar k;
	generate
		for (k = 0; k<4; k = k+1)
		begin: mux
			mux_16_1 mux (
					.INPUT0(mem[16*k + 0].q_mem),
					.INPUT1(mem[16*k + 1].q_mem),
					.INPUT2(mem[16*k + 2].q_mem),
					.INPUT3(mem[16*k + 3].q_mem),
					.INPUT4(mem[16*k + 4].q_mem),
					.INPUT5(mem[16*k + 5].q_mem),
					.INPUT6(mem[16*k + 6].q_mem),
					.INPUT7(mem[16*k + 7].q_mem),
					.INPUT8(mem[16*k + 8].q_mem),
					.INPUT9(mem[16*k + 9].q_mem),
					.INPUT10(mem[16*k + 10].q_mem),
					.INPUT11(mem[16*k + 11].q_mem),
					.INPUT12(mem[16*k + 12].q_mem),
					.INPUT13(mem[16*k + 13].q_mem),
					.INPUT14(mem[16*k + 14].q_mem),
					.INPUT15(mem[16*k + 15].q_mem),
					.SEL(bank_select[3:0]),
					.DATA_OUT(mux_out[(16*(k+1))-1:16*k])
				);
		end
	endgenerate
	
	// Final Output MUX
	always @(*)
	begin
		Q = 0;
		case (bank_select[5:4])		// Last 2 MSB bits
			0: Q = mux_out[15:0];
			1: Q = mux_out[31:16];
			2: Q = mux_out[47:32];
			3: Q = mux_out[63:48];
			default: Q = 0;
		endcase
	end

endmodule
		
