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
               uart_enable,
               uart_write,                    // 1 write
               uart_clk,
               input[13:0] uart_address,
               input[31:0] uart_data,
               output[31:0] Instruction,
               output[31:0] branch_base_addr,
               output reg [31:0] link_addr);
    
    
    reg [31:0] PC, Next_PC;
    assign branch_base_addr = PC + 32'h4;
    
    ins_ram instructionRam(.clka(uart_enable?uart_clk:clock), //fetch on posedge
    .wea(uart_enable?uart_write:1'b0),
    .addra(uart_enable?uart_address:PC[15:2]),
    .dina(uart_enable?uart_data:32'h0),
    .douta(Instruction)
    );
    // prgrom instmem(
    // .clka(clock),
    // .addra(PC[15:2]),
    // .douta(Instruction)
    // );
    
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
