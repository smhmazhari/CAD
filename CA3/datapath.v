module datapath( input clk, 
                 input rst,
                 input [15:0] A,
                 input [15:0] B,
                 input ShlA,
                 input loadA,
                 input ShlB,
                 input loadB,
                 input rst5,
                 input cntU,
                 input cntD,
                 input ShrOut,
                 input loadOut,
                 output DoneA,
                 output DoneB,
                 output down_done,
                 output [15:0] mult_result
                );

    wire [15:0] A_out;
    wire [15:0] B_out;
    wire [15:0] temp_res;
    wire [15:0] mult_res;
    wire [4:0] temp;

    shift_register_left_16bit A_register(clk,loadA,ShlA,A,A_out );
    shift_register_left_16bit B_register(clk,loadB,ShlB,B,B_out );
    mult array_mult(A_out[15:8],B_out[15:8],temp_res);
    shift_register_right_16bit result_register(clk,loadOut,ShrOut,temp_res,mult_res);
    counter_5bit counter_5(clk,rst,rst5,cntU,cntD,down_done,temp);
    
    assign DoneA = A_out[15] || (1'b0) ;//check
    assign DoneB = B_out[15] || (1'b0) ;//check

    assign mult_result = mult_res;


endmodule
