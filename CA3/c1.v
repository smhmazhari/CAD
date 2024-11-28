module c1(input A0 , A1 , SA , B0 , B1 ,SB , S0 , S1,output f) ;
 initial begin 
      $system("c1.exe ");
    end
wire f1 , f2 , s2; 
assign f1 = (SA)? A1:A0;
assign f2 = (SB)? B1:B0;
assign s2 = S0|S1;
assign f=(s2)?f2:f1;
endmodule
