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

module read_audio #(
    parameter BIT_W = 8,
    parameter tb = 0
    )(
    input clk,
    input rst,
    input en,
    output[BIT_W - 1:0] audio
    );
    
    localparam CLK_FRQ = 100_000_000;
    localparam SMP_RATE = 44_100;
    localparam CLK_PER_SMP = CLK_FRQ / SMP_RATE;
    
    localparam ADDR_W = 16;
    localparam NUM_SMP = 2 ** ADDR_W;
    
    wire [ADDR_W - 1:0] addr;
    wire en_inc;
        
    generate    
    if(tb)
    begin
        wire [BIT_W - 1:0] audio_data [15:0];
        
        assign audio_data[0] =  {16'h0000};
        assign audio_data[1] =  {16'h1111};
        assign audio_data[2] =  {16'h2222};
        assign audio_data[3] =  {16'h3333};
        assign audio_data[4] =  {16'h4444};
        assign audio_data[5] =  {16'h5555};
        assign audio_data[6] =  {16'h6666};
        assign audio_data[7] =  {16'h7777};
        assign audio_data[8] =  {16'h8888};
        assign audio_data[9] =  {16'h9999};
        assign audio_data[10] =  {16'hAAAA};
        assign audio_data[11] =  {16'hBBBB};
        assign audio_data[12] =  {16'hCCCC};
        assign audio_data[13] =  {16'hDDDD};
        assign audio_data[14] =  {16'hEEEE};
        assign audio_data[15] =  {16'hFFFF};
        
        assign audio = audio_data[addr[3:0]];
    end
    else
    begin                
        if(BIT_W == 16)
        begin
            reg [BIT_W - 1:0] audio_data [NUM_SMP - 1:0];
            initial $readmemh("music_16b.rom", audio_data);
            assign audio = audio_data[addr];
        end
        else if(BIT_W == 8)
        begin
            reg [BIT_W - 1:0] audio_data [NUM_SMP - 1:0];
            initial $readmemh("music_8b.rom", audio_data);
            assign audio = audio_data[addr];
        end
        else
        begin
            wire [BIT_W - 1:0] audio_data [15:0];
            
            assign audio_data[0] =  {16'h0000};
            assign audio_data[1] =  {16'h1111};
            assign audio_data[2] =  {16'h2222};
            assign audio_data[3] =  {16'h3333};
            assign audio_data[4] =  {16'h4444};
            assign audio_data[5] =  {16'h5555};
            assign audio_data[6] =  {16'h6666};
            assign audio_data[7] =  {16'h7777};
            assign audio_data[8] =  {16'h8888};
            assign audio_data[9] =  {16'h9999};
            assign audio_data[10] =  {16'hAAAA};
            assign audio_data[11] =  {16'hBBBB};
            assign audio_data[12] =  {16'hCCCC};
            assign audio_data[13] =  {16'hDDDD};
            assign audio_data[14] =  {16'hEEEE};
            assign audio_data[15] =  {16'hFFFF};
            
            assign audio = audio_data[addr[3:0]];
        end
    end
    endgenerate       
           
    
    
    count_to #(12, CLK_PER_SMP) inc_en(
            .clk(clk),
            .rst(rst),
            .en(en),
            .shift_out(en_inc)
            );
    
    count_to #(ADDR_W, NUM_SMP - 1) addr_inc(
        .clk(clk),
        .rst(rst),
        .en(en & en_inc),
        .m(addr)
        );
        
  
        
    
endmodule
