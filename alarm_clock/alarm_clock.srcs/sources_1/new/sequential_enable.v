`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/22/2018 09:21:12 PM
// Design Name: 
// Module Name: sequential_enable
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// broadly and's each subsequent enable signal with the last 
// so that out[i] = in[i] & ... & in[0]

// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module sequential_enable #(
    parameter NUM_EN = 1
    )(
    input [NUM_EN - 1:0] en_in,
    output [NUM_EN - 1:0] en_out
    );
    genvar i;
    assign en_out[0] = en_in[0];
    
    //for each output after the first
    //and the in[i] with the out[i - 1]
    
    for(i = 1; i < NUM_EN; i = i + 1)
    begin
        assign en_out[i] = en_out[i - 1] & en_in[i];
    end
endmodule
