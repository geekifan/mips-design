`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/06/07 21:16:10
// Design Name: 
// Module Name: counter
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


module counter(
    input clk,
    input reset,
    input [31:0] addr,
    input counterwr,
    input [31:0] din,
    input resetirq,
    output [31:0] dout,
    output reg irq
    );
    reg [31:0] ctrl;
    reg [31:0] preset;
    reg [31:0] count;
    wire [1:0] counter_addr = addr[3:2];
    assign dout = (counter_addr == 2'b00) ? ctrl:
                  (counter_addr == 2'b01) ? preset:
                  (counter_addr == 2'b10) ? count:
                                            ctrl;
    initial
    begin
        ctrl[31:4] <= 28'b0;
        ctrl[2:1] <= 2'b00;
        ctrl[0] <= 1'b1;
        count = 32'd50;
        irq = 0;
    end
    always@(posedge clk)
    begin
        if(ctrl[0])
            count = count - 1;
        if (count <= 0)
            case(ctrl[2:1])
                2'b01: count = 32'd50;
                2'b00: irq = 1; //interrupt
            endcase
        if(resetirq)
            irq = 0;
        if(counterwr)
        begin
            if (counter_addr == 2'b00)
                ctrl = din;
            if (counter_addr == 2'b01)
                preset = din;
            if (counter_addr == 2'b10)
                count = din;
            $display("@INT:COUNTER[%d] <= %h", counter_addr, din);
        end
    end
endmodule
 