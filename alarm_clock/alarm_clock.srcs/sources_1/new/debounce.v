`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Benjaminm Loo
// 
// Create Date: 11/15/2018 06:07:48 PM
// Design Name: 
// Module Name: debounce
// Project Name: Alarm Clock
// Target Devices: Nexys 4 DDR
// Tool Versions: 
// Description: 
// Debounces button pressess
//
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments: assumes 5MHz clk and max time between bounces 10mS so it counts 
// 
//////////////////////////////////////////////////////////////////////////////////
module debounce #(
    parameter COUNT_BITS = 16,
    parameter CLKS_TO_COUNT = 50_000
    )(
    input clk,
    input rst,
    input d,
    output reg q
    );
    reg [COUNT_BITS - 1:0] count;
    reg d_prev;
    wire cap;
    
    //counts the clks between samples
    count_to #(COUNT_BITS, CLKS_TO_COUNT) cap_samp(
        .clk        (clk),
        .rst        (rst),
        .en         (1'b1),
        .shift_out  (cap)
        );
   
   //if the two previous samples are the same
   //The output is changed to the new value
   //every edge update the samples
   always @ (posedge cap) 
    begin         
        if(~(d ^ d_prev))
            q <= d;
        else
            q <= q;
              
        d_prev <= d;
    end
    
endmodule