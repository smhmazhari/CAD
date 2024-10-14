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
    parameter A = 4'd0 , B = 4'd1 , C = 4'd2 , D = 4'd3,E = 4'd4,F = 4'd5,G = 4'd6,H = 4'd7,I = 4'd8,J = 4'd9,K = 4'd10 , L= 4'd11 , M = 4'd12;
    reg [3:0] ps;
    reg [3:0] ns;

    // sequential part
    always @(posedge clk) begin
        if(rst == 1'b1) 
            ps <= 4'b0;
        else ps <= ns;
    end

    // combinational part (next state)
    always @(start,DoneA,DoneB,Co3,down_done,ps) begin
        ns = A ;
        case(ps)
            A : ns = (start == 1'b0) ? A : B ;
            B : ns = (start == 1'b1) ? B : C ;
            C : ns = D ;
            D : ns = L ;
            L : ns = (DoneA == 1'b0) ? E : M ;  
            E : ns = (DoneA == 1'b0) ? E : M ;
            M : ns = (DoneB == 1'b0) ? F : G ; 
            F : ns = (DoneB == 1'b0) ? F : G ;
            G : ns = H;
            H : ns = (down_done == 1'b0) ? H : I ;
            I : ns = J;
            J : ns = (Co3 == 1'b0) ? C : A;
            K : ns = A ;
            default : ns = A ;
        endcase
    end

    // combinational part (primary output)
    always @(start,DoneA,DoneB,Co3,down_done,ps) begin
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
            B :  
                begin
                    rst3 = 1'b1;
                end
            C :   
                begin
                    read = 1'b1;
                    SA = 1'b1;
                    loadA = 1'b1;
                end
            D :  
                begin
                    read = 1'b1;
                    SB = 1'b1;
                    loadB = 1'b1;
                    rst5 = 1'b1;
                end
            E :
                begin
                    ShlA = 1'b1;  
                    cntU = 1'b1;

                end
            F :
                begin
                    ShlB = 1'b1;  
                    cntU = 1'b1;
                end
            G :
                begin
                    loadOut = 1'b1;  
                end
            H :
                begin
                    ShrOut = 1'b1;  
                    cntD = 1'b1;
                end
            I :
                begin
                    write = 1'b1;  
                end
            K :
                begin
                    Done = 1'b1;  
                end

        endcase
    end
endmodule