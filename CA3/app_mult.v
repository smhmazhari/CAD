module app_mult(input clk ,
                input start,
                input rst,
                input [15:0] A,
                input [15:0] B,
                output Done,
                output [15:0] Result
);
    wire shlA,loadA,shlB,loadB,rst5,cntU,cntD,shrOut,loadOut,DoneA,DoneB,downDone;

    datapath DP (clk,rst,A,B,shlA,loadA,shlB,loadB,rst5,cntU,cntD,shrOut,loadOut,DoneA,DoneB,downDone,Result);
    controller CU(clk,rst,start,DoneA,DoneB,downDone,Done,rst5,loadA,loadB,shlA,shlB,cntU,cntD,loadOut,shrOut);

endmodule
