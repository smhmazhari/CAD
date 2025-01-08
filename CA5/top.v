module design_top #(
    parameter FILT_ADDR_LEN,
    parameter IF_ADDR_LEN,
    parameter IF_SCRATCH_DEPTH,
    parameter IF_SCRATCH_WIDTH,
    parameter FILT_SCRATCH_DEPTH,
    parameter FILT_SCRATCH_WIDTH,
    parameter IF_par_write,
    parameter filter_par_write,
    parameter outbuf_par_read,
    parameter IF_BUFFER_DEPTH,
    parameter FILT_BUFFER_DEPTH,
    parameter OUT_BUFFER_DEPTH,
    parameter PSUM_ADDR_LEN,
    parameter PSUM_SCRATCH_DEPTH,
    parameter PSUM_SCRATCH_WIDTH
)
(
    input wire clk,
    input wire rst,
    input wire start,
    input wire IF_wen,
    input wire PSUM_wen,
    input wire psum_mode,
    input wire [1:0] mode,
    input wire signed [IF_par_write * (IF_SCRATCH_WIDTH + 2) - 1 : 0] IF_din, // signed input
    input wire signed [PSUM_SCRATCH_WIDTH - 1:0] PSUM_din, // signed input
    input wire filter_wen,
    input wire signed [filter_par_write * FILT_SCRATCH_WIDTH - 1 : 0] filter_din, // signed input
    input wire outbuf_ren,
    output wire signed [outbuf_par_read * (PSUM_SCRATCH_WIDTH) - 1 : 0] outbuf_dout, // signed output
    output wire IF_full,
    output wire IF_empty,
    output wire filter_full,
    output wire filter_empty,
    output wire psum_full,
    output wire psum_empty,
    output wire outbuf_full,
    output wire outbuf_empty,
    input wire [FILT_ADDR_LEN - 1:0] filt_len,
    input wire [IF_ADDR_LEN - 1:0] stride_len
);

// Internal wires
wire IF_read_start, filter_read_start, regs_clr, start_rd_gen, reset_all;
wire IF_buf_read, filter_buf_read, full_done, psum_done;
wire stride_count_flag, outbuf_write;
wire signed [IF_SCRATCH_WIDTH + 1:0] IF_buf_inp; // signed wire
wire signed [FILT_SCRATCH_WIDTH - 1:0] filter_buf_inp; // signed wire
wire signed [PSUM_SCRATCH_WIDTH - 1:0] psum_buf_inp; // signed wire
wire signed [PSUM_SCRATCH_WIDTH-1:0] module_outval; // signed wire
wire signed [outbuf_par_read * (PSUM_SCRATCH_WIDTH) - 1 : 0] outbuf_doutt; // signed wire

// IF Buffer
Fifo_buffer #(
    .DATA_WIDTH(IF_SCRATCH_WIDTH + 2),
    .PAR_WRITE(IF_par_write),
    .PAR_READ(1),
    .DEPTH(IF_BUFFER_DEPTH)
) IF_buffer (
    .clk(clk),
    .rstn(~rst),
    .clear(1'b0),
    .ren(IF_buf_read),
    .wen(IF_wen),
    .din(IF_din),
    .dout(IF_buf_inp),
    .full(IF_full),
    .empty(IF_empty)
);
    
assign outbuf_dout = psum_mode ? outbuf_doutt : module_outval;

// Filter Buffer
Fifo_buffer #(
    .DATA_WIDTH(FILT_SCRATCH_WIDTH),
    .PAR_WRITE(filter_par_write),
    .PAR_READ(1),
    .DEPTH(FILT_BUFFER_DEPTH)
) filter_buffer (
    .clk(clk),
    .rstn(~rst),
    .clear(1'b0),
    .ren(filter_buf_read),
    .wen(filter_wen),
    .din(filter_din),
    .dout(filter_buf_inp),
    .full(filter_full),
    .empty(filter_empty)
);

// psum input buffer
Fifo_buffer #(
    .DATA_WIDTH(PSUM_SCRATCH_WIDTH),
    .PAR_WRITE(1),
    .PAR_READ(1),
    .DEPTH(PSUM_SCRATCH_DEPTH)
) PSUM_buffer (
    .clk(clk),
    .rstn(~rst),
    .clear(1'b0),
    .ren(psum_mode),
    .wen(PSUM_wen),
    .din(PSUM_din),
    .dout(psum_buf_inp),
    .full(psum_full),
    .empty(psum_empty)
);

// Output Buffer

// اصلاح سیگنال ها 
Fifo_buffer #(
    .DATA_WIDTH(PSUM_SCRATCH_WIDTH),
    .PAR_WRITE(1),
    .PAR_READ(outbuf_par_read),
    .DEPTH(OUT_BUFFER_DEPTH)
) out_buffer (
    .clk(clk),
    .rstn(~rst),
    .clear(1'b0),
    .ren(outbuf_ren),
    .wen(psum_mode),
    .din(module_outval),
    .dout(outbuf_doutt),
    .full(outbuf_full),
    .empty(outbuf_empty)
);

// Datapath

//complete datapath
design_datapath #(
    .FILT_ADDR_LEN(FILT_ADDR_LEN),
    .IF_ADDR_LEN(IF_ADDR_LEN),
    .IF_SCRATCH_DEPTH(IF_SCRATCH_DEPTH),
    .IF_SCRATCH_WIDTH(IF_SCRATCH_WIDTH),
    .FILT_SCRATCH_DEPTH(FILT_SCRATCH_DEPTH),
    .FILT_SCRATCH_WIDTH(FILT_SCRATCH_WIDTH),
    .PSUM_ADDR_LEN(PSUM_ADDR_LEN),
    .PSUM_SCRATCH_DEPTH(PSUM_SCRATCH_DEPTH),
    .PSUM_SCRATCH_WIDTH(PSUM_SCRATCH_WIDTH)
) datapath (
    .clk(clk),
    .rst(rst | reset_all),
    .mode(mode),
    .psum_mode(psum_mode),
    .IF_read_start(IF_read_start),
    .filter_read_start(filter_read_start),
    .regs_clr(regs_clr),
    .IF_buf_empty_flag(IF_empty),
    .filt_buf_empty(filter_empty),
    .start_rd_gen(start_rd_gen),
    .outbuf_full(outbuf_full),
    .filt_len(filt_len),
    .stride_len(stride_len),
    .IF_buf_inp(IF_buf_inp),
    .psum_buf_inp(psum_buf_inp),
    .filt_buf_inp(filter_buf_inp),
    .module_outval(module_outval),
    .IF_buf_read(IF_buf_read),
    .filt_buf_read(filter_buf_read),
    .full_done(full_done),
    .psum_done(psum_done),
    .stride_count_flag(stride_count_flag),
    .outbuf_write(outbuf_write)
);

// Controller
//complete controller
design_controller #(
    .FILT_ADDR_LEN(FILT_ADDR_LEN),
    .IF_ADDR_LEN(IF_ADDR_LEN),
    .SCRATCH_DEPTH(IF_SCRATCH_DEPTH),
    .SCRATCH_WIDTH(IF_SCRATCH_WIDTH)
) controller (
    .clk(clk),
    .rst(rst),
    .start(start), 
    .full_done(full_done),
    .psum_done(psum_done),
    .stride_count_flag(stride_count_flag),
    .reset_all(reset_all),
    .IF_read_start(IF_read_start),
    .filter_read_start(filter_read_start),
    .clear_regs(regs_clr),
    .start_rd_gen(start_rd_gen)
);

endmodule
