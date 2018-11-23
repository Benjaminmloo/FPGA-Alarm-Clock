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
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module display_mux(
    input [4 * 4:0] d_time,
    input [4 * 4:0] d_alarm,
    input s,
    output reg [4 * 4:0] q
    );
    
    always @ *
        if(s)
            q = d_alarm;
        else
            q = d_time;
            
    
endmodule