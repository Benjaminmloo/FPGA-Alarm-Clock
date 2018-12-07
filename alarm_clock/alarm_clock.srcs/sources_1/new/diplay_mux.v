`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Engineer: Benjamin Loo
// 
// Create Date: 11/15/2018 06:07:48 PM
// Design Name: 
// Module Name: display_mux
// Project Name: Alarm Clock
// Target Devices: Nexys 4 DDR
// Tool Versions: 
// Description: Simple mux to switch between inputs
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module display_mux #(
    parameter MUX_W = 4 * 4
    )(
    input [MUX_W:0] d_clk,
    input [MUX_W:0] d_alarm,
    input [MUX_W:0] d_timer,
    input [1:0] s,
    input blink,
    
    output reg [MUX_W:0] d,
    output reg [7:0] p
    );
    
    always @ *
        if(s == 2'b01)
        begin
            d = d_alarm;
            p = {3'b111, blink , 4'b1111};
        end
        else if(s == 2'b10)
        begin
            d = d_timer;
            p = {8'b1101_0111};
        end
        else
        begin
            d = d_clk;
            p = {3'b111, blink , 4'b1111};
        end
    
endmodule