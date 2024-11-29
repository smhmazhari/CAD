module shift_block(input clk,input rst,input ld,input shift,input parin,input serin,output result);
//module s2(input D00 , D01 ,D10 , D11 , A1 , B1 , A0,B0 , clr , clk , output out);

    s2 shiftblock(result,serin,parin,parin,ld,ld,shift,shift,rst,clk,result);

endmodule