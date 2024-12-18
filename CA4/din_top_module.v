module din_top_module#(
    parameter IF_CELL_SIZE = 8 ,
    parameter IF_ADDRESS_SIZE = 8 ,
    parameter FILTER_CELL_SIZE = 8 ,
    parameter FILTER_ADDRESS_SIZE = 8 ,
    parameter STRIDE_SIZE = 2 ,
    parameter CELL_NUMS_IF = 8,
    parameter CELL_NUMS_FILTER = 8,
    parameter DATA_WIDTH = 16 ,
    parameter PAR_WRITE = 1 ,
    parameter PAR_READ = 1 ,
    parameter DEPTH = 4
)
(input clk , input rst , input inner_start , input[2:0] stride,input [2:0] filter_size,input[2:0] if_size,
    output par_done,output can_mult,output Done );

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
        .write_cnt_if(write_cnt_if),
        .write_cnt_filter(write_cnt_filter),
        .write_addr_if(if_last_write),
        .write_addr_filter(filter_last_write),
        .scratch_write_en(scratch_write_en),
        .par_done(par_done),
        .can_count(can_count),
        .can_mult(can_mult),
        .Done(Done)
);

filter_scratch_top_module #(
        .FILTER_CELL_SIZE(FILTER_CELL_SIZE) ,
        .FILTER_ADDRESS_SIZE(FILTER_ADDRESS_SIZE) ,
        .CELL_NUMS_FILTER(CELL_NUMS_FILTER) 
)filter_scratchpad
        (
        .write_en(),
        .din(),
        .read_addr(),
        .cnt(),
        .read_en(),
        .chip_en(),
        .dout(),
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
    .wen(),
    .scratch_write_en(),
    .start(),
    .din(),
    .dout(),
    .cnt(),
    .write_in_scratch()
);



if_scratch_top_module #(
        .IF_CELL_SIZE(IF_CELL_SIZE),
        .IF_ADDRESS_SIZE(IF_ADDRESS_SIZE),
        .CELL_NUMS_IF(CELL_NUMS_IF) 
) if_scratchpad
        (
    .write_en(),
    .din(),
    .read_addr(),
    .cnt(),
    .dout(),
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
    .wen(),
    .scratch_write_en(),
    .start(),
    .din(),
    .dout(),
    .cnt(),
    .write_in_scratch()
);

endmodule