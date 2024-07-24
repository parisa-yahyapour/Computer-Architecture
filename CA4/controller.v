`timescale 1ns/1ns
module controller (opcode, func3, func7, 
                    PCSrc, ResultSrc, MemWrite, ALUControl, ALUSrc2, ImmSrc, RegWrite, branch, lui, branch_sel);
    input [6:0] opcode;
    input [2:0] func3;
    input [6:0] func7;
    output  MemWrite, RegWrite, branch,ALUSrc2,lui;
    output [1:0] PCSrc, ResultSrc,branch_sel;
    output [2:0] ALUControl, ImmSrc;
    reg MemWrite, branch, ALUSrc2,lui,RegWrite;
    reg [1:0] PCSrc, ResultSrc,branch_sel;
    reg [2:0] ALUControl, ImmSrc;
    wire [9:0] function_choose={func7,func3};
    always @(*) begin
        {MemWrite, RegWrite} =2'd0;
        {PCSrc, ResultSrc, ALUSrc2} =5'd0;
        {ALUControl, ImmSrc} =6'd0;
        {branch,lui}=2'b00;
        branch_sel=2'b00;
        case (opcode)
            7'd51: case (function_choose)
                10'd0: {RegWrite}=2'b1;              //add
                10'd256:begin
                    RegWrite=1'b1;
                    ALUControl=3'b001;
                end           //sub
                10'd6:begin
                    RegWrite=1'b1;
                    ALUControl=3'b011;
                end              //or
                10'd7:begin
                    ALUControl=3'b010;
                    RegWrite=1'b1;
                end              //and
                10'd2:begin
                    RegWrite=1'b1;
                    ALUControl=3'b101;
                end              //slt
                10'd3:begin
                    ALUControl=3'b110;
                    RegWrite=1'b1;
                end               //sltu
            endcase 
            7'd19:case (func3)
                3'b000:begin
                    RegWrite=1'b1;
                    ALUSrc2=1'b1;
                end     //addi
                3'b100:begin
                    ALUControl=3'b100;
                    RegWrite=1'b1;
                    ALUSrc2=1'b1;
                end     //xori
                3'b110:begin
                    ALUControl=3'b011;
                    RegWrite=1'b1;
                    ALUSrc2=1'b1;
                end     //ori
                3'b010:begin
                    ALUControl=3'b101;
                    RegWrite=1'b1;
                    ALUSrc2=1'b1;
                end     //slti
                3'b011:begin
                    ALUControl=3'b110;
                    ALUSrc2=1'b1;
                    RegWrite=1'b1;
                end     //sltui
            endcase
            7'd3:begin
                ResultSrc=2'b01;
                ALUSrc2=1'b1;
                RegWrite=1'b1;
            end           //lw
            7'd35:begin
                MemWrite=1'b1;
                ImmSrc=3'b001;
                ALUSrc2=1'b1;
            end          //sw
            7'd99:case (func3)
                3'b000:begin
                    //PCSrc=(zero==1)? 2'b01 : 2'b00;
                    branch=1'b1;
                    ImmSrc=3'd2;
                    branch_sel=2'b00;
                end             //beq
                3'b001:begin
                    branch=1'b1;
                    //PCSrc=(zero==1)? 2'b00 : 2'b01;
                    ImmSrc=3'd2;
                    branch_sel=2'b01;
                end             //bne
                3'b100:begin
                    branch=1'b1;
                //PCSrc=(lt==1)?  2'b01: 2'b00;
                    ImmSrc=3'd2;
                    branch_sel=2'b10;

                end             //blt
                3'b101:begin
                    branch=1'b1;
                //PCSrc=(bge==1)? 2'b01: 2'b00;
                    branch_sel=2'b11;
                    ImmSrc=3'd2;
                end   //bge
            endcase
            7'd55:begin
                ImmSrc= 3'b011;
                RegWrite= 1'b1;
                ResultSrc=2'b11;
                lui=1'b1;
            end           //lui
            7'd111:begin
                PCSrc=2'b01;
                ResultSrc=2'b10;
                ImmSrc=3'b100;
                RegWrite=1'b1;
            end            //jal
            7'd103:begin
                PCSrc=2'b10;
                ResultSrc=2'b10;
                RegWrite=1'b1;
                ALUSrc2=1'b1;
            end //jalr
        endcase
    end
endmodule
