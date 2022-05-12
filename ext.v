`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/29 13:33:51
// Design Name: 
// Module Name: ext
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


module ext(
    input [15:0] imm16,
    input [1:0] ext_op,
    output reg [31:0] ext32
    );
    
    always@(*)
    begin
        case(ext_op)
            2'b00: ext32 = {{16{1'b0}}, imm16};
            2'b01: ext32 = {{16{imm16[15]}}, imm16};
            2'b10: ext32 = {imm16, {16{1'b0}}};
            default: ext32 = {{16{1'b0}}, imm16};
        endcase
    end
endmodule
