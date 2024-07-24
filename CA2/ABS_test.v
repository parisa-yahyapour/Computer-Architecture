`timescale 1ns/1ns
module ABS_test();
    wire [31:0] res1, res2;
    reg [31:0] Src1=32'd50;
    reg [31:0] Src2=32'd10;

    ABS CUT(Src1, Src2, res1, res2);
    initial begin
        #200 Src1=-32'd50;
        #200 Src2=-32'd198;
        #200 Src1=32'd69;
        #100 $stop;
    end
endmodule