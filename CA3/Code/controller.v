`timescale 1ns/1ns
`define Fetch            4'b0000
`define Decode           4'b0001
`define Execute_R        4'b0010
`define ALUWB1           4'b0011
`define Execute_I        4'b0100
`define Jal              4'b0101
`define Jalr             4'b0110
`define Execute_jalr     4'b0111
`define Sw               4'b1000
`define Write_memory     4'b1001
`define Make_address     4'b1010
`define Lw               4'b1011
`define ALUWB2           4'b1100
`define Check_condition  4'b1101
`define Lui              4'b1110

module controller (clk, rst,opcode, func3, func7, zero, bge, lt, PCWrite, AdrSrc, MemWrite, IRWrite, ResultSrc, ALUControl, 
                    ALUSrcA, ALUSrcB, ImmSrc, RegWrite, branch, sel_branch);
    input [6:0] opcode;
    input [2:0] func3;
    input [6:0] func7;
    input zero, bge, lt, clk, rst;

    output  MemWrite, RegWrite, PCWrite, AdrSrc, IRWrite, branch;
    output [1:0] ResultSrc, ALUSrcA, ALUSrcB, sel_branch;
    output [2:0] ALUControl, ImmSrc;

    reg [3:0] ps, ns;

    reg MemWrite, RegWrite, PCWrite, AdrSrc, IRWrite,branch;
    reg [1:0] ResultSrc, ALUSrcA, ALUSrcB, sel_branch;
    reg [2:0] ALUControl, ImmSrc;

    always @(posedge clk or posedge rst) begin
        if (rst)
            ps <= 4'd0;
        else
            ps <= ns;
    end

    always @(ps or opcode or func3 or func7) begin
        case (ps)
            `Fetch:  ns = `Decode;
            `Decode: ns =  (opcode == 7'b0110011) ? `Execute_R :
                           (opcode == 7'b0010011) ? `Execute_I :
                           (opcode == 7'b1101111) ? `Jal :
                           (opcode == 7'b1100111) ? `Jalr :
                           (opcode == 7'b0100011) ? `Sw :
                           (opcode == 7'b0000011) ? `Make_address :
                           (opcode == 7'b0110111) ? `Lui :
                           (opcode == 7'b1100011) ? `Check_condition : `Fetch;
            `Execute_R:       ns = `ALUWB1;
            `ALUWB1:          ns = `Fetch;
            `Execute_I:       ns = `ALUWB1;
            `Jal:             ns = `ALUWB1;
            `Jalr:            ns = `Execute_jalr;
            `Execute_jalr:    ns = `ALUWB1;
            `Sw:              ns = `Write_memory;
            `Write_memory:    ns = `Fetch;
            `Make_address:    ns = `Lw;
            `Lw:              ns = `ALUWB2;
            `ALUWB2:          ns = `Fetch;
            `Lui:             ns = `Fetch;
            `Check_condition: ns = `Fetch;
            default:          ns = `Fetch;
        endcase
        
    end
    always @(ps) begin
        {MemWrite, RegWrite, PCWrite, AdrSrc, IRWrite} = 5'd0;
        {ResultSrc, ALUSrcA, ALUSrcB} = 6'd0;
        {ALUControl, ImmSrc} = 6'd0;
        branch=1'b0;
        sel_branch=2'd0;
        case (ps)
            `Fetch: begin
                IRWrite <= 1'b1;
                PCWrite <=1'b1;
                ALUSrcB <= 2'b10;
                ResultSrc <= 2'b10;
            end
            `Decode: begin
                ALUSrcA <= 2'b01;
                ALUSrcB <= 2'b01;
                if (opcode == 7'b1100011) begin //b type
                    ImmSrc = 3'b010;
                end
                else begin
                    ImmSrc = 3'b100;
                end
            end
            `Execute_R: begin
                ALUSrcA = 2'b10;
                if (func3 == 3'b000) begin
                    if (func7 == 7'b0000000) begin
                        ALUControl = 3'b000; //add
                    end
                    else begin
                        ALUControl = 3'b001;//sub
                    end
                end
                else if (func3 == 3'b110) begin//or
                    ALUControl = 3'b011;
                end
                else if (func3 == 3'b111) begin
                    ALUControl = 3'b010;//and
                end
                else if (func3 == 3'b010) begin
                    ALUControl = 3'b101;//slt
                end
                else begin
                    ALUControl = 3'b 110;//sltu
                end
            end
            `ALUWB1: begin 
                RegWrite = 1'b1;
            end
            `Execute_I: begin
                ALUSrcA = 2'b10;
                ALUSrcB = 2'b01;
                if (func3 == 3'd0) begin//addi
                    ALUControl = 3'b000;
                end
                else if (func3 == 3'd4) begin//xori
                    ALUControl = 3'b100;
                end
                else if (func3 == 3'd6) begin//ori
                    ALUControl = 3'b011;
                end
                else if (func3 == 3'd2) begin//slti
                    ALUControl = 3'b101;
                end
                else begin//slti
                    ALUControl = 3'b110;//sltui
                end
            end
            `Jal: begin
                ALUSrcA = 2'b01;
                ALUSrcB = 2'b10;
                PCWrite = 1'b1;
            end
            `Jalr: begin
                ALUSrcA = 2'b10;
                ALUSrcB = 2'b01;
                ImmSrc = 3'b000;
            end
            `Execute_jalr: begin
                PCWrite = 1'b1;
                ALUSrcA = 2'b01;
                ALUSrcB = 2'b10;
            end
            `Sw: begin
                ALUSrcA = 2'b10;
                ALUSrcB = 2'b01;
                ImmSrc = 3'b001;
                ALUControl = 3'b000;
            end
            `Write_memory: begin
                {MemWrite, AdrSrc} = 2'b11;
            end
            `Make_address: begin
                ALUSrcA = 2'b10;
                ALUSrcB = 2'b01;
            end
            `Lw: AdrSrc = 1'b1;
            `ALUWB2: begin
                ResultSrc = 2'b01;
                RegWrite = 1'b1;
            end
            `Lui: begin
                ImmSrc = 3'b011;
                ResultSrc = 2'b11;
                RegWrite = 1'b1;
            end
            `Check_condition: begin
                ALUSrcA = 2'b10;
                ALUControl = 3'b001;
                ResultSrc = 2'b00;
                if (func3 == 3'd0) begin//beq  
                    sel_branch=2'b00;
                    branch=1'b1;
                end
                else if (func3 == 3'd1) begin//bne
                    sel_branch=2'b01;
                    branch=1'b1;
                end
                else if (func3 == 3'd4) begin//blt
                    sel_branch=2'b10;
                    branch=1'b1;
                end
                else if (func3 == 3'd5) begin //bge
                    branch=1'b1;
                    sel_branch=2'b11;
                end
            end
        endcase
        
    end
endmodule
