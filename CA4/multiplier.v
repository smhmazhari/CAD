module  multiplier #(parameter INP1_WIDTH = 8 , parameter INP2_WIDTH = 8 ) (input[INP1_WIDTH -1:0] in1,input[INP2_WIDTH-1:0] in2,output[INP1_WIDTH+INP2_WIDTH-1:0] mult_result);

    assign mult_result = in1 * in2 ;    
endmodule
