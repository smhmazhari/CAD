module output_RAM(input write,
                 input [2:0] addr,
                 input clk,
                 input [31:0] data);
    reg [31:0] RAM [0:7];
    always @ (posedge clk)begin 
        if (write == 1'b1)
            RAM[addr] <=  data ; 
    end
    
endmodule
