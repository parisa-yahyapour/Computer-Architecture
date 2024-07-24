`timescale 1ns/1ns
// shift left
module shiftregister_10bit_left (data_in, ser_in, clr, sclr, load, shift_s, clk, data_out);

  parameter N = 10;
  input [N-1:0] data_in;
  input ser_in, sclr, load, shift_s, clk,clr;
  output [N-1:0] data_out;
  reg [N-1:0] data_out;
  
  always @(posedge clk or posedge clr)
    if (clr) 
      data_out <= {N{1'b0}};
    else if (sclr)
      data_out <= {N{1'b0}};
    else if (load)
      data_out <= data_in;
    else if (shift_s)
      data_out <= {data_out[8:0],ser_in};
        
endmodule
//shift right
// module shiftregister_10bit_right (data_in, ser_in, sclr, load, shift_s, clk, data_out);

//   parameter N = 10;
//   input [N-1:0] data_in;
//   input ser_in, sclr, load, shift_s, clk;
//   output [N-1:0] data_out;
//   reg [N-1:0] data_out;
  
//   always @(posedge clk)
//     if (sclr)
//       data_out <= {N{1'b0}};
//     else if (load)
//       data_out <= data_in;
//     else if (shift_s)
//       data_out <= {ser_in,data_out[9:1]};
        
// endmodule