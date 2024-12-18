module adder #(
    parameter ADDER_WIDTH = 8 
)(
    input [ADDER_WIDTH-1:0] in1,
    input[ADDER_WIDTH-1:0] in2,
    output [ADDER_WIDTH:0] add_result
);

    assign add_result = in1 + in2;

endmodule
