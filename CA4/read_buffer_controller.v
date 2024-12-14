module read_buffer_controller (input clk,
                   input rst,
                   input inner_rst,
                   input scratch_write_en,
                   input valid,
                   input start,
                   output write_req_scratch,
                   output read_req_buffer,
                   output cnt,
                   output write_in_scratch
                   );
    parameter Wait = 2'd0 , Read_Req = 2'd1 ,Do_Write = 2'd2;
    reg [1:0] ps;
    reg [1:0] ns;

    // sequential part
    always @(posedge clk) begin
        if(rst == 1'b1 || inner_rst == 1'b1) 
            ps <= 2'b0;
        else ps <= ns;
    end

    // combinational part (next state)
    always @(*) begin
        ns = Wait ;
        case(ps)
            Wait : ns = (start == 1'b0) ? Wait :(scratch_write_en == 1'b1)? Read_Req : Wait ;
            Read_Req : ns = (valid == 1'b0) ? Read_Req : Do_Write ;
            Do_Write : ns = Wait ;
            default : ns = Wait ;
        endcase
    end

    // combinational part (primary output)
    always @(*) begin
        write_req_scratch = 1'b0;
        read_req_bufferr = 1'b0;
        cnt = 1'b0;
        write_in_scratch = 1'b0;

        case (ps)
            Wait :  
                begin
                    write_req_scratch = 1'b1;
                end
            Read_Req :
                begin
                    read_req_buffer = 1'b1;
                end
            Do_Write :
                begin
                    write_in_scratch = 1'b1;
                    cnt = 1'b1;
                end
        endcase
    end
endmodule