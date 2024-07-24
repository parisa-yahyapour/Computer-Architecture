`timescale 1ns/1ns
module adder_imm_test();
    wire [31:0] PCTarget;
    reg [31:0] PC=32'd50;
    reg [31:0] immediate_data=32'd10;

    adder_imm CUT(PC, immediate_data, PCTarget);
    initial begin
        #120 PC=32'd25;
        #120 immediate_data=32'd50;
        #120 PC=32'd90;
        #120 immediate_data=32'd125;
        #120 PC=32'd1002;
        #120 immediate_data=32'd12;

        #800 $stop;
    end
endmodule