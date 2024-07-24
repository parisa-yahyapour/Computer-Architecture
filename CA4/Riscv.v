`timescale 1ns/1ns
module risc_v(clk , rst);
    input clk, rst;
    wire RegWriteD, MemWriteD, ALUSrc2D, branchD,luiD;
    wire [1:0] ResultSrcD, PCSrcD, branch_selD;
    wire [2:0] ALUControlD, ImmSrcD;
    wire [6:0] opcode;
    wire[2:0] func3;
    wire[6:0] func7;


    datapath dp(clk, rst, RegWriteD, MemWriteD, ResultSrcD, PCSrcD,
                ALUSrc2D, ALUControlD, ImmSrcD, branchD,luiD,branch_selD, 
                opcode, func3, func7);
    controller cntr(opcode, func3, func7, 
                    PCSrcD, ResultSrcD, MemWriteD, ALUControlD, ALUSrc2D, ImmSrcD, RegWriteD, branchD, luiD, branch_selD);

endmodule