module design_datapath #(
    parameter FILT_ADDR_LEN,
    parameter IF_ADDR_LEN,
    parameter IF_SCRATCH_DEPTH,
    parameter IF_SCRATCH_WIDTH,
    parameter FILT_SCRATCH_DEPTH,
    parameter FILT_SCRATCH_WIDTH,
    parameter PSUM_ADDR_LEN,
    parameter PSUM_SCRATCH_DEPTH,
    parameter PSUM_SCRATCH_WIDTH
    ) 
    (
    input wire clk,rst,
    input wire psum_mode,
    input wire [1:0] mode,
    input wire IF_read_start,
    input wire filter_read_start,
    input wire regs_clr,
    input wire IF_buf_empty_flag,
    input wire filt_buf_empty,
    input wire start_rd_gen,
    input wire outbuf_full,
    input wire [FILT_ADDR_LEN - 1:0] filt_len,
    input wire [IF_ADDR_LEN - 1:0] stride_len,
    input wire [IF_SCRATCH_WIDTH + 1:0] IF_buf_inp,
    input wire [FILT_SCRATCH_WIDTH - 1:0] filt_buf_inp,
    input wire [PSUM_SCRATCH_WIDTH-1:0] psum_buf_inp,
    output wire [IF_SCRATCH_WIDTH + FILT_SCRATCH_WIDTH:0] module_outval,
    output wire IF_buf_read,
    output wire filt_buf_read,
    output wire full_done,
    output wire psum_done,
    output wire stride_count_flag,
    output wire outbuf_write
);

    // Wire declarations
    wire IF_scratch_wen, IF_end_valid;
    wire [IF_ADDR_LEN - 1:0] start_IF, end_IF, IF_waddr, IF_raddr;
    wire [FILT_ADDR_LEN - 1:0] filt_waddr, filt_raddr;
    wire filt_scratch_wen, filt_ready;
    wire read_from_scratch, done, stall_pipeline;
    wire [IF_SCRATCH_WIDTH - 1:0] IF_scratch_out, IF_scratch_reg_out;
    wire [FILT_SCRATCH_WIDTH - 1:0] filt_scratch_out;
    wire [IF_SCRATCH_WIDTH + FILT_SCRATCH_WIDTH - 1:0] mult_inp, mult_reg_out;
    wire [IF_SCRATCH_WIDTH + FILT_SCRATCH_WIDTH:0] add_inp;//, add_reg_out

    
    // zero detector
    wire zero_stall;
    assign zero_stall = (IF_buf_inp == 0)? 1'b1: 1'b0;//check
    // IF Read Module
    IF_read_module #(
        .ADDR_LEN(IF_ADDR_LEN),
        .SCRATCH_DEPTH(IF_SCRATCH_DEPTH),
        .SCRATCH_WIDTH(IF_SCRATCH_WIDTH)
    ) if_reader (
        .clk(clk),
        .rst(rst),
        .start(IF_read_start),
        .IF_buf_end_flag(IF_buf_inp[IF_SCRATCH_WIDTH]),
        .IF_buf_empty_flag(IF_buf_empty_flag),
        .full_done(full_done),
        .start_IF(start_IF),
        .end_IF(end_IF),
        .IF_buf_read(IF_buf_read),
        .IF_scratch_wen(IF_scratch_wen),
        .IF_waddr(IF_waddr),
        .IF_end_valid(IF_end_valid)
    );

    // Filter Read Module
    filt_read_module #(
        .ADDR_LEN(FILT_ADDR_LEN),
        .SCRATCH_DEPTH(FILT_SCRATCH_DEPTH),
        .SCRATCH_WIDTH(FILT_SCRATCH_WIDTH)
    ) filt_reader (
        .clk(clk),
        .rst(rst),
        .start(filter_read_start),
        .filt_len(filt_len),
        .filt_buf_empty(filt_buf_empty),
        .filt_buf_read(filt_buf_read),
        .filt_scratch_wen(filt_scratch_wen),
        .filt_waddr(filt_waddr),
        .filt_ready(filt_ready)
    );

    // Output Buffer Module
    
    outbuf_module out_buf_writer (
        .clk(clk),
        .rst(rst),
        .done(done),
        .outbuf_full(outbuf_full),
        .stall_pipeline(stall_pipeline),
        .psum_done(psum_done),
        .outbuf_write(outbuf_write),
        .read_from_scratch(read_from_scratch)
    );

    // Read Address Generator
    read_addr_gen_module #(
        .FILT_ADDR_LEN(FILT_ADDR_LEN),
        .IF_ADDR_LEN(IF_ADDR_LEN),
        .IF_SCRATCH_DEPTH(IF_SCRATCH_DEPTH),
        .IF_SCRATCH_WIDTH(IF_SCRATCH_WIDTH)
    ) read_addr_gener (
        .clk(clk),
        .rst(rst),
        .psum_done(psum_done),
        .start(start_rd_gen),
        .IF_end_valid(IF_end_valid),
        .filt_ready(filt_ready),
        .stall_pipeline(stall_pipeline),
        .stride_len(stride_len),
        .IF_end_pos(end_IF),
        .IF_start_pos(start_IF),
        .IF_waddr(IF_waddr),
        .filter_len(filt_len),
        .filt_waddr(filt_waddr),
        .IF_raddr(IF_raddr),
        .filt_raddr(filt_raddr),
        .read_from_scratch(read_from_scratch),
        .done(done),
        .full_done(full_done),
        .stride_count_flag(stride_count_flag)
    );

    // IF Scratchpad
    IF_scratch #(
        .ADDR_LEN(IF_ADDR_LEN),
        .SCRATCH_DEPTH(IF_SCRATCH_DEPTH),
        .SCRATCH_WIDTH(IF_SCRATCH_WIDTH)
    ) scr_IF (
        .clk(clk),
        .rst(rst),
        .wen(IF_scratch_wen && ~zero_stall),//check
        .waddr(IF_waddr),
        .raddr(IF_raddr),
        .din(IF_buf_inp[IF_SCRATCH_WIDTH - 1:0]),
        .dout(IF_scratch_out)
    );

    // Filter Scratchpad
    filter_scratch #(
        .ADDR_LEN(FILT_ADDR_LEN),
        .SCRATCH_DEPTH(FILT_SCRATCH_DEPTH),
        .SCRATCH_WIDTH(FILT_SCRATCH_WIDTH)
    ) scr_filt (
        .clk(clk),
        .rst(rst),
        .clr_out(regs_clr),
        .wen(filt_scratch_wen),
        .ren(read_from_scratch),
        .waddr(filt_waddr),
        .raddr(filt_raddr),
        .din(filt_buf_inp),
        .dout(filt_scratch_out)
    );
    wire [FILT_SCRATCH_WIDTH + IF_SCRATCH_WIDTH:0] psum_scratch_out ;
    wire [PSUM_ADDR_LEN-1:0] psum_addr;
    //psum address generator
    psum_addr_gen #(
        .PSUM_ADDR_LEN(PSUM_ADDR_LEN) 
    ) psum_address_generator (
        .clk(clk) ,
        .rst(rst) ,
        .psum_mode(psum_mode),
        .psum_done(psum_done),
        .addr(psum_addr)    
);



    
    //add psum scratchpad
    PSUM_scratch #(
        .ADDR_LEN(PSUM_ADDR_LEN),
        .SCRATCH_DEPTH(PSUM_SCRATCH_DEPTH),
        .SCRATCH_WIDTH(PSUM_SCRATCH_WIDTH)
    ) scr_psum (
        .clk(clk),
        .rst(rst),
        .wen(read_from_scratch),//check
        .waddr(psum_addr),//check
        .raddr(4'd0),//check psum_addr
        .din(add_inp),
        .dout(psum_scratch_out)
    );

    // IF Register
    wire dum1,dum2,dum3;
    Register #(
        .SIZE(IF_SCRATCH_WIDTH)
    ) IF_reg (
        .clk(clk),
        .rst(rst | regs_clr),
        .right_shen(1'b0),
        .left_shen(1'b0),
        .ser_in(1'b0),
        .outval(IF_scratch_reg_out),
        .inval(IF_scratch_out),
        .ld_en(read_from_scratch),
        .msb(dum1)
    );
    
    //lower mux
    wire [FILT_SCRATCH_WIDTH + IF_SCRATCH_WIDTH:0] psum_scratch_mux_out;
    assign psum_scratch_mux_out = (rst == 1'b0) ?((psum_done == 1'b1) ? 33'b0 : psum_scratch_out):33'b0; 
    wire [FILT_SCRATCH_WIDTH + IF_SCRATCH_WIDTH:0] psum_scratch_reg_out ;
    wire dum4;
    Register #(
        .SIZE(IF_SCRATCH_WIDTH + FILT_SCRATCH_WIDTH)
    ) psum_scratch_reg (
        .clk(clk),
        .rst(rst | regs_clr),
        .right_shen(1'b0),
        .left_shen(1'b0),
        .ser_in(1'b0),
        .outval(psum_scratch_reg_out),
        .inval(psum_scratch_mux_out),
        .ld_en(read_from_scratch),
        .msb(dum4)
    );

    //upper mux 
    wire [FILT_SCRATCH_WIDTH + IF_SCRATCH_WIDTH:0] mux1_out ; 
    assign mux1_out = (psum_mode == 1'b1) ? psum_buf_inp : mult_reg_out;
    // Multiplier Register
    assign mult_inp = filt_scratch_out * IF_scratch_reg_out;

    Register #(
        .SIZE(IF_SCRATCH_WIDTH + FILT_SCRATCH_WIDTH)
    ) mult_reg (
        .clk(clk),
        .rst(rst | regs_clr),
        .right_shen(1'b0),
        .left_shen(1'b0),
        .ser_in(1'b0),
        .outval(mult_reg_out),
        .inval(mult_inp),
        .ld_en(read_from_scratch),
        .msb(dum2)
    );

    // Adder Register
    
    assign add_inp = psum_scratch_reg_out + mux1_out;

    // Register #(
    //     .SIZE(IF_SCRATCH_WIDTH + FILT_SCRATCH_WIDTH + 1)
    // ) add_reg (
    //     .clk(clk),
    //     .rst(rst | regs_clr),
    //     .right_shen(1'b0),
    //     .left_shen(1'b0),
    //     .ser_in(1'b0),
    //     .outval(add_reg_out),
    //     .inval(add_inp),
    //     .ld_en(read_from_scratch),
    //     .msb(dum3)
    // );

    // Output Assignment
    assign module_outval = add_inp;

endmodule
