`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Benjamin Loo
// 
// Create Date: 11/15/2018 06:07:48 PM
// Design Name: 
// Module Name: clock_counter
// Project Name: Alarm Clock
// Target Devices: Nexys 4 DDR
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

module clock_counter (
    input clk,
    input rst, 
    input en,
    input set,
    input btn_h,
    input btn_m,
    output [4 * 8 - 1:0] d
    );
    wire [7:0] display_header;
    wire [5:0] minutes;
    wire [4:0] hours; 
    wire [3:0] minutes_0, minutes_1, hours_0, hours_1;
    wire [1:0] counter_en;
    
    wire rst_internal;
    wire pm;
    wire inc_m, inc_h;
    wire so_minute;
    

//////////////////////////////////////////////////////
//COUNTERS
//////////////////////////////////////////////////////     
    sequential_enable #(2) counter_enable(
        .en_in({so_minute, en & ~set | inc_m}),
        .en_out(counter_en)
        );

    //increment when enabled normally and not when in set mode
    
    count_to #(6, 59) count_minute(
        .clk        (clk),
        .rst        (rst),
        .en         (counter_en[0]), 
        .m          (minutes),
        .shift_out  (so_minute)
        );
        
    count_to #(5, 23) count_hours(
        .clk        (clk),
        .rst        (rst),
        .en         (counter_en[1] | inc_h),
        .m          (hours)
        );

//////////////////////////////////////////////////////
//INCREMENT SIGNALS DRIVERS
//////////////////////////////////////////////////////     
    
    //logic for incrementing registers manually
    //They will increment only once per detected press of the button 
    
    increment_driver increment_minute(
        .clk        (clk),
        .rst        (rst),
        .en         (set),
        .d          (btn_m),
        .q          (inc_m)
        );
        
    increment_driver increment_hour(
        .clk        (clk),
        .rst        (rst),
        .en         (set),
        .d          (btn_h),
        .q          (inc_h)
        );

//////////////////////////////////////////////////////
//ENCODERS / OUTPUT
//////////////////////////////////////////////////////

    //Each encoder takes binary data encoding it into BCD to be displayed
               
    hours_to_bcd_encoder h_bcd_encoder(
        .h          (hours),
        .bcd        ({pm, hours_1, hours_0})
        );           
        
         
    mins_to_bcd_encoder m_bcd_encoder(
        .m          (minutes),
        .bcd        ({minutes_1, minutes_0})
        );
    
    //the diplay header includes a/p word for the msw the lsw just sets the digit off
    assign display_header = {3'b110, pm, 4'b1111};
        
    //the ouput of the register is in bcd to be displayed on a 7 segment display
    //the display format is as follows
    //{a/p, , h1, h0. m1, m0, , }
    assign d = {display_header, hours_1, hours_0, minutes_1, minutes_0, 8'b1111_1111};
    
            
        
endmodule