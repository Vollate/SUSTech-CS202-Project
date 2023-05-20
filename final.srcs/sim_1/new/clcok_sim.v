`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/20/2023 04:49:38 PM
// Design Name: 
// Module Name: clcok_sim
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


module clcok_sim( );
reg sys_clk;
wire cpu,uart;
clk_wiz_0 clk(.clk_in1(sys_clk),
    .cpu_clk(cpu),
    .uart_clk(uart));
always begin
#1 sys_clk=~sys_clk;
end

initial begin
sys_clk=0;
#100000000 $finish;
end
endmodule
