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
// Description: creates a sequare wave
// can scan through frequencies
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module square_wave_gen #(
    parameter clk_freq = 100_000_000,
    parameter des_freq = 500
    )(
    input clk,
    input rst,
    input en,
    output reg [10:0] audio
    );
    localparam min_clks_to_edge = clk_freq /(2 * des_freq);
    reg new_edge;
    wire change_freq;
    wire [27:0] edge_period;
    reg [27:0] count;
    wire [27:0] current_period;
        
    count_to #(28, 10_000) pulse_10Hz( //count to when period should be changed
            .clk        (clk), 
            .rst        (rst), 
            .en         (en), 
            .shift_out  (change_freq)
        );
    
    count_to #(28, min_clks_to_edge)frequency( //register holding the current period modifier
        .clk        (clk), 
        .rst        (rst), 
        .en         (en & change_freq),
        .m          (edge_period),
        .shift_out  (new_frequency)
    );
    
    
    //when ever the wave counter indicates a new edge awitch the out put to create square wave
    always @ (posedge clk)
        if(rst)
            audio <= 0;
        else if(en & new_edge)
            audio <= ~audio;
            
     assign current_period = min_clks_to_edge;// edge_period + min_clks_to_edge;
     
    //pulses at the current period        
    always @ (*)
        new_edge = count == current_period;
    
    always @ (posedge clk, posedge rst)
    begin
        if(rst)
            count <= 28'b0;
        else
            if(en)
                if(new_edge)
                    count <= 28'b0;
                else
                    count <= count + 1;
    end
            
endmodule
