module app_mult(input clk ,
                input start,
                input rst,
                output Done
);
    wire read , write,rst3,cnt3,SA,SB,shlA,loadA,shlB,loadB,rst5,cntU,cntD,ShrOut,loadOut,Co3,DoneA,DoneB,down_done;
    datapath DP (read,write,clk,rst,rst3,cnt3,SA,SB,ShlA,loadA,ShlB,loadB,rst5,cntU,cntD,ShrOut,loadOut,Co3,DoneA,DoneB,down_done);
    controller CU(start,clk,rst,DoneA,DoneB,down_done,Co3,Done,rst3,rst5,read,write,SA,loadA,SB,loadB,ShlA,ShlB,cntU,cntD,cnt3,loadOut,ShrOut);
    // Co5 == down_done
endmodule