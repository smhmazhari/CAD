module FDCP(
  input clk , CLR, D, 
  output reg Q);

  always @(posedge clk or posedge CLR)
    if(CLR)
      Q <= 0;
    else
      Q <= D;
endmodule
