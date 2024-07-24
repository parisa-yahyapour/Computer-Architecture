`timescale 1ns/1ns
module data_path (
    a_in,b_in,q_out,clk,clr,
    shift_A,load_A,load_ACC,clear_ACC,shift_ACC,clear_Q,shift_Q,q_serial,load_B,
    enable_c,load_c,
    greater,zero_status,co,cnt,overflow
);
    input [9:0] a_in, b_in;
    input clk, clr,shift_A,load_A,load_ACC,clear_ACC,shift_ACC,clear_Q,shift_Q,q_serial,load_B,load_c;
    input enable_c;
    output [9:0] q_out;
    output [3:0] cnt;
    output greater,zero_status,co,overflow;
    wire [9:0]a_out,b_out,sum,result;
    wire [10:0] ACC_out;
    shiftregister_10bit_left dividend(a_in,1'b0, clr, clr, load_A, shift_A, clk, a_out);
    register_10bit divisor(load_B ,b_in, clk,1'b0, clr,b_out);
    shiftregister_11bit_left ACC({1'b0,sum}, a_out[9], clear_ACC, clr, load_ACC, shift_ACC, clk, ACC_out);
    shiftregister_10bit_left quotient( {10{1'b0}}, q_serial, clr, clear_Q, 1'b0, shift_Q, clk, q_out);
    subtractor_11bit subtract(ACC_out, b_out, sum);
    comperator_11bit comparetor(ACC_out, b_out, greater);
    Counter_mod14 count_up(enable_c, clr, clk, load_c, co, cnt);
    assign zero_status=~|b_out;
    assign overflow=~|q_out[9:4];
endmodule