module datapath( input read,
                 input write,
                 input clk,
                 input rst,
                 input rst3,
                 input cnt3,
                 input SA,
                 input SB,
                 input ShlA,
                 input loadA,
                 input ShlB,
                 input loadB,
                 input rst5,
                 input cntU,
                 input cntD,
                 input ShrOut,
                 input loadOut,
                 output Co3,
                 output DoneA,
                 output DoneB,
                 output down_done
                );
    wire cascading_bit;
    wire [2:0] counter3_res;
    wire [15:0] RAM_res;
    wire [15:0] A_out;
    wire [15:0] B_out;
    wire [15:0] temp_res;
    wire [31:0] mult_res;
    wire [4:0] temp;
    mux mux_2to1 (SA,SB, 1'b0, 1'b1, cascading_bit);
    counter_3bit counter_3(clk,rst,rst3,cnt3,Co3,counter3_res);
    shift_register_16bit A_register(clk,loadA,ShlA,RAM_res,A_out );
    shift_register_16bit B_register(clk,loadB,ShlB,RAM_res,B_out );
    mult array_mult(A_out[15:8],B_out[15:8],temp_res);
    shift_register_32bit result_register(clk,loadOut,ShrOut,{temp_res,16'b0},mult_res);
    output_RAM out_RAM(write,counter3_res,clk,mult_res);//check RAM
    counter_5bit counter_5(clk,rst,rst5,cntU,cntD,down_done,temp);
    assign DoneA = A_out[15] || (1'b0) ;//check
    assign DoneB = B_out[15] || (1'b0) ;//check

    input_RAM in_RAM(clk,read,{counter3_res,cascading_bit},RAM_res);


endmodule