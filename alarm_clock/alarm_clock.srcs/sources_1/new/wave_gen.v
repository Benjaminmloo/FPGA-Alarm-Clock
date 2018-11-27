`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2018 05:37:23 PM
// Design Name: 
// Module Name: wave_gen
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


module square_wave_gen #(
    parameter clk_freq = 100_000_000,
    parameter des_freq = 5_000
    )(
    input clk,
    input rst,
    input en,
    output reg [10:0] audio
    );
    localparam num_clks_per_edge = clk_freq /(2 * des_freq);
    wire new_edge;
    
    count_to #(27, 100_000_000)_edge(
        .clk        (clk), 
        .rst        (rst), 
        .en         (en), 
        .shift_out  (new_edge)
    );
    
    always @ (posedge clk)
        if(rst)
            audio = 0;
        else if(en & new_edge)
            audio = ~audio;
        else
            audio = 0;
            
endmodule
