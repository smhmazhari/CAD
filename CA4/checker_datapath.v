module checker_datapath  #(
    parameter IF_CELL_SIZE = 8 ,
    parameter IF_ADDRESS_SIZE = 8 ,
    parameter FILTER_CELL_SIZE = 8 ,
    parameter FILTER_ADDRESS_SIZE = 8 ,
    parameter STRIDE_SIZE = 2 ,
    parameter CELL_NUMS = 8
)(
          input clk,
          input rst,
          input [STRIDE_SIZE:0] stride,
          input [2:0] filter_size,
          input [2:0] if_size,
          input write_cnt_if,
          input write_cnt_filter,
          input [IF_ADDRESS_SIZE:0] write_addr_if,
          input [FILTER_ADDRESS_SIZE:0] write_addr_filter,
          input load,
          output scratch_write_en,
          output par_done,
          output can_count,
          output can_mult,
          output Done);
          
wire [IF_ADDRESS_SIZE:0] start_if; 
wire [IF_ADDRESS_SIZE:0] current_if;
wire [FILTER_ADDRESS_SIZE:0] start_filter;
wire [FILTER_ADDRESS_SIZE:0] current_filter;
wire [IF_ADDRESS_SIZE:0] write_start;

wire [IF_ADDRESS_SIZE:0] start_if_out;
wire [IF_ADDRESS_SIZE:0] current_if_out;
wire [FILTER_ADDRESS_SIZE:0] start_filter_out;
wire [FILTER_ADDRESS_SIZE:0] current_filter_out;
wire [IF_ADDRESS_SIZE:0] write_start_out;
 
checker#(
    IF_CELL_SIZE,
    IF_ADDRESS_SIZE,
    FILTER_CELL_SIZE,
    FILTER_ADDRESS_SIZE,
    STRIDE_SIZE
)checker_logic (stride,
          filter_size,
          if_size,
          write_cnt_if,
          write_cnt_filter,
          write_addr_if,
          write_addr_filter,
          start_if,
          current_if,
          start_filter,
          current_filter,
          write_start,
          scratch_write_en,
          start_if_out,
          current_if_out,
          start_filter_out,
          current_filter_out,
          write_start_out,
          par_done,
          can_count,
          can_mult,
          Done);


check_register#(IF_ADDRESS_SIZE)if_map_start (
   clk,  
   load,
   rst, 
   start_if, 
   start_if_out 
);

check_register#(IF_ADDRESS_SIZE)if_map_current (
   clk,  
   load,
   rst, 
   current_if, 
   current_if_out 
);

check_register#(FILTER_ADDRESS_SIZE)filter_start (
   clk,  
   load,
   rst, 
   start_filter, 
   start_filter_out 
);

check_register#(FILTER_ADDRESS_SIZE)filter_current (
   clk,  
   load,
   rst, 
   current_filter, 
   current_filter_out 
);

check_register#(IF_ADDRESS_SIZE)write_Start_reg (
   clk,  
   load,
   rst, 
   write_start, 
   write_start_out 
);

endmodule