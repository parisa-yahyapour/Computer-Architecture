`timescale 1ns/1ns
module mux5_test();
    wire [31:0] out;
    reg [31:0] Src1=32'd50;
    reg [31:0] Src2=32'd10;
    reg [31:0] Src3=32'd128;
    reg [31:0] Src4=32'd998;
    reg [31:0] Src5=32'd225;

    reg [2:0]select=3'd1;
    mux5 CUT(select, Src1, Src2, Src3, Src4, Src5, out);
    initial begin
        #100 select=3'd0;
        #100 select=3'd3;
        #100 select=3'd5;
        #100 select=3'd2;
        #100 select=3'd4;
        #100 $stop;
    end
endmodule