`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2018 05:37:23 PM
// Design Name: 
// Module Name: wave_gen
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


module square_wave_gen #(
    parameter clk_freq = 100_000_000,
    parameter des_freq = 5_000
    )(
    input clk,
    input rst,
    input en,
    output reg [10:0] audio
    );
    localparam min_edge_period = clk_freq /(2 * des_freq);
    reg new_edge;
    wire change_freq;
    wire [27:0] edge_period;
    reg [27:0] count;
    wire [27:0] current_period;
        
    count_to #(28, 10_000) pulse_10Hz( //pulse every 10 HZ
            .clk        (clk), 
            .rst        (rst), 
            .en         (en), 
            .shift_out  (change_freq)
        );
    
    count_to #(28, min_edge_period)frequency( //puslse incrementing frequency every tenth of a second
        .clk        (clk), 
        .rst        (rst), 
        .en         (en & change_freq),
        .m          (edge_period),
        .shift_out  (new_frequency)
    );
    
    
    //square wave at given period
    always @ (posedge clk)
        if(rst)
            audio = 0;
        else if(en & new_edge)
            audio = ~audio;
            
     assign current_period = edge_period + min_edge_period;
    //pulses at the current period        
    always @ (*)
        new_edge = count == current_period;
    
    always @ (posedge clk, posedge rst)
    begin
        if(rst)
            count = 28'b0;
        else
            if(en)
                if(new_edge)
                    count = 28'b0;
                else
                    count = count + 1;
    end
            
endmodule
