`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/24/2026 02:28:41 PM
// Design Name: 
// Module Name: tb
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


module tb();
      // Parameters
  localparam  INPUT_WIDTH = 16;
  localparam  PROD_WIDTH = 32;
  localparam  RESULT_WIDTH = 40;

  //Ports
  reg  clk;
  reg  rst_n;
  reg  valid_in;
  reg [INPUT_WIDTH-1:0] a;
  reg [INPUT_WIDTH-1:0] b;
  reg  clear;
  wire [RESULT_WIDTH-1:0] result;
  wire valid_out;
  wire overflow;

  pipelined_mac # (
    .INPUT_WIDTH(INPUT_WIDTH),
    .PROD_WIDTH(PROD_WIDTH),
    .RESULT_WIDTH(RESULT_WIDTH)
  ) mac1 (
        .clk(clk),
        .rst_n(rst_n),
        .clear(clear),
        .valid_in(valid_in),
        .a(a),
        .b(b),
        .result(result),
        .valid_out(valid_out),
        .overflow(overflow)
        );
    always #5 clk=~clk;
    
    initial begin
        clk=0;
        rst_n=0;
        clear=0;
        a=0;
        valid_in=0;
        b=0;
        repeat(3) @(posedge clk);
        rst_n=1;
        for(integer i=0; i<4; i=i+1) begin
            for(integer j=0; j<4; j=j+1) begin
                @(negedge clk)
                valid_in=1; a=i; b=j;
            end
        end
        
        @(negedge clk); valid_in=0;
        
        repeat(3) @(posedge clk); 
        $finish;
    end
endmodule
