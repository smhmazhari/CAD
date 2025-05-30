module FA (
    input wire A,   
    input wire B,    
    input wire Cin,  
    output wire Sum,  
    output wire Cout 
);

    wire AxorB;
    wire AandB;
    wire XorAndCin;

    Xor x1(.out(AxorB), .a(A), .b(B));
    Xor x2(.out(Sum), .a(AxorB), .b(Cin));

    And a2(.out(XorAndCin), .a(AxorB), .b(Cin));
    And a3(.out(AandB), .a(A), .b(B));
  
    Or o1(.out(Cout),.a( XorAndCin), .b(AandB));

endmodule
