module general_controller(input clk,input rst,input start,input done,output reg inner_start);
    parameter WAIT = 2'd0 , INIT = 2'd1 , COMPUTE = 2'd2;
    reg[1:0] ps;
    reg[1:0] ns;
    always @(posedge clk ,posedge rst)begin
        if(rst)begin
            ps <= WAIT;
        end    
        else begin
            ps <= ns;
        end

    end
    //next state
    always @(*)begin
        ns = WAIT;
        case(ps)
            WAIT : ns =  start ? INIT : WAIT;
            INIT : ns = start ? INIT : COMPUTE;
            COMPUTE : ns = done ? WAIT : COMPUTE;
        endcase
    end
    //OUTPUT
    always @(*)begin
        inner_start = 1'b0;
        case (ps)
            INIT: inner_start = start ? 1'b0 : 1'b1;
        endcase
    end

endmodule