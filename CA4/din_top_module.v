module din_top_module#(
    parameter IF_CELL_SIZE = 8 ,
    parameter IF_ADDRESS_SIZE = 8 ,
    parameter FILTER_CELL_SIZE = 8 ,
    parameter FILTER_ADDRESS_SIZE = 8 ,
    parameter STRIDE_SIZE = 1 ,
    parameter CELL_NUMS_IF = 8,
    parameter CELL_NUMS_FILTER = 8,
    parameter DATA_WIDTH = 16 ,
    parameter PAR_WRITE = 1 ,
    parameter PAR_READ = 1 ,
    parameter DEPTH = 4
)(
    input clk ,
    input rst ,
    input inner_start ,
    input[STRIDE_SIZE-1:0] stride,
    input [2:0] filter_size,
    input[2:0] if_size,
    input filter_buff_write_en,
    input if_buff_write_en,
    input chip_en,
    input [FILTER_CELL_SIZE-1:0] filter_buff_input,
    input [IF_CELL_SIZE-1:0] if_buff_input,
    output [FILTER_CELL_SIZE-1:0] filter_scp_out,
    output [IF_CELL_SIZE-1:0] if_scp_out,
    output par_done,
    // output can_mult,
    output Done 
);
wire [IF_ADDRESS_SIZE-1:0] start_if_out; 
wire [IF_ADDRESS_SIZE-1:0] current_if_out;
wire [FILTER_ADDRESS_SIZE-1:0] start_filter_out;
wire [FILTER_ADDRESS_SIZE-1:0] current_filter_out;
wire [IF_ADDRESS_SIZE-1:0] write_start_out;



wire write_cnt_if ;
wire write_cnt_filter;
wire [IF_ADDRESS_SIZE-1:0] if_last_write ;
wire [FILTER_ADDRESS_SIZE-1:0] filter_last_write ;
wire scratch_write_en ;
wire can_count;

checker_top_module  #(
    .IF_CELL_SIZE (IF_CELL_SIZE),
    .IF_ADDRESS_SIZE (IF_ADDRESS_SIZE),
    .FILTER_CELL_SIZE (FILTER_CELL_SIZE),
    .FILTER_ADDRESS_SIZE (FILTER_ADDRESS_SIZE),
    .STRIDE_SIZE (STRIDE_SIZE),
    .CELL_NUMS_IF (CELL_NUMS_IF),
    .CELL_NUMS_FILTER (CELL_NUMS_FILTER) 
)checker(
        .clk(clk),
        .rst(rst),
        .inner_start(inner_start),
        .stride(stride),
        .filter_size(filter_size),
        .if_size(if_size),
        .write_addr_if(if_last_write),
        .write_addr_filter(filter_last_write),
        .scratch_write_en(scratch_write_en),
        .par_done(par_done),
        .can_count(can_count),
        .can_mult(can_mult),
        .Done(Done),
        .start_if_out(start_if_out),
        .current_if_out(current_if_out),
        .start_filter_out(start_filter_out),
        .current_filter_out(current_filter_out),
        .write_start_out(write_start_out)
);



wire write_in_filter_scp;
wire [FILTER_ADDRESS_SIZE-1:0] filter_buff_out;
wire cnt_filter;

filter_scratch_top_module #(
        .SCRATCH_WIDTH(FILTER_CELL_SIZE) ,
        .SCRATCH_ADDRESS_SIZE(FILTER_ADDRESS_SIZE) ,
        .CELL_NUMS(CELL_NUMS_FILTER) 
)filter_scratchpad(
        .clk(clk),
        .rst(rst),
        .write_en(write_in_filter_scp),
        .din(filter_buff_out),
        .read_addr(current_filter_out),
        .cnt(cnt_filter),
        .read_en(can_count),
        .chip_en(chip_en),
        .dout(filter_scp_out),
        .last_write(filter_last_write)
);
//filter
 input_buffer_top_module#(
    .DATA_WIDTH(DATA_WIDTH),
    .PAR_WRITE(PAR_WRITE),
    .PAR_READ(PAR_READ),
    .DEPTH(DEPTH) 
) filter_buff(
    .clk(clk),
    .rst(rst),
    .wen(filter_buff_write_en),
    .scratch_write_en(1'd1),
    .inner_start(inner_start),
    .din(filter_buff_input),
    .dout(filter_buff_out),
    .cnt(cnt_filter),
    .write_in_scratch(write_in_filter_scp)
);


wire write_en_if_scp;
wire [IF_ADDRESS_SIZE-1:0] if_buff_out;
wire cnt_if;
if_scratch_top_module #(
        .SCRATCH_WIDTH(IF_CELL_SIZE),
        .SCRATCH_ADDRESS_SIZE(IF_ADDRESS_SIZE),
        .CELL_NUMS(CELL_NUMS_IF) 
) if_scratchpad(
    .clk(clk),
    .rst(rst),
    .write_en(write_en_if_scp),
    .din(if_buff_out),
    .read_addr(current_if_out),//can_count
    .cnt(cnt_if),
    .dout(if_scp_out),
    .last_write(if_last_write)
);

//if
 input_buffer_top_module#(
    .DATA_WIDTH(DATA_WIDTH),
    .PAR_WRITE(PAR_WRITE),
    .PAR_READ(PAR_READ),
    .DEPTH(DEPTH) 
)if_buff (
    .clk(clk),
    .rst(rst),
    .wen(if_buff_write_en),
    .scratch_write_en(scratch_write_en),
    .inner_start(inner_start),
    .din(if_buff_input),
    .dout(if_buff_out),
    .cnt(cnt_if),
    .write_in_scratch(write_en_if_scp)
);

endmodule