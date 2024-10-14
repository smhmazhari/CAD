module counter_5bit (
    input clk,
    input rst,
    input rst5,
    input cntU,
    input cntD,
    output down_done,
    output reg [4:0] result
);
    reg [4:0] in_res;
    always @(posedge clk) begin
        if (rst == 1'b1)
            in_res <= 5'b0;
        else if (rst5 == 1'b1)
            in_res <= 5'b0;    
        else if (cntU == 1'b1)
            in_res <= in_res + 1;
        else if (cntD == 1'b1)
            in_res <= in_res - 1;

    end
    assign down_done = ~|(in_res);
    assign result = in_res;
endmodule