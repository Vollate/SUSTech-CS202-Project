`timescale 1ns / 1ps


module executs32_old(input[31:0] Read_data_1,
                     input[31:0] Read_data_2,
                     input[31:0] Sign_extend,
                     input[5:0] Function_opcode,
                     input[5:0] Exe_opcode,
                     input[1:0] ALUOp,
                     input[4:0] Shamt,
                     input 		 Sftmd,
                     input ALUSrc,
                     input I_format,
                     input Jr,
                     output Zero,
                     output [31:0] ALU_Result,
                     output[31:0] Addr_Result,
                     input[31:0] PC_plus_4);

wire [31:0] operand1;
wire [31:0] operand2;
assign operand1 = Read_data_1;
assign operand2 = ALUSrc? Sign_extend:Read_data_2;

wire [5:0] Exe_code;
assign Exe_code = I_format?{3'b000,Exe_opcode[2:0]}:Function_opcode;
wire [2:0] ALU_ctl;
assign ALU_ctl[0]  = (Exe_code[0] | Exe_code[3]) & ALUOp[1];
assign ALU_ctl[1]  = ((!Exe_code[2]) | (!ALUOp[1]));
assign ALU_ctl[2]  = (Exe_code[1] & ALUOp[1]) | ALUOp[0];
assign Zero        = (alu_result_mux == 32'h0) ? 1'b1:1'b0;
assign Addr_Result = PC_plus_4 + (Sign_extend << 2);

reg [31:0] alu_result_mux;
reg [31:0] alu;

assign ALU_Result = alu;

reg [31:0] Shift_Result;
wire[2:0] Sftm;
assign Sftm = Function_opcode[2:0];

// always@(ALU_ctl or operand1 or operand2) begin
always@(*) begin
    casez(ALU_ctl)
        3'b000:alu_result_mux   = operand1 & operand2;
        3'b001:alu_result_mux   = operand1 | operand2;
        3'b01z:alu_result_mux   = operand1 + operand2;
        3'b100:alu_result_mux   = operand1 ^ operand2;
        3'b101:alu_result_mux   = ~(operand1 | operand2);
        3'b11z:alu_result_mux   = operand1 - operand2;
        default: alu_result_mux = 32'h00000000;
    endcase
end



always @* begin
    if (Sftmd)
        case(Sftm[2:0])
            3'b000:Shift_Result  = operand2 << Shamt;
            3'b010:Shift_Result  = operand2 >> Shamt;
            3'b100:Shift_Result  = operand2 << operand1;
            3'b110:Shift_Result  = operand2 >> operand1;
            3'b011:Shift_Result  = $signed(operand2) >>> Shamt;
            3'b111:Shift_Result  = $signed(operand2) >>> operand1;
            default:Shift_Result = operand2;
        endcase
    else begin
        Shift_Result = operand2;
    end
end

always @* begin
    if (((ALU_ctl == 3'b111) && (Exe_code[3] == 1)) || ((ALU_ctl == 3'b110) && (Exe_opcode == 6'b001010)) || (ALU_ctl == 3'b111) && (Exe_opcode == 6'b001011))
        alu = $signed(operand1-operand2)<0?1:0;
    else if ((ALU_ctl == 3'b101) && (I_format == 1))
        alu = {operand2[15:0],16'b0};
    else if (Sftmd == 1)
        alu = Shift_Result;
    else
        alu = alu_result_mux[31:0];
end
endmodule
