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
    
    reg    clk,
            rst,
            en,
            ld,
            start,
            btn_s,
            btn_m;
            
    wire [4*8 - 1:0] d;
    
    timer DUV (
        .clk        (clk),
        .rst        (rst),
        .en         (en),
        .ld_rq      (ld),
        .btn_s      (btn_s),
        .btn_m      (btn_m),
        .d          (d)
        );
        
        
        initial
        begin
            clk = 0;
            rst = 0;
            en = 0;
            ld = 0;
            btn_s = 0;
            btn_m = 0;
            
            forever 
                #5 clk = ~clk;
        end
        
        initial
        begin
            #10 rst = ~rst;
            #10 rst = ~rst;
            
            #10 en = 1;
            
            #10 btn_s = 1;
            #10 btn_s = 0;
            
            #10 btn_m = 1;
            #10 btn_m = 0;
            
            #10 en = 0;
            
            #10 btn_s = 1;
            #10 btn_s = 0;
            
            #10 btn_m = 1;
            #10 btn_m = 0;
            
            #10 ld = 1;
            
            #10 btn_s = 1;
            #30 btn_s = 0;
            
            #10 btn_m = 1;
            #30 btn_m = 0;
            
            #20 ld = 0;
            
            #10 btn_s = 1;
            #30 btn_s = 0;
            
            #10 btn_m = 1;
            #30 btn_m = 0;
            
            #10 en = 1;
                        
            #10 ld = 1;
            
            #10 btn_s = 1;
            #30 btn_s = 0;
            
            #10 btn_m = 1;
            #30 btn_m = 0;
            
            
            #20 ld = 0;
        end
        
endmodule
