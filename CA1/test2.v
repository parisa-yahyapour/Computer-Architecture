`timescale 1ns/1ns
module test_bench2 ();
    reg [9:0] a_in,b_in;
    wire[9:0] q_out;
    reg sclr=1'b0,clk=1'b0,start=1'b0;
    wire dvz,ovf,busy,valid;
    always #60 clk=~clk;
    divider d(a_in,b_in,clk,sclr,start,q_out,dvz,ovf,busy,valid);
    initial begin
        // 20 / 0 = zero
        #10 start=1'b1;
        #120 a_in=10'b0101000000;b_in=10'b0000000000;
        #600;$stop;
    end
endmodule
