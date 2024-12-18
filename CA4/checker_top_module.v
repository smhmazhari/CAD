module 
checker_top_module  #(
    parameter IF_CELL_SIZE = 8 ,
    parameter IF_ADDRESS_SIZE = 8 ,
    parameter FILTER_CELL_SIZE = 8 ,
    parameter FILTER_ADDRESS_SIZE = 8 ,
    parameter STRIDE_SIZE = 2 ,
    parameter CELL_NUMS_IF = 8,
    parameter CELL_NUMS_FILTER = 8  
)(
          input clk,
          input rst,
          input inner_start,
          input [STRIDE_SIZE:0] stride,
          input [2:0] filter_size,
          input [2:0] if_size,
          input write_cnt_if,
          input write_cnt_filter,
          input [IF_ADDRESS_SIZE:0] write_addr_if,
          input [FILTER_ADDRESS_SIZE:0] write_addr_filter,
          output scratch_write_en,
          output par_done,
          output can_count,
          output can_mult,
          output Done
    
);

wire load;

    read_address_gen_controller CHK_CU(.clk(clk),
                .rst(rst),
                .can_count(can_count),
                .start(inner_start),
                .load_registers(load)
                   );
    
    checker_datapath #(IF_CELL_SIZE,IF_ADDRESS_SIZE,FILTER_CELL_SIZE,FILTER_ADDRESS_SIZE,STRIDE_SIZE,CELL_NUMS_IF,CELL_NUMS_FILTER) CHK_DP(
        .clk(clk),
        .rst(rst),
        .stride(stride),
        .filter_size(filter_size),
        .if_size(if_size),
        .write_cnt_if(write_cnt_if),
        .write_cnt_filter(write_cnt_filter),
        .write_addr_if(write_addr_if),
        .write_addr_filter(write_addr_filter),
        .load(load),
        .scratch_write_en(scratch_write_en),
        .par_done(par_done),
        .can_count(can_count),
        .can_mult(can_mult),
        .Done(Done)
    );

    
    
endmodule