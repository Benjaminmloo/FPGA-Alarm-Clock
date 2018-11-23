`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Benjamin Loo
// 
// Create Date: 11/15/2018 06:07:48 PM
// Design Name: 
// Module Name: seg_driver
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

module seg_driver #(
    parameter NUM_SEG = 8
    )(
    input clk,
    input rst,
    input en,
    input [4 * NUM_SEG - 1:0] bcd,
    input [7:0] p,
    output reg [7:0] an,
    output reg [7:0] seg
    );
    
    reg [3:0] count;
    wire [3:0] bcd_array [NUM_SEG - 1:0];
    genvar i;
        
    for(i = 0; i < NUM_SEG; i = i + 1)
    begin:digit
        assign bcd_array[i] = bcd[4*i +: 4];
    end
    
    always @ (posedge clk, posedge rst)
    if(rst)
        count <= 0; 
    else if(count == NUM_SEG - 1)
        count <= 0;
    else
        count <= count + en;
    
    always @ (count)
    case(count)
        4'b0000:an = 8'b11111110;
        4'b0001:an = 8'b11111101;
        4'b0010:an = 8'b11111011;
        4'b0011:an = 8'b11110111;
        4'b0100:an = 8'b11101111;
        4'b0101:an = 8'b11011111;
        4'b0110:an = 8'b10111111;
        4'b0111:an = 8'b01111111;
        default:an = 8'b11111111;
    endcase
    
    always @ (*)
    case(bcd_array[count])
        4'b0000:seg ={p[count], 7'b1000000};
        4'b0001:seg ={p[count], 7'b1111001};
        4'b0010:seg ={p[count], 7'b0100100};
        4'b0011:seg ={p[count], 7'b0110000};
        4'b0100:seg ={p[count], 7'b0011001};
        4'b0101:seg ={p[count], 7'b0010010};
        4'b0110:seg ={p[count], 7'b0000010};
        4'b0111:seg ={p[count], 7'b1111000};
        4'b1000:seg ={p[count], 7'b0000000};
        4'b1001:seg ={p[count], 7'b0010000};
        default:seg ={8'b11111111};
    endcase
endmodule