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
    parameter AUDIO_FROM_FILE = 1,
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
    input   set_timer,
    input   audio_en,
    input   run_timer,
    input   run_on_sec,
    
    output  [7:0] an,
    output  [7:0] seg,
    output  [1:0] s,
    output  pm,
    output  alarm_en,
    output  alarm_on,
    output  alarm_led,
    output  audio_led,
    output  audio_pwm,
    output  audio_sd
    );
//////////////////////////////////////////////////////
//LOCAL PARAMETERS

////////////////////////////////////////////////////// 
    localparam DISPL_W = 4*8;
    localparam AUDIO_W = 8;
        
//////////////////////////////////////////////////////
//BUSSES
////////////////////////////////////////////////////// 
    wire clk_delim;
    wire [7:0]      p_pattern = {3'b111, clk_delim , 4'b1111};
    wire [5:0]      sec_reg;
    wire [DISPL_W - 1:0]  d_clk, d_alarm, d_display, d_timer;
    wire [AUDIO_W - 1:0] audio_data;
    //wire [1:0] s;
                
//////////////////////////////////////////////////////
//WIRES
////////////////////////////////////////////////////// 
    wire    clk_5MHz,
            btn_h_stb,
            btn_m_stb,
            en_1_60Hz,
            en_1Hz,
            en_2Hz,
            en_500Hz,
            en_20kHz
            ;

//////////////////////////////////////////////////////
//CLOCKS and COUNTERS of various kinds
////////////////////////////////////////////////////// 
      
    clk_wiz_0 clk_wiz (
        .clk_in1    (clk_100MHz),
        .clk_out1   (clk_5MHz)        
    );
    
    //raises enable signal every second
    count_to #(24, 4_999_999) en_1Hz_count (
        .clk        (clk_5MHz),
        .rst        (rst),
        .en         (1'b1),
        .shift_out  (en_1Hz)
        );
    
    //raises enable signal 20000 times second
    count_to #(13, 4_999) en_1kHz_count (
       .clk         (clk_5MHz),
       . rst        (rst),
       . en         (1'b1),
       . shift_out  (en_1kHz)
       ) ;
       
   //raises enable signal 20000 times second
    count_to #(9, 249) en_2Hz_count (
       .clk         (clk_5MHz),
       . rst        (rst),
       . en         (en_1kHz),
       . shift_out  (en_2Hz)
       ) ;
    
    //raises enable signal every minute           
    count_to #(6, 59) count_seconds(
        .clk        (clk_5MHz),
        .rst        (rst | set_time),
        .en         (en_1Hz),
        .m          (sec_reg),
        .shift_out  (en_1_60Hz)
        );
    
    //register bank for the real time clock                
    clock_counter  rt_clock(
        .clk        (clk_5MHz),
        .rst        (rst),
        .en         (en_1Hz & (run_on_sec | en_1_60Hz & ~run_on_sec)),// allows switching between second increment or minute 
        .set        (set_time),
        .btn_h      (btn_h_stb),
        .btn_m      (btn_m_stb),
        .d          (d_clk)
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
        
    //Register bank that stores the alarm time
    timer  timer_reg(
        .clk        (clk_5MHz),
        .rst        (rst),
        .en         (run_timer),
        .ld_rq      (set_timer),
        .btn_m      (btn_h_stb),
        .btn_s      (btn_m_stb),
        .d          (d_timer)
        );

//////////////////////////////////////////////////////    
//LOGIC                                                 
////////////////////////////////////////////////////// 
    assign clk_delim = sec_reg[0];
    //controller for the alarm
    master_controller mc(
        .clk        (clk_5MHz),
        .rst        (rst),
        .d_clk      (d_clk),
        .d_alarm    (d_alarm),
        .en_alarm   (en_alarm),
        .set_alarm  (set_alarm),
        .alarm_on   (alarm_on),
        .alarm_en   (alarm_en)
        );
        
    disp_mux_ctrl dmc(
        .set_alarm  (set_alarm),
        .set_timer  (set_timer),
        .run_timer  (run_timer),
        .s          (s)
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
    display_mux #(DISPL_W - 1) dm(
        .d_clk      (d_clk),
        .d_alarm    (d_alarm),
        .d_timer    (d_timer),
        .s          (s),
        .q          (d_display)
        );
    
    //Display if it is pm on an LED
    assign pm = d_display[28];
    
    //Drives the seven segment display with the current register bank data  
    seg_driver #(8) sd(
        .clk        (clk_5MHz),
        .rst        (rst),
        .en         (en_1kHz),
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
        
    generate
        if(AUDIO_FROM_FILE)
        begin:from_file
            read_audio #(AUDIO_W) ra (
                .clk        (clk_100MHz),
                .rst        (rst),
                .en         (audio_en | alarm_led),
                .audio      (audio_data)
                );
        end
        else
        begin:sqr_wave
            square_wave_gen swg(
                .clk        (clk_100MHz),
                .rst        (rst),
                .en         (audio_en | alarm_on), //Audio can be turned on with switch or with the alarm display signal
                .audio      (audio_data)
                );
        end
    endgenerate
    assign audio_led = audio_data [0];
    assign audio_sd = 1;
        
    //Drives pwm out put 
    pwm_driver #(AUDIO_W) pwm_d(
        .clk        (clk_100MHz),
        .rst        (rst),
        .duty_in    (audio_data),
        .pwm_out    (audio_pwm)
    );
    
endmodule
