`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2018 04:34:31 PM
// Design Name: 
// Module Name: timer_tb
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


module timer_tb(

    );
    
    reg     clk,
            rst,
            en,
            ld,
            start,
            btnu,
            btnd;
            
    wire [4*8 - 1:0] d;
    
    timer DUV (
        .clk        (clk),
        .rst        (rst),
        .en         (en),
        .ld_rq      (ld),
        .btn_min    (btnu),
        .btn_sec    (btnd),
        .d          (d),
        .trigger    (trigger)
        );
        
        
        initial
        begin
            clk = 0;
            rst = 0;
            en = 0;
            ld = 0;
            btnu = 0;
            btnd = 0;
            
            forever 
                #1 clk = ~clk;
        end
        
        initial
        begin
            #10 rst = 1;
            #10 rst = 0;
                        
            #10 btnu = 1;
            #10 btnu = 0;
            
            #10 btnd = 1;
            #10 btnd = 0;
            
            #10 en = 1;
            
            #10 btnu = 1;
            #10 btnu = 0;
            
            #10 btnd = 1;
            #10 btnd = 0;
            
            #20 ld = 1;
            
            #10 btnu = 1;
            #10 btnu = 0;
            
            #10 btnd = 1;
            #10 btnd = 0;
            
            #10 ld = 0;
                                    
            #10 btnu = 1;
            #10 btnu = 0;
            
                     
            #1000 btnu = 1;
            #10 btnu = 0;
            
        end
        
endmodule
