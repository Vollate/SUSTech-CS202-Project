`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 04/24/2023 05:37:05 PM
// Design Name:
// Module Name: top
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


module top(input uart_rx_pin,
           bank_sys_clk,
           bank_rst,
           output uart_tx_pin,
           input [23:0]switches_pin,
           input [4:0]button_pins,
           keypad_detect,
           output [7:0]seg7_led_pin,
           seg7_bits_pin,
           output [23:0]leds_pin);
    // assign leds_pin = switches_pin;
    
    wire cpu_clk,uart_clk,global_rst_n,Zero;
    wire [63:0]seg_val;
    wire [31:0]memory_address_in,memory_data_in,memory_data_out;
    wire [1:0]ALUOp;
    wire Jr,RegDST,ALUSrc,MemtoReg,RegWrite,MemWrite,Branch,nBranch,Jmp,Jal,I_format,Sftmd;
    wire[31:0]read_data_1,read_data_2,ALU_result,sign_extend;
    wire  upg_clk_o,upg_rst;
    wire upg_wen_o;
    wire upg_done_o;
    wire [14:0] upg_adr_o;
    wire [31:0] upg_dat_o;
    
    assign upg_rst = ~switches_pin[23];
    
    uart_bmpg_0 uart(
    .upg_clk_i(uart_clk),
    .upg_rst_i(upg_rst),
    .upg_rx_i(uart_rx_pin),
    .upg_clk_o(upg_clk_o),
    .upg_wen_o(upg_wen_o),
    .upg_adr_o(upg_adr_o),
    .upg_dat_o(upg_dat_o),
    .upg_done_o(upg_done_o),
    .upg_tx_o(uart_tx_pin)
    );
    
    clk_wiz_0 clock(.clk_in1(bank_sys_clk),
    .cpu_clk(cpu_clk),
    .uart_clk(uart_clk)
    );
    
    wire [31:0]branch_base_addr,Instruction,Addr_result,link_addr;
    
    Ifetc32 ins_fetech(
    .clock(cpu_clk),
    .reset(~global_rst_n),
    .Addr_result(Addr_result),
    .Zero(Zero),
    .Read_data_1(read_data_1),
    .Branch(Branch),
    .nBranch(nBranch),
    .Jmp(Jmp),
    .Jal(Jal),
    .Jr(Jr),
    .upg_rst_i(upg_rst),
    .upg_clk_i(upg_clk_o),
    .upg_wen_i(upg_wen_o & (!upg_adr_o[14])),
    .upg_adr_i(upg_adr_o[13:0]),
    .upg_dat_i(upg_dat_o),
    .upg_done_i(upg_done_o),
    .Instruction(Instruction),
    .branch_base_addr(branch_base_addr),
    .link_addr(link_addr)
    );
    
    control32 controler(.Opcode(Instruction[31:26]),
    .Function_opcode(Instruction[5:0]),
    .Jr(Jr),
    .RegDST(RegDST),
    .ALUSrc(ALUSrc),
    .MemtoReg(MemtoReg),
    .RegWrite(RegWrite),
    .MemWrite(MemWrite),
    .Branch(Branch),
    .nBranch(nBranch),
    .Jmp(Jmp),
    .Jal(Jal),
    .I_format(I_format),
    .Sftmd(Sftmd),
    .ALUOp(ALUOp));
    
    executs32 ALU(
    .Read_data_1(read_data_1),
    .Read_data_2(read_data_2),
    .Sign_extend(sign_extend),
    .Function_opcode(Instruction[5:0]),
    .Exe_opcode(Instruction[31:26]),
    .ALUOp(ALUOp),
    .Shamt(Instruction[10:6]),
    .Sftmd(Sftmd),
    .ALUSrc(ALUSrc),
    .I_format(I_format),
    .Jr(Jr),
    .Zero(Zero),
    .ALU_Result(ALU_result),
    .Addr_Result(Addr_result),
    .PC_plus_4(branch_base_addr)
    );
    
    decode32 decoder(.read_data_1(read_data_1),
    .read_data_2(read_data_2),
    .Instruction(Instruction),
    .mem_data(memory_data_out),
    .ALU_result(ALU_result),
    .Jal(Jal),
    .RegWrite(RegWrite),
    .MemtoReg(MemtoReg),
    .RegDst(RegDST),
    .Sign_extend(sign_extend),
    .clock(cpu_clk),
    .reset(~global_rst_n),
    .opcplus4(link_addr));
    
    data_mem RAM(.clk(cpu_clk),
    .rst_n(global_rst_n),
    .mem_write(MemWrite),
    .switch_in(switches_pin[15:0]),
    .address(ALU_result),
    .data_in(read_data_2),
    .led_out(leds_pin[15:0]),
    .seg_out(seg_val),
    .data_out(memory_data_out),
    .upg_rst_i(upg_rst),
    .upg_clk_i(upg_clk_o),
    .upg_wen_i(upg_wen_o & upg_adr_o[14]),
    .upg_adr_i(upg_adr_o[13:0]),
    .upg_dat_i(upg_dat_o),
    .upg_done_i(upg_done_o)
    );
    
    segment seg(
    .clk(cpu_clk),
    .rst_n(global_rst_n),
    .numbers(seg_val),
    .seg_select_pin(seg7_bits_pin),
    .seg_out(seg7_led_pin)
    );
    assign leds_pin[23:16] = switches_pin[23:16];
    assign global_rst_n    = ~bank_rst;
    
endmodule
