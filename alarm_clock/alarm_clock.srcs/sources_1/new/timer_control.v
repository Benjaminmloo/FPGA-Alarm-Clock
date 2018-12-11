`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/10/2018 07:11:52 PM
// Design Name: 
// Module Name: timer_control
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


module timer_control(
    input clk,
    input rst,
    input en,
    input start,
    input ld_rq,
    input done,
    
    output count_en,
    output ld,
    output trigger
    );
    
    
    localparam S0 = 0, S1 = 1, S2 = 2, S3 = 3, S4 = 4, S5 = 5, S6 = 6, S7 = 7;
    reg [2:0] state, next_state;
    
    always @ *
        case(state)
            S0: if(en)                  next_state = S1;             //counter disabled
                else                    next_state = S0;
                
            S1: if(!en)                 next_state = S0;            //counter enabled - wait for start / ld_rq
                else if(start & ~done)  next_state = S2;
                else if(ld_rq)          next_state = S5;
                else                    next_state = S1;
                
            S2: if(!en)                 next_state = S0;            //counter started - waiting for start release 
                else if(!start)         next_state = S3;
                else if(done)           next_state = S6;
                else                    next_state = S2;
                
            S3: if(!en)                 next_state = S0;            //counter still - counting on release 
                else if(start)          next_state = S7;
                else if(ld_rq)          next_state = S5;
                else if(done)           next_state = S4;
                else                    next_state = S3; 
                           
            S4: if(!en)                 next_state = S0;            //counter finished - trigger finish alarm
                else if(start)          next_state = S7;
                else if(ld_rq)          next_state = S5;
                else                    next_state = S4;
                            
            S5: if(!en)                 next_state = S0;            //counter setting/resetting  
                else if(!ld_rq)         next_state = S1;
                else                    next_state = S5;    
                        
            S6: if(!en)                 next_state = S0;            // finished while start is still held - wait for release to allow any action
                else if(!start)         next_state = S4;
                else                    next_state = S6;            
                
            S7: if(!en)                 next_state = S0;            //counter paused - wait for release to allow further action
                else if(!start)         next_state = S1;
                else                    next_state = S7;
                
            default:                    next_state = S0;
        endcase
                  
        assign count_en = (state == S2) | (state == S3);
        assign ld = state == S5;
        assign trigger  = (state == S4) | (state == S6);
        
    always @(posedge rst, posedge clk)
        if(rst)
            state <= S0;
        else
            state <= next_state;
    
endmodule
