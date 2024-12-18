module checker #(
    parameter IF_CELL_SIZE = 8 ,
    parameter IF_ADDRESS_SIZE = 8 ,
    parameter FILTER_CELL_SIZE = 8 ,
    parameter FILTER_ADDRESS_SIZE = 8 ,
    parameter STRIDE_SIZE = 2 ,
    parameter CELL_NUMS_IF = 8,
    parameter CELL_NUMS_FILTER = 8
)(
    input [STRIDE_SIZE-1:0] stride,
    input [2:0] filter_size,
    input [2:0] if_size,
    input [IF_ADDRESS_SIZE-1:0] write_addr_if,
    input [FILTER_ADDRESS_SIZE-1:0] write_addr_filter,
    input [IF_ADDRESS_SIZE-1:0] start_if,
    input [IF_ADDRESS_SIZE-1:0] current_if,
    input [FILTER_ADDRESS_SIZE-1:0] start_filter,
    input [FILTER_ADDRESS_SIZE-1:0] current_filter,
    input [IF_ADDRESS_SIZE-1:0] write_start,
    output reg scratch_write_en,//,
    output reg [IF_ADDRESS_SIZE-1:0] start_if_out,//,
    output reg [IF_ADDRESS_SIZE-1:0] current_if_out,//,
    output reg [FILTER_ADDRESS_SIZE-1:0] start_filter_out,//,
    output reg [FILTER_ADDRESS_SIZE-1:0] current_filter_out,//,
    output reg [IF_ADDRESS_SIZE-1:0] write_start_out,//,
    output reg par_done,//,
    output reg can_count,//,
    output reg can_mult,//,
    output reg Done
);//TODO);

    always @(*)begin
        if(current_filter-start_filter % filter_size == filter_size - 1)begin//1
            if(current_if - start_if % if_size == if_size -1)begin//a
                if((current_filter + 1) / filter_size == CELL_NUMS_FILTER / filter_size)begin//i
                    if((start_if + 1) % CELL_NUMS_IF == write_addr_if)begin
                        can_count = 1'd0;
                        can_mult = 1'd0;
                        par_done = 1'd1;
                        start_filter_out = start_filter;
                        current_filter_out = current_filter;
                        current_if_out = current_if;
                        start_if_out =start_if;
                        write_start_out = write_start;
                    end
                    else begin
                        start_if_out = (start_if + if_size) % CELL_NUMS_IF;
                        current_if_out = (start_if + if_size) % CELL_NUMS_IF;
                        current_filter_out = 0;
                        start_filter_out = 0;
                        can_count = 1'd1;
                        can_mult = 1'd1;
                        par_done = 1'd1;
                        write_start_out = (write_start + if_size)%CELL_NUMS_IF;
                        

                    end
            end
                else begin//ii
                    if((start_filter + 1)%CELL_NUMS_FILTER == write_addr_filter)begin
                        can_count = 1'd0;
                        can_mult = 1'd0;
                        par_done = 1'd1;
                        start_filter_out = start_filter;
                        current_filter_out = current_filter;
                        current_if_out = current_if;
                        start_if_out =start_if;
                        write_start_out = write_start;
                    end
                    else begin
                        current_if_out = start_if;
                        start_if_out = start_if;
                        start_filter_out = (start_filter + filter_size) % CELL_NUMS_FILTER;
                        current_filter_out = (start_filter + filter_size) % CELL_NUMS_FILTER;
                        can_count = 1'd1;
                        can_mult = 1'd1;
                        par_done = 1'd1;
                        write_start_out = write_start;
                    end
                end
            end
            else begin//b
                if((current_if + 1) % CELL_NUMS_IF > write_addr_if)begin
                    can_count = 1'd0;
                    can_mult = 1'd0;
                    par_done = 1'd1;
                    start_filter_out = start_filter;
                    current_filter_out = current_filter;
                    current_if_out = current_if;
                    start_if_out =start_if;

                    write_start_out = write_start;
                end
                else begin
                    current_filter_out = start_filter;
                    start_filter_out = start_filter;
                    current_if_out = start_if + stride;
                    start_if_out = start_if + stride;
                    can_count = 1'd1;
                    can_mult = 1'd1;
                    par_done = 1'd1;
                    write_start_out = write_start;
                    
                end
            end
        end
        else begin//2
                if((current_if + 1) % CELL_NUMS_IF > write_addr_if || (current_filter + 1) % CELL_NUMS_FILTER > write_addr_filter )begin
                    can_count = 1'd0;
                    can_mult = 1'd0;
                    par_done = 1'd0;
                    start_filter_out = start_filter;
                    current_filter_out = current_filter;
                    current_if_out = current_if;
                    start_if_out =start_if;
                    write_start_out = write_start;
                end
                else begin
                    can_count = 1'd1;
                    can_mult = 1'd1;
                    par_done = 1'd0;
                    start_filter_out = start_filter;
                    current_filter_out = current_filter + 1;
                    start_if_out = start_if;
                    current_if_out = current_if + 1;
                    write_start_out = write_start;
                end
        end
    end
    always @(*)begin
        if((write_addr_if + 1) % CELL_NUMS_IF == write_start)begin
            scratch_write_en = 1'd0;
        end
        else begin
            scratch_write_en = 1'd1;
        end
    end
endmodule