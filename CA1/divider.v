`timescale 1ns/1ns
module divider(a_in, b_in, clk, sclr, start, q_out, dvz, ovf, busy, valid);
    input [9:0] a_in, b_in;
    input start,clk,sclr;
    output [9:0] q_out;
    output dvz,ovf,busy,valid;

    wire shift_A,load_A,load_ACC,clear_ACC,shift_ACC,clear_Q,shift_Q,q_serial,load_B,
        enable_c,load_c, greater,zero_status,co,overflow;
    wire [3:0] cnt;
    data_path dp(.a_in(a_in),.b_in(b_in),.q_out(q_out),.clk(clk),.clr(sclr),.shift_A(shift_A),
                .load_A(load_A),.load_ACC(load_ACC),.clear_ACC(clear_ACC),
                .shift_ACC(shift_ACC),.clear_Q(clear_Q),.shift_Q(shift_Q),
                .q_serial(q_serial),.load_B(load_B),.enable_c(enable_c),
                .load_c(load_c),.greater(greater),.zero_status(zero_status),
                .co(co),.cnt(cnt),.overflow(overflow));
    divider_controller controller(.start(start),.clock(clk),.sclr(sclr),
                                .overflow_time(cnt),.overflow_detected(overflow),
                                .valid_devision(zero_status),.gt(greater),
                                .complete_divide(cnt),.valid(valid),.loadA(load_A),
                                .loadB(load_B),.clearQ(clear_Q),.clearACC(clear_ACC),
                                .q_serial(q_serial),.shift_enable_A(shift_A),
                                .shifht_enable_ACC(shift_ACC),.loadACC(load_ACC),
                                .count_up(enable_c),.load_counter(load_c),.busy(busy),
                                .ovf(ovf),.dvz(dvz), .shift_enable_q(shift_Q));
endmodule