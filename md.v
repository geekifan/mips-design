`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/07 11:01:08
// Design Name: 
// Module Name: md
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


module md(
    input [31:0] a,
    input [31:0] b,
    input [2:0] md_ctr,
    output reg [31:0] hi,
    output reg [31:0] lo
    );
    parameter md_mul = 3'b000,
              md_mulu = 3'b001,
              md_div = 3'b010,
              md_divu = 3'b011,
              md_mthi = 3'b100,
              md_mtlo = 3'b101;
    wire [63:0] mul;
    wire [65:0] mulu;
    assign mul = a * b;
    assign mulu = {1'b0, a} * {1'b0, b};
    always@(*)
    begin
        case(md_ctr)
            md_mul:
            begin
                hi = mul[63:32];
                lo = mul[31:0];
            end
            md_mulu:
            begin
                hi = mulu[63:32];
                lo = mulu[31:0];
            end
            md_div:
            begin
                case({a[31], b[31]})
                    2'b00:
                    begin
                        hi = a % b;
                        lo = a / b;
                    end
                    2'b01:
                    begin
                        hi = a % (-b);
                        lo = -(a / (-b));
                    end
                    2'b10:
                    begin
                        hi = -((-a) % b);
                        lo = -((-a) / b);
                    end
                    2'b11:
                    begin
                        hi = -((-a) % (-b));
                        lo = (-a) / (-b);
                    end
                endcase
            end
            md_divu:
            begin
                hi = {1'b0, a} % {1'b0, b};
                lo = {1'b0, a} / {1'b0, b};
            end
            md_mthi:
                hi = a;
            md_mtlo:
                lo = a;
        endcase
    end
endmodule
