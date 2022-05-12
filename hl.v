`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/07 11:36:39
// Design Name: 
// Module Name: hl
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


module hl(
    input clk,
    input hiwr,
    input lowr,
    input hl_opt,
    input [31:0] pc,
    input [31:0] din_hi,
    input [31:0] din_lo,
    output [31:0] dout
    );
    reg [31:0] hi,lo;
    assign dout = hl_opt ? hi : lo;
    initial
    begin
        hi <= 32'b0;
        lo <= 32'b0;
    end
    always@(posedge clk)
    begin
        if(hiwr)
        begin
            hi <= din_hi;
            $display("@%h:hi <= %h", pc - 4, din_hi);
        end
        if(lowr)
        begin
            lo <= din_lo;
            $display("@%h:lo <= %h", pc - 4, din_lo);
        end
    end
endmodule
