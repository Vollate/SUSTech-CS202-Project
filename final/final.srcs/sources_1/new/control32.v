`timescale 1ns / 1ps
/////////////////////////////////////////////////////////////////////////////
// Create Date: 2023/05/18 10:28:06
// Design Name:
// Module Name: control32
// Description:
// Revision 0.01 - File Created
/////////////////////////////////////////////////////////////////////////////

module control32(input[5:0] Opcode,
                 input[5:0] Function_opcode,
                 output Jr,
                 output RegDST,
                 output ALUSrc,
                 output MemtoReg,
                 output RegWrite,
                 output MemWrite,
                 output Branch,
                 output nBranch,
                 output Jmp,
                 output Jal,
                 output I_format,
                 output Sftmd,
                 output[1:0] ALUOp);

wire R_format;
wire Lw;
wire Sw;
assign Lw       = (Opcode == 6'b100011)? 1'b1:1'b0;
assign Sw       = (Opcode == 6'b101011)?1'b1:1'b0;
assign Jr       = ((Opcode == 6'b000000)&&(Function_opcode == 6'b001000)) ? 1'b1 : 1'b0;
assign Jal      = (Opcode == 6'b000011)? 1'b1:1'b0;
assign Jmp      = (Opcode == 6'b000010)? 1'b1:1'b0;
assign R_format = (Opcode == 6'b000000)? 1'b1:1'b0;
assign RegDST   = R_format;
assign I_format = (Opcode[5:3] == 3'b001)?1'b1:1'b0;
assign ALUOp    = {(R_format || I_format),(Branch || nBranch)};
assign Sftmd = (((Function_opcode == 6'b000000)||(Function_opcode == 6'b000010)
||(Function_opcode == 6'b000011)||(Function_opcode == 6'b000100)
||(Function_opcode == 6'b000110)||(Function_opcode == 6'b000111))
&& R_format)? 1'b1:1'b0;
assign RegWrite = (R_format || Lw || Jal || I_format) && !(Jr);
assign Branch   = (Opcode == 6'b000100)? 1'b1:1'b0;
assign nBranch  = (Opcode == 6'b000101)? 1'b1:1'b0;
assign MemWrite = (Opcode == 6'b101011)? 1'b1:1'b0;
assign MemtoReg = Lw;
assign ALUSrc   = (Opcode == 6'b101011||I_format||Opcode == 6'b100011)? 1'b1:1'b0;
endmodule
