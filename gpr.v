`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/29 13:33:51
// Design Name: 
// Module Name: gpr
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


module gpr(
    input clk,
    input reset,
    input we,
    input [4:0] a1, a2, a3,
    input [31:0] wd,
    input [31:0] pc,
    output [31:0] rd1, rd2
    );
    reg [31:0] gpr[31:0];
    assign rd1 = gpr[a1];
    assign rd2 = gpr[a2];
    integer i;
    
    initial
    begin
        for(i = 0;i < 32; i = i + 1)
            gpr[i] <= 32'b0;
    end
    
    always@(posedge clk)
    begin
        if(reset)
            for(i = 0; i < 32; i = i + 1)
                gpr[i] <= 32'b0;
        else if (we)
        begin
            gpr[a3] <= wd;
            $display("@%h:$r%d <= %h", pc-4, a3, wd);
        end
    end
    
endmodule
