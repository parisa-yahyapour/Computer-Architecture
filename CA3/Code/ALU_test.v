`timescale 1ns/1ns
module ALU_test();
    reg [31:0] SrcA = 32'd137;
    reg [31:0] SrcB = 32'd134;
    reg [2:0] ALUControl=3'd0;
    wire [31:0] ALUResult;
    wire  zero, bge, lt;
    ALU CUT(SrcA, SrcB, ALUControl, ALUResult, zero, bge, lt);
    initial begin
        #100 ALUControl=3'd1;
        #100 ALUControl=3'd2;
        #100 ALUControl=3'd3;
        #100 ALUControl=3'd4;
        #100 ALUControl=3'd5;
        #100 ALUControl=3'd6;
        #100 SrcA=SrcB;
        #100 SrcB=32'd198;
        #100 $stop;
    end
endmodule