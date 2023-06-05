`timescale 1ns / 1ps

module Ifetc32(input clock,
               reset,
               input [31:0] Addr_result,
               input Zero,
               input [31:0] Read_data_1,
               input Branch,
               input nBranch,
               input Jmp,
               input Jal,
               input Jr,
               output[31:0] Instruction,
               output[31:0] branch_base_addr,
               output reg [31:0] link_addr,
               input upg_rst_i,
               input upg_clk_i,
               input upg_wen_i,
               input[13:0] upg_adr_i,
               input[31:0] upg_dat_i,
               input upg_done_i);
    
    
    reg [31:0] PC, Next_PC;
    assign branch_base_addr = PC + 32'h4;
    wire kickOff            = upg_rst_i | (~upg_rst_i & upg_done_i);
    
    ins_ram instructionRam(.clka(kickOff?clock:upg_clk_i), //fetch on posedge
    .wea(kickOff?1'b0:upg_wen_i),
    .addra(kickOff?PC[15:2]:upg_adr_i),
    .dina(kickOff?32'h0 : upg_dat_i),
    .douta(Instruction)
    );
    
    
    always @* begin
        if (((Branch == 1)&&(Zero == 1)) || ((nBranch == 1) && (Zero == 0)))
            Next_PC = Addr_result;
        else if (Jr == 1)
            Next_PC = Read_data_1;
        else
            Next_PC = PC + 32'h4;
    end
    
    
    always @(negedge clock) begin
        if (reset)
            PC <= 32'h0;
        
        else if (Jmp == 1) begin
        PC <= {PC[31:28], Instruction[25:0],2'b00};
    end
    else if (Jal == 1) begin
    PC        <= {PC[31:28], Instruction[25:0],2'b00};
    link_addr <= PC + 32'h4;
    end
    else PC <= Next_PC;
    end
    
endmodule
