`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2018 06:07:48 PM
// Design Name: 
// Module Name: time
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

module clock_counter (
    input clk,
    input rst, 
    input en,
    output [4 * 4:0] d;
    );
    
    wire[3:0] seconds, minutes_0, minutes_1, hours_0, minutes_1;
    
    reg 
    
    count_to #(6, 59) count_seconds(
        .clk(clk),
        .rst(rst),
        .en(en),
        .m(seconds)
        .shift_out(minutes_0_en);
        )
        
    count_to #(4, 9) count_minute_0(
        .clk(clk),
        .rst(rst),
        .en(en),
        .m(seconds)
        .shift_out(minutes_1_en);
        )
    count_to #(3, 5) count_minutes_1(
        .clk(clk),
        .rst(rst),
        .en(en),
        .m(seconds)
        .shift_out(hours_en);
        )
        
    count_to #(4, 12) count_seconds(
        .clk(clk),
        .rst(rst),
        .en(en),
        .m(seconds)
        .shift_out(pm_en);
        )
        
    
endmodule