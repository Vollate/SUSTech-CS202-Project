`timescale 1ns / 1ps

module segment (input clk,
                input rst_n,
                input[63:0] numbers,
                output reg[7:0] seg_select,
                output reg[7:0] seg_out);
    
    reg [2:0] each_counter;
    
    reg [13:0] cnt;
    
    always @(posedge clk) begin
        if (!rst_n) begin
            cnt <= 0;
            end else begin
            cnt <= cnt + 1;
        end
    end
    
    wire div_clk = cnt[13] == 1;
    reg  div_clk_d0;
    always @(posedge clk) div_clk_d0 <= div_clk;
    wire div_clk_posedge = div_clk && !div_clk_d0;
    
    always @(posedge clk) begin
        if (!rst_n) begin
            each_counter <= 0;
            seg_select   <= 8'b0000_0001;
            seg_out      <= 0;
            end else begin
            if (div_clk_posedge) begin
                each_counter = each_counter + 1;
                seg_select <= ~(1 << each_counter);
                seg_out    <= ~numbers[each_counter*8+:8];
                end else begin
                each_counter <= each_counter;
                seg_select   <= seg_select;
                seg_out      <= seg_out;
            end
        end
    end
    
    
endmodule
