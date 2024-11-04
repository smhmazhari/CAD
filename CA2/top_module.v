module top_module#(
    parameter PAR_WRITE = 2,       
    parameter PAR_READ = 4,
    parameter BUFFER_SIZE = 16,
    parameter BUFFER_ADDR = 3  
)(                input clk,
                  input rst,
                  input read_en,
                  input write_en,
                  input [PAR_WRITE * BUFFER_SIZE -1 : 0] data_in,
                  output [PAR_READ * BUFFER_SIZE -1 : 0] data_out,
                  output full,
                  output empty,
                  output valid,
                  output ready);
    wire check_read ;
    wire check_write ;
    wire count_read_pointer ;
    wire count_write_pointer ;

    controller read_controller(.clk(clk),.rst(rst),.en(read_en),.check(check_read),.valid(valid),.count_pointer(count_read_pointer));

    controller write_controller(.clk(clk),.rst(rst),.en(write_en),.check(check_write),.valid(ready),.count_pointer(count_write_pointer));

    fifo #(.PAR_WRITE(PAR_WRITE),.PAR_READ(PAR_READ),.BUFFER_SIZE(BUFFER_SIZE),.BUFFER_ADDR(BUFFER_ADDR))FIFO
    (.clk(clk),.rst(rst),.read_en(check_read),.write_en(check_write),.count_write_pointer(count_write_pointer),
    .count_read_pointer(count_read_pointer),.data_in(data_in),.data_out(data_out),.full(full),.empty(empty));

endmodule