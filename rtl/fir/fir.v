`timescale 1ns/1ps

module fir (clk, rstn, din, addr, dload, cload, dout, valid, Done, s);		
	input clk; 										 
	input rstn;
	input dload;
	input cload;
	input s;
	input [15:0] din;
	input [13:0] addr; 		// 2^14 = 16,384

	output [15:0] dout;		// 16-bit output data
	output valid; 
	output reg Done;

	wire z1, z2;
	reg [2:0] presentState, nextState;
	reg Msel, EM, Ysel, EY, LN, EIMEM, EX;
	reg LI, ECMEM, EB, EN, EI, Sel1, Sel2, ALUsel; 

	wire [15:0] DataX, DataB;			// Register Inputs
	wire [15:0] X, B; 				// Register Outputs
 	reg  [37:0] DataM, DataY;			// Register Inputs
	wire [37:0] M, Y;				// Register Outputs
	wire [13:0] N; 					// Counter Output N
	wire [5:0] I; 					// Counter Output I
	
	reg  [37:0] operand_1;				// ALU inputs
	reg  [37:0] operand_2;
	wire [37:0] ALU_out;				// ALU output


// CONTROL CIRCUIT ----------------------------------------------------------------

	parameter S1 = 3'b000, S2 = 3'b001, S3 = 3'b010, S4 = 3'b011,
		  S5 = 3'b100, S6 = 3'b101;

	// State Table
	always @(s, presentState, z1, z2)
	begin
		case(presentState)
			S1: if(s==0) nextState=S1;
			    else nextState=S2;

			S2: nextState=S3;

			S3: nextState=S4;

			S4: nextState=S5;

			S5: if(z2==0) nextState=S3;
			    else begin
				if(z1==0) nextState=S2;
				else nextState=S6;
			    end

			S6: if(s==0) nextState=S1;
			    else nextState=S6;
			
			default: nextState=3'bxxx;
		endcase
	end
			
    	// State Switching
	always @(posedge clk)
	begin
		if (rstn == 0)
			presentState <= S1;
		else
			presentState <= nextState;
	end

	
	// FSM Outputs
	always @(s, presentState, z1, z2)
	begin
		Msel=0; EM=0; Ysel=0; EY=0; LN=0; EIMEM=0; EX=0;
		LI=0; ECMEM=0; EB=0; EN=0; EI=0; Sel1=0; Sel2=0; ALUsel=0; 
	
		case(presentState)
			S1: begin
			    	Msel = 0;
				EM = 1;
				Ysel = 0;
				EY = 1;
				LN = 1;
				
				EIMEM = 0;
				EX = 1;
				LI = 1;
				ECMEM = 0;
				EB = 1;
			    end

			S2: begin
				EN = 1;
				EX = 1;
			    end

			S3: begin
				EI = 1;
				EB = 1;
			    end

			S4: begin
				Sel1 = 0;
				Sel2 = 0;
				ALUsel = 0;
				Msel = 1;
				EM = 1;
				EY = 0;
			    end

			S5: begin
				Sel1 = 1;
				Sel2 = 1;
				ALUsel = 1;
				Ysel = 1;
				EY = 1;
				EM = 0;

				if(z2==1) LI=1;
			    end

			S6: Done = 1;
		endcase
	end

// DATAPATH CIRCUIT ----------------------------------------------------------------

	cmem cmem_0(.CLK(clk), .CEN(ECMEM), .WEN(cload), .A(addr[5:0]), .D(din), .Q(DataB));

	imem imem_0(.CLK(clk), .CEN(EIMEM), .WEN(dload), .A(addr), .D(din), .Q(DataX));	

	alu alu_0(.A(operand_1), .B(operand_2), .SELECT(ALUsel), .RESETN(rstn), .CLK(clk), .ANS(ALU_out));
	
	reg_16 reg_16_X(.CLK(clk), .EN(EX), .RESETN(rstn), .DATA_IN(DataX), .DATA_OUT(X));

	reg_16 reg_16_B(.CLK(clk), .EN(EB), .RESETN(rstn), .DATA_IN(DataB), .DATA_OUT(B));

	reg_38 reg_38_M(.CLK(clk), .EN(EM), .RESETN(rstn), .DATA_IN(DataM), .DATA_OUT(M));

	reg_38 reg_38_Y(.CLK(clk), .EN(EY), .RESETN(rstn), .DATA_IN(DataY), .DATA_OUT(Y));

	upcounter_14 upcounter_N(.CLK(clk), .ENABLE(EN), .LOAD(LN), .COUNT(N));

	upcounter_6 upcounter_I(.CLK(clk), .ENABLE(EI), .LOAD(LI), .COUNT(I));

	
	assign z1 = (N == 16384);
	assign z2 = (I == 64);

	assign valid = 0;

	assign dout = Y[15:0];

	// MUX 1
	always @(Sel1, M, X)
	begin
		case(Sel1)
			0: operand_1 = X;
			1: operand_1 = M;
		endcase
	end

	// MUX 2
	always @(Sel2, B, Y)
	begin
		case(Sel2)
			0: operand_2 = B;
			1: operand_2 = Y;
		endcase
	end

	// MUX 3
	always @(Msel, ALU_out)
	begin
		case(Msel)
			0: DataM = 0;
			1: DataM = ALU_out;
		endcase
	end

	// MUX 4
	always @(Ysel, ALU_out)
	begin
		case(Ysel)
			0: DataY = 0;
			1: DataY = ALU_out;
		endcase
	end

endmodule
		
