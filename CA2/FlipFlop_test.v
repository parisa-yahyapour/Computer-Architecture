`timescale 1ns/1ns
module FlipFlop_test();
    reg rst = 1'b0 , clk = 1'b0 ;
    wire [31:0] PC;
    reg [31:0] PCNext=32'd50;
    FlipFlop CUT(clk,rst,PCNext,PC);
    always #60 clk=~clk;
    initial begin
        #120 PCNext=32'd25;
        #120 PCNext=32'd58;
        #120 PCNext=32'd98;
        #120 PCNext=32'd125;
        #120 PCNext=32'd1002;
        #800 $stop;
    end
endmodule