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
// Description: creates a pwm signal with the given duty cycle
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


module pwm_driver(
    input clk,
    input [10:0] duty_in,
    output reg pwm_out
    );
    
    reg [10:0] current_duty = 0;
    reg [10:0] pwm_ramp = 0;
    
    always @ (posedge clk)
    begin
        if(pwm_ramp == 0) current_duty <= duty_in;
        pwm_ramp <= pwm_ramp + 1'b1;
        pwm_out <= (current_duty < pwm_ramp);
    end
endmodule
