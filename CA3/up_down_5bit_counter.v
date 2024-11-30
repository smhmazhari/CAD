module counter_5bit (
    input clk,
    input rst,
    input rst5,
    input cntU,
    input cntD,
    output down_done,
    output[4:0] result
);
    // reg [4:0] in_res;
    // always @(posedge clk) begin
    //     if (rst == 1'b1)
    //         in_res <= 5'b0;
    //     else if (rst5 == 1'b1)
    //         in_res <= 5'b0;    
    //     else if (cntU == 1'b1)
    //         in_res <= in_res + 1;
    //     else if (cntD == 1'b1 && down_done == 1'b0)
    //         in_res <= in_res - 1;


    // end
    // assign down_done = ~|(in_res);
    // assign result = in_res;
    wire [4:0]adder_out;
    wire [4:0]dff_in;
    wire [4:0]mux_out;
    reg [4:0]dff_out;
    wire cout;
    assign dff_in = rst5 ? 5'd0 : adder_out;
    always @(posedge clk,posedge rst)begin
        if(rst)
            dff_out <= 5'd0;
        else begin
            dff_out <= dff_in;
        end
    end
    assign mux_out = (~cntD & ~cntU) ? 5'd0 : (cntD) ? 5'b11111 : 5'd00001;
    //module Adder #(parameter N = 5)(a, b, cin, s, cout);
    Adder adder5(dff_out,mux_out,1'd0,adder_out,cout);
    assign down_done = ~|(dff_out);
    assign result = dff_out;


endmodule
