module controller (input start,
                   input clk,
                   input rst,
                   input DoneA,
                   input DoneB,
                   input down_done,
                   input Co3,
                   output reg Done,
                   output reg rst3,
                   output reg rst5,
                   output reg read,
                   output reg write,
                   output reg SA,
                   output reg loadA,
                   output reg SB,
                   output reg loadB,
                   output reg ShlA,
                   output reg ShlB,
                   output reg cntU,
                   output reg cntD,
                   output reg cnt3,
                   output reg loadOut,
                   output reg ShrOut
                   );
    parameter IDLE = 4'd0 , WAIT = 4'd1 , READ_A = 4'd2 , READ_B = 4'd3,SHIFT_A = 4'd4,SHIFT_B = 4'd5,REGISTER_MULT_RES = 4'd6,SHIFT_RES = 4'd7,WRITE_RES = 4'd8,EXTRA = 4'd9,CHECK_END = 4'd10 , CHECK_DONE_A= 4'd11 , CHECK_DONE_B = 4'd12,LOAD_A = 4'd13,LOAD_B = 4'd14;
    reg [3:0] ps;
    reg [3:0] ns;

    // sequential part
    always @(posedge clk) begin
        if(rst == 1'b1) 
            ps <= 4'b0;
        else ps <= ns;
    end

    // combinational part (next state)
    always @(*) begin
        ns = IDLE ;
        case(ps)
            IDLE : ns = (start == 1'b0) ? IDLE : WAIT ;
            WAIT : ns = (start == 1'b1) ? WAIT : READ_A ;
            READ_A : ns = LOAD_A ;
            LOAD_A: ns = READ_B;
            READ_B : ns = LOAD_B ;
            LOAD_B: ns = CHECK_DONE_A;
            CHECK_DONE_A : ns = (DoneA == 1'b0) ? SHIFT_A : CHECK_DONE_B ;  
            SHIFT_A : ns = CHECK_DONE_A;
            CHECK_DONE_B : ns = (DoneB == 1'b0) ? SHIFT_B : REGISTER_MULT_RES ; 
            SHIFT_B : ns = CHECK_DONE_B;
            REGISTER_MULT_RES : ns = SHIFT_RES;
            SHIFT_RES : ns = (down_done == 1'b0) ? SHIFT_RES : WRITE_RES ;
            WRITE_RES : ns = EXTRA;
            EXTRA : ns = (Co3 == 1'b0) ? READ_A : IDLE;
            CHECK_END : ns = IDLE ;
            default : ns = IDLE ;
        endcase
    end

    // combinational part (primary output)
    always @(*) begin
        Done = 1'b0;
        rst3 = 1'b0;
        rst5 = 1'b0;
        read = 1'b0 ;
        write = 1'b0;
        SA = 1'b0;
        loadA = 1'b0;
        SB = 1'b0;
        loadB = 1'b0;
        ShlA = 1'b0;
        ShlB = 1'b0;
        cntU = 1'b0;
        cntD = 1'b0;
        cnt3 = 1'b0;
        loadOut = 1'b0;
        ShrOut = 1'b0;
        case (ps)
            WAIT :  
                begin
                    rst3 = 1'b1;
                end
            READ_A :   
                begin
                    read = 1'b1;
                    SA = 1'b1;
                    
                end
            LOAD_A : begin
                loadA = 1'b1;
            end
            READ_B :  
                begin
                    read = 1'b1;
                    SB = 1'b1;
                    
                    rst5 = 1'b1;
                end
            LOAD_B : begin
                loadB = 1'b1;
            end
            SHIFT_A :
                begin
                    ShlA = 1'b1;  
                    cntU = 1'b1;

                end
            SHIFT_B :
                begin
                    ShlB = 1'b1;  
                    cntU = 1'b1;
                end
            REGISTER_MULT_RES :
                begin
                    loadOut = 1'b1;  
                end
            SHIFT_RES :
                begin
                    if(down_done == 1'b0) 
                        ShrOut = 1'b1; 
                    cntD = 1'b1;
                end
            WRITE_RES :
                begin
                    write = 1'b1;
                    cnt3 = 1'b1;  
                end
            CHECK_END :
                begin
                    Done = 1'b1;  
                end

        endcase
    end
endmodule