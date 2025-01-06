`timescale 1ps / 1ps

module testbench1();

    // Parameters
    parameter FILT_ADDR_LEN = 4;
    parameter PSUM_ADDR_LEN = 4 ;//
    parameter IF_ADDR_LEN = 4;
    parameter PSUM_SCRATCH_WIDTH = 33;
    parameter IF_SCRATCH_DEPTH = 12;
    parameter IF_SCRATCH_WIDTH = 16;
    parameter PSUM_SCRATCH_DEPTH = 16;//
    parameter FILT_SCRATCH_DEPTH = 16;
    parameter FILT_SCRATCH_WIDTH = 16;
    parameter IF_par_write = 1;
    parameter filter_par_write = 1;
    parameter outbuf_par_read = 1;
    parameter IF_BUFFER_DEPTH = 64;
    parameter FILT_BUFFER_DEPTH = 64;
    parameter OUT_BUFFER_DEPTH = 64;

    // Signals
    reg clk;
    reg rst;
    reg start;
    reg IF_wen;
    reg PSUM_wen;
    reg psum_mode;
    reg [1:0] mode;
    reg [IF_par_write * (IF_SCRATCH_WIDTH + 2) - 1 : 0] IF_din;
    reg [PSUM_SCRATCH_WIDTH - 1:0] PSUM_din;
    reg filter_wen;
    reg [filter_par_write * FILT_SCRATCH_WIDTH - 1 : 0] filter_din;
    reg outbuf_ren;
    wire [outbuf_par_read * (IF_SCRATCH_WIDTH + FILT_SCRATCH_WIDTH + 1) - 1 : 0] outbuf_dout;
    reg [outbuf_par_read * (IF_SCRATCH_WIDTH + FILT_SCRATCH_WIDTH + 1) - 1 : 0] dout_val;
    wire IF_full;
    wire IF_empty;
    wire filter_full;
    wire filter_empty;
    wire psum_full;
    wire psum_empty;
    wire outbuf_full;
    wire outbuf_empty;
    reg [FILT_ADDR_LEN - 1:0] filt_len;
    reg [IF_ADDR_LEN - 1:0] stride_len;

    // Instantiate the design_top module
    design_top #(
        .FILT_ADDR_LEN(FILT_ADDR_LEN),
        .IF_ADDR_LEN(IF_ADDR_LEN),
        .IF_SCRATCH_DEPTH(IF_SCRATCH_DEPTH),
        .IF_SCRATCH_WIDTH(IF_SCRATCH_WIDTH),
        .FILT_SCRATCH_DEPTH(FILT_SCRATCH_DEPTH),
        .FILT_SCRATCH_WIDTH(FILT_SCRATCH_WIDTH),
        .IF_par_write(IF_par_write),
        .filter_par_write(filter_par_write),
        .outbuf_par_read(outbuf_par_read),
        .IF_BUFFER_DEPTH(IF_BUFFER_DEPTH),
        .FILT_BUFFER_DEPTH(FILT_BUFFER_DEPTH),
        .OUT_BUFFER_DEPTH(OUT_BUFFER_DEPTH),
        .PSUM_ADDR_LEN(PSUM_ADDR_LEN),
        .PSUM_SCRATCH_DEPTH(PSUM_SCRATCH_DEPTH),
        .PSUM_SCRATCH_WIDTH(PSUM_SCRATCH_WIDTH)
    ) uut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .IF_wen(IF_wen),
        .PSUM_wen(PSUM_wen),
        .psum_mode(psum_mode),
        .mode(mode),
        .IF_din(IF_din),
        .PSUM_din(PSUM_din),
        .filter_wen(filter_wen),
        .filter_din(filter_din),
        .outbuf_ren(outbuf_ren),
        .outbuf_dout(outbuf_dout),
        .IF_full(IF_full),
        .IF_empty(IF_empty),
        .filter_full(filter_full),
        .filter_empty(filter_empty),
        .psum_full(psum_full),
        .psum_empty(psum_empty),
        .outbuf_full(outbuf_full),
        .outbuf_empty(outbuf_empty),
        .filt_len(filt_len),
        .stride_len(stride_len)
    );

    always @(posedge clk) begin
        if (outbuf_ren) dout_val <= outbuf_dout;
    end

    // Clock generation
    always #5 clk = ~clk;

    // Testbench logic
    integer i;
    reg [15:0] psum_values [0:15];
    reg [FILT_SCRATCH_WIDTH - 1:0] filter_inputs [0:17];
    reg [IF_SCRATCH_WIDTH + 1:0] IFmap_inputs [0:17];
    reg [PSUM_SCRATCH_WIDTH - 1:0] psum_inputs[0:17];

    initial begin
        // Initialize signals
        clk = 0;
        rst = 1;
        start = 0;
        IF_wen = 0;
        PSUM_wen = 1;
        psum_mode = 1;
        mode = 0;
        filter_wen = 0;
        outbuf_ren = 1;
        IF_din = 0;
        filter_din = 0;
        filt_len = 4;
        stride_len = 4;

        // Initialize input arrays (from CSV)
        // filter_inputs[1] = 16'b0000000000001001; IFmap_inputs[1] = 18'b000000000000100000; psum_values[1] = 16'b0001001000000001;
        filter_inputs[0] = 16'b1111111111001001; IFmap_inputs[0] = 18'b101111111111011111; psum_values[0] = 16'b0000001010000011;
        // psum_inputs[0] = 16'b101111111111011111;
        // psum_inputs[1] = 16'b000000000000000000;
        // psum_inputs[2] = 16'b000000000000100000;
        // psum_inputs[3] = 16'b001111111111100111;
        // psum_inputs[4] = 16'b001111111111011000;
        // psum_inputs[5] = 16'b001111111111101001;
        // psum_inputs[6] = 16'b000000000000111110;
        // psum_inputs[7] = 16'b001111111111100000;
        // psum_inputs[8] = 16'b010000000000100011;
        // psum_inputs[9] = 16'b100000000000000101; 
        // psum_inputs[10] = 16'b100000000001000101;                
        // psum_inputs[11] = 16'b001111111111101110;
        // psum_inputs[12] = 16'b000000000000100000;
        // psum_inputs[13] = 16'b001111111111010000;
        // psum_inputs[14] = 16'b001111111111001100;
        // psum_inputs[15] = 16'b001111111111001111;
        // psum_inputs[16] = 16'b001111111111101111;
        // psum_inputs[17] = 16'b011111111111001111;
        psum_inputs[0] =  33'd1;
        psum_inputs[1] =  33'd2;
        psum_inputs[2] =  33'd1;
        psum_inputs[3] =  33'd2;
        psum_inputs[4] =  33'd1;
        psum_inputs[5] =  33'd1;
        psum_inputs[6] =  33'd1;
        psum_inputs[7] =  33'd2;
        psum_inputs[8] =  33'd1;
        psum_inputs[9] =  33'd1; 
        psum_inputs[10] = 33'd1;                
        psum_inputs[11] = 33'd1;
        psum_inputs[12] = 33'd1;
        psum_inputs[13] = 33'd1;
        psum_inputs[14] = 33'd1;
        psum_inputs[15] = 33'd1;
        psum_inputs[16] = 33'd1;
        psum_inputs[17] = 33'd1;
        
        filter_inputs[1] = 16'b0000000000001001; IFmap_inputs[1] = 18'b000000000000000000; psum_values[1] = 16'b0001001000000001;
        filter_inputs[2] = 16'b1111111111100100; IFmap_inputs[2] = 18'bX;                psum_values[2] = 16'b1110100000110110;
        filter_inputs[3] = 16'b0000000000110110; IFmap_inputs[3] = 18'b001111111111100111; psum_values[3] = 16'b1111010110111011;
        filter_inputs[4] = 16'b0000000000011110; IFmap_inputs[4] = 18'b001111111111011000; psum_values[4] = 16'b0000001100011101;
        filter_inputs[5] = 16'bX;                IFmap_inputs[5] = 18'b001111111111101001; psum_values[5] = 16'b0001001100010101;
        filter_inputs[6] = 16'b1111111111011000; IFmap_inputs[6] = 18'b000000000000111110; psum_values[6] = 16'b0000001110100110;
        filter_inputs[7] = 16'b0000000000110100; IFmap_inputs[7] = 18'b001111111111100000; psum_values[7] = 16'b1111100101011011;
        filter_inputs[8] = 16'bX;                IFmap_inputs[8] = 18'b010000000000100011; psum_values[8] = 16'b1111000010101011;
        filter_inputs[9] = 16'b0000000000111111; IFmap_inputs[9] = 18'b100000000000000101; psum_values[9] = 16'b0000000011111001;
        filter_inputs[10] = 16'b1111111111000100; IFmap_inputs[10] = 18'bX;                psum_values[10] = 16'b1111111000010110;
        filter_inputs[11] = 16'b0000000000101110; IFmap_inputs[11] = 18'b001111111111101110; psum_values[11] = 16'b1111001000001101;
        filter_inputs[12] = 16'b0000000000011111; IFmap_inputs[12] = 18'b000000000000100000; psum_values[12] = 16'b1111011010101000;
        filter_inputs[13] = 16'b0000000000101111; IFmap_inputs[13] = 18'b001111111111010000; psum_values[13] = 16'b1111100001010100;
        filter_inputs[14] = 16'b0000000000100100; IFmap_inputs[14] = 18'b001111111111001100; psum_values[14] = 16'b0000001010111010;
        filter_inputs[15] = 16'b1111111111101101; IFmap_inputs[15] = 18'b001111111111001111; psum_values[15] = 16'b0000011010111010;
        filter_inputs[16] = 16'b1111111111001110; IFmap_inputs[16] = 18'b001111111111101111; 
        filter_inputs[17] = 16'b1111111111011011; IFmap_inputs[17] = 18'b011111111111001111; 

        // Apply reset
        #10 rst = 0;

        // Start operation
        start = 1;
        #10 start = 0;

        // Input data
        for (i = 0; i < 18; i = i + 1) begin
            if (filter_inputs[i] !== 16'bX) begin
                filter_din = filter_inputs[i];
                filter_wen = 1;
            end

            if (IFmap_inputs[i] !== 18'bX) begin
                IF_din = IFmap_inputs[i];
                IF_wen = 1;
            end
            // if (psum_inputs[i] != 33'bX)begin
            PSUM_din = psum_inputs[i];
            // PSUM_din = 33'b1;
                // PSUM_wen = i;
            // end

            #10;
            filter_wen = 0;
            IF_wen = 0;
        end

        // Read outputs
        for (i = 0; i < 16; i = i + 1) begin
            // Wait until buffer is not empty
            while (outbuf_empty) begin
                #1; // Wait for 1 time unit and recheck
            end

            outbuf_ren = 1; // Enable read
            #10;
            //$display("Time: %0t - Outbuf: %b, Psum: %b, True: %b", $time, dout_val[15:0], psum_values[i], dout_val[15:0] == psum_values[i]);
            outbuf_ren = 0; // Disable read
        end
        // End simulation
        #100 $stop;
    end

endmodule
