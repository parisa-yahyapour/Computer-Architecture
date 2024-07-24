`timescale 1ns/1ns
module datapath(clk, rst, PCWrite, AdrSrc, MemWrite, IRWrite, ResultSrc, ALUControl
                , ALUSrc1, ALUSrc2, ImmSrc, RegWrite, lt, bge , zero, opcode, func3, func7, branch,sel_branch);
    
    
    input clk, rst, PCWrite, AdrSrc, MemWrite, IRWrite , RegWrite,branch;
    input[1:0] ResultSrc, ALUSrc1, ALUSrc2,sel_branch;
    input[2:0] ALUControl, ImmSrc;
    output [6:0] opcode;
    output lt, bge, zero;
    output[2:0] func3;
    output[6:0] func7;
    wire out;
    wire [31:0] Result, PC, OldPC, ReadData, instr, Data, RD1, RD2, A, B, ALUOut, ALUResult;
    wire [31:0] Adr, WD, SrcA, SrcB, ImmExt,WriteData;
    wire [4:0] A1, A2, A3;
    wire enable;
    assign A1 = instr[19:15];
    assign A2 = instr[24:20];
    assign A3 = instr[11:7];
    assign WD = Result;
    assign opcode = instr[6:0];
    assign func3 = instr[14:12];
    assign func7 = instr[31:25];
    assign WriteData = B; 


    assign enable= PCWrite | (branch & out );

    Register PCR   (Result, enable, rst, clk, PC);
    Register OldPCR(PC, IRWrite, rst, clk, OldPC);
    Register IR    (ReadData, IRWrite, rst, clk, instr);
    Register MDR   (ReadData, 1'b1, rst, clk, Data); 
    Register AR    (RD1, 1'b1, rst, clk, A);
    Register BR    (RD2, 1'b1, rst, clk, B);
    Register ALUR  (ALUResult, 1'b1, rst, clk, ALUOut);

    pc_select en_ps(sel_branch, zero, ~zero, lt, bge, out);
    mux2 address_selector(AdrSrc, PC, Result, Adr);
    DataMemory data_mem(Adr, WriteData, MemWrite, clk, ReadData);
    regfile register_file(clk,rst, RegWrite, A1, A2, A3, Result, RD1, RD2);
    extension_unit extnd(instr, ImmSrc, ImmExt);
    mux3 mux_A(ALUSrc1, PC, OldPC, A, SrcA);
    mux3 mux_B(ALUSrc2, WriteData,ImmExt,32'd4, SrcB);
    ALU alu_comp(SrcA, SrcB, ALUControl, ALUResult, zero, bge, lt);
    mux4 result_selector(ResultSrc, ALUOut, Data, ALUResult, ImmExt, Result);
endmodule