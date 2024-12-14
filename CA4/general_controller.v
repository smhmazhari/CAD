module general_controller(input clk,input rst,input start,input done,output reg inner_start,output reg inner_rst);
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
    always(*)begin
        ns = WAIT;
        case(ps)
            WAIT : start ? INIT : WAIT;
            INIT : start ? INIT : COMPUTE;
            COMPUTE : done ? WAIT : COMPUTE;
        endcase
    end
    //OUTPUT
    always(*)begin
        {inner_rst,inner_start} = 2'b10;
        case (ps)
            INIT: {inner_rst,inner_start} = start ? 2'b10 : 2'b01;
        endcase
    end

endmodule