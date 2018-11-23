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
    input clk,
    input rst,
    input   [4 * 4:0] d_rt,
    input   [4 * 4:0] d_alarm,
    input   en_alarm,     //enable signle for the alarm
    input   set_alarm,
    output reg alarm_on,
    output  alarm_en    //signal indicating if the alarm is enabled
    );
    parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3;
    
    reg [1:0] state, state_next;
    
    wire trigger;
    
    assign alarm_en = en_alarm & ~set_alarm;
    assign trigger = d_rt == d_alarm;
    
    always @ (posedge clk, posedge rst)
        if(rst)
            state = S0;
        else
            state = state_next;
            
    always @ *
        case(state)
            S2: alarm_on = 1;
            default: alarm_on = 0;
        endcase
    
    always @ * 
        case(state)
            S0: if(!alarm_en)       //disabled alarm - only do something if alarm is enabled
                    state_next = S0;
                else
                    state_next = S1;
            S1: if(!alarm_en)       //enabled alarm - waits for trigger or to be turned off
                    state_next = S0;
                else if(trigger)
                    state_next = S2;
                else
                    state_next = S1;
            S2: if(!alarm_en)       //triggered alarm - continues until disabled 
                    if(trigger)
                        state_next = S3;
                    else
                        state_next = S0;
                else
                    state_next = S2;
            S3: if(trigger)         //disabled triggered - prevents the alarm from going on twice for the same trigger
                    state_next = S3;
                else
                    if(alarm_en)
                        state_next = S1;
                    else
                        state_next = S0;
                        
            default: state_next = S0;
        endcase
endmodule