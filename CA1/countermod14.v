`timescale 1ns/1ns
module Counter_mod14(en, clr, clk, load, co, cnt);
    input en, clr, clk, load;
    output co;
    output [3:0] cnt;
    reg [3:0] cnt;

    always @(posedge clk or posedge clr) begin
        if (clr)
            cnt <= {4{1'b0}};
        else if (load)
            cnt <= {4'b0010};
        else if (en) 
            cnt <= cnt + 1'b1;
    end

    assign co =(cnt==4'b1111)?1'b1 :1'b0;
endmodule