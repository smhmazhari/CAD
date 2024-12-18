module write_buffer_controller (input clk,
                   input rst,
                   input par_done,
                   input ready,
                   input start,
                   output reg stall_output_buffer,
                   output reg write_in_buffer
                   );
    parameter Wait = 2'd0 ,Stall = 2'd2, Do_Write = 2'd3 ;
    reg [1:0] ps;
    reg [1:0] ns;

    // sequential part
    always @(posedge clk) begin
        if(rst == 1'b1 ) 
            ps <= 2'b0;
        else ps <= ns;
    end

    // combinational part (next state)
    always @(*) begin
        ns = Wait ;
        case(ps)
            Wait : ns = (start == 1'b0) ? Wait :((par_done == 1'b1) ? ((ready) ? Do_Write:Stall) : Wait);
            Stall : ns = (ready == 1'b0) ? Stall : Do_Write;
            Do_Write : ns = par_done ? Do_Write : Wait ;
            default : ns = Wait ;
        endcase
    end

    // combinational part (primary output)
    always @(*) begin
        stall_output_buffer = 1'b0;
        write_in_buffer = 1'b0;

        case (ps)
            Stall :
                begin
                    stall_output_buffer = 1'b1 ;
                end
            Do_Write :
                begin
                    write_in_buffer = 1'b1;
                end
        endcase
    end
endmodule