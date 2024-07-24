`timescale 1ns/1ns
module risc(clk ,rst);
    input clk,rst;
    wire [6:0] opcode;
    wire lt, bge, zero;
    wire[2:0] func3;
    wire[6:0] func7;

    wire PCWrite, AdrSrc, MemWrite, IRWrite , RegWrite, branch ;
    wire [1:0] ResultSrc, ALUSrc1, ALUSrc2,sel_branch;
    wire [2:0] ALUControl, ImmSrc;
    datapath dp(clk, rst, PCWrite, AdrSrc, MemWrite, IRWrite, ResultSrc, ALUControl
                , ALUSrc1, ALUSrc2, ImmSrc, RegWrite, lt, bge , zero, opcode, func3, func7,branch, sel_branch);
    controller cntr(clk, rst, opcode, func3, func7, zero, bge, lt, PCWrite, AdrSrc,
                MemWrite, IRWrite, ResultSrc, ALUControl, ALUSrc1, ALUSrc2, ImmSrc, RegWrite,branch ,sel_branch);


endmodule