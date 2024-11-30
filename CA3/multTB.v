`timescale 1ns / 1ps

module mult_testbench;

  reg [7:0] D1;
  reg [7:0] D2;
  wire [15:0] out;  
  
  mult dut(
    .D1(D1), 
    .D2(D2), 
    .out(out)
  );

  initial begin
  
    D1 = 0;
    D2 = 0;
  
    #100;    
  
    D1 = 8'b01000000; D2 = 8'b10010000; #100; 
    D1 = 8'b10010000; D2 = 8'b01001000; #100;
    D1 = 8'b11111000; D2 = 8'b11111000; #100; 
    D1 = 8'b10001000; D2 = 8'b10001000; #100; 
    D1 = 8'b01111000; D2 = 8'b00010000; #100; 
    $stop;
  
  end
  
endmodule
