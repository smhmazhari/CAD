module shift_block(input clk,input rst,input ld,input shift,input parin,input serin,output result);

    s2 shiftblock(result,serin,parin,parin,ld,ld,shift,shift,rst,clk,result);
    
endmodule