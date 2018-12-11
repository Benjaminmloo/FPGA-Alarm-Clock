`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/07/2018 04:02:50 PM
// Design Name: 
// Module Name: pdm_driver
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


// Pulse density Modulator
`timescale 1 ns / 1 ps

module pdm_driver #(parameter NBITS = 8)
(
  input wire                      clk,
  input wire [NBITS-1:0]          duty_in,
  input wire                      rst,
  output reg                      audio_out,
  output reg [NBITS-1:0]          error
);

  localparam integer MAX = 2**NBITS - 1;
  reg [NBITS-1:0] duty_in_reg;
  reg [NBITS-1:0] error_0;
  reg [NBITS-1:0] error_1;

  always @(posedge clk) begin
    duty_in_reg <= duty_in;
    error_1 <= error + MAX - duty_in_reg;
    error_0 <= error - duty_in_reg;
  end

  always @(posedge clk) begin
    if (rst == 1'b1) begin
      audio_out <= 0;
      error <= 0;
    end
    else if (duty_in_reg >= error) begin
      audio_out <= 1;
      error <= error_1;
    end else begin
      audio_out <= 0;
      error <= error_0;
    end
  end

endmodule
