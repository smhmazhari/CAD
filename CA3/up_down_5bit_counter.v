module counter_5bit (
    input clk,
    input rst,
    input rst5,
    input cntU,
    input cntD,
    output down_done,
    output[4:0] result
);

    wire [4:0]adder_out;
    wire [4:0]mux_out;
    wire cout;

    s2 input_dff0(adder_out[0],adder_out[0],1'd0,1'd0,rst5,rst5,1'd0,1'd0,rst,clk,result[0]);
    s2 input_dff1(adder_out[1],adder_out[1],1'd0,1'd0,rst5,rst5,1'd0,1'd0,rst,clk,result[1]);
    s2 input_dff2(adder_out[2],adder_out[2],1'd0,1'd0,rst5,rst5,1'd0,1'd0,rst,clk,result[2]);
    s2 input_dff3(adder_out[3],adder_out[3],1'd0,1'd0,rst5,rst5,1'd0,1'd0,rst,clk,result[3]);
    s2 input_dff4(adder_out[4],adder_out[4],1'd0,1'd0,rst5,rst5,1'd0,1'd0,rst,clk,result[4]);

    c2 output_mux0(1'd0,1'd1,1'd1,1'd0,cntD,cntD,cntU,cntU,mux_out[0]);
    c2 output_mux1(1'd0,1'd0,1'd1,1'd0,cntD,cntD,cntU,cntU,mux_out[1]);
    c2 output_mux2(1'd0,1'd0,1'd1,1'd0,cntD,cntD,cntU,cntU,mux_out[2]);
    c2 output_mux3(1'd0,1'd0,1'd1,1'd0,cntD,cntD,cntU,cntU,mux_out[3]);
    c2 output_mux4(1'd0,1'd0,1'd1,1'd0,cntD,cntD,cntU,cntU,mux_out[4]);

    Adder adder5(result,mux_out,1'd0,adder_out,cout);
    wire first_or;
    wire second_or;
    wire third_or;
    wire inv_down_done;
    Or first(result[0],result[1],first_or);
    Or second(result[2],result[3],second_or);
    Or third(first_or,second_or,third_or);
    Or fourth(result[4],third_or,inv_down_done);
    Not down_out(inv_down_done,down_done);
    
endmodule