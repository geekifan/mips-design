`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/29 13:33:51
// Design Name: 
// Module Name: npc
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


module npc(
    input zero,
    input negative,
    input [3:0] npc_instr,
    input [31:0] pc,
    input [31:0] epc,
    input [1:0] npc_op,
    input [25:0] imm,
    input [25:0] rs,
    output [31:0] npc,
    output [31:0] pc4
    );
    parameter NPC_IR = 4'b0000,
              NPC_BEQ = 4'b0001,
              NPC_BNE = 4'b0010,
              NPC_BGTZ = 4'b0011,
              NPC_BGEZ = 4'b0100,
              NPC_BLTZ = 4'b0101,
              NPC_BLEZ = 4'b0110,
              NPC_J_JAL = 4'b0111,
              NPC_JR_JALR = 4'b1000,
              NPC_INT = 4'b1001,
              NPC_ERET = 4'b1010;
    wire [15:0] b_addr = imm[15:0];
    assign npc = (npc_instr == NPC_IR) ? pc + 4:
                 ((npc_instr == NPC_BEQ && zero) || (npc_instr == NPC_BNE && !zero) || (npc_instr == NPC_BGTZ && !negative && !zero) || (npc_instr == NPC_BGEZ && !negative) || (npc_instr == NPC_BLTZ && negative) || (npc_instr == NPC_BLEZ && (negative || zero))) ? pc + {{14{b_addr[15]}}, b_addr, 2'b00}:
                 (npc_instr == NPC_J_JAL) ? {pc[31:28], imm, {2{1'b0}}}:
                 (npc_instr == NPC_JR_JALR) ? rs: 
                 (npc_instr == NPC_INT) ? 32'h4180:
                 (npc_instr == NPC_ERET) ? epc:
                 pc + 4;
    assign pc4 = pc + 4;
endmodule
