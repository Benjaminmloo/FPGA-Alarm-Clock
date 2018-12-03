`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/02/2018 10:47:53 PM
// Design Name: 
// Module Name: read_audio
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: Fill memory with audio and output
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

parameter CLK_FRQ = 100_000_000;
parameter SMP_RATE = 44_100;
parameter CLK_PER_SMP = CLK_FRQ / SMP_RATE;

module read_audio #(
    parameter BIT_WIDTH = 8
    )(
    input clk,
    input rst,
    input en,
    output[BIT_WIDTH - 1:0] audio
    );
    reg [BIT_WIDTH - 1:0] audio_data [2 ** BIT_WIDTH - 1:0];
       
    wire [BIT_WIDTH -1:0] addr;
    wire en_inc;
           
    count_to #(BIT_WIDTH, CLK_PER_SMP) inc_en(
            .clk(clk),
            .rst(rst),
            .en(en),
            .shift_out(en_inc)
            );
    
    count_to #(BIT_WIDTH, 2 ** BIT_WIDTH - 1) addr_inc(
        .clk(clk),
        .rst(rst),
        .en(en & en_inc),
        .m(addr)
        );
        
    assign audio = audio_data[addr];
    
    if(BIT_WIDTH == 16)
        initial $readmemh("music_16b.rom", audio_data);
    else
        initial $readmemh("music_8b.rom", audio_data);
    
endmodule
