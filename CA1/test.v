`timescale 1ns/1ns
module test_bench1 ();
    reg [9:0] a_in,b_in;
    wire[9:0] q_out;
    reg sclr=1'b0,clk=1'b0,start=1'b0;
    wire dvz,ovf,busy,valid;
    always #60 clk=~clk;
    divider d(a_in,b_in,clk,sclr,start,q_out,dvz,ovf,busy,valid);
    initial begin
        // 5/2 =2.5
        #10 start=1'b1;
        #120 a_in=10'b0001010000;b_in=10'b0000100000;
        #9100;
        start = 0;
        // 18 / 6 = 3
        #10 start=1'b1;
        #120 a_in=10'b0100100000;b_in=10'b0000110000;
        #9100;$stop;
    end
endmodule
