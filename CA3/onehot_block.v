module one_hot_block(input clk,input rst,input [1:0]in,input signal,output state,output out_inv,output out);
    
    s2 first(1'd0,in[0],1'd0,in[1],in[1],in[1],1'd1,1'd1,rst,clk,state);
    c1 inverter(state,state,state,1'd1,1'd0,signal,state,state,out_inv);
    c1 outt(state,state,state,signal,signal,signal,state,state,out);
    
endmodule