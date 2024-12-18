module read_buffer_controller (
    input clk,
    input rst,
    input scratch_write_en,
    input valid,
    input start,
    output reg cnt,
    output reg write_in_scratch
);

    parameter Wait = 1'd0 ,Do_Write = 1'd1;
    reg ps;
    reg ns;

    // sequential part
    always @(posedge clk) begin
        if(rst == 1'b1 ) 
            ps <= 1'b0;
        else ps <= ns;
    end

    // combinational part (next state)
    always @(*) begin
        ns = Wait ;
        case(ps)
            Wait : ns = (start == 1'b0) ? Wait :((scratch_write_en == 1'b1)? ((valid == 1'b1) ? Do_Write : Wait):Wait) ;
            Do_Write : ns = (scratch_write_en == 1'b1) ? Do_Write : Wait ;
            default : ns = Wait ;
        endcase
    end

    // combinational part (primary output)
    always @(*) begin

        cnt = 1'b0;
        write_in_scratch = 1'b0;

        case (ps)
            Do_Write :
                begin
                    write_in_scratch = 1'b1;
                    cnt = 1'b1;
                end
        endcase
    end
endmodule