`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/24/2026 01:43:52 PM
// Design Name: 
// Module Name: pipelined_mac
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

(* use_dsp = "no" *)
module pipelined_mac #(
    parameter INPUT_WIDTH=16,
    parameter PROD_WIDTH =32,
    parameter RESULT_WIDTH=40)
    (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        valid_in,
    input  wire [INPUT_WIDTH-1:0]  a,          // multiplicand
    input  wire [INPUT_WIDTH-1:0]  b,          // multiplier
    input  wire        clear,      // reset accumulator to 0
    output reg  [RESULT_WIDTH-1:0] result,     // accumulated sum
    output reg         valid_out,
    output reg         overflow    // optional, but good to have
);
reg [PROD_WIDTH:0] prod_reg;
reg valid_s1;

always@(posedge clk) begin
    if(!rst_n) begin
        result<=0;
        valid_out<=0;
        overflow<=0;
        prod_reg<=0;
        valid_s1<=0;
    end
    else begin
        valid_s1<=0;
        if(valid_in) begin
            prod_reg<=a*b;
            valid_s1<=1;
        end
        if(valid_s1) begin
            {overflow,result}<=result+prod_reg;
            valid_out<=1;
        end
        else begin
            valid_out<=0;
        end
        if(clear) begin
            overflow<=0;
            result<=0;
        end
    end
end
endmodule
