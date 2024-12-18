module read_address_gen_controller (
    input clk,
    input rst,
    input can_count,
    input start,
    output reg load_registers
);

    parameter Wait = 1'b0 , Count = 1'b1;
    reg ps;
    reg ns;

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
            Wait : ns = (start == 1'b0) ? Wait :(can_count == 1'b1)? Count : Wait;
            Count : ns = (can_count == 1'b1) ? Count : Wait ;
            default : ns = Wait ;
        endcase
    end

    // combinational part (primary output)
    always @(*) begin
        load_registers = 1'b0;

        case (ps)
            Wait :  
                begin
                    load_registers = (can_count == 1'b1) ? 1'b1 : 1'b0 ;
                end
            Count :
                begin
                    load_registers = 1'b1 ;
                end
        endcase
    end
endmodule