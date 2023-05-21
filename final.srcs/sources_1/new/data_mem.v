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


module data_mem(input clk,
                rst_n,
                mem_write,              //0 read 1 write
                input[15:0]switch_in,
                input[31:0]address,
                input[31:0]data_in,
                output[31:0]data_out,
                output [15:0]led_out,
                output [63:0]seg_out,
                input upg_rst_i,
                input upg_clk_i,
                input upg_wen_i,
                input [13:0] upg_adr_i,
                input [31:0] upg_dat_i,
                input upg_done_i);
    
    wire use_io,use_led,use_switch,use_seg_1,use_seg_2;
    wire [16:0] ram_address;
    wire [31:0] ram_out,io_out;
    
    reg [31:0] led_cache;
    reg [63:0] seg_cache;
    assign seg_out = seg_cache;
    assign led_out = led_cache[15:0];
    assign use_io  = ~(address < 32'hFFFF_FC00);
    wire kickOff   = upg_rst_i | (~upg_rst_i & upg_done_i);
    RAM ram(.clka(kickOff  ? clk: upg_clk_i),//store on negedge
    .wea(kickOff?(use_io?1'b0:mem_write):upg_wen_i),
    .addra(kick?address[15:2]:upg_adr_i),
    .dina(kick?data_in:upg_dat_i),
    .douta(ram_out)
    );
    
    assign use_led      = (address == 32'hFFFF_FC60);
    assign use_switch   = (address == 32'hFFFF_FC70);
    assign use_seg_1    = (address == 32'hFFFF_FC80);
    assign use_seg_2    = (address == 32'hFFFF_FC90);
    assign io_out       = {16'b0,switch_in};
    assign data_out     = mem_write?32'b0:(use_io?io_out:ram_out);
    //    assign io_out = (address == 32'hFFFF_FC60)?led_cache:{8'b0,switch_in};
    // assign io_out    = {16'b0,switch_in};
    // assign data_out  = (use_io?io_out:ram_out);
    
    // always@(negedge rst_n)begin
    
    // end
    always@(negedge clk) begin
        if (~rst_n)begin
            led_cache <= 32'b0;
            seg_cache <= 64'hFFFF_FFFF;
        end
        else if (mem_write) begin
            case({use_led,use_seg_1,use_seg_2})
                3'b100:led_cache[15:0]  <= data_in;
                3'b010:seg_cache[31:0]  <= {seg_cache[63:32],data_in};
                3'b001:seg_cache[63:32] <= {data_in,seg_cache[31:0]};
                default: begin
                end
            endcase
        end
            end
            
            endmodule
