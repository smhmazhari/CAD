module input_RAM(input clk,
    input read,
                 input [3:0] addr,
                 output reg [15:0] result);
    reg [15:0] RAM [0:15];
    initial begin
        $readmemb("file/data_input.txt", RAM);
    end
    always @(posedge clk)begin
        if(read)
        result <= RAM[addr];
    end
endmodule
