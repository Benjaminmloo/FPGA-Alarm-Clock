`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/05/2018 10:49:21 AM
// Design Name: 
// Module Name: timer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Counts down from set value
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module timer(
    input clk,
    input rst, 
    input en,
    input ld_rq,
    input btn_sec,
    input btn_min,
    input start,
    
    output [4 * 8 - 1:0] d,
    output trigger
    );
    
    localparam DIGIT_CNTR_W  = 4;
    localparam SEC_CNTR_W  = 6;
    localparam MIN_CNTR_W  = 6;
    
    localparam MSEC_RST_M  = 0;
    localparam MSEC_MAX_M  = 9;
    
    
    genvar i;
       
    wire [1:0]                  reg_ini_en;
    wire [1:0]                  reg_ini_so;
    
    wire [4:0]                  reg_dec_cnt;
    wire [4:0]                  reg_dec_empty;
    

    wire [SEC_CNTR_W - 1:0]     ld_sec_m;
    wire [MIN_CNTR_W - 1:0]     ld_min_m;
    
    wire [DIGIT_CNTR_W - 1:0]   msec_m [2:0];
    wire [SEC_CNTR_W - 1:0]     sec_m;
    wire [MIN_CNTR_W - 1:0]     min_m;

    wire [SEC_CNTR_W - 1:0]     ini_sec_m;
    wire [MIN_CNTR_W - 1:0]     ini_min_m;
    
    wire [7:0]                  min_bcd, 
                                sec_bcd;
    
    wire    en_1kHz, 
            inc_sec, 
            inc_min, 
            ld, 
            count_en,
            done;
    
//////////////////////////////////////////////////////
//COUNTER LOGIC
//////////////////////////////////////////////////////  

    assign done =  ~|{min_m, sec_m, msec_m[2], msec_m[1], msec_m[0]}; //done high when all values are 0
    
    timer_control tc(
        .clk        (clk),
        .rst        (rst),
        .en         (en),
        .start      (start),
        .ld_rq      (ld_rq),
        .done       (done),
        
        .count_en   (count_en),
        .ld         (ld),
        .trigger    (trigger)
        );
            
    assign reg_ini_en = {inc_min & ld, inc_sec & ld};
                            
                            
    count_to #(13, 5_000) en_1kHz_count(
        .clk        (clk),
        .rst        (rst),
        .en         (en),
        
        .shift_out  (en_1kHz)
        );
        
    dec_en #(5) de(
        .empty      (reg_dec_empty),
        .en         (en_1kHz & count_en),
        
        .dec        (reg_dec_cnt)
        ); 
        
    
//////////////////////////////////////////////////////
//INCREMENT SIGNALS DRIVERS
//////////////////////////////////////////////////////     
    
    //logic for incrementing registers manually
    //They will increment only once per detected press of the button 
    
    increment_driver increment_sec(
        .clk        (clk),
        .rst        (rst),
        .en         (ld),
        .d          (btn_sec),
        
        .q          (inc_sec)
        );
        
    increment_driver increment_min(
        .clk        (clk),
        .rst        (rst),
        .en         (ld),
        .d          (btn_min),
        
        .q          (inc_min)
        );
        
//////////////////////////////////////////////////////
//COUNT DOWN REGISTERS
////////////////////////////////////////////////////// 

    count_from #(DIGIT_CNTR_W, MSEC_MAX_M) dec_msec_0(
        .clk        (clk),
        .rst        (rst),
        .dec        (reg_dec_cnt[0]),
        .ld         (ld),
        .ld_m       (MSEC_RST_M),
        
        .m          (msec_m[0]),
        .empty      (reg_dec_empty[0])
        ); 
        
    count_from #(DIGIT_CNTR_W, MSEC_MAX_M) dec_msec_1(
        .clk        (clk),
        .rst        (rst),
        .dec        (reg_dec_cnt[1]),
        .ld         (ld),
        .ld_m       (MSEC_RST_M),
        
        .m          (msec_m[1]),
        .empty      (reg_dec_empty[1])
        ); 
        
    count_from #(DIGIT_CNTR_W, MSEC_MAX_M) dec_msec_2(
        .clk        (clk),
        .rst        (rst),
        .dec        (reg_dec_cnt[2]),
        .ld         (ld),
        .ld_m       (MSEC_RST_M),
        
        .m          (msec_m[2]),
        .empty      (reg_dec_empty[2])
        );
    
    count_from #(SEC_CNTR_W, 59) dec_sec(
        .clk        (clk),
        .rst        (rst),
        .dec        (reg_dec_cnt[3]), 
        .ld         (ld),
        .ld_m       (ini_sec_m),
        .m          (sec_m),
        .empty      (reg_dec_empty[3])
        );
        
    count_from #(MIN_CNTR_W, 59) dec_min(
        .clk        (clk),
        .rst        (rst),
        .dec        (reg_dec_cnt[4]),
        .ld         (ld),
        .ld_m       (ini_min_m),
        .m          (min_m),
        .empty      (reg_dec_empty[4])
        );


//////////////////////////////////////////////////////
//SET REGISTERS
//////////////////////////////////////////////////////  
    
    count_to #(SEC_CNTR_W, 59) ini_reg_sec(
        .clk        (clk),
        .rst        (rst),
        .en         (reg_ini_en[0]), 
        .m          (ini_sec_m),
        .shift_out  (reg_ini_so[0])
        );
            
    count_to #(MIN_CNTR_W, 59) ini_reg_min(
        .clk        (clk),
        .rst        (rst),
        .en         (reg_ini_en[1]), 
        .m          (ini_min_m),
        .shift_out  (reg_ini_so[1])
        );
        
        
//////////////////////////////////////////////////////
//ENCODERS / OUTPUT
//////////////////////////////////////////////////////

    //Each encoder takes binary data encoding it into BCD to be displayed
    mins_to_bcd_encoder s_bcd_encoder(
        .m          (sec_m),
        .bcd        (sec_bcd)
        );
               
    mins_to_bcd_encoder m_bcd_encoder(
        .m          (min_m),
        .bcd        (min_bcd)
        );   
        
    
    assign d = {4'b1111, min_bcd, sec_bcd, msec_m[2], msec_m[1], msec_m[0]};
            
endmodule