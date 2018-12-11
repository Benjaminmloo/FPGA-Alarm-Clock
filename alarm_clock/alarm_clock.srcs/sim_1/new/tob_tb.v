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
    reg clk, rst, en, btnu, btnd, btnl, btnr;
    
    wire [7:0] an, seg;
    wire pm, a_en, a_on;
    
    top #(1, 20, 5)DUV (
        .clk_100MHz (clk),
        .rst        (rst),       
        .en_alarm   (en),  
        .btnu_raw  (btnu), 
        .btnd_raw  (btnd), 
        .btnl   (btnl),  
        .btnr  (btnr), 
        .audio_en   (audio_en),  
        .run_on_sec (run_on_sec), 
        
        .an         (an),  
        .seg        (seg), 
        .pm         (pm),        
        .alarm_en   (a_en),  
        .alarm_led   (a_led)   
    );
    
    initial
    begin
        clk = 0;
        rst = 0;
        en = 0;
        btnu = 0;
        btnd = 0;
        btnl = 0;
        btnr = 0;
        
        forever
            #10 clk = ~clk;
    end
    
    initial
    begin
        #1 rst = 1;
        #1 rst = 0;
    end
    
    initial
    begin
        #20_000 btnl = 1; 
        #5 btnu = 1; 
        #5 btnu = 0; 
        #100 btnu = 1; 
        #100 btnu = 0; 
        #100 btnu = 1; 
        #100 btnu = 0; 
        #100 btnu = 1; 
        #100 btnu = 0;
        
        #5 btnd = 1; 
        #5 btnd = 0; 
        #100 btnd = 1; 
        #100 btnd = 0; 
        #100 btnd = 1; 
        #100 btnd = 0; 
        #100 btnd = 1; 
        #100 btnd = 0;
        
        #100 btnl = 0;
        
        #100 en = 1; 
        
        #200 btnr = 1; 
        #5 btnu = 1; 
        #5 btnu = 0; 
        #100 btnu = 1; 
        #100 btnu = 0; 
        #100 btnu = 1; 
        #100 btnu = 0; 
        #100 btnu = 1; 
        #100 btnu = 0;
        
        #5 btnd = 1; 
        #5 btnd = 0; 
        #100 btnd = 1; 
        #100 btnd = 0; 
        #100 btnd = 1; 
        #100 btnd = 0; 
        #100 btnd = 1; 
        #100 btnd = 0;
        #100 btnd = 1; 
        #100 btnd = 0; 
        #100 btnd = 1; 
        #100 btnd = 0; 
        #100 btnd = 1; 
        #100 btnd = 0;
        #100 btnd = 1; 
        #100 btnd = 0; 
        #100 btnd = 1; 
        #100 btnd = 0; 
        #100 btnd = 1; 
        #100 btnd = 0;
        #100 btnd = 1; 
        #100 btnd = 0; 
        #100 btnd = 1; 
        #100 btnd = 0; 
        #100 btnd = 1; 
        #100 btnd = 0;
        #100 btnd = 1; 
        #100 btnd = 0;
        
        #100 btnr = 0;
    end
endmodule
