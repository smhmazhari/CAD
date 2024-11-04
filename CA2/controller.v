module controller (input clk,
                   input rst,
                   input en,
                   input check,
                   output reg valid,
                   output reg count_pointer
                   );
    parameter Idle = 2'd0 , Wait = 2'd1 ,Read_Write = 2'd2 ;
    reg [1:0] ps;
    reg [1:0] ns;

    // sequential part
    always @(posedge clk) begin
        if(rst == 1'b1) 
            ps <= 2'b0;
        else ps <= ns;
    end

    // combinational part (next state)
    always @(en,check,ps) begin
        ns = Idle ;
        case(ps)
            Idle : ns = (en == 1'b0) ? Idle : Wait ;
            Wait : ns = (check == 1'b0) ? Wait : Read_Write ;
            Read_Write : ns = Idle ;
            default : ns = Idle ;
        endcase
    end

    // combinational part (primary output)
    always @(ps) begin
        valid = 1'b0;
        count_pointer = 1'b0;

        case (ps)
            Read_Write :  
                begin
                    valid = 1'b1 ;
                    count_pointer = 1'b1 ;
                end
        endcase
    end
endmodule