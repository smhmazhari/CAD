module shift_register_32bit (
  input clk,  
  input load,
  input shr, 
  input [31:0] data_in, 
  output reg [31:0] data_out
);

  always @(posedge clk) begin
    if (load) begin
      data_out <= data_in; 
    end else if (shr == 1'b1) begin
      data_out <= {1'b0,data_out[31:1]}; 
    end 
  end

endmodule