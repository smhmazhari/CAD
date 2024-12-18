module input_buffer_top_module#(
    parameter DATA_WIDTH = 16,
    parameter PAR_WRITE = 1,
    parameter PAR_READ = 1,
    parameter DEPTH = 4 
)(  input clk,
    input rst,
    input wen,
    input scratch_write_en,
    input inner_start,
    input [PAR_WRITE * DATA_WIDTH - 1 : 0]din,
    output [PAR_READ * DATA_WIDTH - 1 : 0] dout,
    output cnt,
    output write_in_scratch
);

wire empty;
wire full;
Fifo_buffer #(
    .DATA_WIDTH(DATA_WIDTH) ,
    .PAR_WRITE (PAR_WRITE),
    .PAR_READ (PAR_READ),
    .DEPTH(DEPTH)
)fb(
   .clk(clk),
   .rstn(~rst),   
   .clear(1'd0), 
   .ren(1'd1),  
   .wen(wen), 
   .din(din), 
   .dout(dout), 
   .full(full),  
   .empty(empty)  
);

read_buffer_controller Read_buffer_controller(
    .clk(clk),
    .rst(rst),
    .scratch_write_en(scratch_write_en),
    .valid(~empty),
    .start(inner_start),
    .cnt(cnt),
    .write_in_scratch(write_in_scratch)
);
    
endmodule
