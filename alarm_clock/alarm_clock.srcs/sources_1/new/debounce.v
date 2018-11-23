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
// Debouncer for button input that count presses
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
    
    wire roll_over;
    
    assign roll_over = count == CLKS_TO_COUNT; //this acts like the shift out of regular counter
    
    always @ (posedge clk, posedge rst)
    if (rst)
        begin
            count <= {COUNT_BITS{1'b0}};
            q <= 0;
            d_prev <= 0;
        end
    else if(roll_over)
    begin
        count <= {COUNT_BITS{1'b0}};
         
        if(~(d ^ d_prev))
            q <= d;
        else
            q <= q;
              
        d_prev <= d;
    end
    else
        count <= count + 1; 
    
endmodule