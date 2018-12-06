`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2018 01:19:48 PM
// Design Name: 
// Module Name: dec_en
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


module dec_en #(
    parameter NUM_DIGITS  = 3
    )(
        input [NUM_DIGITS - 1:0] empty,
        input en,
        input ld,
        output [NUM_DIGITS - 1:0] dec
    );
    
    genvar i;
    
    assign dec[0] = ~&empty[NUM_DIGITS - 1:0] & en & ~ld;
    
    for(i = 1; i < NUM_DIGITS; i = i +1)
    begin
        assign dec[i] = ~&empty[NUM_DIGITS - 1:i] & empty[i - 1] & dec[i - 1] & en & ~ld;
    end
endmodule
