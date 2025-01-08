module Register #(parameter SIZE = 16) (
    input wire clk,
    input wire rst,
    input wire right_shen,
    input wire left_shen,
    input wire ser_in,
    input wire ld_en,
    input wire signed [SIZE - 1:0] inval,
    output wire msb,
    output wire signed [SIZE - 1:0] outval
);
    reg signed [SIZE - 1:0] outval_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) outval_reg <= 0;
        else if (ld_en) outval_reg <= inval;
        else begin
            if (right_shen) outval_reg = {ser_in, outval_reg[SIZE - 1:1]};
            else if (left_shen) outval_reg = {outval_reg[SIZE - 2:0], ser_in}; // msb out
        end
    end

    assign outval = outval_reg;
    assign msb = outval[SIZE - 1];
endmodule


module Counter #(parameter NUM_BIT = 4,parameter DEPTH = 4) (
    input wire clk,
    input wire rst,
    input wire cnt_mode,
    input wire ld_cnt,
    input wire cnt_en,
    input wire [NUM_BIT - 1:0] load_value,
    output wire co,
    output wire [NUM_BIT - 1:0] cnt_out_wire
);
    reg [NUM_BIT - 1:0] cnt_out = 0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            cnt_out <= 0;
        end else begin
            if (ld_cnt) begin
                cnt_out <= load_value;
            end else if (cnt_en) begin
                if (cnt_mode == 1'd0) begin
                    cnt_out <= cnt_out + 1;
                end else begin
                    if (cnt_out + 2 == (DEPTH)) // Handle overflow
                        cnt_out <= 1; // Reset to 1 when maximum is reached
                    else
                        cnt_out <= cnt_out + 2;
                end
            end
        end
    end

    assign co = &cnt_out; // co is high when all bits are 1
    assign cnt_out_wire = cnt_out;

endmodule

module Counter2 #(parameter NUM_BIT = 4) (clk,rst,ld_cnt,cnt_en,co,load_value,cnt_out_wire);
    input wire clk,rst,ld_cnt,cnt_en;
    input wire[NUM_BIT - 1:0] load_value;
    output wire co;
    output wire [NUM_BIT - 1:0] cnt_out_wire;
    reg [NUM_BIT - 1:0] cnt_out = 0;
    always @(posedge clk,posedge rst) begin
        if (rst) cnt_out <= 0;
        else begin
            if (ld_cnt) cnt_out <= load_value;
            else if(cnt_en) cnt_out <= cnt_out + 2;
        end
    end

    assign co = &cnt_out;
    assign cnt_out_wire = cnt_out;

endmodule
module IF_distance_calculator #(parameter ADDR_LEN,
          parameter SCRATCH_DEPTH,
          parameter SCRATCH_WIDTH)
      (start_val,end_val,distance);

    input wire [ADDR_LEN - 1:0] start_val,end_val;
    output wire [ADDR_LEN - 1:0] distance;

    assign distance = start_val > end_val ? SCRATCH_DEPTH - (start_val - end_val):
                    end_val - start_val;

endmodule