`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/05/29 13:33:51
// Design Name: 
// Module Name: ctrl
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


module ctrl(
    input [31:0] instr,
    input clk, zero, negative, reset, irq,
    input [7:0] addr,
    output reg [3:0] alu_ctr,
    output reg [2:0] ext_dm, md_ctr,
    //output reg [2:0] md_ctr,
    output reg [1:0] regdst, ext_op, //ext_be,
    output reg irwr, pcwr,gprwr,dmwr,bsel,shiftsel,hiwr,lowr,hl_opt,cp0wr,epcwr,resetirq,counterwr,
    output reg [1:0] npc_op, be,
    output reg [2:0] wdsel,
    output reg [3:0] npc_instr
    );
    parameter IR = 4'b0000,
              B = 4'b0001,
              J = 4'b0010,
              MA = 4'b0011,
              MD = 4'b0100,
              RHL = 4'b0101,
              RC = 4'b0111,
              WC = 4'b1000,
              ER = 4'b1001,
              BREAK = 4'b1010;
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
    parameter S0 = 5'b00000,
              S1 = 5'b00001,
              S2 = 5'b00010,
              S3 = 5'b00011,
              S4 = 5'b00100,
              S5 = 5'b00101,
              S6 = 5'b00110,
              S7 = 5'b00111,
              S8 = 5'b01000,
              S9 = 5'b01001,
              S10 = 5'b01010,
              S11 = 5'b01011,
              S12 = 5'b01100,
              S13 = 5'b01101,
              S14 = 5'b01110,
              S15 = 5'b01111,
              S16 = 5'b10000;
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
              alu_db = 4'b1011; //direct access of B
    parameter md_mul = 3'b000,
              md_mulu = 3'b001,
              md_div = 3'b010,
              md_divu = 3'b011,
              md_mthi = 3'b100,
              md_mtlo = 3'b101;
    parameter dm_sw = 2'b00,
              dm_sb = 2'b01,
              dm_sh = 2'b10;
    wire [5:0] op, func;
    wire [4:0] rs, rt, rd;
    wire [15:0] imm;
    assign op = instr[31:26];
    assign func = instr[5:0];
    assign rs = instr[25:21];
    assign rt = instr[20:16];
    assign rd = instr[15:11];
    assign imm = instr[15:0];
    // IR
    wire sll = (op == 6'b000000 && func == 6'b000000);
    wire sllv = (op == 6'b000000 && func == 6'b000100);
    wire sra = (op == 6'b0000000 && func == 6'b000011);
    wire srav = (op == 6'b000000 && func == 6'b000111);
    wire srl = (op == 6'b000000 && func == 6'b000010);
    wire srlv = (op == 6'b000000 && func == 6'b000110);
    wire add = (op == 6'b000000 && func == 6'b100000);
    wire addu = (op == 6'b000000 && func == 6'b100001);
    wire sub = (op == 6'b000000 && func == 6'b100010);
    wire subu = (op == 6'b000000 && func == 6'b100011);
    wire andr = (op == 6'b000000 && func == 6'b100100);
    wire orr = (op == 6'b000000 && func == 6'b100101);
    wire xorr = (op == 6'b000000 && func == 6'b100110);
    wire norr = (op == 6'b000000 && func == 6'b100111);
    wire slt = (op == 6'b000000 && func == 6'b101010);
    wire sltu = (op == 6'b000000 && func == 6'b101011);
    wire addi = (op == 6'b001000);
    wire addiu = (op == 6'b001001);
    wire andi = (op == 6'b001100);
    wire slti = (op == 6'b001010);
    wire sltiu = (op == 6'b001011);
    wire lui = (op == 6'b001111);
    wire ori = (op == 6'b001101);
    wire xori = (op == 6'b001110);
    wire imme = (addi || addiu || andi || slti || sltiu || lui || ori || xori);
    
    //MA
    wire lw = (op == 6'b100011);
    wire lb = (op == 6'b100000);
    wire lbu = (op == 6'b100100);
    wire lh = (op == 6'b100001);
    wire lhu = (op == 6'b100101);
    wire sw = (op == 6'b101011);
    wire sb = (op == 6'b101000);
    wire sh = (op == 6'b101001);
    
    //B
    wire beq = (op == 6'b000100);
    wire bgez = (op == 6'b000001 && rt == 5'b00001);
    wire bgtz = (op == 6'b000111);
    wire blez = (op == 6'b000110);
    wire bltz = (op == 6'b00001 && rt == 5'b00000);
    wire bne = (op == 6'b000101);
    
    //J
    wire j = (op == 6'b000010);
    wire jal = (op == 6'b000011);
    wire jr = (op == 6'b000000 && func == 6'b001000);
    wire jalr = (op == 6'b000000 && func == 6'b001001);
    
    //MD
    wire mult = (op == 6'b000000 && func == 6'b011000);
    wire multu = (op == 6'b000000 && func == 6'b011001);
    wire div = (op == 6'b000000 && func == 6'b011010);
    wire divu = (op == 6'b000000 && func == 6'b011011);
    wire mthi = (op == 6'b000000 && func == 6'b010001);
    wire mtlo = (op == 6'b000000 && func == 6'b010011);
    
    //RHL
    wire mfhi = (op == 6'b000000 && func == 6'b010000);
    wire mflo = (op == 6'b000000 && func == 6'b010010);
    
    //RC
    wire mfc0 = (op == 6'b010000 && rs == 5'b00000);
    
    //WC
    wire mtc0 = (op == 6'b010000 && rs == 5'b00100);
    
    //ER
    wire eret = (op == 6'b010000 && func == 6'b011000);
    
    wire [3:0] op_type = (sll || sllv || sra || srav || srl || srlv || add || addi || sub || subu || andr || orr || xorr || norr || slt || sltu || addi || addiu || andi || slti || sltiu || lui || ori || xori) ? IR :
                     (lw || lb || lbu || lh || lhu || sw || sh || sb) ? MA:
                          (beq || bgez || bgtz || blez || bltz || bne) ? B:
                                              (j || jal || jr || jalr) ? J:
                       (mult || multu || div || divu || mtlo || mthi) ? MD:
                                                      (mfhi || mflo) ? RHL:
                                                                 mfc0 ? RC:
                                                                 mtc0 ? WC:
                                                                 eret ? ER:
                                                                        IR;
                   
    wire load = (lw || lb || lbu || lh || lhu);
    wire store = (sw || sb || sh);
    
    reg [4:0] fsm;
    initial
    begin
        fsm <= S0;
        pcwr = 1;
        npc_op = 2'b00;
        irwr = 1;
        gprwr = 0;
        dmwr = 0;
        npc_instr = NPC_IR;
        
    end
    always@(posedge clk)
    begin
        if (reset)
            fsm <= S0;
        else
            case(fsm)
                S0: fsm <= S1;
                S1: case(op_type)
                        IR: fsm <= S2;
                        MA: fsm <= S4;
                        B: fsm <= S8;
                        J: fsm <= S9;
                        MD: fsm <= S10;
                        RHL: fsm <= S12;
                        RC: fsm <= S13;
                        WC: fsm <= S14;
                        ER: fsm <= S16;
                    endcase
                S2: fsm <= S3;
                S3: fsm <= (irq == 1) ? S15 : S0;
                S4: fsm <= load ? S5 : S7;
                S5: fsm <= S6;
                S6: fsm <= irq ? S15 : S0;
                S7: fsm <= irq ? S15 : S0;
                S8: fsm <= irq ? S15 : S0;
                S9: fsm <= irq ? S15 : S0;
                S10: fsm <= S11;
                S11: fsm <= irq ? S15 : S0;
                S12: fsm <= irq ? S15 : S0;
                S13: fsm <= irq ? S15 : S0;
                S14: fsm <= irq ? S15 : S0;
                S15: fsm <= S0;
                S16: fsm <= S0;
            endcase
    end
    always@(*)
    begin
        case(fsm)
            S0:
            begin
                pcwr = 1;
                npc_op = 2'b00;
                irwr = 1;
                gprwr = 0;
                dmwr = 0;
                npc_instr = NPC_IR;
                hiwr = 0;
                lowr = 0;
                cp0wr = 0;
                resetirq = 0;
                epcwr = 0;
                counterwr = 0;
            end
            S1:
            begin
                pcwr = 0;
                irwr = 0;
                gprwr = 0;
                dmwr = 0;
                alu_ctr = (add || addi || addu || addiu) ? alu_add:
                             (sub || subu || beq || bne) ? alu_sub:
                                             (orr || ori) ? alu_or:
                          (slt || slti || sltu || sltiu) ? alu_neg:
                                          (andr || andi) ? alu_and:
                                          (xorr || xori) ? alu_xor:
                                                  (norr) ? alu_nor:
                                            (sll || sllv) ? alu_sl:
                                            (srl || srlv) ? alu_sr:
                                           (sra || srav) ? alu_sra:
                                                    (lui) ? alu_db:
                           (bgtz || bgez || bltz || blez) ? alu_da:
                                                           alu_add;
                shiftsel = (sllv || srlv || srav) ? 1 : 0;
                regdst = imme ? 2'b00 : 2'b01;
                bsel = (addi || addiu || andi || slti || sltiu || lui || ori || xori) ? 1 : 0;
                wdsel = 3'b000;
                ext_op = (addi || addiu || slti || sltiu) ? 2'b01: //sign_extend
                                    (ori || andi || xori) ? 2'b00: //zero_extend
                                                    (lui) ? 2'b10: //high_byte_extend
                                                            2'b00;
                npc_instr = (IR||MA) ? NPC_IR:
                            beq ? NPC_BEQ:
                            bne ? NPC_BNE:
                            bgtz ? NPC_BGTZ:
                            bgez ? NPC_BGEZ:
                            blez ? NPC_BLEZ:
                            bltz ? NPC_BLEZ:
                                     NPC_IR;
                hl_opt = mfhi ? 1 : 0;
                hiwr = 0;
                lowr = 0;
                cp0wr = 0;
                epcwr = 0;
            end
            S2:
            begin
                pcwr = 0;
                irwr = 0;
                gprwr = 0;
                dmwr = 0;
                alu_ctr = (add || addi || addu || addiu) ? alu_add:
                                           (sub || subu) ? alu_sub:
                                             (orr || ori) ? alu_or:
                          (slt || slti || sltu || sltiu) ? alu_neg:
                                          (andr || andi) ? alu_and:
                                          (xorr || xori) ? alu_xor:
                                                  (norr) ? alu_nor:
                                            (sll || sllv) ? alu_sl:
                                            (srl || srlv) ? alu_sr:
                                           (sra || srav) ? alu_sra:
                                                    (lui) ? alu_db:
                                                           alu_add;
                shiftsel = (sllv || srlv || srav) ? 1 : 0;
                regdst = imme ? 2'b00 : 2'b01;
                bsel = (addi || addiu || andi || slti || sltiu || lui || ori || xori) ? 1 : 0;
                wdsel = 3'b000;
                ext_op = (addi || addiu || slti || sltiu) ? 2'b01: //sign_extend
                                    (ori || andi || xori) ? 2'b00: //zero_extend
                                                    (lui) ? 2'b10: //high_byte_extend
                                                            2'b00;
                npc_instr = NPC_IR;
                hiwr = 0;
                lowr = 0;
                cp0wr = 0;
                epcwr = 0;
            end
            S3:
            begin
                pcwr = 0;
                irwr = 0;
                gprwr = 1;
                dmwr = 0;
                alu_ctr = (add || addi || addu || addiu) ? alu_add:
                                           (sub || subu) ? alu_sub:
                                             (orr || ori) ? alu_or:
                                           (slt || slti) ? alu_neg:
                                          (andr || andi) ? alu_and:
                                          (xorr || xori) ? alu_xor:
                                                  (norr) ? alu_nor:
                                            (sll || sllv) ? alu_sl:
                                            (srl || srlv) ? alu_sr:
                                           (sra || srav) ? alu_sra:
                                                           alu_add;
                shiftsel = (sllv || srlv || srav) ? 1 : 0;
                regdst = imme ? 2'b00 : 2'b01;
                bsel = (addi || addiu || andi || slti || sltiu || lui || ori || xori) ? 1 : 0;
                wdsel = 3'b000;
                npc_instr = NPC_IR;
                hiwr = 0;
                lowr = 0;
                cp0wr = 0;
                epcwr = 0;
            end
            S4:
            begin
                pcwr = 0;
                irwr = 0;
                gprwr = 0;
                dmwr = 0;
                alu_ctr = alu_add;
                regdst = 2'b00;
                bsel = 1;
                wdsel = (addr == 16'h7f) ? 3'b101 : 3'b001;
                ext_op = 2'b01;
                npc_instr = NPC_IR;
                hiwr = 0;
                lowr = 0;
                cp0wr = 0;
                epcwr = 0;
       
            end
            S5:
            begin
                pcwr = 0;
                irwr = 0;
                gprwr = 0;
                dmwr = 0;
                alu_ctr = alu_add;
                regdst = 2'b00;
                bsel = 1;
                wdsel = (addr == 16'h7f) ? 3'b101 : 3'b001;
                ext_op = 2'b01;
                ext_dm = lw ? 3'b000:
                         lb ? 3'b001:
                        lbu ? 3'b010:
                         lh ? 3'b011:
                        lhu ? 3'b100:
                              3'b000;
                npc_instr = NPC_IR;
                hiwr = 0;
                lowr = 0;
                cp0wr = 0;
                epcwr = 0;
            end
            S6:
            begin
                pcwr = 0;
                irwr = 0;
                gprwr = 1;
                dmwr = 0;
                alu_ctr = alu_add;
                regdst = 2'b00;
                bsel = 1;
                wdsel = (addr == 16'h7f) ? 3'b101 : 3'b001;
                ext_op = 2'b01;
                ext_dm = lw ? 3'b000:
                         lb ? 3'b001:
                        lbu ? 3'b010:
                         lh ? 3'b011:
                        lhu ? 3'b100:
                              3'b000;
                npc_instr = NPC_IR;
                hiwr = 0;
                lowr = 0;
                cp0wr = 0;
                epcwr = 0;
            end
            S7:
            begin
                pcwr = 0;
                irwr = 0;
                gprwr = 0;
                dmwr = (addr == 16'h7f) ? 0 : 1;
                be = sw ? dm_sw:
                     sh ? dm_sh:
                     sb ? dm_sb:
                          dm_sw;
                alu_ctr = alu_add;
                regdst = 2'b00;
                bsel = 1;
                wdsel = 3'b001;
                ext_op = 2'b01;
                npc_instr = NPC_IR;
                hiwr = 0;
                lowr = 0;
                cp0wr = 0;
                epcwr = 0;
                counterwr = (addr == 16'h7f) ? 1 : 0;
            end
            S8:
            begin
                pcwr = ((beq && zero) || (bne && !zero) || (bgtz && !zero && !negative) || (bgez && !negative) || (bltz && negative) || (blez && (zero || negative))) ? 1 : 0;
                irwr = 0;
                gprwr = 0;
                dmwr = 0;
                alu_ctr = alu_sub;
                regdst = 2'b00;
                bsel = 0;
                npc_instr = beq ? NPC_BEQ:
                            bne ? NPC_BNE:
                            bgtz ? NPC_BGTZ:
                            bgez ? NPC_BGEZ:
                            blez ? NPC_BLEZ:
                            bltz ? NPC_BLEZ:
                                    NPC_BEQ;
                hiwr = 0;
                lowr = 0;
                cp0wr = 0;
                epcwr = 0;
            end
            S9:
            begin
                pcwr = 1;
                irwr = 0;
                gprwr = (jal || jalr) ? 1 : 0;
                dmwr = 0;
                regdst = jal ? 2'b10:
                        jalr ? 2'b01:
                               2'b01;
                npc_instr = (j || jal) ? NPC_J_JAL:
                            (jr || jalr) ? NPC_JR_JALR:
                                             NPC_J_JAL;
                wdsel = 3'b010;
                hiwr = 0;
                lowr = 0;
                cp0wr = 0;
                epcwr = 0;
            end
            S10:
            begin
                pcwr = 0;
                irwr = 0;
                gprwr = 0;
                dmwr = 0;
                npc_instr = NPC_IR;
                md_ctr = mult ? md_mul:
                         multu ? md_mulu:
                         div ? md_div:
                         divu ? md_divu:
                         mthi ? md_mthi:
                         mtlo ? md_mtlo:
                                md_mul;
                hiwr = 0;
                lowr = 0;
                cp0wr = 0;
                epcwr = 0;
            end
            S11:
            begin
                pcwr = 0;
                irwr = 0;
                gprwr = 0;
                dmwr = 0;
                npc_instr = NPC_IR;
                md_ctr = mult ? md_mul:
                         multu ? md_mulu:
                         div ? md_div:
                         divu ? md_divu:
                         mthi ? md_mthi:
                         mtlo ? md_mtlo:
                                md_mul;
                hiwr = mtlo ? 0 : 1;
                lowr = mthi ? 0 : 1;
                cp0wr = 0;
                epcwr = 0;
            end
            S12:
            begin
                pcwr = 0;
                irwr = 0;
                gprwr = 1;
                dmwr = 0;
                npc_instr = NPC_IR;
                hiwr = 0;
                lowr = 0;
                hl_opt = mfhi ? 1 : 0;
                regdst = 2'b01;
                wdsel = 3'b011;
                cp0wr = 0;
                epcwr = 0;
            end
            S13:
            begin
                pcwr = 0;
                irwr = 0;
                gprwr = 1;
                dmwr = 0;
                npc_instr = NPC_IR;
                hiwr = 0;
                lowr = 0;
                regdst = 2'b00;
                wdsel = 3'b100;
                cp0wr = 0;
                epcwr = 0;
            end
            S14:
            begin
                pcwr = 0;
                irwr = 0;
                gprwr = 0;
                dmwr = 0;
                npc_instr = NPC_IR;
                hiwr = 0;
                lowr = 0;
                regdst = 2'b00;
                wdsel = 3'b100;
                cp0wr = 1;
                epcwr = 0;
            end
            S15:
            begin
                pcwr = 1;
                irwr = 0;
                gprwr = 0;
                dmwr = 0;
                npc_instr = NPC_INT;
                hiwr = 0;
                lowr = 0;
                cp0wr = 0;
                epcwr = 1;
                resetirq = 1;
                
            end
            S16:
            begin
                pcwr = 1;
                irwr = 0;
                gprwr = 0;
                dmwr = 0;
                npc_instr = NPC_ERET;
                hiwr = 0;
                lowr = 0;
                cp0wr = 0;
                epcwr = 0;
                resetirq = 0;
                
            end
        endcase
    end
endmodule
