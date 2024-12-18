module output_buffer_top_module  #(
    parameter DATA_WIDTH = 16,
    parameter PAR_WRITE = 1,
    parameter PAR_READ = 1,
    parameter DEPTH = 4
)(
    input clk,
    input rst,
    input read_buffer_result,
    input inner_start,
    input [DATA_WIDTH-1:0] add_reg_out,
    output [DATA_WIDTH-1:0]buffer_res_out,
    output par_done,
    output stall_output_buffer
);

wire empty;
wire full;
wire write_in_buffer;

Fifo_buffer #(
    .DATA_WIDTH(DATA_WIDTH), //data bitwidth
    .PAR_WRITE(PAR_WRITE),
    .PAR_READ(PAR_READ),
    .DEPTH(DEPTH)
)fb (
    .clk(clk),
    .rstn(~rst), //active low reset
    .clear(1'd0), //clear buffer counters
    .ren(read_buffer_result), //read enable 
    .wen(write_in_buffer), //write enable
    .din(add_reg_out), //input data to write into the buffer
    .dout(buffer_res_out), //output data to read from the buffer
    .full(full), //output to signal if buffer is full
    .empty(empty) //output to signal if buffer is empty
);

write_buffer_controller write_controller (
    .clk(clk),
    .rst(rst),
    .par_done(par_done),
    .ready(~full),
    .start(inner_start),
    .stall_output_buffer(stall_output_buffer),
    .write_in_buffer(write_in_buffer)
);

endmodule