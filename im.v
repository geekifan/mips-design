`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/29 13:33:51
// Design Name: 
// Module Name: im
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


module im(
    input [31:0] pc,
    output [31:0] instr
    );
    integer i;
    reg [31:0] im[16'h13ff:16'h0c00];
    initial
    begin
        for(i = 16'h0c00; i <= 16'h13ff; i = i + 1)
            im[i] = 32'b0;
        $readmemh("code.txt", im);
        //$readmemh("int.txt", im);
        im[16'h1060] = 32'hac0a0100; //sw $t2, 0x0100($zero)
        im[16'h1061] = 32'h014a5026; //xor $t2,$t2,$t2
        im[16'h1062] = 32'h200a0032; //addi $t2,$zero,50
        im[16'h1063] = 32'hac0a7f08; //sw $t2,0x7f08($zero)
        im[16'h1064] = 32'h8c0a0100; //lw $t2, 0x0100($zero)
        im[16'h1065] = 32'h42000018; //eret
    end
    assign instr = im[pc[16:2]];
endmodule
