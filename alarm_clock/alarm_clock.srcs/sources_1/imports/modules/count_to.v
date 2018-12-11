`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Benjamin Loo
// 
// Create Date: 10/15/2018 10:14:41 AM
// Design Name: 
// Module Name: count_to
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


module count_to
    #(
    parameter COUNT_W = 4,
    parameter COUNT_TO = 4'D9
    )(
    input clk,
    input rst,
    input en,
    output reg [COUNT_W - 1:0] m,
    output reg shift_out
    );
    
    always @ (*)
        shift_out = m == COUNT_TO; 
        //When the given value is reached the shift outsignal is raised 
        //this can act as an enable signal as it will be lowered in the next clk edge
        
        
    always @ (posedge clk, posedge rst)
    begin
        if(rst)
            m <= {(COUNT_W){1'b0}};
        else
            if(en)
                if(shift_out)
                    m <= {(COUNT_W){1'b0}};
                else
                    m <= m + 1;
    end
endmodule
