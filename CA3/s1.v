module s1(input D00 , D01 ,D10 , D11 , A1 , B1 , A0 , clr , clk , output out);
 initial begin 
      $system("s2-s1.exe ");
    end
    wire s0 , s1 ,d; 
    assign s1 = A1 | B1 ;
    assign s0 = A0 & clr ;
    assign d= ({s1,s0}== 2'd0)? D00: 
              ({s1,s0}==2'd1)? D01: 
              ({s1,s0}==2'd2)? D10: 
              ({s1,s0}==2'd3)? D11 :
                    2'bz;
    FDCP ff(clk , clr , d, out) ;

endmodule
