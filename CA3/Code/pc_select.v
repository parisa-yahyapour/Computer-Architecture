`timescale 1ns/1ns
module pc_select (select, Src1, Src2, Src3, Src4, out);
    input [1:0]select;
    input  Src1, Src2, Src3, Src4;
    output out;
    reg out;
    always @(*) begin
        case (select)
            2'd0: out= Src1;
            2'd1: out= Src2;
            2'd2: out= Src3;
            2'd3: out= Src4;
            default: out=1'd0;
        endcase
    end
endmodule