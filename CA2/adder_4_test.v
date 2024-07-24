`timescale 1ns/1ns
module adder_4_test();
    wire [31:0] PCPlus4;
    reg [31:0] PC=32'd50;
    adder_4 CUT(PC,PCPlus4);
    initial begin
        #120 PC=32'd25;
        #120 PC=32'd50;
        #120 PC=32'd90;
        #120 PC=32'd125;
        #120 PC=32'd1002;
        #800 $stop;
    end
endmodule