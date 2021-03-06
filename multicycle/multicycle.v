`timescale 1ns / 1ps


module D_ff(input clk, input reset, input regWrite,input d, output reg q);
	always@(negedge clk)
		begin
			if(reset)
				q=0;
			else
				if(regWrite == 1) begin q=d; end
		end
endmodule

module D_ff_reg (input clk, input reset, input regWrite, input decOut1b, input d, output reg q);
	always @ (negedge clk)
		begin
			if(reset==1)
				q=1;
			else
				if(regWrite == 1 && decOut1b==1)
					begin
						q=d;
					end
		end
endmodule

module D_ff_Mem (input memRead, input init,  output reg q);
	always@(memRead or init)
	begin
	if (memRead)
		q = init;
	end
endmodule

// Instruction Memory Design
module register_Mem(input memRead,input [15:0] init, output [15:0] q_out);
	D_ff_Mem dMem0(memRead, init[0], q_out[0]);
	D_ff_Mem dMem1(memRead, init[1], q_out[1]);
	D_ff_Mem dMem2(memRead, init[2], q_out[2]);
	D_ff_Mem dMem3(memRead, init[3], q_out[3]);
	
	D_ff_Mem dMem4(memRead, init[4], q_out[4]);
	D_ff_Mem dMem5(memRead, init[5], q_out[5]);
	D_ff_Mem dMem6(memRead, init[6], q_out[6]);
	D_ff_Mem dMem7(memRead, init[7], q_out[7]);

	D_ff_Mem dMem8(memRead, init[8], q_out[8]);
	D_ff_Mem dMem9(memRead, init[9], q_out[9]);
	D_ff_Mem dMem10(memRead, init[10], q_out[10]);
	D_ff_Mem dMem11(memRead, init[11], q_out[11]);
	
	D_ff_Mem dMem12(memRead, init[12], q_out[12]);
	D_ff_Mem dMem13(memRead, init[13], q_out[13]);
	D_ff_Mem dMem14(memRead, init[14], q_out[14]);
	D_ff_Mem dMem15(memRead, init[15], q_out[15]);
endmodule


module mux16to1(input [15:0] outR0, outR1, outR2, outR3, outR4, outR5, outR6, outR7, outR8, outR9, outR10, outR11, outR12, outR13, outR14, outR15, input [3:0] Sel, output reg [15:0] outBus);
	always @ (outR0 or outR1 or outR2 or outR3 or outR4 or outR5 or outR6 or outR7 or outR8 or outR9 or outR10 or outR11 or outR12 or outR13 or outR14 or outR15 or Sel)
	case (Sel)
		4'b0000: outBus = outR0;
		4'b0001: outBus = outR1;
		4'b0010: outBus = outR2;
		4'b0011: outBus = outR3;
		4'b0100: outBus = outR4;
		4'b0101: outBus = outR5;
		4'b0110: outBus = outR6;
		4'b0111: outBus = outR7;
		4'b1000: outBus = outR8;
		4'b1001: outBus = outR9;
		4'b1010: outBus = outR10;
		4'b1011: outBus = outR11;
		4'b1100: outBus = outR12;
		4'b1101: outBus = outR13;
		4'b1110: outBus = outR14;
		4'b1111: outBus = outR15;
	endcase
endmodule

module Mem(input memRead, input [15:0] pc, output [15:0] IR);
	wire [15:0] Qout0, Qout1, Qout2, Qout3, Qout4, Qout5, Qout6, Qout7, Qout8, Qout9, Qout10, Qout11, Qout12, Qout13, Qout14, Qout15;
	
	register_Mem r0(memRead, 16'b0001_001_010_000_000,Qout0); 		//sub $r0, $r1, $r2
	register_Mem r1(memRead, 16'b0011_000_010_000_010, Qout1); 	//addic $r2, $r0, 2
	register_Mem r2(memRead, 16'b0000_010_001_001_000, Qout2); 	//add $r1, $r2, $r1
	register_Mem r3(memRead, 16'b0100_010_100_000_001, Qout3); 	//shift $r4, $r2, 1
	register_Mem r4(memRead, 16'b0010_100_010_110_000, Qout4); 	//addc $r6, $r4, $r2
	register_Mem r5(memRead, 16'b0001_110_001_101_000, Qout5); 	//sub $r5, $r6, $r1
	register_Mem r6(memRead, 16'b0011_111_011_000_011, Qout6); 	//addic $r3, $r7, 3
	register_Mem r7(memRead, 16'b0010_111_110_111_000, Qout7);		//addc $r7, $r7, $r6
	register_Mem r8(memRead, 16'b0101_110_111_000_000, Qout8); 	//mul $r6,$r7
	register_Mem r9(memRead, 16'b0000_000_000_000_000, Qout9); 		
	register_Mem r10(memRead, 16'b0000_000_000_000_000, Qout10); 	
	register_Mem r11(memRead, 16'b0000_000_000_000_000, Qout11); 	
	register_Mem r12(memRead, 16'b0000_000_000_000_000, Qout12); 
	register_Mem r13(memRead, 16'b0000_000_000_000_000, Qout13); 
	register_Mem r14(memRead, 16'b0000_000_000_000_000, Qout14); 	
	register_Mem r15(memRead, 16'b0000_000_000_000_000, Qout15); 	
	mux16to1 mIM (Qout0,Qout1,Qout2,Qout3,Qout4,Qout5,Qout6,Qout7,Qout8,Qout9,Qout10,Qout11,Qout12,Qout13,Qout14,Qout15,pc[4:1],IR);
	
endmodule
//Instruction Memory Design Ends
//Register Memory Design begins
module register16bit_RegFile( input clk, input reset, input regWrite, input decOut1b, input [15:0] writeData, output  [15:0] outR );
	D_ff_reg d0(clk, reset, regWrite, decOut1b, writeData[0], outR[0]);
	D_ff_reg d1(clk, reset, regWrite, decOut1b, writeData[1], outR[1]);
	D_ff_reg d2(clk, reset, regWrite, decOut1b, writeData[2], outR[2]);
	D_ff_reg d3(clk, reset, regWrite, decOut1b, writeData[3], outR[3]);
	D_ff_reg d4(clk, reset, regWrite, decOut1b, writeData[4], outR[4]);
	D_ff_reg d5(clk, reset, regWrite, decOut1b, writeData[5], outR[5]);
	D_ff_reg d6(clk, reset, regWrite, decOut1b, writeData[6], outR[6]);
	D_ff_reg d7(clk, reset, regWrite, decOut1b, writeData[7], outR[7]);
	D_ff_reg d8(clk, reset, regWrite, decOut1b, writeData[8], outR[8]);
	D_ff_reg d9(clk, reset, regWrite, decOut1b, writeData[9], outR[9]);
	D_ff_reg d10(clk, reset, regWrite, decOut1b, writeData[10], outR[10]);
	D_ff_reg d11(clk, reset, regWrite, decOut1b, writeData[11], outR[11]);
	D_ff_reg d12(clk, reset, regWrite, decOut1b, writeData[12], outR[12]);
	D_ff_reg d13(clk, reset, regWrite, decOut1b, writeData[13], outR[13]);
	D_ff_reg d14(clk, reset, regWrite, decOut1b, writeData[14], outR[14]);
	D_ff_reg d15(clk, reset, regWrite, decOut1b, writeData[15], outR[15]);
endmodule

module registerSet( input clk, input reset, input regWrite, input [7:0] decOut, input [15:0] writeData,
output [15:0] outR0, output [15:0] outR1, output [15:0] outR2, output [15:0] outR3,
	output [15:0] outR4,output [15:0] outR5, output [15:0] outR6, output [15:0] outR7);

	register16bit_RegFile rs0( clk, reset, regWrite, decOut[0], writeData, outR0 );
	register16bit_RegFile rs1( clk, reset, regWrite, decOut[1], writeData, outR1 );
	register16bit_RegFile rs2( clk, reset, regWrite, decOut[2], writeData, outR2 );
	register16bit_RegFile rs3( clk, reset, regWrite, decOut[3], writeData, outR3 );
	
	register16bit_RegFile rs4( clk, reset, regWrite, decOut[4], writeData, outR4 );
	register16bit_RegFile rs5( clk, reset, regWrite, decOut[5], writeData, outR5 );
	register16bit_RegFile rs6( clk, reset, regWrite, decOut[6], writeData, outR6 );
	register16bit_RegFile rs7( clk, reset, regWrite, decOut[7], writeData, outR7 );
endmodule

module decoder( input [2:0] destReg, output reg [7:0] decOut);
always @(destReg)
	case(destReg)
	3'd0: decOut=8'b0000_0001;
	3'd1: decOut=8'b0000_0010;
	3'd2: decOut=8'b0000_0100;
	3'd3: decOut=8'b0000_1000;
	3'd4: decOut=8'b0001_0000;
	3'd5: decOut=8'b0010_0000;
	3'd6: decOut=8'b0100_0000;
	3'd7: decOut=8'b1000_0000;
	endcase
endmodule

module mux8to1( input [15:0] outR0, input [15:0] outR1, input [15:0] outR2, input [15:0] outR3, input [15:0] outR4, input [15:0] outR5, 
input [15:0] outR6, input [15:0] outR7, input [2:0] Sel, output reg [15:0] outBus );

always@(outR0,outR1,outR2,outR3,outR4,outR5,outR6,outR7,Sel)
	case(Sel)
		3'd0:outBus=outR0;
		3'd1:outBus=outR1;
		3'd2:outBus=outR2;
		3'd3:outBus=outR3;
		3'd4:outBus=outR4;
		3'd5:outBus=outR5;
		3'd6:outBus=outR6;
		3'd7:outBus=outR7;
	endcase
endmodule

module registerFile(input clk, input reset, input regWrite, input [2:0] rs, input [2:0] rt,input [2:0] rd, 
input [15:0] writeData, output [15:0] outR0, output [15:0] outR1);
	
	wire [7:0] decOut;
	wire [15:0] outR00,outR11, outR2, outR3, outR4, outR5, outR6, outR7;
	decoder dec(rd,decOut);
	registerSet rSet( clk, reset, regWrite,decOut, writeData,outR00,outR11, outR2, outR3, outR4, outR5, outR6, outR7);
	mux8to1 mux8_1_1( outR00, outR11,outR2,outR3,outR4, outR5, outR6,outR7, rs, outR0 );
	mux8to1 mux8_1_2( outR00, outR11,outR2,outR3,outR4, outR5, outR6,outR7, rt, outR1 );
endmodule
//Register Memory Design ends

// Register to be used for PC, IR, A, B, ALUOut HI, LO
module register16bit( input clk, input reset, input regWrite, input [15:0] writeData, output  [15:0] outR );
	D_ff d0(clk,reset,regWrite,writeData[0],outR[0]);
	D_ff d1(clk,reset,regWrite,writeData[1],outR[1]);
	D_ff d2(clk,reset,regWrite,writeData[2],outR[2]);
	D_ff d3(clk,reset,regWrite,writeData[3],outR[3]);
	D_ff d4(clk,reset,regWrite,writeData[4],outR[4]);
	D_ff d5(clk,reset,regWrite,writeData[5],outR[5]);
	D_ff d6(clk,reset,regWrite,writeData[6],outR[6]);
	D_ff d7(clk,reset,regWrite,writeData[7],outR[7]);
	D_ff d8(clk,reset,regWrite,writeData[8],outR[8]);
	D_ff d9(clk,reset,regWrite,writeData[9],outR[9]);
	D_ff d10(clk,reset,regWrite,writeData[10],outR[10]);
	D_ff d11(clk,reset,regWrite,writeData[11],outR[11]);
	D_ff d12(clk,reset,regWrite,writeData[12],outR[12]);
	D_ff d13(clk,reset,regWrite,writeData[13],outR[13]);
	D_ff d14(clk,reset,regWrite,writeData[14],outR[14]);
	D_ff d15(clk,reset,regWrite,writeData[15],outR[15]);
endmodule

module signExt6to16( input [5:0] offset, output reg [15:0] signExtOffset);
	always@(offset)
			signExtOffset={{10{offset[5]}},offset[5:0]};
endmodule
	
module zeroExt4to16( input [3:0] offset, output reg [15:0] zeroExtOffset);
	always@(offset)
		zeroExtOffset={{12{1'b0}},offset[3:0]};
endmodule

module alu(input [15:0] aluIn1, input [15:0] aluIn2,input [1:0] aluOp,
		output reg carry, output reg [15:0] aluOut1,output reg [15:0] aluOut2);
	always@(aluIn1 or aluIn2 or aluOp)
	begin
		case(aluOp)
			2'b00: {carry,aluOut1}=aluIn1 + aluIn2;
			2'b01: {carry,aluOut1}=aluIn1 - aluIn2;
			2'b10: {carry,aluOut1}=aluIn1 << aluIn2;
			2'b11: {aluOut2,aluOut1}=aluIn1 * aluIn2; 
		endcase
	end
endmodule

module zeroExt1to16( input cFlag, output reg [15:0] zeroExtcFlag);
	always@(cFlag)
		zeroExtcFlag={{15{1'b0}},cFlag};
endmodule

module adder(input [15:0] in1, input [15:0] in2, output reg [15:0] adder_out);
	always@(in1 or in2)
	begin
		adder_out=in1 + in2;
	end
endmodule

module mux2to1_3bits(input [2:0] in1, input [2:0] in2, input sel, output reg [2:0] muxOut);
	always@(in1 or in2 or sel)
	begin
		case(sel)
			1'b0:muxOut=in1;
			1'b1:muxOut=in2;
		endcase
	end
endmodule

module mux2to1_16bits(input [15:0] in1, input [15:0] in2, input sel, output reg [15:0] muxOut);
    always@(in1 or in2 or sel)
	begin
		case(sel)
			1'b0:muxOut=in1;
			1'b1:muxOut=in2;
		endcase
	end
endmodule

module mux4to1_16bits(input [15:0] in1, input [15:0] in2, input [15:0] in3, input [15:0] in4, input [1:0] sel, output reg [15:0] muxOut);
	always@(in1 or in2 or in3 or in4 or sel)
	begin
		case(sel)
			2'b00:muxOut=in1;
			2'b01:muxOut=in2;
			2'b10:muxOut=in3;		
			2'b11:muxOut=in4;				
		endcase
	end
endmodule

module ctrlCkt(input clk,input reset,input [3:0] opcode,output reg pcWr,output reg memRd,output reg irWr,
output reg regDest,output reg regWr,output reg regSrc,output reg aluSrcA,output reg [1:0] aluSrcB,output reg [1:0] aluOp,
output reg hiWr,output reg loWr,output reg flagWr);	
	
	reg [3:0] state;
	reg [3:0] next_state;
	always @ (negedge clk)
	begin
	if (reset)
	begin
	//pcWr=1'b0;
	//irWr=1'b0;
	//memRd=1'b0;
	//regDest=1'b0;
	//regWr=1'b0;
	//regSrc=1'b0;
	//aluSrcA=1'b0;
	//aluSrcB=2'b00;
	//aluOp=2'b00;
	//hiWr=1'b0;
	//loWr=1'b0;
	//flagWr=1'b0;
	state=4'b0000;
	end
	
	else
	state=next_state;
	end
	
	always @ (state)
	begin
	case (state)
	4'b0000:begin
					pcWr=1'b1;
					irWr=1'b1;
					memRd=1'b1;
					regDest=1'b0;
					regWr=1'b0;
					regSrc=1'b0;
					aluSrcA=1'b0;
					aluSrcB=2'b01;
					aluOp=2'b00;
					hiWr=1'b0;
					loWr=1'b0;
					flagWr=1'b0;
					next_state=4'b0001;
				end
	4'b0001:begin
					pcWr=1'b0;
					irWr=1'b0;
					memRd=1'b0;
					regDest=1'b0;
					regWr=1'b0;
					regSrc=1'b0;
					aluSrcA=1'b0;
					aluSrcB=2'b00;
					aluOp=2'b00;
					hiWr=1'b0;
					loWr=1'b0;
					flagWr=1'b0;
					case (opcode)
						4'b0000:next_state=4'b0010;
						4'b0001:next_state=4'b0100;
						4'b0010:next_state=4'b0110;
						4'b0011:next_state=4'b1000;
						4'b0100:next_state=4'b1010;
						4'b0101:next_state=4'b1100;
						endcase
						end
				//		4'b0000:next_state=4'b0010;
				//		4'b0000:next_state=4'b0010;
				//		4'b0000:next_state=4'b0010;
				//		4'b0000:next_state=4'b0010;
				//		4'b0000:next_state=4'b0010;
				//		4'b0000:next_state=4'b0010;
				//		4'b0000:next_state=4'b0010;
				//		4'b0000:next_state=4'b0010;
				//		4'b0000:next_state=4'b0010;
				//		4'b0000:next_state=4'b0010;
			4'b0010:
						begin
					pcWr=1'b0;
					irWr=1'b0;
					memRd=1'b0;
					regDest=1'b0;
					regWr=1'b0;
					regSrc=1'b0;
					aluSrcA=1'b1;
					aluSrcB=2'b00;
					aluOp=2'b00;
					hiWr=1'b0;
					loWr=1'b0;
					flagWr=1'b1;
					next_state=4'b0011;
					end
			
			4'b0011:
					begin
					pcWr=1'b0;
					irWr=1'b0;
					memRd=1'b0;
					regDest=1'b1;
					regWr=1'b1;
					regSrc=1'b1;
					aluSrcA=1'b0;
					aluSrcB=2'b00;
					aluOp=2'b00;
					hiWr=1'b0;
					loWr=1'b0;
					flagWr=1'b0;
					next_state=4'b0000;
					end	
				4'b0100:
						begin
					pcWr=1'b0;
					irWr=1'b0;
					memRd=1'b0;
					regDest=1'b0;
					regWr=1'b0;
					regSrc=1'b0;
					aluSrcA=1'b1;
					aluSrcB=2'b00;
					aluOp=2'b01;
					hiWr=1'b0;
					loWr=1'b0;
					flagWr=1'b1;
					next_state=4'b0101;
					end
					
					4'b0101:
					begin
					pcWr=1'b0;
					irWr=1'b0;
					memRd=1'b0;
					regDest=1'b1;
					regWr=1'b1;
					regSrc=1'b1;
					aluSrcA=1'b0;
					aluSrcB=2'b00;
					aluOp=2'b00;
					hiWr=1'b0;
					loWr=1'b0;
					flagWr=1'b0;
					next_state=4'b0000;
					end
					
					4'b0110:
						begin
						pcWr=1'b0;
					irWr=1'b0;
					memRd=1'b0;
					regDest=1'b0;
					regWr=1'b0;
					regSrc=1'b0;
					aluSrcA=1'b1;
					aluSrcB=2'b00;
					aluOp=2'b00;
					hiWr=1'b0;
					loWr=1'b0;
					flagWr=1'b1;
					next_state=4'b0111;
					end
					
					4'b0111:
					begin
						pcWr=1'b0;
					irWr=1'b0;
					memRd=1'b0;
					regDest=1'b1;
					regWr=1'b1;
					regSrc=1'b0;
					aluSrcA=1'b0;
					aluSrcB=2'b00;
					aluOp=2'b00;
					hiWr=1'b0;
					loWr=1'b0;
					flagWr=1'b0;
					next_state=4'b0000;
					end
					
					4'b1000:
					begin
						pcWr=1'b0;
					irWr=1'b0;
					memRd=1'b0;
					regDest=1'b0;
					regWr=1'b0;
					regSrc=1'b0;
					aluSrcA=1'b1;
					aluSrcB=2'b10;
					aluOp=2'b00;
					hiWr=1'b0;
					loWr=1'b0;
					flagWr=1'b1;
					next_state=4'b1001;
					end
					
					4'b1001:
						begin
						pcWr=1'b0;
					irWr=1'b0;
					memRd=1'b0;
					regDest=1'b0;
					regWr=1'b1;
					regSrc=1'b0;
					aluSrcA=1'b0;
					aluSrcB=2'b00;
					aluOp=2'b00;
					hiWr=1'b0;
					loWr=1'b0;
					flagWr=1'b0;
					next_state=4'b0000;
					end
					
					4'b1010:
					begin
						pcWr=1'b0;
					irWr=1'b0;
					memRd=1'b0;
					regDest=1'b0;
					regWr=1'b0;
					regSrc=1'b0;
					aluSrcA=1'b1;
					aluSrcB=2'b11;
					aluOp=2'b10;
					hiWr=1'b0;
					loWr=1'b0;
					flagWr=1'b1;
					next_state=4'b1011;
					end
					
					4'b1011:
					
						begin
						pcWr=1'b0;
					irWr=1'b0;
					memRd=1'b0;
					regDest=1'b0;
					regWr=1'b1;
					regSrc=1'b1;
					aluSrcA=1'b0;
					aluSrcB=2'b00;
					aluOp=2'b00;
					hiWr=1'b0;
					loWr=1'b0;
					flagWr=1'b0;
					next_state=4'b0000;
					end
					
					4'b1100:
					begin
						pcWr=1'b0;
					irWr=1'b0;
					memRd=1'b0;
					regDest=1'b0;
					regWr=1'b0;
					regSrc=1'b0;
					aluSrcA=1'b1;
					aluSrcB=2'b00;
					aluOp=2'b11;
					hiWr=1'b1;
					loWr=1'b1;
					flagWr=1'b0;
					next_state=4'b0000;
					end
					endcase
					end
endmodule

//top module
module multiCycle(input clk, input reset, output [15:0] Result);
		
		wire pcWr;
		wire memRd;
		wire irWr;
		wire regDest;
		wire regWr;
		wire regSrc;
		wire aluSrcA;
		wire [1:0] aluSrcB;
		wire [1:0] aluOp;
		wire hiWr;
		wire loWr;
		wire flagWr;
		wire [15:0] instr;
		
		wire [15:0] alu1out;
		wire [15:0] pcout;
		register16bit pc1(  clk,  reset, pcWr, alu1out, pcout );
		
		
		
		wire [15:0] irin;
		Mem mem1(memRd, pcout, irin);
		
		
		register16bit instrreg(  clk,  reset, irWr, irin, instr );
		ctrlCkt cntrl( clk, reset,instr[15:12], pcWr,  memRd,  irWr, regDest,  regWr,  regSrc, aluSrcA,  aluSrcB, aluOp, hiWr,  loWr, flagWr);
		
		wire [2:0] rdnew;
		mux2to1_3bits threebmux(instr[8:6], instr[5:3] ,regDest, rdnew);
		
		wire [15:0] regrs;
		wire [15:0] regrt;
		wire [15:0] muxout;
		registerFile regfil( clk,  reset, regWr, instr[11:9], instr[8:6],rdnew, Result, regrs,regrt);
		
		wire [15:0] A;
		wire [15:0] B;
		register16bit A16(  clk,  reset, 1'b1, regrs, A);
		register16bit B16(  clk,  reset, 1'b1, regrt, B );
		
		wire [15:0] signExtOffset;
		signExt6to16 sext( instr[5:0], signExtOffset);
		
		wire [15:0] zeroExtOffset;
		zeroExt4to16 zext( instr[3:0] , zeroExtOffset);
		
		wire [15:0] alu1in2;
		mux4to1_16bits mux4in(B, 16'd2, signExtOffset, zeroExtOffset, aluSrcB, alu1in2);
		
		wire [15:0] alu1in1;
		mux2to1_16bits twoto1sixteenbits(pcout, A, aluSrcA, alu1in1);
		
		wire carry;
		wire [15:0] alu1out2;
		alu alu1(alu1in1, alu1in2,aluOp, carry,  alu1out,alu1out2);
		
		wire carryflag;
		D_ff carryAA( clk,  reset, flagWr,carry, carryflag);
		
		wire [15:0] hi;
		register16bit hireg(  clk,  reset, hiWr, alu1out2, hi);
		
		wire [15:0] lo;
		register16bit loreg(  clk,  reset, loWr, alu1out, lo );
		
		wire [15:0] alu1final;
		register16bit alu1reg(  clk,  reset, 1'b1, alu1out, alu1final);
		
		wire [15:0] adderin2;
		zeroExt1to16 zext1bit( carryflag, adderin2);
		
		wire [15:0] adderout;
		adder addfinal(alu1final, adderin2,  adderout);
		
		
		mux2to1_16bits( adderout,alu1final, regSrc, Result);
		
endmodule

module testMultiCycle;

	// Inputs
	reg clk;
	reg reset;

	// Outputs
	wire [15:0] Result;

	// Instantiate the Unit Under Test (UUT)
	multiCycle uut (
		.clk(clk), 
		.reset(reset), 
		.Result(Result)
	);

	always
	#5 clk = ~clk;
	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;
		#10 reset = 0;
		#370 $finish;
	end
      
endmodule

