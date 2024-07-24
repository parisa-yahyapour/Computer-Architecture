`define Idle 4'b0000
`define Load_Data 4'b0001
`define Check_Dividing_By_Zero 4'b0010
`define Shift 4'b0011
`define Compare 4'b0100
`define Greater 4'b0101
`define Less 4'b0110
`define Check_Overflow_Time 4'b0111
`define Check_Overflow 4'b1000
`define No_Overflow 4'b1001
`define Next_Division 4'b1010
`define Done 4'b1011
`define Overflow 4'b1100
`define Zero_Divisor 4'b1101
`timescale 1ns/1ns
module divider_controller(start, clock, sclr,overflow_time, overflow_detected, valid_devision, gt, complete_divide, valid, loadA, loadB, clearQ,
                        clearACC, q_serial, shift_enable_A, shifht_enable_ACC, loadACC, count_up,shift_enable_q, load_counter, busy, ovf, dvz);
    input start, clock, sclr, overflow_detected, valid_devision, gt;
    input [3:0] overflow_time,complete_divide;
    output valid, loadA, loadB, clearQ, clearACC, shift_enable_A, shifht_enable_ACC, q_serial, loadACC, count_up,shift_enable_q, load_counter, busy, ovf, dvz;
    reg [3:0] ps, ns;
    reg loadA, loadB, clearQ, clearACC, shift_enable_A, shifht_enable_ACC, q_serial, loadACC, count_up, load_counter, busy, ovf, dvz, valid, shift_enable_q;

    always @(posedge clock) begin
        if (sclr)
            ps <= 4'b0000;
        else
            ps <= ns;
    end

    always @(ps or start or valid_devision or gt or overflow_detected or overflow_time or complete_divide) begin
        case (ps)
            `Idle: ns = start ? `Load_Data : `Idle ;
            `Load_Data: ns = `Check_Dividing_By_Zero;
            `Check_Dividing_By_Zero: ns = valid_devision ? `Zero_Divisor : `Shift;
            `Zero_Divisor: ns = `Idle;
            `Shift: ns = `Compare;
            `Compare: ns = gt ? `Greater : `Less;
            `Greater: ns = `Check_Overflow_Time;
            `Less: ns = `Check_Overflow_Time;
            `Check_Overflow_Time: ns = (overflow_time == 4'b1001) ? `Check_Overflow : `No_Overflow;
            `Check_Overflow: ns = overflow_detected ? `No_Overflow : `Overflow;
            `Overflow: ns = `Idle; 
            `No_Overflow: ns = `Next_Division;
            `Next_Division: ns = (complete_divide == 4'b1111) ? `Done : `Compare;
            `Done: ns = `Idle;
            default: ns = `Idle;
        endcase
    end

    always @(ps) begin
        {loadA,loadB,clearQ,clearACC, busy, load_counter, dvz, shift_enable_A,shifht_enable_ACC, q_serial, loadACC, ovf, count_up,shift_enable_q, valid} = 15'b0;
        case (ps)
            `Idle:;
            `Load_Data: {loadA,loadB,clearQ,clearACC, busy} = 5'b11111;
            `Check_Dividing_By_Zero: {load_counter, busy} = 2'b11;
            `Zero_Divisor: {busy, dvz} = 2'b11;
            `Shift: {shift_enable_A,shifht_enable_ACC, busy} = 3'b111;
            `Compare:busy = 1'b1;
            `Greater: {q_serial, loadACC, busy, shift_enable_q} = 4'b1111;
            `Less:{busy, shift_enable_q} = 2'b11;
            `Check_Overflow_Time:busy = 1'b1;
            `Check_Overflow: busy = 1'b1;
            `Overflow: {ovf, busy} = 2'b11;
            `No_Overflow: {shift_enable_A,shifht_enable_ACC, busy} = 3'b111;
            `Next_Division: {count_up, busy} = 2'b11;
            `Done: {valid, busy} = 2'b11;
            default:;
        endcase
    end
endmodule