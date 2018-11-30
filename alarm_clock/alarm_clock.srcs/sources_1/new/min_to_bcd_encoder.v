`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/30/2018 10:58:40 AM
// Design Name: 
// Module Name: min_to_bcd_encoder
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: encodes binary minute values to bcd minutes
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mins_to_bcd_encoder(
    input [5:0] m,
    output reg [7:0] bcd
    );
    
    //create a LUT to convert the binary input to 2 BCD digits
    always @ * 
        case(m)
            6'd00:bcd = 8'h00;
            6'd01:bcd = 8'h01;      
            6'd02:bcd = 8'h02;      
            6'd03:bcd = 8'h03;      
            6'd04:bcd = 8'h04;      
            6'd05:bcd = 8'h05;      
            6'd06:bcd = 8'h06;      
            6'd07:bcd = 8'h07;      
            6'd08:bcd = 8'h08;      
            6'd09:bcd = 8'h09;      
            6'd10:bcd = 8'h10;      
            6'd11:bcd = 8'h11;      
            6'd12:bcd = 8'h12;      
            6'd13:bcd = 8'h13;      
            6'd14:bcd = 8'h14;      
            6'd15:bcd = 8'h15;      
            6'd16:bcd = 8'h16;      
            6'd17:bcd = 8'h17;      
            6'd18:bcd = 8'h18;      
            6'd19:bcd = 8'h19;      
            6'd20:bcd = 8'h20;      
            6'd21:bcd = 8'h21;      
            6'd22:bcd = 8'h22;      
            6'd23:bcd = 8'h23;      
            6'd24:bcd = 8'h24;      
            6'd25:bcd = 8'h25;
            6'd26:bcd = 8'h26;      
            6'd27:bcd = 8'h27;      
            6'd28:bcd = 8'h28;      
            6'd29:bcd = 8'h29;      
            6'd30:bcd = 8'h30;      
            6'd31:bcd = 8'h31;      
            6'd32:bcd = 8'h32;      
            6'd33:bcd = 8'h33;      
            6'd34:bcd = 8'h34;      
            6'd35:bcd = 8'h35;      
            6'd36:bcd = 8'h36;      
            6'd37:bcd = 8'h37;      
            6'd38:bcd = 8'h38;      
            6'd39:bcd = 8'h39;       
            6'd40:bcd = 8'h40;      
            6'd41:bcd = 8'h41;      
            6'd42:bcd = 8'h42;      
            6'd43:bcd = 8'h43;      
            6'd44:bcd = 8'h44;      
            6'd45:bcd = 8'h45;      
            6'd46:bcd = 8'h46;      
            6'd47:bcd = 8'h47;      
            6'd48:bcd = 8'h48;      
            6'd49:bcd = 8'h49;       
            6'd50:bcd = 8'h50;      
            6'd51:bcd = 8'h51;      
            6'd52:bcd = 8'h52;      
            6'd53:bcd = 8'h53;      
            6'd54:bcd = 8'h54;      
            6'd55:bcd = 8'h55;      
            6'd56:bcd = 8'h56;      
            6'd57:bcd = 8'h57;      
            6'd58:bcd = 8'h58;      
            6'd59:bcd = 8'h59;   
            default:bcd = 8'h99;
        endcase
endmodule
