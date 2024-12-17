module checker #(
    parameter IF_CELL_SIZE = 8 ,
    parameter IF_ADDRESS_SIZE = 8 ,
    parameter FILTER_CELL_SIZE = 8 ,
    parameter FILTER_ADDRESS_SIZE = 8 ,
    parameter STRIDE_SIZE = 2 ,
    parameter CELL_NUMS = 8
)(input [STRIDE_SIZE:0] stride,
          input [2:0] filter_size,
          input [2:0] if_size,
          input write_cnt_if,
          input write_cnt_filter,
          input [IF_ADDRESS_SIZE:0] write_addr_if,
          input [FILTER_ADDRESS_SIZE:0] write_addr_filter,
          input [IF_ADDRESS_SIZE:0] start_if,
          input [IF_ADDRESS_SIZE:0] current_if,
          input [FILTER_ADDRESS_SIZE:0] start_filter,
          input [FILTER_ADDRESS_SIZE:0] current_filter,
          input [IF_ADDRESS_SIZE:0] write_start,
          output scratch_write_en,
          output [IF_ADDRESS_SIZE:0] start_if_out,
          output [IF_ADDRESS_SIZE:0] current_if_out,
          output [FILTER_ADDRESS_SIZE:0] start_filter_out,
          output [FILTER_ADDRESS_SIZE:0] current_filter_out,
          output [IF_ADDRESS_SIZE:0] write_start_out,
          output par_done,
          output can_count,
          output can_mult,
          output Done);
    

endmodule