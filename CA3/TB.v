`timescale 1ns / 1ns
module TB();
    
    reg clk = 1'b1;
    reg start=1'b0;
    reg rst=1'b1;
    reg[15:0] A;
    reg[15:0] B;
    wire Done;
    wire[15:0] result;

    app_mult uut (
        .clk(clk),
        .start(start),
        .rst(rst),
        .Done(Done),
        .A(A),
        .B(B),
        .Result(result)
    );
    always #5 clk = ~clk;    

    initial begin
        #7
        rst = 1;  
        start = 0;
        #10;
        
        rst = 0;
        #10;

        start = 1;
        A = 16'b0010000000000000;
        B = 16'b0000000001000000;
        #50; 
        start = 0; 

        #100000; 

        $finish;
    end
    
endmodule