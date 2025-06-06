module filter_scratch_top_module #(
        parameter SCRATCH_WIDTH = 8,
        parameter SCRATCH_ADDRESS_SIZE = 8,
        parameter CELL_NUMS = 8
)(
            input clk,
            input rst,
            input write_en,
            input [CELL_NUMS-1:0] din,
            input[SCRATCH_ADDRESS_SIZE-1:0] read_addr,
            input cnt,
            input read_en,
            input chip_en,
            output [SCRATCH_WIDTH-1:0]dout,
            output [SCRATCH_ADDRESS_SIZE-1:0]last_write
);

wire [SCRATCH_ADDRESS_SIZE-1:0]counter_result;

filter_scratch #(
    .SCRATCH_WIDTH(SCRATCH_WIDTH),
    .SCRATCH_ADDRESS_SIZE(SCRATCH_ADDRESS_SIZE),
    .CELL_NUMS(CELL_NUMS)
)filter_scratchpad_in_top(
    .clk(clk),
    .rst(rst),
    .write_en(write_en),
    .read_en(read_en),
    .chip_en(chip_en),
    .data_in(din),
    .write_addr(counter_result),
    .read_addr(read_addr),
    .data_out(dout)
);

write_counter #(
    .ADD_VAL(1'd1),       
    .COUNTER_WIDTH(SCRATCH_ADDRESS_SIZE)   
)IF_address_counter(
    .clk(clk),              
    .reset(rst),            
    .cnt(cnt),              
    .count(counter_result)
);

assign last_write = counter_result ;
endmodule