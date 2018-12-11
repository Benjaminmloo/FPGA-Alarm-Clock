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
    parameter AUDIO_S = 4,
    parameter USE_PDM = 1,
    parameter DEBOUNCE_CYCLES = 50_000,
    parameter DEBOUNCE_BITS = 16
    )(
    input   clk_100MHz,
    input   rst,
    input   en_alarm,
    input   btnu_raw,
    input   btnd_raw,
    input   btnl,
    input   btnr,
    input   btnc,
    input   audio_en,
    input   timer_en,
    input   run_timer,
    input   run_on_sec,
    
    output  [7:0] an,
    output  [7:0] seg,
    output  audio_out,
    output  audio_sd,
    output  [15:0] led_audio_meter
    );
//////////////////////////////////////////////////////
//LOCAL PARAMETERS

////////////////////////////////////////////////////// 
    localparam DISPL_W = 4*8;
    localparam AUDIO_W = 8;
    
    genvar i;
        
//////////////////////////////////////////////////////
//BUSSES
////////////////////////////////////////////////////// 
    wire clk_delim;
    wire [7:0]              p_display;
    wire [5:0]              sec_reg;
    wire [DISPL_W - 1:0]    d_clk, 
                            d_alarm, 
                            d_display, 
                            d_timer;
                            
    wire [AUDIO_W - 1:0]    audio_data;
    wire [1:0]              s;
                
//////////////////////////////////////////////////////
//WIRES
////////////////////////////////////////////////////// 
    wire    clk_5MHz,
            btnu_stb,
            btnd_stb,
            en_1_60Hz,
            en_1Hz,
            en_500Hz,
            en_1kHz,
            en_20kHz,
            timer_trig,
            time_alarm_on,
            timer_alarm_on,
            alarm_on
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
         
    //raises enable signal every minute           
    count_to #(6, 59) count_seconds(
        .clk        (clk_5MHz),
        .rst        (rst | btnl),
        .en         (en_1Hz),
        .m          (sec_reg),
        .shift_out  (en_1_60Hz)
        );
    
    //register bank for the real time clock                
    clock_counter  rt_clock(
        .clk        (clk_5MHz),
        .rst        (rst),
        .en         (en_1Hz & (run_on_sec | en_1_60Hz & ~run_on_sec)),// allows switching between second increment or minute 
        .set        (btnl),
        .btn_hr     (btnu_stb),
        .btn_mn     (btnd_stb),
        .d          (d_clk)
        );
    
    //Register bank that stores the alarm time
    clock_counter  alarm_reg(
        .clk        (clk_5MHz),
        .rst        (rst),
        .en         (1'b0),
        .set        (btnr),
        .btn_hr     (btnu_stb),
        .btn_mn     (btnd_stb),
        .d          (d_alarm)
        );
        
    //Register bank that stores the alarm time
    timer  t(
        .clk        (clk_5MHz),
        .rst        (rst),
        .en         (timer_en),
        .ld_rq      (btnc),
        .btn_min    (btnu_stb),
        .btn_sec    (btnd_stb),
        .start      (run_timer),
        
        .d          (d_timer),
        .trigger    (timer_trig)
        );

        
//////////////////////////////////////////////////////    
//LOGIC                                                 
////////////////////////////////////////////////////// 
    //controller for the alarm
    alarm_controller time_alarm(
        .clk        (clk_5MHz),
        .rst        (rst),
        .en         (en_alarm & ~btnr),
        .trigger    (d_clk == d_alarm),
        .alarm_on   (time_alarm_on)
        );
                
    assign alarm_on = time_alarm_on | timer_trig; // alarm turn on if any possible alarm is set off. 
        
    disp_mux_ctrl dmc(
        .clk        (clk_5MHz),
        .rst        (rst),
        .set_time   (btnl),
        .set_alarm  (btnr),
        .timer_en   (timer_en),
        .s          (s)
        );
    
    //bouncers for butons used to increment registers
    debounce #(DEBOUNCE_BITS, DEBOUNCE_CYCLES)
        debounce_up (
        .clk        (clk_5MHz),
        .rst        (rst),
        .d          (btnu_raw),
        .q          (btnu_stb)
        );
        
    debounce #(DEBOUNCE_BITS, DEBOUNCE_CYCLES)
        debounce_dn (
        .clk        (clk_5MHz),
        .rst        (rst),
        .d          (btnd_raw),
        .q          (btnd_stb)
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
        .blink      (sec_reg[0]),
        .d          (d_display),
        .p          (p_display)            
        );
        
    led_driver led_d(
        .audio_data (audio_data),
        .led_out    (led_audio_meter[15:8])
        );
        
    for(i = 0; i < 8; i = i + 1)
    begin:repeat_leds
         assign led_audio_meter[i] = led_audio_meter [15 - i];
    end
    
    //Drives the seven segment display with the current register bank data  
    seg_driver #(8) sd(
        .clk        (clk_5MHz),
        .rst        (rst),
        .en         (en_1kHz),
        .bcd        (d_display),
        .p          (p_display),
        .an         (an),
        .seg        (seg)        
        );
            
    generate
        if(AUDIO_FROM_FILE)
        begin:from_file
            read_audio #(AUDIO_W, AUDIO_S, 0) ra (
                .clk        (clk_100MHz),
                .rst        (rst),
                .en         (audio_en | alarm_on),
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
    
    assign audio_sd = 1;
    
    generate
        if(USE_PDM)
        begin:pdm
            //Drives pwm out put 
            pdm_driver #(AUDIO_W) pdm_d(
                .clk            (clk_100MHz),
                .rst            (rst),
                .duty_in        (audio_data),
                .audio_out      (audio_out)
                );
        end
        else
        begin:pwm
            //Drives pwm out put 
            pwm_driver #(AUDIO_W) pwm_d(
                .clk            (clk_100MHz),
                .rst            (rst),
                .duty_in        (audio_data),
                .audio_out      (audio_out)
                );
        end
    endgenerate
    
endmodule
