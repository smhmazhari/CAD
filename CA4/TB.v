module TB();
    reg clk = 1'd0;
    reg rst = 1'd1;
    reg chip_en = 1'd1;
    reg start = 1'd0;
    reg [2:0] filter_size = 3'd2;
    reg [2:0] if_size = 3'd4;
    reg [1:0] stride = 2'd1;
    reg [8-1:0] filter_buff_input;
    reg [8+1:0] if_buff_input;
    reg filter_buff_write_en = 1'd1;
    reg if_buff_write_en = 1'd1;
    reg read_buffer_result = 1'd1;
    wire Done;
    wire [8 + 8 : 0] par_sum;

conv_top_module  #(
    .IF_CELL_SIZE(10) ,
    .IF_ADDRESS_SIZE(8),
    .FILTER_CELL_SIZE(8),
    .FILTER_ADDRESS_SIZE(8) ,
    .STRIDE_SIZE(2),
    .CELL_NUMS_IF(8),
    .CELL_NUMS_FILTER(8),
    // .DATA_WIDTH(8),
    .PAR_WRITE(1),
    .PAR_READ(1),
    .DEPTH(64)
) top_moduuuuule(
    .clk(clk),
    .rst(rst),
    .chip_en(chip_en),
    .start(start),
    .filter_size(filter_size),
    .if_size(if_size),
    .stride(stride),
    .filter_buff_input(filter_buff_input),
    .if_buff_input(if_buff_input),
    .filter_buff_write_en(filter_buff_write_en),
    .if_buff_write_en(if_buff_write_en),
    .read_buffer_result(read_buffer_result),
    // input ,
    .Done(Done),
    .par_sum(par_sum)
);
    always #5 clk = ~clk;    

    initial begin
        #7 rst = 1'd1;
        #10 rst = 1'd0;
        #10 filter_buff_input = 8'd7;
        if_buff_input = 10'd15;
        start = 1'd1;
        start = 1'd0;
        #1000;
        $finish;
    end

endmodule