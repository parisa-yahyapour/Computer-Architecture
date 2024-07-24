`timescale 1ns/1ns
module mux2_test();
    wire [31:0] out;
    reg [31:0] Src1=32'd50;
    reg [31:0] Src2=32'd10;
    reg select=1'b1;
    mux2 CUT(select, Src1, Src2, out);
    initial begin
        #100 select=1'b0;
        #100 $stop;
    end
endmodule