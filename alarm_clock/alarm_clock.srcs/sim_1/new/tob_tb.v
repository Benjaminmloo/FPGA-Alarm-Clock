`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2018 06:17:46 PM
// Design Name: 
// Module Name: tob_tb
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


module tob_tb(

    );
    reg clk, rst, en, btn_h, btn_m, set_time, set_alarm;
    
    wire [7:0] an, seg;
    wire pm, a_en, a_on;
    
    top #(1)DUV (
        .clk_100MHz (clk),
        .rst        (rst),       
        .en_alarm   (en),  
        .btn_h_raw  (btn_h), 
        .btn_m_raw  (btn_m), 
        .set_time   (set_time),  
        .set_alarm  (set_alarm), 
        .an         (an),  
        .seg        (seg), 
        .pm         (pm),        
        .alarm_en   (a_en),  
        .alarm_on   (a_on)   
    );
    
    initial
    begin
        clk = 0;
        rst = 0;
        en = 0;
        btn_h = 0;
        btn_m = 0;
        set_time = 0;
        set_alarm = 0;
        
        forever
            #1 clk = ~clk;
    end
    
    initial
    begin
        #1 rst = 1;
        #1 rst = 0;
    end
endmodule
