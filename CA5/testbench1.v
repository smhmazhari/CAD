`timescale 1ps / 1ps

module testbench1();

    // Parameters
    parameter FILT_ADDR_LEN = 4;
    parameter PSUM_ADDR_LEN = 4;
    parameter IF_ADDR_LEN = 4;
    parameter PSUM_SCRATCH_WIDTH = 16;
    parameter IF_SCRATCH_DEPTH = 12;
    parameter IF_SCRATCH_WIDTH = 16;
    parameter PSUM_SCRATCH_DEPTH = 6;
    parameter FILT_SCRATCH_DEPTH = 4;
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
    reg signed [IF_par_write * (IF_SCRATCH_WIDTH + 2) - 1 : 0] IF_din;
    reg signed [PSUM_SCRATCH_WIDTH - 1:0] PSUM_din;
    reg filter_wen;
    reg signed [filter_par_write * FILT_SCRATCH_WIDTH - 1 : 0] filter_din;
    reg outbuf_ren;
    wire signed [outbuf_par_read * ( PSUM_SCRATCH_WIDTH) - 1 : 0] outbuf_dout;
    reg signed [outbuf_par_read * (PSUM_SCRATCH_WIDTH) - 1 : 0] dout_val;
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
    reg signed [15:0] psum_values [0:15];
    reg signed [FILT_SCRATCH_WIDTH - 1:0] filter_inputs [0:17];
    reg signed [IF_SCRATCH_WIDTH + 1:0] IFmap_inputs [0:17];
    reg signed [PSUM_SCRATCH_WIDTH - 1:0] psum_inputs[0:17];

    initial begin
        // Initialize signals
        filt_len = 4;//check
        clk = 0;
        rst = 1;
        start = 0;
        IF_wen = 0;
        PSUM_wen = 0;
        psum_mode = 0;
        mode = 2;//check
        filter_wen = 0;
        outbuf_ren = 0;
        IF_din = 0;
        filter_din = 0;
        stride_len = 1;
        
        // Initialize input arrays (from CSV)
        filter_inputs[0] = -2; IFmap_inputs[0] = 18'sb100000000000000001;//16'sd1
        psum_inputs[0] =  33'sd1;
        psum_inputs[1] =  33'sd2;
        psum_inputs[2] =  33'sd1;
        psum_inputs[3] =  33'sd2;
        psum_inputs[4] =  33'sd1;
        psum_inputs[5] =  33'sd1;
        psum_inputs[6] =  33'sd1;
        psum_inputs[7] =  33'sd2;
        psum_inputs[8] =  33'sd1;
        psum_inputs[9] =  33'sd1; 
        psum_inputs[10] = 33'sd1;                
        psum_inputs[11] = 33'sd1;
        psum_inputs[12] = 33'sd1;
        psum_inputs[13] = 33'sd1;
        psum_inputs[14] = 33'sd1;
        psum_inputs[15] = 33'sd1;
        psum_inputs[16] = 33'sd1;
        psum_inputs[17] = 33'sd1;
        
        filter_inputs[1] = -3; IFmap_inputs[1] = 18'sb001111111111100101; 
        filter_inputs[2] = -4; IFmap_inputs[2] = 18'sb000000000000000000;               
        filter_inputs[3] = -5; IFmap_inputs[3] = 18'sb000000000000000011;
        filter_inputs[4] = 16'sd5; IFmap_inputs[4] = 18'sb010000000000010000; 
        filter_inputs[5] = 16'sd6;                IFmap_inputs[5] = 18'sb010000000000000001; 
        filter_inputs[6] = 16'sd7; IFmap_inputs[6] = 18'sb000000000000000010; 
        filter_inputs[7] = 16'sd8; IFmap_inputs[7] = 18'sb010000000000000111; 
        filter_inputs[8] = 16'sbx;                IFmap_inputs[8] = 18'sb010000000000100011; 
        filter_inputs[9] = 16'sb0000000000111111; IFmap_inputs[9] = 18'sb100000000000000101; 
        filter_inputs[10] = 16'sb1111111111000100; IFmap_inputs[10] = 18'sbx;                
        filter_inputs[11] = 16'sb0000000000101110; IFmap_inputs[11] = 18'sb001111111111101110; 
        filter_inputs[12] = 16'sb0000000000011111; IFmap_inputs[12] = 18'sb000000000000100000; 
        filter_inputs[13] = 16'sb0000000000101111; IFmap_inputs[13] = 18'sb001111111111010000; 
        filter_inputs[14] = 16'sb0000000000100100; IFmap_inputs[14] = 18'sb001111111111001100; 
        filter_inputs[15] = 16'sb1111111111101101; IFmap_inputs[15] = 18'sb001111111111001111; 
        filter_inputs[16] = 16'sb1111111111001110; IFmap_inputs[16] = 18'sb001111111111101111; 
        filter_inputs[17] = 16'sb1111111111011011; IFmap_inputs[17] = 18'sb011111111111001111; 

        // Apply reset
        #10 rst = 0;

        // Start operation
        start = 1;
        #10 start = 0;
        for (i = 0; i < filt_len; i = i + 1) begin
            filter_din = filter_inputs[i];
            filter_wen = 1;
            #10;
            filter_wen = 0;
        end
        #100;

        //psum
        for (i = 0; i < PSUM_SCRATCH_DEPTH; i = i + 1) begin //check 
            if (psum_inputs[i] !== 16'sbx) begin
                PSUM_din = psum_inputs[i];
                PSUM_wen = 1;
            end    
            #10;
            PSUM_wen = 0;
        end

        // Input data
        for (i = 0; i < 5; i = i + 1) begin //check 
            if (IFmap_inputs[i] !== 18'sbx) begin
                IF_din = IFmap_inputs[i];
                IF_wen = 1;
            end
            #10;
            IF_wen = 0;
            
        end
        #1000 psum_mode = 1;
        // Read outputs
        for (i = 0; i < 16; i = i + 1) begin
            while (outbuf_empty) begin
                #1;
            end
            outbuf_ren = 1;
            #10;
            outbuf_ren = 0;
        end
        #100 $stop;
    end

endmodule
