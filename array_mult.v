module mult(input [7:0] A,
            input [7:0] B,
            output [15:0] mult_res
            );
    assign mult_res = A * B ; 
endmodule