`timescale 1ns/1ns
module register_10bit(load, data_B, clk, sclr, clr, parout);
    parameter N = 10;

    input load, clk, clr,sclr;
    input [N-1:0] data_B;
    output [N-1:0] parout;
    reg [N-1:0] parout;

    always @(posedge clk or posedge clr) begin
        if (clr)
            parout <= {N{1'b0}};
        else if (sclr)
            parout <= {N{1'b0}};
        else if (load)
            parout <= data_B;
    end
endmodule