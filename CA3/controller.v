module controller(input clk,input rst,input start,input DoneA,input DoneB,input downDone,output reg Done,output reg rst5,output reg loadA,output reg loadB,output reg shlA,output reg shlB,output reg cntU,output reg cntD,output reg loadOut,output reg shrOut);
    parameter IDLE = 3'd0 ,WAIT = 3'd1 ,CHECKA = 3'd2 ,SHA = 3'd3, CHECKB = 3'd4 ,SHB = 3'd5 ,SHOUT = 3'd6;
    reg [2:0]ps;
    reg [2:0]ns;
    always @(posedge clk) begin
        if(rst == 1'b1) 
            ps <= 3'b0;
        else ps <= ns;
    end
    always @(*)begin
        ns = IDLE;
        case(ps)
            IDLE : ns = start ? WAIT : IDEL;
            WAIT : ns = start ? WAIT : CHECKA;
            CHECKA : ns = DoneA ? CHECKB : SHA;
            SHA : ns = CHECKA;
            CHECKB : ns = DoneB ? SHOUT : SHB;
            SHB : ns = CHECKB;
            SHOUT : ns = down_done ? IDLE : SHOUT;
        endcase
    end
    always @(*)begin
        {Done,rst5,loadA,loadB,shlA,shlB,cntU,cntD,loadOut,shrOut} = 10'd0;
        case(ps)
            WAIT : begin
              rst5 = 1'd0;
              {loadA,loadA} = start ? 2'd0 : 2'd3;
            end
            SHA : begin
              {shlA,cntU} = 2'd3;
            end
            SHB : begin
              {shlB,cntU} = 2'd3;
            end
            CHECKB : begin
                loadOut = DoneB ? 1'd1 : 1'd0;
            end
            SHOUT :  begin
                if(down_done == 1'b0)begin
                    shrOut = 1'b1;

                end
                else begin
                    Done = 1'd1;
                end
                     
                cntD = 1'b1;
            end


        endcase
    end

endmodule
