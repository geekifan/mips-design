`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/02 09:56:40
// Design Name: 
// Module Name: alu
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


module alu(
    input [31:0] a,
    input [31:0] b,
    input [3:0] alu_ctr,
    input [4:0] shift,
    input shiftsel,
    output reg [31:0] result,
    output reg zero,
    output reg negative
    );
    parameter alu_add = 4'b0000,
              alu_sub = 4'b0001,
              alu_or = 4'b0010,
              alu_neg = 4'b0011,
              alu_and = 4'b0100,
              alu_xor = 4'b0101,
              alu_nor = 4'b0110,
              alu_sl = 4'b0111,
              alu_sr = 4'b1000,
              alu_sra = 4'b1001,
              alu_da = 4'b1010, //direct access of A
              alu_db = 4'b1011;
    reg [64:0] temp;
    always@(*)
    begin
        case(alu_ctr)
            alu_add: result = a + b;
            alu_sub: result = a - b;
            alu_or: result = a | b;
            alu_neg: result = (a < b) ? 1 : 0;
            alu_and: result = a & b;
            alu_xor: result = a ^ b;
            alu_nor: result = ~(a | b);
            alu_sl: result = shiftsel ? b << a[4:0] : b << shift;
            alu_sr: result = shiftsel ? b >> a[4:0] : b >> shift;
            alu_sra:
                begin
                    temp = shiftsel ? {{32{b[31]}}, b} >> a[4:0] : {{32{b[31]}}, b} >> shift;
                    result = temp[31:0];
                end
            alu_da: result = a;
            alu_db: result = b;
        endcase
        zero = (result == 0) ? 1 : 0;
        negative = (result < 0) ? 1 : 0;
    end
endmodule
