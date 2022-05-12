`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/29 13:33:51
// Design Name: 
// Module Name: pc
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


module pc(
    input clk,
    input reset,
    input pcwr,
    input [31:0] npc,
    output reg [31:0] pc
    );
    initial
    begin
        pc <= 32'h00003000;
    end
    always@(posedge clk)
    begin
        if(reset)
            pc <= 32'h00003000;
        else if(pcwr)
            pc <= npc;
    end
endmodule
