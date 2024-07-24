`timescale 1ns/1ns
module bench_test();
    reg rst = 1'b1 , clk = 1'b1 ;
    always #35 clk=~clk;
    risc_v CUT(clk ,rst);

    initial begin
        #5 rst=1'b0;
        #50000 $stop;
    end
endmodule