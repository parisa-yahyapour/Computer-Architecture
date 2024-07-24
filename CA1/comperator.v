`timescale 1ns/1ns
module comperator_11bit(ACC, B, greater);
    parameter N = 10;

    input [N-1:0] B;
    input [N:0] ACC;

    output greater;

    assign greater= (ACC>=B) ? 1'b1 : 1'b0;
endmodule