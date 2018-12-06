`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2018 07:12:11 PM
// Design Name: 
// Module Name: disp_mux_ctrl
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


module disp_mux_ctrl(
    input set_alarm,
    input set_timer,
    input run_timer,
    
    output [1:0] s
    );
    reg [1:0] active, set;
    reg clk_2Hz;
    
    localparam DC = 0, DA = 1, DT = 2;
    
    always @ *
        if(run_timer)
            active = DT;
        else
            active = DC;
            
    always @ *
        if(set_alarm & ~set_timer)
            set = DA;
        else if(set_timer & ~set_alarm)
            set = DT;
        else
            set = active;
            
    assign s = set;
endmodule
