`timescale 1ns/1ns
module ABS(Src1, Src2, res1, res2);
    input [31:0] Src1, Src2;
    output [31:0] res1, res2;
    reg [31:0] res1, res2;
    wire [1:0] select;
    assign select={Src1[31],Src2[31]};
    always @(*) begin
        case (select)
            2'd0: begin
                res1=Src1;
                res2=Src2;
            end
            2'd1: begin
                res1=Src1;
                res2=~(Src2)+1;
            end
            2'd2: begin
                res1=~(Src1)+1;
                res2=Src2;
            end
            2'd3: begin
                res1=~(Src1)+1;
                res2=~(Src2)+1;
            end
            default: begin
                res1=Src1;
                res2=Src2;
            end
        endcase
    end
endmodule