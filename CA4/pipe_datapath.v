module pipe_data_path #(
    parameter IF_CELL_SIZE = 8,
    parameter FILTER_CELL_SIZE = 8
)(
    input clk,
    input rst,
    input ld_mult,
    input ld_add,
    input par_done,
    input pipe_stall,
    input[IF_CELL_SIZE-1:0] if_in,
    input[FILTER_CELL_SIZE-1:0] filter_in,
    output [FILTER_CELL_SIZE+IF_CELL_SIZE:0] out
);

wire [IF_CELL_SIZE+FILTER_CELL_SIZE:0]mult_result;
wire [IF_CELL_SIZE+FILTER_CELL_SIZE:0]mult_reg_out;
wire [IF_CELL_SIZE+FILTER_CELL_SIZE:0]adder_result;
wire par_done_reg;
wire [IF_CELL_SIZE+FILTER_CELL_SIZE:0]adder_reg_out;

multiplier #(
    .INP1_WIDTH(IF_CELL_SIZE),
    .INP2_WIDTH(FILTER_CELL_SIZE)
) Multiplier(
    .in1(if_in),
    .in2(filter_in),
    .mult_result(mult_result)
);

check_register #(
    .REG_SIZE(1)
)par_done_register(
    .clk(clk),
    .rst(rst),
    .load(load),
    .data_in(par_done),
    .data_out(par_done_reg)
);

check_register #(
    .REG_SIZE(IF_CELL_SIZE+FILTER_CELL_SIZE+1)
)mult_register(
    .clk(clk),
    .rst(rst),
    .load(load_mult),
    .data_in(mult_result),
    .data_out(mult_reg_out)
);

pipe_register #(
    .REG_SIZE(IF_CELL_SIZE+FILTER_CELL_SIZE+1)
)add_register(
    .clk(clk),
    .rst(rst),
    .load(load_add),
    .clr(par_done_reg),
    .data_in(adder_result),
    .data_out(out)
);

adder #(
    .ADDER_WIDTH(IF_CELL_SIZE+FILTER_CELL_SIZE+1)
)Adder_module(
    .in1(mult_reg_out),
    .in2(out),
    .add_result(adder_result)
);
    
endmodule
