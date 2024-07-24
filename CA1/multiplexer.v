`timescale 1ns/1ns
module multiplexer_1bit(select,out);
    input select;
    output out;

    assign out= (select) ? 1'b1 : 1'b0;
endmodule