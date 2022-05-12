`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/07 21:07:17
// Design Name: 
// Module Name: cp0
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


module cp0(
    input clk,
    input cp0wr,
    input reset,
    input epcwr,
    input [31:0] pc,
    input [31:0] din,
    input [4:0] addr,
    input [31:0] npc,
    output [31:0] dout,
    output [31:0] epc
    );
    integer i;
    reg [31:0] cp0[31:0];
    wire [31:0] SR = cp0[12];
    wire [31:0] CAUSE = cp0[13];
    wire [31:0] EPC = cp0[14];
    assign epc = cp0[14];
    assign dout = cp0[addr];
    initial
    begin
        for (i = 0; i < 32; i = i + 1)
            cp0[i] <= 32'b0;
    end
    always@(posedge clk)
    begin
        if(reset)
            for (i = 0; i < 32; i = i + 1)
                cp0[i] <= 32'b0;
        if(cp0wr)
        begin
            cp0[addr] <= din;
            $display("@%h:cp0[%d] <= %h", pc-4, addr, din);
        end
        if(epcwr)
        begin
            cp0[14] = pc;
            $display("@INT:EPC <= %h", pc-4);
        end
    end
endmodule
