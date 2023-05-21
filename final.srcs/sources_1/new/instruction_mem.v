`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/18/2023 05:18:17 PM
// Design Name:
// Module Name: memory
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


module instruction_mem(input clk,
                       uart_enable,
                       uart_write,                   // 1 write
                       uart_clk,
                       input[13:0] uart_address,
                       input[31:0] uart_data,
                       input[31:0] pc,
                       output[31:0]instruction_out);
    
    RAM ram(.clka(uart_write?uart_clk:clk),//fetch on posedge
    .wea(uart_enable? uart_write:1'b0),
    .addra(uart_write?uart_address:pc[15:2]),
    .dina(uart_data),
    .douta(instruction_out)
    );
endmodule
