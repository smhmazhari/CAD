module counter_3bit (
    input clk,
    input rst,
    input rst3,
    input cnt3,
    output reg Co3,
    output [2:0] result
);
    reg [2:0]in_res;
    always @(posedge clk) begin
        if (rst == 1'b1)
            in_res <= 3'b0;
        else if (rst3 == 1'b1)
            in_res <= 3'b0;    
        else if (cnt3 == 1'b1)
            {Co3,in_res} <= in_res + 1;
    end

    assign result = in_res;
endmodule