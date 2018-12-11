`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2018 04:59:46 PM
// Design Name: 
// Module Name: led_driver
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


module led_driver(
    input   [7:0] audio_data,
    
    output  [7:0] led_out
    );
  
    
      
    assign led_out [0] = audio_data > 32  ? 1'b1:1'b0;
    assign led_out [1] = audio_data > 64  ? 1'b1:1'b0;
    assign led_out [2] = audio_data > 96  ? 1'b1:1'b0;
    assign led_out [3] = audio_data > 128  ? 1'b1:1'b0;
    assign led_out [4] = audio_data > 150  ? 1'b1:1'b0;
    assign led_out [5] = audio_data > 182  ? 1'b1:1'b0;
    assign led_out [6] = audio_data > 214  ? 1'b1:1'b0;
    assign led_out [7] = audio_data == 250  ? 1'b1:1'b0;
        
endmodule
