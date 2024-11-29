`timescale 1ns / 1ns
module TB();
    // Parameters
    reg clk = 1'b1;
    reg start=1'b0;
    reg rst=1'b1;
    reg[15:0] A;
    reg[15:0] B;
    wire Done;
    wire[15:0] result;


    // Instantiate the app_mult module
    app_mult uut (
        .clk(clk),
        .start(start),
        .rst(rst),
        .Done(Done),
        .A(A),
        .B(B),
        .Result(result)
    );
    // Clock generation
    always #5 clk = ~clk;    

    // Test procedure
    initial begin
        // Initialize signals
        #7
        rst = 1;  // Assert reset
        start = 0;
        #10;
        
        // De-assert reset
        rst = 0;
        #10;

        // Test Case 1: Start multiplication
        start = 1;
        A = 16'b0010000000000000;
        B = 16'b0000000001000000;
        #50; // Wait for one clock cycle
        start = 0; // De-assert start

        // Wait for Done signal
        
        #100000; // Wait for a short time

        $finish;
    end
endmodule