module psum_addr_gen#(parameter PSUM_ADDR_LEN ) (input clk ,
                      input rst ,
                      input psum_mode,
                      input psum_done,
                      output reg [PSUM_ADDR_LEN-1:0] addr    
);
    wire co1 ;
    wire co2 ;
    wire [PSUM_ADDR_LEN-1:0] psum_read_addr;
    wire [PSUM_ADDR_LEN-1:0] read_write_addr;

    Counter #(.NUM_BIT(PSUM_ADDR_LEN)) input_psum_read_addr_counter (.clk(clk),.rst(rst),.ld_cnt(1'd0),.cnt_en(psum_mode),.co(co1),.load_value(0),.cnt_out_wire(psum_read_addr));

    Counter #(.NUM_BIT(PSUM_ADDR_LEN)) read_write_addr_counter (.clk(clk),.rst(rst),.ld_cnt(1'd0),.cnt_en(psum_done && ~psum_mode),.co(co2),.load_value(0),.cnt_out_wire(read_write_addr));

    assign addr = (psum_mode == 1'b1)? psum_read_addr : read_write_addr;

endmodule