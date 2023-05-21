`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 05/19/2023 08:12:40 PM
// Design Name:
// Module Name: data_mem_sim
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


module data_mem_sim();
    reg clk,rst_n,mem_write;
    reg [15:0] switch_in;
    reg [31:0] address,data_in;
    wire [15:0]led_out;
    wire [63:0]seg_out;
    wire[31:0] data_out;
    reg uart_enable,uart_clk,uart_write;
    reg [13:0]uart_address;
    reg [31:0]uart_data_in;
    reg uart_done;
    data_mem data_mem_inst(
    .clk(clk),
    .rst_n(rst_n),
    .mem_write(mem_write),
    .switch_in(switch_in),
    .address(address),
    .data_in(data_in),
    .led_out(led_out),
    .seg_out(seg_out),
    .data_out(data_out),
    .uart_enable(uart_enable),
    .uart_clk(uart_clk),
    .uart_write(uart_write),
    .uart_address(uart_address),
    .uart_data_in(uart_data_in),
    .uart_done(uart_done)
    );
    always begin
        #1 clk = ~clk;
    end
    initial begin
        clk         = 1'b1;
        rst_n       = 1'b0;
        uart_enable = 1'b0;
        #2 rst_n    = 1'b1;
        //data write&read test
        #2 mem_write = 1'b1;
        address      = 32'h0000_0100;
        data_in      = 32'h0000_1413;
        #2 address   = 32'h0011_1111;
        data_in      = 32'h2000_1000;
        #2 mem_write = 1'b0;
        data_in      = 32'b0;
        address      = 32'h0000_0100;
        //io write test
        #2 mem_write = 1'b1;
        address      = 32'hFFFF_FC60;
        data_in      = {16'b0,16'hF0FF};
        #2 rst_n     = 1'b0;
        address      = 32'b0;
        #2 rst_n     = 1'b1;
        #2 data_in   = {16'b0,16'h0};
        #2 data_in   = {16'b0,16'hF000};
        //io read test
        #2 switch_in = 16'hFFF0;
        mem_write    = 1'b0;
        address      = 32'hFFFF_FC70;
        //uart write test
        #10 $finish;
    end
endmodule
