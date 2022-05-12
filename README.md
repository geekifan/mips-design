# MIPS 硬件设计

该项目为 MIPS 硬件设计实验课 （2021）的课程大作业，于2022年决定将其开源。该项目作者水平有限，在此声明该项目不适用于工程实践，仅用于模拟 MIPS 架构的CPU运行。该项目使用 Verilog 进行开发，实现了 MIPS-C5 指令集（ MIPS 完整指令集的子集）：

```
MIPS-C5={ LB, LBU, LH, LHU, LW, SB, SH, SW, ADD, 
ADDU, SUB, SUBU, MULT, MULTU, DIV, DIVU, SLL, 
SRL, SRA, SLLV, SRLV, SRAV, AND, OR, XOR, NOR, 
ADDI, ADDIU, ANDI, ORI,  XORI, LUI, SLT, SLTI, 
SLTIU, SLTU, BEQ, BNE, BLEZ, BGTZ, BLTZ, BGEZ, 
J, JAL, JALR, JR, MFHI, MFLO, MTHI, MTLO, ERET, 
MFC0, MTC0 }
```

该 CPU 设计中包含了一个定时时钟，实现了定时中断机制，在指定位置可以加载中断处理程序对时钟进行重置后继续计时（中断处理程序未包含在该项目开源的代码中）。

## 使用方法

代码只包含了必要的源代码，没有工程配置。该项目的开发平台使用了 Xilinx 的 IDE 进行开发，在此不提供部署方法，请自行将代码导入个人选择的开发平台。

## 许可证

本代码使用 MIT 许可证对其授权。

## 声明

本人不对抄袭、不当使用该代码产生的后果负责。本人只提供代码参考，强烈不建议为了提交作业而抄袭、不当使用该项目。This project comes with ABSOLUTELY NO WARRANTY.

## 致谢

该代码有部分逻辑受到了历年学长学姐代码的启发，同时也在与同学讨论的过程中逐渐完善了代码。在此对历年来学长学姐和同学的指导表示衷心的感谢。