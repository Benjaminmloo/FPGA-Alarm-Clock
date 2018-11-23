`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Banjamin Loo
// 
// Create Date: 11/15/2018 05:54:17 PM
// Design Name: 
// Module Name: top
// Project Name: Alarm Clock
// Target Devices: Nexys 4 DDR
// Tool Versions: 
// Description: top module for the design, connect all submodules to the hardware and each other.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top#(
    parameter tb = 0
    )(
    input   clk_100MHz,
    input   rst,
    input   en_alarm,
    input   btn_h_raw,
    input   btn_m_raw,
    input   set_time,
    input   set_alarm,
    output  [7:0] an,
    output  [7:0] seg,
    output  pm,
    output  alarm_en,
    output  alarm_on
    );
    wire [7:0]      p_pattern = 8'b1111_1011;
    wire [4 * 4:0]  d_rt, d_alarm, d_display;
    
    
    wire    clk_5MHz,
            btn_h_stb,
            btn_m_stb,
            en_1Hz,
            en_1_60Hz;

//////////////////////////////////////////////////////
//CLOCKS of various kinds
//////////////////////////////////////////////////////

    debounce debounce_up (
        .clk        (clk_5MHz),
        .rst        (rst),
        .d          (btn_h_raw),
        .q          (btn_h_stb)
        );
        
    debounce debounce_dn (
        .clk        (clk_5MHz),
        .rst        (rst),
        .d          (btn_m_raw),
        .q          (btn_m_stb)
        );

//////////////////////////////////////////////////////
//CLOCKS of various kinds
////////////////////////////////////////////////////// 
      
    if(!tb)
        clk_wiz_0 clk_wiz (
            .clk_in1    (clk_100MHz),
            .clk_out1   (clk_5MHz)        
        );
    else
        assign clk_5MHz = clk_100MHz;
    
    if(!tb)
        count_to #(24, 5_000_000) en_1Hz_count (
            .clk        (clk_5MHz),
            .rst        (rst),
            .en         (1'b1),
            .shift_out  (en_1Hz)
            );
    else
        count_to #(5, 20) en_1Hz_count (
            .clk        (clk_5MHz),
            .rst        (rst),
            .en         (1'b1),
            .shift_out  (en_1Hz)
            );
                
    count_to #(6, 59) count_seconds(
        .clk        (clk_5MHz),
        .rst        (rst | set_time),
        .en         (en_1Hz),
        .shift_out  (en_1_60Hz)
        );
                    
    clock_counter  rt_clock(
        .clk        (clk_5MHz),
        .rst        (rst),
        .en         (en_1_60Hz & en_1Hz),
        .set        (set_time),
        .btn_h      (btn_h_stb),
        .btn_m      (btn_m_stb),
        .d          (d_rt)
        );
                    
    clock_counter  alarm_reg(
        .clk        (clk_5MHz),
        .rst        (rst),
        .en         (1'b0),
        .set        (set_alarm),
        .btn_h      (btn_h_stb),
        .btn_m      (btn_m_stb),
        .d          (d_alarm)
        );

//////////////////////////////////////////////////////    
//LOGIC                                                 
////////////////////////////////////////////////////// 

master_controller mc(
    .d_rt           (d_rt),
    .d_alarm        (d_alarm),
    .en_alarm       (en_alarm),
    .set_alarm      (set_alarm),
    .alarm_on       (alarm_on),
    .alarm_en       (alarm_en)
    );

//////////////////////////////////////////////////////
//DISPLAY
////////////////////////////////////////////////////// 
        
    display_mux dm(
        .d_time     (d_rt),
        .d_alarm    (d_alarm),
        .s          (set_alarm),
        .q          (d_display)
        );
        
        assign pm = d_display[16];
        
    seg_driver #(4) sd(
        .clk        (clk_5MHz),
        .rst        (rst),
        .en         (1'b1),
        .bcd        (d_display[15:0]),
        .p          (p_pattern),
        .an         (an),
        .seg        (seg)        
        );
        
    alarm_driver ad(
        .clk(clk_5MHz),
        .rst(rst),
        .en(alarm_en),
        .alarm_on(alarm_on)
        );
        
endmodule
