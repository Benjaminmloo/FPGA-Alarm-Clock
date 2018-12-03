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
    parameter tb = 0,
    parameter DEBOUNCE_CYCLES = 50_000,
    parameter DEBOUNCE_BITS = 16
    )(
    input   clk_100MHz,
    input   rst,
    input   en_alarm,
    input   btn_h_raw,
    input   btn_m_raw,
    input   set_time,
    input   set_alarm,
    input   audio_en,
    
    output  [7:0] an,
    output  [7:0] seg,
    output  pm,
    output  alarm_en,
    output  alarm_on,
    output  alarm_led,
    output  [10:0] audio_out,
    output  audio_pwm
    );
//////////////////////////////////////////////////////
//LOCAL PARAMETERS

////////////////////////////////////////////////////// 
    parameter DISP_W = 4*8 - 1;
        
//////////////////////////////////////////////////////
//BUSSES
////////////////////////////////////////////////////// 
    wire [7:0]      p_pattern = 8'b1110_1111;
    wire [DISP_W:0]  d_rt, d_alarm, d_display;
                
//////////////////////////////////////////////////////
//WIRES
////////////////////////////////////////////////////// 
    wire    clk_5MHz,
            btn_h_stb,
            btn_m_stb,
            en_500Hz,
            en_1Hz,
            en_1_60Hz;

//////////////////////////////////////////////////////
//CLOCKS and COUNTERS of various kinds
////////////////////////////////////////////////////// 
      
    clk_wiz_0 clk_wiz (
        .clk_in1    (clk_100MHz),
        .clk_out1   (clk_5MHz)        
    );
    
    //raises enable signal every second
    count_to #(24, 5_000_000) en_1Hz_count (
        .clk        (clk_5MHz),
        .rst        (rst),
        .en         (1'b1),
        .shift_out  (en_1Hz)
        );
    
    //raises enable signal 1000 times second
    count_to #(14, 5_000) en_1KHz_count (
       .clk         (clk_5MHz),
       . rst        (rst),
       . en         (1'b1),
       . shift_out  (en_500Hz)
       ) ;
    
    //raises enable signal every minute           
    count_to #(6, 59) count_seconds(
        .clk        (clk_5MHz),
        .rst        (rst | set_time),
        .en         (en_1Hz),
        .shift_out  (en_1_60Hz)
        );
    
    //register bank for the real time clock                
    clock_counter  rt_clock(
        .clk        (clk_5MHz),
        .rst        (rst),
        .en         (en_1Hz & ~set_alarm),// & en_1_60Hz ),
        .set        (set_time),
        .btn_h      (btn_h_stb),
        .btn_m      (btn_m_stb),
        .d          (d_rt)
        );
    
    //Register bank that stores the alarm time
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
    
    //controller for the alarm
    master_controller mc(
        .clk        (clk_5MHz),
        .rst        (rst),
        .d_rt       (d_rt),
        .d_alarm    (d_alarm),
        .en_alarm   (en_alarm),
        .set_alarm  (set_alarm),
        .alarm_on   (alarm_on),
        .alarm_en   (alarm_en)
        );
    
    //bouncers for butons used to increment registers
    debounce #(DEBOUNCE_BITS, DEBOUNCE_CYCLES)
        debounce_up (
        .clk        (clk_5MHz),
        .rst        (rst),
        .d          (btn_h_raw),
        .q          (btn_h_stb)
        );
        
    debounce #(DEBOUNCE_BITS, DEBOUNCE_CYCLES)
        debounce_dn (
        .clk        (clk_5MHz),
        .rst        (rst),
        .d          (btn_m_raw),
        .q          (btn_m_stb)
        );
//////////////////////////////////////////////////////
//DISPLAY
////////////////////////////////////////////////////// 
    //mux to dchoose which register bank to display
    display_mux #(DISP_W) dm(
        .d_time     (d_rt),
        .d_alarm    (d_alarm),
        .s          (set_alarm),
        .q          (d_display)
        );
    
    //Display if it is pm on an LED
    assign pm = d_display[28];
    
    //Drives the seven segment display with the current register bank data  
    seg_driver #(8) sd(
        .clk        (clk_5MHz),
        .rst        (rst),
        .en         (en_500Hz),
        .bcd        (d_display),
        .p          (p_pattern),
        .an         (an),
        .seg        (seg)        
        );
    
    //Drives the Alarm out put (raises LED high and low when alarm is triggered)
    alarm_driver ad(
        .clk        (clk_5MHz),
        .rst        (rst),
        .en         (alarm_on),
        .switch_edge(en_1Hz),
        .alarm_on   (alarm_led)
        );
        
    read_audio #(16) ra (
        .clk(clk_100MHz),
        .rst(rst),
        .en(audio_en | alarm_led),
        .audio(audio_out)
        );
    
    //Generates a square wave signal for the pwm driver
    /*square_wave_gen swg(
        .clk        (clk_100MHz),
        .rst        (rst),
        .en         (audio_en | alarm_led), //Audio can be turned on with switch or with the alarm display signal
        .audio      (audio_out)
        );*/
        
    //Drives pwm out put 
    pwm_driver pwm_d(
        .clk        (clk_100MHz),
        .duty_in    (audio_out),
        .pwm_out    (audio_pwm)
    );
    
endmodule
