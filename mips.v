`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/29 13:33:51
// Design Name: 
// Module Name: mips
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


module mips(
    input clk,
    input reset
    );
    wire pcwr, irwr;
    wire [31:0] npc_addr;
    wire [31:0] pc_addr;
    wire [31:0] pc4_addr;
    wire [31:0] epc_addr;
    wire zero;
    wire negative;
    wire [31:0] instr;
    wire [31:0] ir_instr;
    wire [1:0] regdst, npc_op, ext_op, be;
    wire [2:0] wdsel;
    wire [4:0] a1,a2,a3;
    wire gprwr, shiftsel, dmwr, hiwr, lowr, hl_opt, cp0wr, resetirq, irq, epcwr, counterwr;
    wire [31:0] wd;
    wire [31:0] rd1, rd2;
    wire [31:0] hi, lo, hi_reg, lo_reg, dout_hl;
    wire [31:0] a,b;
    wire [31:0] ext32, aluin1, aluin2, result, alu_res, dm_out, dm_out_reg, ext_dm_out, cp0_out, counter_out;
    wire [3:0] alu_ctr, npc_instr;
    wire [2:0] ext_dm, md_ctr;
    wire bsel;
    assign aluin1 = a;
    pc PC(.clk(clk), .reset(reset), .pcwr(pcwr), .npc(npc_addr), .pc(pc_addr));
    npc NPC(.zero(zero), .negative(negative), .pc(pc_addr), .npc(npc_addr), .epc(epc_addr), .pc4(pc4_addr), .npc_instr(npc_instr), .imm(ir_instr[25:0]), .rs(a));
    im IM(.pc(pc_addr), .instr(instr));
    ir IR(.clk(clk), .irwr(irwr), .din(instr), .dout(ir_instr));
    mux_3_5b MUX_GPR(.a0(ir_instr[20:16]), .a1(ir_instr[15:11]), .a2(5'h1f), .opt(regdst), .dout(a3));
    mux_6_32b MUX_GPR_WR(.a0(alu_res), .a1(dm_out_reg), .a2(pc_addr), .a3(dout_hl), .a4(cp0_out), .a5(counter_out), .opt(wdsel), .dout(wd));
    gpr GPR(.clk(clk), .reset(reset), .we(gprwr), .pc(pc_addr), .a1(ir_instr[25:21]), .a2(ir_instr[20:16]), .a3(a3), .wd(wd), .rd1(rd1), .rd2(rd2));
    cp0 CP0(.clk(clk), .reset(reset), .cp0wr(cp0wr), .epcwr(epcwr), .pc(pc_addr), .addr(ir_instr[15:11]), .din(b), .dout(cp0_out), .epc(epc_addr));
    register A(.clk(clk), .din(rd1), .dout(a));
    register B(.clk(clk), .din(rd2), .dout(b));
    md MD(.a(a), .b(b), .md_ctr(md_ctr),.hi(hi), .lo(lo));
    register MD_HI_OUT(.clk(clk), .din(hi), .dout(hi_reg));
    register MD_LO_OUT(.clk(clk), .din(lo), .dout(lo_reg));
    hl HL(.clk(clk), .hiwr(hiwr), .lowr(lowr), .pc(pc_addr), .din_hi(hi_reg), .din_lo(lo_reg), .hl_opt(hl_opt), .dout(dout_hl));
    ext EXT(.imm16(ir_instr[15:0]), .ext_op(ext_op), .ext32(ext32));
    mux_2_32b MUX_ALU(.a0(b), .a1(ext32), .opt(bsel), .dout(aluin2));
    alu ALU(.a(aluin1), .b(aluin2), .alu_ctr(alu_ctr), .shift(ir_instr[10:6]), .shiftsel(shiftsel), .result(result), .zero(zero), .negative(negative));
    register ALU_OUT(.clk(clk), .din(result), .dout(alu_res));
    dm DM(.clk(clk), .pc(pc_addr), .be(be), .reset(reset), .dmwr(dmwr), .addr(alu_res), .din(b), .dout(dm_out));
    ext_dm EXT_DM(.byte_addr(alu_res[1:0]), .ext_dm(ext_dm), .din(dm_out), .dout(ext_dm_out));
    register DM_OUT(.clk(clk), .din(ext_dm_out), .dout(dm_out_reg));
    ctrl CTRL(.instr(ir_instr), .clk(clk), .zero(zero), .negative(negative), .reset(reset), 
              .dmwr(dmwr), .gprwr(gprwr), .bsel(bsel), .shiftsel(shiftsel), .alu_ctr(alu_ctr), 
              .ext_op(ext_op), .regdst(regdst), .wdsel(wdsel), .pcwr(pcwr), .irwr(irwr), 
              .ext_dm(ext_dm), .npc_instr(npc_instr), .md_ctr(md_ctr), .hiwr(hiwr), .lowr(lowr), 
              .hl_opt(hl_opt), .be(be), .cp0wr(cp0wr), .resetirq(resetirq), .irq(irq), .epcwr(epcwr), .addr(result[15:8]), .counterwr(counterwr));
    counter COUNTER(.clk(clk), .resetirq(resetirq), .counterwr(counterwr), .irq(irq), .addr(alu_res), .din(b), .dout(counter_out));
    
    
endmodule
