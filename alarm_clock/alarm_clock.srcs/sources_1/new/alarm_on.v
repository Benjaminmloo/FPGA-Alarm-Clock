`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2018 06:07:48 PM
// Design Name: 
// Module Name: alarm_on
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


module alarm_driver(
    input clk,
    input rst,
    input en,
    output reg alarm_on
    );
    
    always @ (posedge clk, posedge rst)
    if (rst)
        alarm_on = 0;
    else if(en)
        alarm_on = ~ alarm_on;
    else
        alarm_on = 0;
        
endmodule
