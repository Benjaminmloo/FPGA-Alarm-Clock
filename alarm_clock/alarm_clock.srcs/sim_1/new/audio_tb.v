`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2018 07:04:45 PM
// Design Name: 
// Module Name: audio_tb
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


module audio_tb(

    );
    reg clk;
    reg rst;
    reg audio_en;
    
    wire [10:0] audio_out;
    wire audio_pwm;
    
    square_wave_gen swg(
        .clk        (clk),
        .rst        (rst),
        .en         (audio_en),
        .audio      (audio_out)
        );
    
    pwm_driver pwm_d(
        .clk        (clk),
        .duty_in    (audio_out),
        .pwm_out    (audio_pwm)
        );
        
    initial
    begin
        clk = 0;
        rst = 0;
        audio_en = 0;
    end
    
    initial
    begin
        #10 audio_en = 1;
        rst = 1;
        #10 rst = 0;
               
    end
    
    always
        #1 clk = ~clk;
        
endmodule
