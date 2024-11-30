module one_hot_block_first_state(input clk,input rst,input [2:0]in,input signal,output state,output out_inv,output out);
    
    wire flip_in;
    c1 firsttt(in[0],in[1],in[1],in[2],in[2],in[2],in[2],in[2],flip_in);
    s2 ff(flip_in,flip_in,flip_in,flip_in,flip_in,flip_in,flip_in,flip_in,rst,clk,state);
    c1 inverterrrrr(state,state,state,1'd1,1'd0,signal,state,state,out_inv);
    c1 outttttt(state,state,state,signal,signal,signal,state,state,out);

endmodule