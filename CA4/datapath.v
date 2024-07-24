`timescale 1ns/1ns
module datapath(clk, rst, RegWriteD, MemWriteD, ResultSrcD, PCSrcD,
                ALUSrc2D, ALUControlD, ImmSrcD, branchD,luiD,branch_selD, 
                opcode, func3, func7);

    input clk, rst, RegWriteD, MemWriteD, ALUSrc2D, branchD,luiD;
    input[1:0] ResultSrcD, PCSrcD, branch_selD;
    input[2:0] ALUControlD, ImmSrcD;
    output [6:0] opcode;
    output[2:0] func3;
    output[6:0] func7;

    //wiring 
        //fetch
    wire [4:0] A1, A2, A3, Rs1D, Rs2D, RdD, Rs1E, Rs2E, RdE, RdM, RdW;
    wire stallF,stallD,flushD;
    wire[1:0] PCSrcE,PCSrc_undone;
    wire[31:0] PCPlus4F,PCTargetE,ALUResultE,PCF,PC_outF,instrF;
        //decode
    wire[31:0] PCPlus4D,instrD, PCD, ImmExtD;
    wire [31:0] ResultW, WD, RD1, RD2;
    wire flushE;
        //execute 
    wire RegWriteE, MemWriteE, ALUSrc2E, branchE,luiE,out;
    wire[1:0] ResultSrcE,branch_selE;
    wire[2:0] ALUControlE;
    wire [31:0]PCPlus4E, RD1E, RD2E, PCE, SrcAE, SrcBE,writeDataE,ImmExtE;
    wire[1:0] ForwardAE,ForwardBE;
    wire lt, bge, zero;
        //memory
    wire [31:0] mux_outM, writeDataM, ALUResultM, PCPlus4M, ReadDataM;
    wire RegWriteM, MemWriteM,luiM;
    wire[1:0] ResultSrcM;
    wire[31:0] ImmExtM;   
        //writeback
    wire [31:0] ALUResultW, PCPlus4W, ReadDataW;
    wire RegWriteW;
    wire[1:0] ResultSrcW;
    wire[31:0] ImmExtW;    
    //fetch
    mux3 pc_selector(PCSrcE, PCPlus4F, PCTargetE, ALUResultE, PCF);
    Register PC_reg(PCF, ~stallF, rst, clk, PC_outF);
    InstructionMemory inst_mem(PC_outF, instrF);
    adder_4 pc_updator(PC_outF, PCPlus4F);
    RegIF_ID F_to_D(clk, rst, ~stallD, flushD, instrF, PC_outF, PCPlus4F, PCPlus4D,instrD, PCD);
    //

    //decode
    assign A1 = instrD[19:15];
    assign A2 = instrD[24:20];
    assign A3 = instrD[11:7];
    assign WD = ResultW;
    assign opcode = instrD[6:0];
    assign func3 = instrD[14:12];
    assign func7 = instrD[31:25];
    assign Rs1D=A1;
    assign Rs2D=A2;
    assign RdD=A3;

    regfile register_file(clk,rst, RegWriteW, A1, A2, RdW, WD, RD1, RD2);//RegWrite - > RegWriteW
    extension_unit extnd(instrD, ImmSrcD, ImmExtD);
    RegID_EX D_to_E(clk, rst, flushE, RegWriteD, ResultSrcD, MemWriteD, branchD, ALUControlD, ALUSrc2D, 
                RD1, RD2, PCD, Rs1D, Rs2D, RdD, ImmExtD, PCPlus4D, luiD,
                RegWriteE, ALUSrc2E, MemWriteE, luiE,
                branchE, ALUControlE, ResultSrcE, RD1E, RD2E, PCE,Rs1E,
                Rs2E,RdE, ImmExtE,PCPlus4E,PCSrcD , PCSrc_undone,branch_selD,branch_selE);

    //

    //execute
    ALU alu_comp(SrcAE, SrcBE, ALUControlE, ALUResultE, zero, bge, lt);
    mux3 A_input(ForwardAE, RD1E, ResultW, mux_outM, SrcAE);
    mux3 B_input(ForwardBE, RD2E, ResultW, mux_outM, writeDataE);
    mux2 src1_alu_selector(ALUSrc2E, writeDataE ,ImmExtE, SrcBE);
    adder_imm pc_target_counter(PCE, ImmExtE, PCTargetE);
    //check condition PCSrc
    pc_select pc_en(branch_selE, zero, zero, lt, bge, PCSrc_undone,branchE, PCSrcE);

    RegEX_MEM E_to_M(clk, rst, RegWriteE, ResultSrcE, MemWriteE,
                 ALUResultE, writeDataE, RdE, PCPlus4E, luiE, ImmExtE,
                 RegWriteM, ResultSrcM, MemWriteM, ALUResultM,
                 writeDataM, RdM, PCPlus4M, luiM, ImmExtM);
    //

    //memory
    DataMemory data_mem(ALUResultM, writeDataM, MemWriteM, clk, ReadDataM);
    mux2 lui_select(luiM,ALUResultM,ImmExtM, mux_outM);

    RegMEM_WB M_to_W(clk, rst, RegWriteM, ResultSrcM, ALUResultM, ReadDataM, RdM, PCPlus4M,ImmExtM, 
                ImmExtW, RegWriteW, ResultSrcW, ALUResultW, ReadDataW, RdW, PCPlus4W);

    //

    //write back
    mux4 result_selector(ResultSrcW, ALUResultW, ReadDataW, PCPlus4W, ImmExtW, ResultW);

    //hazard unit
    HazardUnit hazard(
        .Rs1D(Rs1D), .Rs2D(Rs2D), .RdE(RdE), .RdM(RdM), 
        .RdW(RdW), .Rs2E(Rs2E), .Rs1E(Rs1E), .stallF(stallF),
        .PCSrcE(PCSrcE), .resultSrc0(ResultSrcE[0]), 
        .regWriteW(RegWriteW),.regWriteM(RegWriteM), 
        .stallD(stallD), .flushD(flushD), .flushE(flushE), 
        .forwardAE(ForwardAE), .forwardBE(ForwardBE)
    );

endmodule