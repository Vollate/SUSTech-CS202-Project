// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2017.4 (win64) Build 2086221 Fri Dec 15 20:55:39 MST 2017
// Date        : Mon May 22 01:15:26 2023
// Host        : Volinos running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               C:/codes/project/final/final.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_stub.v
// Design      : clk_wiz_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tfgg484-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module clk_wiz_0(cpu_clk, uart_clk, clk_in1)
/* synthesis syn_black_box black_box_pad_pin="cpu_clk,uart_clk,clk_in1" */;
  output cpu_clk;
  output uart_clk;
  input clk_in1;
endmodule
