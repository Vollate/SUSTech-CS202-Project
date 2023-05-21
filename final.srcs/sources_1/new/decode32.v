`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2023/05/14 11:18:09
// Design Name:
// Module Name: decode32
// Project Name:
// Target Devices:
// Tool Versions:
// Description:
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////


module decode32(read_data_1,
                read_data_2,
                Instruction,
                mem_data,
                ALU_result,
                Jal,
                RegWrite,
                MemtoReg,
                RegDst,
                Sign_extend,
                clock,
                reset,
                opcplus4);
    output[31:0] read_data_1;
    output[31:0] read_data_2;
    input[31:0]  Instruction;
    input[31:0]  mem_data;
    input[31:0]  ALU_result;
    input        Jal;
    input        RegWrite;
    input        MemtoReg;
    input        RegDst;
    output[31:0] Sign_extend;
    input		 clock,reset;
    input[31:0]  opcplus4;
    
    wire [5:0] opcode = Instruction[31:26];
    wire [4:0] rs_id  = Instruction[25:21];
    wire [4:0] rt_id  = Instruction[20:16];
    wire [4:0] rd_id  = Instruction[15:11];
    reg [31:0] register[0:31];
    
    assign read_data_1 = register[rs_id];
    assign read_data_2 = register[rt_id];
    assign Sign_extend = (opcode == 6'b001100 || opcode == 6'b001101||opcode == 6'b001110||opcode == 6'b001011) ? {16'b0, Instruction[15:0]} : {{16{Instruction[15]}}, Instruction[15:0]};
    
    integer i;
    always @(posedge clock) begin
        if (reset) begin
            for(i = 0; i < 32; i = i+1) begin
                register[i] <= 32'h0;
            end
        end
        else begin
            if (!Jal) begin
                for(i = 1; i < 32; i = i+1) begin
                    if (i == rt_id && RegWrite && !RegDst) begin
                        if (MemtoReg)begin
                            register[i] <= mem_data;
                        end
                        else begin
                            register[i] <= ALU_result;
                        end
                    end
                    else if (i == rd_id && RegWrite && RegDst) begin
                        register[i] <= ALU_result;
                    end
                    else begin
                        register[i] <= register[i];
                    end
                end
            end
            else begin
                register[31] <= opcplus4;
            end
        end
    end
    
endmodule
