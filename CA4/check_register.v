module check_register  #(
    parameter REG_SIZE = 16      
) (
  input clk,  
  input load,
  input rst, 
  input [REG_SIZE:0] data_in, 
  output reg [REG_SIZE:0] data_out 
);

  always @(posedge clk) begin
    if (rst)begin
      data_out <= 0; //REG_SIZE'b
    end
    else if (load) begin
      data_out <= data_in; 
    end
  end

endmodule