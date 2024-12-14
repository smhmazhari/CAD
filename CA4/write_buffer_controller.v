module controller (input clk,
                   input rst,
                   input par_done,
                   input ready,
                   output write_req,
                   output stall_output_buffer,
                   output write_in_buffer
                   );
    parameter Wait = 2'd0 , Write_Req = 2'd1 ,Stall = 2'd2, Do_Write = 2'd3 ;
    reg [1:0] ps;
    reg [1:0] ns;

    // sequential part
    always @(posedge clk) begin
        if(rst == 1'b1) 
            ps <= 2'b0;
        else ps <= ns;
    end

    // combinational part (next state)
    always @(par_done,ready) begin
        ns = Wait ;
        case(ps)
            Wait : ns = (par_done == 1'b0) ? Wait : Write_Req ;
            Write_Req : ns = (ready == 1'b0) ? Stall : Do_Write ;
            Stall : ns = (ready == 1'b0) ? Stall : Do_Write;
            Do_Write : ns = Wait ;
            default : ns = Wait ;
        endcase
    end

    // combinational part (primary output)
    always @(ps) begin
        write_req = 1'b0;
        stall_output_buffer = 1'b0;
        write_in_buffer = 1'b0;

        case (ps)
            Wait :  
                begin
                    write_req = (par_done == 1'b1) ? 1'b1 : 1'b0 ;
                end
            Write_Req :
                begin
                    stall_output_buffer = (ready == 1'b1) ? 1'b0: 1'b1 ;
                end
            Stall :
                begin
                    stall_output_buffer = 1'b1 ;
                    write_req = 1'b1 ;
                end
            Do_Write :
                begin
                    write_in_buffer = 1'b1;
                end
        endcase
    end
endmodule