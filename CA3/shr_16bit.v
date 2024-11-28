module shift_register_right_16bit (
  input clk,  
  input load,
  input shr, 
  input [15:0] data_in, 
  output reg [15:0] data_out 
);

  always @(posedge clk) begin
    if (load) begin
      data_out <= data_in; 
    end else if (shr == 1'b1) begin
      data_out <= {1'b0,data_out[15:1]}; 
    end 
  end

endmodule