`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Benjamin Loo
// 
// Create Date: 11/16/2018 01:48:23 AM
// Design Name: 
// Module Name: increment_driver
// Project Name: Alarm Clock
// Target Devices: Nexys 4 DDR
// Tool Versions: 
// Description: syncronous FSM that controls how a register increments
// for every individual button press only one syncronous enable will be produced
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module increment_driver(
    input clk,
    input rst,
    input en, 
    input d,
    
    output reg q
    );
    parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10;
    
    reg [1:0] state, state_n;
    
   always @ (posedge clk, posedge rst)
        if(rst)
            state <= S0;
        else if(en)
            state <= state_n;
            
    always @ * 
        case(state)
            S0: if(d)   state_n = S1; //wait for button press
                else    state_n = S0;
            S1: if(d)   state_n = S2; //the button has been pressed so a en is neede
                else    state_n = S0;
            S2: if(d)   state_n = S2;//the button has been pressed but no en is needed
                else    state_n = S0;
            default: state_n = S0;
        endcase
        
    always @ * 
        case(state)
            S1:q = 1; //only rasie the enable in s1
            default: q = 0;
        endcase
endmodule
