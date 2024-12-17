module //BE CHEKER DADE SHE.
if_scratch  #(parameter SCRATCH_WIDTH = 8,
        parameter SCRATCH_ADDRESS_SIZE = 8,
        parameter CELL_NUMS = 8)
(
    input clk,
    input rst,
    input write_en,
    input[SCRATCH_WIDTH-1:0] data_in,
    input[SCRATCH_ADDRESS_SIZE-1:0] write_addr,
    input[SCRATCH_ADDRESS_SIZE-1:0] read_addr,
    output[SCRATCH_WIDTH-1:0] data_out
);
    reg [SCRATCH_WIDTH:0] if_scratch_pad [CELL_NUMS-1:0];
    assign data_out = if_scratch_pad[read_addr];

    integer i;
    
    always @(posedge clk ,posedge rst) begin
        if (rst) begin

            for (i = 0; i < CELL_NUMS; i = i + 1) begin
                if_scratch_pad[i] <= 0;//SCRATCH_WIDTH'b
            end
        end else if (write_en) begin
            if_scratch_pad[write_addr] <= data_in;
        end
    end
    
endmodule