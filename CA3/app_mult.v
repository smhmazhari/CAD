module app_mult(input clk ,
                input start,
                input rst,
                output Done
);
    wire ShlA,loadA,ShlB,loadB,rst5,cntU,cntD,ShrOut,loadOut,DoneA,DoneB,down_done;

    datapath DP (clk,rst,A,B,ShlA,loadA,ShlB,loadB,rst5,cntU,cntD,ShrOut,loadOut,DoneA,DoneB,down_done);
    controller CU(start,clk,rst,DoneA,DoneB,down_done,Done,rst5,loadA,loadB,ShlA,ShlB,cntU,cntD,loadOut,ShrOut);
endmodule