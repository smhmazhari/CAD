
module pipe_cotroller(input clk,input rst,input start,input can_mult,output reg pipe_stall,output reg ld_mult,output reg ld_add);
    parameter WAIT = 1'd0 , PIPE = 1'd1;
    reg ps;
    reg ns;
    always @(posedge clk,posedge rst)begin
        if(rst)begin
            ps <= 1'd0;
        end
        else begin
            ps <= ns;
        end

    end
    //next state
    always @(*)begin
        ns = WAIT;
        case(ps)
            WAIT : begin
                if(!start)
                    ps <= WAIT;
                else begin
                    if(can_mult)begin
                        ns <= PIPE;
                    end
                    else begin
                        ns <= WAIT;
                    end
                end
            end
            PIPE : ns = can_mult ? PIPE : WAIT;
        endcase
    end
    //output
    always@(*)begin
        {pipe_stall,ld_add,ld_mult} = 3'b000;
        case (ps)
            WAIT : pipe_stall = 1'd1;
            PIPE : {ld_add,ld_mult} = 2'b11;
        endcase
    end


endmodule