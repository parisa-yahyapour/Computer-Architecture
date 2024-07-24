`timescale 1ns/1ns
module controller_test();
    reg [6:0] opcode=7'd51;
    reg [2:0] func3=3'd0;
    reg [6:0] func7=7'd0;
    reg zero=1'b0, bge=1'b0, lt=1'b0;
    wire MemWrite, ALUSrc1, RegWrite, Abs_src;
    wire [1:0] PCSrc, ResultSrc, ALUSrc2;
    wire [2:0] ALUControl, ImmSrc;
    controller CUT(opcode, func3, func7, zero, bge, lt, 
                    PCSrc, ResultSrc, MemWrite, ALUControl, ALUSrc1, ALUSrc2, ImmSrc, RegWrite, Abs_src);
    initial begin
        // add
        #100 func7=7'd32; //sub
        #100 begin 
            func3=3'd7;
            func7=7'd0;
         end //and
        #100 func3=3'd6; //or
        #100 func3=3'd2; //slt
        #100 func3=3'd3; //sltu
        #100 opcode=7'd3; //lw
        #100 begin
           opcode=7'd19;
           func3=3'd0; 
        end //addi
        #100 func3=3'd4; //xori
        #100 func3=3'd6; //ori
        #100 func3=3'd2; //slti
        #100 func3=3'd3; //sltui
        #100 func3=3'd1; //jalr
        #100 opcode=7'd35; // sw
        #100 opcode=7'd111; //jal
        #100 func3=3'd0; 
        #100 opcode=7'd99; //beq
        #100 zero= 1'b1;
        // #100 opcode=7'd99; //beq
        #100 func3=3'd1; //bne
        #100 zero=1'b0;
        #100 bge=1'b1;
        #100 func3=3'd5; //bge
        #100 func3=3'd4; //blt
        #100 lt=1'b1;
        #100 opcode=7'd55; //lui
        #100 $stop;
    end
endmodule