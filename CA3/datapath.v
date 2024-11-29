module datapath( input clk, 
                 input rst,
                 input [15:0] A,
                 input [15:0] B,
                 input shlA,
                 input loadA,
                 input shlB,
                 input loadB,
                 input rst5,
                 input cntU,
                 input cntD,
                 input shrOut,
                 input loadOut,
                 output DoneA,
                 output DoneB,
                 output downDone,
                 output [15:0] mult_result
                );

    wire [15:0] A_out;
    wire [15:0] B_out;
    wire [15:0] temp_res;
    wire [15:0] mult_res;
    wire [4:0] temp;

    shift_register_left_16bit A_register(clk,loadA,shlA,A,A_out );
    shift_register_left_16bit B_register(clk,loadB,shlB,B,B_out );
    mult array_mult(A_out[15:8],B_out[15:8],temp_res);
    shift_register_right_16bit result_register(clk,loadOut,shrOut,temp_res,mult_res);
    counter_5bit counter_5(clk,rst,rst5,cntU,cntD,downDone,temp);
    
    assign DoneA = A_out[15] || (1'b0) ;
    assign DoneB = B_out[15] || (1'b0) ;

    assign mult_result = mult_res;


endmodule
