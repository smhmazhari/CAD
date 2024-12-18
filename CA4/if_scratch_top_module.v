module if_scratch_top_module #(parameter SCRATCH_WIDTH = 8,
        parameter SCRATCH_ADDRESS_SIZE = 8,
        parameter CELL_NUMS = 8)
        ();
if_scratch  #(.SCRATCH_WIDTH(SCRATCH_WIDTH) ,
    .SCRATCH_ADDRESS_SIZE(SCRATCH_ADDRESS_SIZE) ,
    CELL_NUMS(CELL_NUMS) )
    IF_scratch(

    .clk(clk),
    .rst(rst),
    .write_en,
    .data_in,
    .write_addr,
    .read_addr,
    .data_out
);
endmodule