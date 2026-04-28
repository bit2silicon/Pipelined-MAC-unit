`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/27/2026 03:18:07 PM
// Design Name: 
// Module Name: mac_top
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


module mac_top#(
    parameter INPUT_WIDTH=16,
    parameter PROD_WIDTH =32,
    parameter RESULT_WIDTH=40)(
    input  wire clk_p,
    input  wire clk_n,
    input  wire rst_n,
    input  wire valid_in,
    input  wire clear
);

wire [RESULT_WIDTH-1:0] result;
wire valid_out;
wire saturated;
wire clk;

IBUFDS ibufds_inst (
        .I (clk_p),   // positive side of diff clock
        .IB(clk_n),   // negative side of diff clock
        .O (clk)      // single-ended clock signal
    );

reg [INPUT_WIDTH-1:0] counter;
always@(posedge clk) begin
    if(!rst_n) counter <= 0;
    else counter <= counter + 1;
end

// feed counter as both a and b
wire [INPUT_WIDTH-1:0] a = counter[INPUT_WIDTH-1:0];
wire [INPUT_WIDTH-1:0] b = counter[INPUT_WIDTH-1:0];

pipelined_mac # (
    .INPUT_WIDTH(INPUT_WIDTH),
    .PROD_WIDTH(PROD_WIDTH),
    .RESULT_WIDTH(RESULT_WIDTH)
  ) u_mac(
    .clk(clk),
    .rst_n(rst_n),
    .valid_in(valid_in),
    .clear(clear),
    .a(a),
    .b(b),
    .result(result),
    .valid_out(valid_out),
    .overflow(saturated)
);

ila_0 u_ila (
    .clk(clk),
    .probe0(a),
    .probe1(b),
    .probe2(valid_in),
    .probe3(valid_out),
    .probe4(result),
    .probe5(saturated)
);

endmodule
