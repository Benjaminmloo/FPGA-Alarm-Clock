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
    input clk,
    input rst,
    input set_time,
    input set_alarm,
    input timer_en,
    
    output reg [1:0] s
    );
    localparam S0 = 0, S1 = 1, S2 = 2;
    reg[1:0] state, n_state;
    
    wire [1:0] set;
    assign set = {set_alarm, set_time};
    
    reg [1:0] active;
    reg clk_2Hz;
    
    localparam DC = 2'b00, DA = 2'b01, DT = 2'b10;
    
    always @ *
        if(timer_en) //depending on if the timer is running set the currently active device
            active = DT;
        else
            active = DC;
            
    always @ *
        case(state)
            S0: if(set == 3'b001) //when a single set btn is pressed load that device as set_dv
                    n_state = S1;
                else if(set == 3'b010)
                    n_state = S2;
                else
                    n_state = S0;
            S1: if(!set[0]) //when setting a device only releasing the currently pressed button will return to the active device
                    n_state = S0;
                else
                    n_state = S1;
            S2: if(!set[1])
                    n_state = S0;
                else
                    n_state = S2;
            default n_state = S0;
        endcase
        
    always @ *
        case(state)
            S0: s = active;
            S1: s = DC;
            S2: s = DA;
            default: s = DC;
        endcase
            
        
    always @ (posedge clk, posedge rst)
    begin
    if(rst) 
        state <= S0;
    else
        state <= n_state;
    end
    
endmodule
