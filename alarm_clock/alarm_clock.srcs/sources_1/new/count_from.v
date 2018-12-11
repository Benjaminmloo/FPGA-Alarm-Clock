`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2018 10:49:21 AM
// Design Name: 
// Module Name: count_from
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


module count_from
    #(
    parameter COUNT_W = 4,
    parameter MAX_VAL = 15
    )(
    input clk,
    input rst,
    input dec,
    input ld,
    input [COUNT_W -1:0] ld_m,
    output reg [COUNT_W - 1:0] m,
    output reg empty
    );
    
    always @ (*)
        empty = &(~m); 
        //When the given value is reached the shift outsignal is raised 
        //this can act as an enable signal as it will be lowered in the next clk edge
        
        
    always @ (posedge clk, posedge rst, posedge ld)
    begin
        if(rst)
            m <= {(COUNT_W){1'b0}};
        else if(ld)
            m <= ld_m;
        else
            if(dec)
                if(empty)
                    m <= MAX_VAL;
                else
                    m <= m - 1;
           
            
    end
endmodule
