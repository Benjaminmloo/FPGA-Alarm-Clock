`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2018 06:59:52 PM
// Design Name: 
// Module Name: pwm_module
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: creates a pwm signal with the duty cyclegiven by 10bit binary input
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// based on digilents design from music looper demo project
// frequency of the duty is dependeant on input clock
// uses 10 bit counter so it takes  2^10 clock edges for every pwm cylcle
// with 100Mhz clk PWM will run just under 100KHz
//////////////////////////////////////////////////////////////////////////////////


module pwm_driver#(
    parameter AUDIO_W = 8
    )(
    input clk,
    input rst,
    input [AUDIO_W - 1:0] duty_in,
    output reg pwm_out
    );
    
    reg [AUDIO_W - 1:0] current_duty = 0;
    reg [AUDIO_W - 1:0] pwm_ramp = 0;
    
    always @ (posedge clk, posedge rst)
    begin
        if(rst)
            pwm_ramp <= 0;
        else
        begin
            //if new cycle reset the duty
            if(pwm_ramp == 0) current_duty <= duty_in;
            
            //increment cycle #    
            pwm_ramp <= pwm_ramp + 1'b1;
            
            //if the cycle # is less than the duty raise the output 
            pwm_out <= (current_duty < pwm_ramp);
        end
    end
endmodule
