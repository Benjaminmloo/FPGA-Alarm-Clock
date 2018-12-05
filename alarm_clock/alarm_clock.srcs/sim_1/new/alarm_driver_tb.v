`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/03/2018 03:07:34 PM
// Design Name: 
// Module Name: alarm_on_tb
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


module alarm_driver_tb(
    );
    
    reg clk, rst, en, en_1Hz;
    
    alarm_driver DUV (
            .clk        (clk),
            .rst        (rst),
            .en         (en),
            .switch_edge(en_1Hz),
            .alarm_on   (alarm_led)
        );
        
    initial
    begin
        
    end
endmodule
