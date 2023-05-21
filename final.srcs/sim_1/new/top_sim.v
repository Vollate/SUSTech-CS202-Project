`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/21/2023 07:08:12 PM
// Design Name:
// Module Name: top_sim
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


module top_sim();
    reg uart_rx_pin,sys_clk,sys_rst;
    wire uart_tx_pin;
    reg[23:0] switches_pin;
    wire [23:0]leds_pin;
    
    top_test sim_top(.uart_rx_pin(uart_rx_pin),
    .bank_sys_clk(sys_clk),
    .bank_rst(sys_rst),
    .uart_tx_pin(uart_tx_pin),
    .switches_pin(switches_pin),
    .leds_pin(leds_pin)
    );
    always begin
        #1 sys_clk = ~sys_clk;
    end
    
    initial begin
        sys_rst      = 1'b1;
        sys_clk      = 0;
        switches_pin = 24'b111111111111111111111111;
        #1 sys_rst   = 1'b0;
        #1000000 $finish;
    end
endmodule
