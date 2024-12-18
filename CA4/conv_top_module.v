module conv_top_module  #(
        parameter IF_CELL_SIZE = 8 ,
        parameter IF_ADDRESS_SIZE = 8 ,
        parameter FILTER_CELL_SIZE = 8 ,
        parameter FILTER_ADDRESS_SIZE = 8 ,
        parameter STRIDE_SIZE = 2 ,
        parameter CELL_NUMS_IF = 8,
        parameter CELL_NUMS_FILTER = 8,
        // parameter DATA_WIDTH = 16 ,
        parameter PAR_WRITE = 1 ,
        parameter PAR_READ = 1 ,
        parameter DEPTH = 4
)(
    input clk,
    input rst,
    input chip_en,
    input start,
    input [2:0]filter_size,
    input [2:0]if_size,
    input [STRIDE_SIZE-1:0]stride,
    input [FILTER_CELL_SIZE-1:0] filter_buff_input,
    input [IF_CELL_SIZE-1:0] if_buff_input,
    input filter_buff_write_en,
    input if_buff_write_en,
    input read_buffer_result,

    // input ,
    output Done,
    output [FILTER_CELL_SIZE + FILTER_CELL_SIZE : 0] par_sum


);
wire inner_start;
general_controller gc(
    .clk(clk),
    .rst(rst),
    .start(start),
    .done(Done),//TODO
    .inner_start(inner_start)
);

wire par_done;
wire [FILTER_CELL_SIZE-1:0] filter_scp_out;
wire [FILTER_CELL_SIZE-1:0] if_scp_out;
wire stall_output_buffer;

din_top_module#(
    .IF_CELL_SIZE(IF_CELL_SIZE-2) ,
    .IF_ADDRESS_SIZE(IF_ADDRESS_SIZE) ,
    .FILTER_CELL_SIZE(FILTER_CELL_SIZE) ,
    .FILTER_ADDRESS_SIZE(FILTER_ADDRESS_SIZE),
    .STRIDE_SIZE(STRIDE_SIZE),
    .CELL_NUMS_IF(CELL_NUMS_IF),
    .CELL_NUMS_FILTER(CELL_NUMS_FILTER),
    .DATA_WIDTH(FILTER_CELL_SIZE),//TODO
    .PAR_WRITE(PAR_WRITE),
    .PAR_READ(PAR_READ),
    .DEPTH(DEPTH) 
)dtp(
    .clk(clk),
    .rst(rst),
    .inner_start(inner_start),
    .stride(stride),
    .filter_size(filter_size),
    .if_size(if_size),
    .filter_buff_write_en(filter_buff_write_en),
    .if_buff_write_en(if_buff_write_en),
    .chip_en(chip_en),
    .filter_buff_input(filter_buff_input),
    .if_buff_input(if_buff_input),
    .filter_scp_out(filter_scp_out),
    .if_scp_out(if_scp_out),
    .par_done(par_done),
    // output can_mult,
    .Done (Done)
);
wire[FILTER_CELL_SIZE+FILTER_CELL_SIZE:0] pipe_out;
 output_buffer_top_module  #(
    .DATA_WIDTH(FILTER_CELL_SIZE+FILTER_CELL_SIZE+1),
    .PAR_WRITE(PAR_WRITE),
    .PAR_READ(PAR_READ),
    .DEPTH(DEPTH)
)obtm(
    .clk(clk),
    .rst(rst),
    .read_buffer_result(read_buffer_result),
    .inner_start(inner_start),
    .add_reg_out(pipe_out),
    .buffer_res_out(par_sum),
    .par_done(par_done),
    .stall_output_buffer(stall_output_buffer)
);

pipe_top_module#(
    .IF_CELL_SIZE(IF_CELL_SIZE-2) ,
    .FILTER_CELL_SIZE(FILTER_CELL_SIZE) 
)ptm(
    .clk(clk),
    .rst(rst),
    .start(inner_start),
    .can_mult(can_mult),
    .par_done(par_done),
    .if_in(if_scp_out),
    .filter_in(filter_scp_out),
    .out(pipe_out)
);
    
endmodule