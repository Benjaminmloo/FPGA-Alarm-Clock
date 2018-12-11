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
    localparam AUDIO_W = 8;
    reg clk;
    reg rst;
    reg audio_en;
    
    wire [AUDIO_W - 1:0] audio_out;
    wire audio_pwm;
    wire [8:0] led_audio_meter;
               
    
    read_audio #(AUDIO_W, 2,  0) ra(
        .clk        (clk),
        .rst        (rst),
        .en         (audio_en),
        .audio      (audio_out)
        );
    
    pwm_driver #(AUDIO_W) pwm_d(
        .clk        (clk),
        .duty_in    (audio_out),
        .audio_out    (audio_pwm)
        );
        
    led_driver led_d(
        .clk        (clk),
        .rst        (rst),
        .audio_data (audio_out),
        .led_out    (led_audio_meter)
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
