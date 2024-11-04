module fifo#(
    parameter PAR_WRITE = 2,       
    parameter PAR_READ = 4,
    parameter BUFFER_SIZE = 16,
    parameter BUFFER_ADDR = 3  
)(input clk,
  input rst,
  input count_write_pointer,
  input count_read_pointer,
  input [PAR_WRITE * BUFFER_SIZE -1 : 0] data_in,
  output read_en,
  output write_en,
  output [PAR_READ * BUFFER_SIZE -1 : 0] data_out,
  output full,
  output empty);

  wire [BUFFER_ADDR -1 : 0] read_addr ;
  wire [BUFFER_ADDR -1 : 0] write_addr ;
  wire check_read ;
  wire check_write ;

  assign read_en = check_read ; 
  assign write_en = check_write ;
 counter #(
    .ADD_VAL(PAR_READ),       
    .COUNTER_WIDTH(BUFFER_ADDR)  
  )read_counter(
    .clk(clk),              
    .reset(rst),            
    .cnt(count_read_pointer),              
    .count(read_addr)
);

 counter #(
    .ADD_VAL(PAR_WRITE),
    .COUNTER_WIDTH(BUFFER_ADDR)
) write_counter (
    .clk(clk),
    .reset(rst),
    .cnt(count_write_pointer),
    .count(write_addr)
);
 checker #(
    .PAR_WRITE(PAR_WRITE),    
    .PAR_READ(PAR_READ),
    .POINTER_SIZE(BUFFER_ADDR)  
)fifo_checker(
    .write_pointer(write_addr),
    .read_pointer(read_addr),
    .full(full),
    .empty(empty),
    .check_write(check_write),
    .check_read(check_read)
);

 buffer #(
    .PAR_WRITE(PAR_WRITE),   
    .PAR_READ(PAR_READ),
    .BUFFER_SIZE(BUFFER_SIZE) ,
    .BUFFER_ADDR(BUFFER_ADDR)  
)circular_buffer(
    .clk(clk),
    .rst(rst),
    .read_en(check_read),
    .write_en(check_write),
    .read_addr(read_addr),
    .write_addr(write_addr),
    .data_in(data_in),
    .data_out(data_out)
);


endmodule