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
    parameter DATA_SET = 0, 
    //1 - LUT very short loop (my od man loop)
    //2 - BRAM 30s loop (matches)
    parameter tb = 0
    )(
    input clk,
    input rst,
    input en,
    output[BIT_W - 1:0] audio
    );
    
    localparam CLK_FRQ = 100_000_000;
    localparam SMP_RATE =   (DATA_SET == 1) ? 44_100:
                            (DATA_SET == 2) ? 16_000:
                            (DATA_SET == 3) ? 8_000:
                            8_000;
    
    localparam ADDR_W =     (DATA_SET == 1) ? 16:
                            (DATA_SET == 2) ? 19:
                            (DATA_SET == 3) ? 20:
                            32;
        
    localparam DCTR_W =     (DATA_SET == 1) ? 12:
                            (DATA_SET == 2) ? 13:
                            (DATA_SET == 2) ? 14:
                            14;
    
    localparam NUM_SMP =    (DATA_SET == 1) ? 2 ** 16:
                            (DATA_SET == 2) ? 284_304:
                            (DATA_SET == 3) ? 552_960:
                            2**16;
                            
    
    localparam CLK_PER_SMP = CLK_FRQ / SMP_RATE;
    
    wire [ADDR_W - 1:0] addr;
    wire en_inc;
        
    generate    
    if(tb)
    begin:test_data
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
    begin:real_data
        if(DATA_SET == 1)
        begin:LUT                
            if(BIT_W == 16)
            begin
                reg [BIT_W - 1:0] audio_data [NUM_SMP - 1:0];
                initial $readmemh("music_16b.rom", audio_data);
                assign audio = audio_data[addr];
            end
            else if(BIT_W == 8)
            begin
                reg [BIT_W - 1:0] audio_data [NUM_SMP - 1:0];
                initial $readmemh("music_8b_amp.rom", audio_data);
                assign audio = audio_data[addr];
            end
        end
        else if(DATA_SET == 2)
        begin:BRAM
            bram_matches matches_data (
                .clka(clk),    // input wire clka
                .ena(en),      // input wire ena
                .addra(addr),  // input wire [18 : 0] addra
                .douta(audio)  // output wire [7 : 0] douta
                );
        end
        else if(DATA_SET == 3)
        begin:BRAM
            bram_hey hey_data (
                .clka(clk),    // input wire clka
                .ena(en),      // input wire ena
                .addra(addr),  // input wire [18 : 0] addra
                .douta(audio)  // output wire [7 : 0] douta
                );
        end
        else
        begin:test
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
           
    
    
    count_to #(DCTR_W, CLK_PER_SMP) dctr(
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
