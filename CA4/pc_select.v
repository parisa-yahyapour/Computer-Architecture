`timescale 1ns/1ns
module pc_select (select, Src1, Src2, Src3, Src4, PCSrc_undone,branch, out);
    input [1:0]select,PCSrc_undone;
    input  Src1, Src2, Src3, Src4,branch;
    output[1:0] out;
    reg[1:0] out;
    always @(*) begin
        case (select)
            2'd0: out= (Src1 & branch)?2'b01:PCSrc_undone;
            2'd1: out= (~Src2  &branch )?2'b01:PCSrc_undone;
            2'd2: out= (Src3 & branch)?2'b01:PCSrc_undone;
            2'd3: out= (Src4 & branch)?2'b01:PCSrc_undone;
            default: out=1'd0;
        endcase
    end
endmodule