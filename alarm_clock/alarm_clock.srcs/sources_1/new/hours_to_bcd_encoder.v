`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Benjamin Loo
// 
// Create Date: 11/15/2018 08:42:56 PM
// Design Name: 
// Module Name: hours_to_bcd_encoder
// Project Name: Alarm Clock
// Target Devices: Nexys 4 DDR
// Tool Versions: 
// Description: Encodes binary 24 hour values to 12 hour BCD values
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module hours_to_bcd_encoder(
    input [4:0] h,
    output reg [8:0] bcd
    );
    
    //create a LUT to convert the binary input to 3 BCD digits  
    //the input register count to 24 
    //the output digits are as follows
    //2: pm
    //1: h1
    //0: h0
    
    always @ * 
        case(h)
            5'b00000:bcd = 9'h001;
            5'b00001:bcd = 9'h002;
            5'b00010:bcd = 9'h003;
            5'b00011:bcd = 9'h004;
            5'b00100:bcd = 9'h005;
            5'b00101:bcd = 9'h006;
            5'b00110:bcd = 9'h007;
            5'b00111:bcd = 9'h008;
            5'b01000:bcd = 9'h009;
            5'b01001:bcd = 9'h010;
            5'b01010:bcd = 9'h011;
            5'b01011:bcd = 9'h112;
            5'b01100:bcd = 9'h101;
            5'b01101:bcd = 9'h102;
            5'b01110:bcd = 9'h103;
            5'b01111:bcd = 9'h104;
            5'b10000:bcd = 9'h105;
            5'b10001:bcd = 9'h106;
            5'b10010:bcd = 9'h107;
            5'b10011:bcd = 9'h108;
            5'b10100:bcd = 9'h109;
            5'b10101:bcd = 9'h110;
            5'b10110:bcd = 9'h111;
            5'b10111:bcd = 9'h012;
            default: bcd = 9'h000;
        endcase
endmodule
