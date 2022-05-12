`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/02 10:33:25
// Design Name: 
// Module Name: dm
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


module dm(
    input clk,
    input [31:0] pc,
    input reset,
    input dmwr,
    input [1:0] be,
    input [31:0] addr,
    input [31:0] din,
    output [31:0] dout
    );
    parameter dm_sw = 2'b00,
              dm_sb = 2'b01,
              dm_sh = 2'b10;
    reg [31:0] dm[1023:0];
    integer i;
    initial
    begin
        for (i = 0; i < 1024; i = i + 1)
            dm[i] <= 32'b0;
    end
    assign dout = dm[addr[11:2]];
    always@(*)
    begin
        if (reset)
            for (i = 0; i < 1024; i = i + 1)
                dm[i] <= 32'b0;
        else if (dmwr)
        begin
            case (be)
                dm_sw:
                begin
                    dm[addr[11:2]] <= din;
                    $display("@%h:*%h <= %h", pc, addr, din);
                end
                dm_sb:
                begin
                    case(addr[1:0])
                        2'b00:
                        begin
                            dm[addr[11:2]][7:0] <= din[7:0];
                            $display("@%h:*%h <= %h", pc, addr, din[7:0]);
                        end
                        2'b01:
                        begin
                            dm[addr[11:2]][15:8] <= din[7:0];
                            $display("@%h:*%h <= %h", pc, addr, din[7:0]);
                        end
                        2'b10:
                        begin
                            dm[addr[11:2]][23:16] <= din[7:0];
                            $display("@%h:*%h <= %h", pc, addr, din[7:0]);
                        end
                        2'b11:
                        begin
                            dm[addr[11:2]][31:24] <= din[7:0];
                            $display("@%h:*%h <= %h", pc, addr, din[7:0]);
                        end
                    endcase
                end
                dm_sh:
                begin
                    case(addr[1])
                        1'b0:
                        begin
                            dm[addr[11:2]][15:0] <= din[15:0];
                            $display("@%h:*%h <= %h", pc-4, addr, din[15:0]);
                        end
                        1'b1:
                        begin
                            dm[addr[11:2]][31:16] <= din[15:0];
                            $display("@%h:*%h <= %h", pc-4, addr, din[15:0]);
                        end
                    endcase
                end
            endcase
            
        end
    end
endmodule
