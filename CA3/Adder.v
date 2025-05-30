module Adder #(parameter N = 5)(a, b, cin, s, cout);
    input [N-1:0] a;
    input [N-1:0] b;
    input cin;

    output [N-1:0] s;
    output cout;

    wire [N-1:0] carry;

    genvar i;
    generate
    for (i = 0; i < N; i = i + 1) begin
        if (i == 0)
            FA f(.A(a[0]), .B(b[0]), .Cin(cin), .Sum(s[0]), .Cout(carry[0]));
        else
            FA f(.A(a[i]), .B(b[i]), .Cin(carry[i-1]), .Sum(s[i]), .Cout(carry[i]));
    end

    assign cout = carry[N-1];
    endgenerate
    
endmodule
