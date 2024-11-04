module buffer #(
    parameter PAR_WRITE = 2,       
    parameter PAR_READ = 4,
    parameter BUFFER_SIZE = 16,
    parameter BUFFER_ADDR = 3  
)(
    input clk,
    input rst,
    input read_en,
    input write_en,
    input [BUFFER_ADDR-1 : 0] read_addr,
    input [BUFFER_ADDR-1 : 0] write_addr,
    input [PAR_WRITE * BUFFER_SIZE - 1 : 0] data_in,
    output reg [PAR_READ * BUFFER_SIZE - 1 : 0] data_out
);

    reg [BUFFER_SIZE - 1 : 0] RAM [0 : (1 << BUFFER_ADDR) - 1];

    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < (1 << BUFFER_ADDR); i = i + 1) begin
                RAM[i] <= 0;
            end
        end else if (write_en) begin
            for (i = 0; i < PAR_WRITE; i = i + 1) begin
                RAM[(write_addr + i) % (1 << BUFFER_ADDR)] <= data_in[i * BUFFER_SIZE +: BUFFER_SIZE];
            end
        end
    end

    always @(*) begin
        if (read_en) begin
            for (i = 0; i < PAR_READ; i = i + 1) begin
                data_out[i * BUFFER_SIZE +: BUFFER_SIZE] = RAM[(read_addr + i) % (1 << BUFFER_ADDR)];
            end
        end else begin
            data_out = 0;
        end
    end

endmodule
