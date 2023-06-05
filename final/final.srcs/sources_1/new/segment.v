`timescale 1ns / 1ps

module segment (input clk,
                input rst_n,
                input[63:0] numbers,
                output [7:0] seg_select_pin,
                output reg[7:0] seg_out);
    reg [7:0]seg_select;
    reg [16:0] cnt;
    reg slow_clk;
    
    assign seg_select_pin = seg_select^8'b1111_1111;
    always @(posedge clk) begin
        if (!rst_n) begin
            cnt      <= 0;
            slow_clk <= 0;
            seg_out  <= 0;
        end
        else begin
            cnt <= cnt + 1;
        end
        
        if (cnt> 17'd25000)begin
            slow_clk <= ~slow_clk;
            cnt      <= 0;
        end
    end
    
    
    always @(posedge slow_clk,negedge rst_n) begin
        if (~rst_n)begin
            seg_select <= 8'b1;
        end
        else if (seg_select == 8'b1000_0000)begin
            seg_select <= 8'b1;
        end
        else begin
            seg_select = seg_select<<1;
        end
        
        case(seg_select)
            8'b0000_0001: seg_out = numbers[7:0];
            8'b0000_0010: seg_out = numbers[15:8];
            8'b0000_0100: seg_out = numbers[23:16];
            8'b0000_1000: seg_out = numbers[31:24];
            8'b0001_0000: seg_out = numbers[39:32];
            8'b0010_0000: seg_out = numbers[47:40];
            8'b0100_0000: seg_out = numbers[55:48];
            8'b1000_0000: seg_out = numbers[63:56];
            default: seg_out      = 0;
        endcase
        
    end
    
    
endmodule
