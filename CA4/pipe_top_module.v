module pipe_top_module#(
    parameter IF_CELL_SIZE = 8,
    parameter FILTER_CELL_SIZE = 8
)(
    input clk,
    input rst,
    input start,
    input can_mult,
    input par_done,
    input[IF_CELL_SIZE-1:0] if_in,
    input[FILTER_CELL_SIZE-1:0] filter_in,
    output [FILTER_CELL_SIZE+IF_CELL_SIZE:0] out
);

wire ld_add;
wire ld_mult;
wire pipe_stall;

pipe_data_path #(
    .IF_CELL_SIZE(IF_CELL_SIZE),
    .FILTER_CELL_SIZE(FILTER_CELL_SIZE)
)DataPath(
    .clk(clk),
    .rst(rst),
    .ld_mult(ld_mult),
    .ld_add(ld_add),
    .par_done(par_done),
    .pipe_stall(pipe_stall),
    .if_in(if_in),
    .filter_in(filter_in),
    .out(out)
);

pipe_cotroller Controller(
    .clk(clk),
    .rst(rst),
    .start(start),
    .can_mult(can_mult),
    .pipe_stall(pipe_stall),
    .ld_mult(ld_mult),
    .ld_add(ld_add)
);
    
endmodule