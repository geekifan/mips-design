`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/06 12:18:20
// Design Name: 
// Module Name: ext_dm
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


module ext_dm(
    input [1:0] byte_addr,
    input [2:0] ext_dm,
    input [31:0] din,
    output [31:0] dout
    );
    wire [7:0] byte;
    wire [15:0] half_byte;
    assign byte = (byte_addr == 2'b00) ? din[7:0]:
                 (byte_addr == 2'b01) ? din[15:8]:
                (byte_addr == 2'b10) ? din[23:16]:
                (byte_addr == 2'b11) ? din[31:24]:
                                                0;
                                                
    assign half_byte = (byte_addr[1] == 0) ? din[15:0]:
                      (byte_addr[1] == 1) ? din[31:16]:
                                                     0;
    assign dout = (ext_dm == 3'b000) ? din:
                  (ext_dm == 3'b001) ? {{24{byte[7]}}, byte}:
                  (ext_dm == 3'b010) ? {{24{1'b0}}, byte}:
                  (ext_dm == 3'b011) ? {{16{half_byte[15]}}, half_byte}:
                  (ext_dm == 3'b100) ? {{16{1'b0}}, half_byte}:
                                                         32'h0;
    
endmodule
