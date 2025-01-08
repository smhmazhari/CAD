module psum_addr_gen#(parameter PSUM_ADDR_LEN ,parameter PSUM_SCRATCH_DEPTH) (input clk ,
                      input rst ,
                      input psum_mode,
                      input psum_done,
                      input cnt_mode,
                      output reg [PSUM_ADDR_LEN-1:0] addr    
);
    wire co1 ;
    wire co2 ;
    wire [PSUM_ADDR_LEN-1:0] psum_read_addr;
    wire [PSUM_ADDR_LEN-1:0] read_write_addr;

    Counter #(.NUM_BIT(PSUM_ADDR_LEN),.DEPTH(PSUM_ADDR_LEN)) input_psum_read_addr_counter (.clk(clk),.rst(rst),.ld_cnt(1'd0),.cnt_en(psum_mode && psum_mode),.co(co1),.load_value(0),.cnt_out_wire(psum_read_addr),.cnt_mode(1'b0));

    Counter #(.NUM_BIT(PSUM_ADDR_LEN),.DEPTH(PSUM_SCRATCH_DEPTH)) read_write_addr_counter (.clk(clk),.rst(rst),.ld_cnt(1'd0),.cnt_en(psum_done && ~psum_mode),.co(co2),.load_value(0),.cnt_out_wire(read_write_addr),.cnt_mode(cnt_mode));

    assign addr = (psum_mode == 1'b1)? psum_read_addr : read_write_addr;

endmodule