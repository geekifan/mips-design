`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/02 11:19:42
// Design Name: 
// Module Name: mux
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
module mux_6_32b(
    input [31:0] a0, a1, a2, a3, a4, a5,
    input [2:0] opt,
    output [31:0] dout
    );
    assign dout = (opt == 3'b000) ? a0:
                  (opt == 3'b001) ? a1:
                  (opt == 3'b010) ? a2:
                  (opt == 3'b011) ? a3:
                  (opt == 3'b100) ? a4:
                  (opt == 3'b101) ? a5:
                                   a0;
endmodule

module mux_5_32b(
    input [31:0] a0, a1, a2, a3, a4,
    input [2:0] opt,
    output [31:0] dout
    );
    assign dout = (opt == 3'b000) ? a0:
                  (opt == 3'b001) ? a1:
                  (opt == 3'b010) ? a2:
                  (opt == 3'b011) ? a3:
                  (opt == 3'b100) ? a4:
                                   a0;
endmodule

module mux_4_32b(
    input [31:0] a0, a1, a2, a3,
    input [1:0] opt,
    output [31:0] dout
    );
    assign dout = (opt == 2'b00) ? a0:
                  (opt == 2'b01) ? a1:
                  (opt == 2'b10) ? a2:
                  (opt == 2'b11) ? a3:
                                   a0;
endmodule

module mux_3_32b(
    input [31:0] a0, a1, a2,
    input [1:0] opt,
    output [31:0] dout
    );
    assign dout = (opt == 2'b00) ? a0:
                  (opt == 2'b01) ? a1:
                  (opt == 2'b10) ? a2:
                                   a0;
endmodule

module mux_3_5b(
    input [4:0] a0, a1, a2,
    input [1:0] opt,
    output [4:0] dout
    ); 
    assign dout = (opt == 2'b00) ? a0:
                  (opt == 2'b01) ? a1:
                  (opt == 2'b10) ? a2:
                                   a0;
endmodule

module mux_2_32b(
    input [31:0] a0, a1,
    input opt,
    output [31:0] dout
);
    assign dout = (opt == 1) ? a1 : a0;
endmodule
