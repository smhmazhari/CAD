module checker #(
    parameter PAR_WRITE = 2,       
    parameter PAR_READ = 4,
    parameter POINTER_SIZE = 3  
)(
    input [POINTER_SIZE -1 : 0] write_pointer,
    input [POINTER_SIZE -1 : 0] read_pointer,
    output full,
    output empty,
    output reg check_write,
    output reg check_read
);

    assign full = (write_pointer + 1 == read_pointer) ? 1'b1 : 1'b0; 
    assign empty = (write_pointer == read_pointer) ? 1'b1 : 1'b0; 

    integer i; 

    always @(*) begin
        check_read = 1; 

        for (i = 0; i < PAR_READ; i = i + 1) begin
            if ((read_pointer + i) % (1 << POINTER_SIZE) == write_pointer) begin 
                check_read = 0; 
       
            end
        end
    end

    always @(*) begin
        check_write = 1; 

        for (i = 0; i < PAR_WRITE; i = i + 1) begin
            if ((write_pointer + i) % (1 << POINTER_SIZE) == read_pointer) begin 
                check_write = 0; 
          
            end
        end
        
    end


endmodule
