module output_RAM(
    input write,
    input [2:0] addr,
    input clk,
    input [31:0] data
);

    reg [31:0] RAM [0:7];
    integer file; 

    always @ (posedge clk) begin 
        if (write == 1'b1) begin
            RAM[addr] <=  data;
        file = $fopen("file/data_output.txt", "a");
        
            
       
        $fwrite(file, "%h\n", data);
            
            $fclose(file);
    
        end
    end


    
endmodule