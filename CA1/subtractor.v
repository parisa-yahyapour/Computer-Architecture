`timescale 1ns/1ns
module subtractor_11bit(ACC, B, result);
    parameter N = 10;

    input [N-1:0] B;
    input [N:0] ACC;
    output [N-1:0] result;
    wire co;
    assign {co,result} = ACC-{1'b0,B};
endmodule
// alternative one
// module subtractor_11bit(A, B, result);
//     parameter N = 11;

//     input [N-1:0] A;
//     inout [N-2:0] B;
//     output [N-1:0] result;

//     assign result = A - {1'b0,B};
// endmodule