`timescale 1ns/1ns
module extension_test();
    wire [31:0] instruction, ImmExt;
    reg [2:0] ImmSrc = 3'b000;
    assign instruction = 32'b01011111000010100111000110100101;
    extension_unit CUT(instruction, ImmSrc, ImmExt);
    initial begin
        #200 ImmSrc = 3'b001;
        #200 ImmSrc = 3'b010;
        #200 ImmSrc = 3'b011;
        #200 ImmSrc = 3'b100;
        #200 ImmSrc = 3'b101;
        #200;
    end
endmodule