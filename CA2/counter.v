module counter #(
    parameter ADD_VAL = 1,       
    parameter COUNTER_WIDTH = 3  
)(
    input clk,              
    input reset,            
    input cnt,              
    output reg [COUNTER_WIDTH-1:0] count
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= {COUNTER_WIDTH{1'b0}}; 
    end else if (cnt) begin
        count <= count + ADD_VAL;       
    end
end

endmodule

