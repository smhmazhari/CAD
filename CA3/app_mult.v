module app_mult(input clk ,
                input start,
                input rst,
                output Done
);
    wire shlA,loadA,shlB,loadB,rst5,cntU,cntD,shrOut,loadOut,DoneA,DoneB,downDone;

    datapath DP (clk,rst,A,B,shlA,loadA,shlB,loadB,rst5,cntU,cntD,shrOut,loadOut,DoneA,DoneB,downDone);
    controller CU(clk,rst,start,DoneA,DoneB,downDone,Done,rst5,loadA,loadB,shlA,shlB,cntU,cntD,loadOut,shrOut);

endmodule