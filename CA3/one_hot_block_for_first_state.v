module one_hot_block_first_state(input clk,input rst,input [2:0]in,input signal,output state,output out_inv,output out);
    //module s2(input D00 , D01 ,D10 , D11 , A1 , B1 , A0,B0 , clr , clk , output out);
//     module FDCP(
//   input clk , CLR, D, 
//   output reg Q);
//module c1(input A0 , A1 , SA , B0 , B1 ,SB , S0 , S1,output f) ;

    wire flip_in;
    c1 firsttt(in[0],in[1],in[1],in[2],in[2],in[2],in[2],in[2],flip_in);
    FDCP ff(clk,rst,flip_in,state);
    c1 inverterrrrr(state,state,state,1'd1,1'd0,signal,state,state,out_inv);
    c1 outttttt(state,state,state,signal,signal,signal,state,state,out);

endmodule