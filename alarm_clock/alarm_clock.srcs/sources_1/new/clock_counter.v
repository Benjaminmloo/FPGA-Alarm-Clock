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
    output [4 * 4:0] d
    );
    
    wire [4:0] hours; 
    wire [3:0] minutes_0, minutes_1, hours_0, hours_1;
    wire [2:0] counter_en;
    
    wire rst_internal;
    wire pm;
    wire inc_m, inc_h;
    wire so_minute_0, so_minute_1;
    

//////////////////////////////////////////////////////
//COUNTERS
//////////////////////////////////////////////////////     
    sequential_enable #(3) counter_enable(
        .en_in({so_minute_1, so_minute_0, en & ~set | inc_m}),
        .en_out(counter_en)
        );

    //increment when enabled normally and not when in set mode
    
    count_to #(4, 9) count_minute_0(
        .clk        (clk),
        .rst        (rst),
        .en         (counter_en[0]), 
        .m          (minutes_0),
        .shift_out  (so_minute_0)
        );
    //Each subsequent counter enables the next on last digit
    count_to #(4, 5) count_minutes_1(
        .clk        (clk),
        .rst        (rst),
        .en         (counter_en[1]),
        .m          (minutes_1),
        .shift_out  (so_minute_1)
        );
        
    count_to #(5, 23) count_hours(
        .clk        (clk),
        .rst        (rst),
        .en         (counter_en[2] | inc_h),
        .m          (hours)
        
        );

//////////////////////////////////////////////////////
//INCREMENT SIGNALS DRIVERS
//////////////////////////////////////////////////////     
    
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
    hours_to_bcd_encoder bcd_encoder(
        .h          (hours),
        .bcd        ({pm, hours_1, hours_0})
        );
        
    assign d = {pm, hours_1, hours_0, minutes_1, minutes_0};
    
            
        
endmodule