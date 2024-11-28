module mux (
    input SA,
    input SB,
    input A,
    input B,
    output result
);
    assign result = (SA == 1'b1) ? A: 
                    (SB == 1'b1) ? B:
                    A ;
endmodule                     