`timescale 1ns / 1ns

module top_module_tb;

    // Parameters
    parameter PAR_WRITE = 2;
    parameter PAR_READ = 4;
    parameter BUFFER_SIZE = 16;
    parameter BUFFER_ADDR = 3;

    // Testbench signals
    reg clk=1'b0;
    reg rst;
    reg read_en;
    reg write_en;
    reg [PAR_WRITE * BUFFER_SIZE - 1 : 0] data_in;  // Data input with width defined by PAR_WRITE and BUFFER_SIZE
    wire [PAR_READ * BUFFER_SIZE - 1 : 0] data_out; // Data output
    wire full;
    wire empty;
    wire valid;
    wire ready;

    // Instantiate the top_module
    top_module #(
        .PAR_WRITE(PAR_WRITE),
        .PAR_READ(PAR_READ),
        .BUFFER_SIZE(BUFFER_SIZE),
        .BUFFER_ADDR(BUFFER_ADDR)
    ) uut (
        .clk(clk),
        .rst(rst),
        .read_en(read_en),
        .write_en(write_en),
        .data_in(data_in),
        .data_out(data_out),
        .full(full),
        .empty(empty),
        .valid(valid),
        .ready(ready)
    );


    always #5 clk = ~clk; // 10 time units period


    // Test stimulus
    initial begin
        // Initialize signals
        rst = 1; // Start with reset
        read_en = 0;
        write_en = 0;
        data_in = 0;

        // Apply reset
        #10;
        rst = 0; // Release reset
        #10;

        // Test Case 1: Write data into FIFO
        write_en = 1;
        data_in = {16'b0000_0000_0000_0001, 16'b0000_0000_0000_0010}; // Example data to write
        #10;
        write_en = 0; // Disable writing

        // Test Case 2: Read data from FIFO
        read_en = 1;
        #10;
        read_en = 0; // Disable reading

        // Test Case 3: Check FIFO status


        // Test Case 4: Reset FIFO
        rst = 1; // Assert reset
        #10;
        rst = 0; // De-assert reset

        // End of tests
        $finish;
    end

endmodule
