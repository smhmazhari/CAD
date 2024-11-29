`timescale 1ns / 1ps

module mult_testbench;

  // Testbench signals
  reg [7:0] D1;
  reg [7:0] D2;
  wire [15:0] out;
  
  // Instantiate the Device Under Test (DUT)
  mult dut(
    .D1(D1), 
    .D2(D2), 
    .out(out)
  );

  // Initial block starts only once at the very beginning of simulation
  initial begin
    // Initialize Inputs
    D1 = 0;
    D2 = 0;

    // Wait for global reset
    #100;
    
    // Apply some test vectors
    D1 = 8'b01000000; D2 = 8'b10010000; #100; // Test small numbers
    D1 = 8'b10010000; D2 = 8'b01001000; #100; // Test with some 1s and 0s
    D1 = 8'b11111000; D2 = 8'b11111000; #100; // Test all 1s
    D1 = 8'b10001000; D2 = 8'b10001000; #100; // Test edge values
    D1 = 8'b01111000; D2 = 8'b00010000; #100; // Test random values
    $stop;
    // Add more test cases as necessary
  end
  


endmodule
