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
    
    reg [AUDIO_W - 1:0] audio_data [2 ** AUDIO_W - 1:0];
           
    
    read_audio #(AUDIO_W, 0) ra(
        .clk        (clk),
        .rst        (rst),
        .en         (audio_en),
        .audio      (audio_out)
        );
    
    pwm_driver #(AUDIO_W) pwm_d(
        .clk        (clk),
        .duty_in    (audio_out),
        .pwm_out    (audio_pwm)
        );
        
    initial
    begin
        $readmemh("music_8b_amp.rom", audio_data);
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
