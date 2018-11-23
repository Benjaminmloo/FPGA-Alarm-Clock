`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Benjamin Loo
// 
// Create Date: 11/15/2018 06:07:48 PM
// Design Name: 
// Module Name: master_controller
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

module master_controller(
    input   [4 * 4:0] d_rt,
    input   [4 * 4:0] d_alarm,
    input   en_alarm,     //enable signle for the alarm
    input   set_alarm,
    output  alarm_on,
    output  alarm_en    //signal indicating if the alarm is enabled
    );
    
    assign alarm_en = en_alarm & ~set_alarm;
    
    assign alarm_on = (d_rt == d_alarm) & alarm_en;
    
    
endmodule