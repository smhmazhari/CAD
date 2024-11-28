module shift_register_left_16bit (
  input clk,  
  input load,
  input shl, 
  input [15:0] data_in, 
  output reg [15:0] data_out 
);

  always @(posedge clk) begin
    if (load) begin
      data_out <= data_in; 
    end else if (shl == 1'b1) begin
      data_out <= {data_out[14:0], 1'b0}; 
    end 
  end

endmodule