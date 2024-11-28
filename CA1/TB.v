`timescale 1ns / 1ns
module TB();
    // Parameters
    reg clk = 1'b1;
    reg start=1'b0;
    reg rst=1'b0;
    wire Done;

    // Instantiate the app_mult module
    app_mult uut (
        .clk(clk),
        .start(start),
        .rst(rst),
        .Done(Done)
    );
    // Clock generation
    always #10 clk = ~clk;    

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
        #50; // Wait for one clock cycle
        start = 0; // De-assert start

        // Wait for Done signal
        
        #100000; // Wait for a short time

        $finish;
    end
endmodule