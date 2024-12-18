module checker_datapath  #(
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
      input [STRIDE_SIZE-1:0] stride,
      input [2:0] filter_size,
      input [2:0] if_size,
      input [IF_ADDRESS_SIZE-1:0] write_addr_if,
      input [FILTER_ADDRESS_SIZE-1:0] write_addr_filter,
      input load,
      output scratch_write_en,
      output par_done,
      output can_count,
      output can_mult,
      output Done,
      output [IF_ADDRESS_SIZE-1:0] start_if_out,
      output [IF_ADDRESS_SIZE-1:0] current_if_out,
      output [FILTER_ADDRESS_SIZE-1:0] start_filter_out,
      output [FILTER_ADDRESS_SIZE-1:0] current_filter_out,
      output [IF_ADDRESS_SIZE-1:0] write_start_out
);
          
wire [IF_ADDRESS_SIZE-1:0] start_if; 
wire [IF_ADDRESS_SIZE-1:0] current_if;
wire [FILTER_ADDRESS_SIZE-1:0] start_filter;
wire [FILTER_ADDRESS_SIZE-1:0] current_filter;
wire [IF_ADDRESS_SIZE-1:0] write_start;

// wire [IF_ADDRESS_SIZE:0] start_if_out;
// wire [IF_ADDRESS_SIZE:0] current_if_out;
// wire [FILTER_ADDRESS_SIZE:0] start_filter_out;
// wire [FILTER_ADDRESS_SIZE:0] current_filter_out;
// wire [IF_ADDRESS_SIZE:0] write_start_out;
 
checker#(
    .IF_CELL_SIZE(IF_CELL_SIZE),
    .IF_ADDRESS_SIZE(IF_ADDRESS_SIZE),
    .FILTER_CELL_SIZE(FILTER_CELL_SIZE),
    .FILTER_ADDRESS_SIZE(FILTER_ADDRESS_SIZE),
    .STRIDE_SIZE(STRIDE_SIZE),
    .CELL_NUMS_IF(CELL_NUMS_IF),
    .CELL_NUMS_FILTER(CELL_NUMS_FILTER)
)checker_logic (
          .stride(stride),
          .filter_size(filter_size),
          .if_size(if_size),
          .write_addr_if(write_addr_if),
          .write_addr_filter(write_addr_filter),
          .start_if(start_if),
          .current_if(current_if),
          .start_filter(start_filter),
          .current_filter(current_filter),
          .write_start(write_start),
          .scratch_write_en(scratch_write_en),
          .start_if_out(start_if_out),
          .current_if_out(current_if_out),
          .start_filter_out(start_filter_out),
          .current_filter_out(current_filter_out),
          .write_start_out(write_start_out),
          .par_done(par_done),
          .can_count(can_count),
          .can_mult(can_mult),
          .Done(Done));


check_register#(
   .REG_SIZE(IF_ADDRESS_SIZE)
)if_map_start (
   .clk(clk),  
   .load(load),
   .rst(rst), 
   .data_in(start_if_out), 
   .data_out(start_if) 
);

check_register#(
   .REG_SIZE(IF_ADDRESS_SIZE)
)if_map_current (
   .clk(clk),  
   .load(load),
   .rst(rst), 
   .data_in(current_if_out), 
   .data_out(current_if) 
);

check_register#(
   .REG_SIZE(FILTER_ADDRESS_SIZE)
)filter_start (
   .clk(clk),  
   .load(load),
   .rst(rst), 
   .data_in(start_filter_out), 
   .data_out(start_filter) 
);

check_register#(
   .REG_SIZE(FILTER_ADDRESS_SIZE)
)filter_current (
   .clk(clk),  
   .load(load),
   .rst(rst), 
   .data_in(current_filter_out), 
   .data_out(current_filter) 
);

check_register#(
   .REG_SIZE(IF_ADDRESS_SIZE)
)write_Start_reg (
   .clk(clk),  
   .load(load),
   .rst(rst), 
   .data_in(write_start_out), 
   .data_out(write_start) 
);

endmodule