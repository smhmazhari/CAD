module IF_scratch #(parameter ADDR_LEN,
          parameter SCRATCH_DEPTH,
          parameter SCRATCH_WIDTH)
     (
        input wire clk,
        input wire rst,
        input wire wen,
        input wire [ADDR_LEN - 1:0] waddr,
        input wire [ADDR_LEN - 1:0] raddr,
        input wire signed [SCRATCH_WIDTH - 1:0] din, // signed data input
        output wire signed [SCRATCH_WIDTH - 1:0] dout // signed data output
    );
    
    reg [SCRATCH_WIDTH - 1:0] main_mem [SCRATCH_DEPTH - 1:0];
    
    assign dout = main_mem[raddr];
    
    integer i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < SCRATCH_DEPTH; i = i + 1) begin
                main_mem[i] <= 0;
            end
        end
        else if (wen)
            main_mem[waddr] <= din;
    end
    
endmodule



module filter_scratch #(parameter ADDR_LEN,
          parameter SCRATCH_DEPTH,
          parameter SCRATCH_WIDTH)
     (
        input wire clk,
        input wire rst,
        input wire wen,
        input wire ren,
        input wire clr_out,
        input wire [ADDR_LEN - 1:0] waddr,
        input wire [ADDR_LEN - 1:0] raddr,
        input wire signed [SCRATCH_WIDTH - 1:0] din, // signed data input
        output reg signed [SCRATCH_WIDTH - 1:0] dout // signed data output
    );
    
    reg [SCRATCH_WIDTH - 1:0] main_mem [SCRATCH_DEPTH - 1:0];
    
    integer i;
    always @(posedge clk or posedge rst or posedge clr_out) begin
        if (rst | clr_out) begin
            if (rst) begin
                for (i = 0; i < SCRATCH_DEPTH; i = i + 1) begin
                    main_mem[i] <= 0;
                end
            end
            dout <= 0;
            if (clr_out & wen) main_mem[waddr] <= din;
        end
        else begin 
                if (wen) main_mem[waddr] <= din;
                if (ren) dout <= main_mem[raddr];
        end
    end
    
endmodule

module PSUM_scratch #(
    parameter ADDR_LEN,
    parameter SCRATCH_DEPTH,
    parameter SCRATCH_WIDTH,
    parameter FILT_ADDR_LEN // طول آدرس شمارنده نوشتن
) (
    input wire clk,
    input wire rst,
    input wire wen,
    input wire [ADDR_LEN - 1:0] waddr,
    input wire [ADDR_LEN - 1:0] raddr,
    input wire signed [SCRATCH_WIDTH - 1:0] din, // signed data input
    input wire [FILT_ADDR_LEN - 1:0] filt_len, // unsigned length parameter
    output wire signed [SCRATCH_WIDTH - 1:0] dout // signed data output
);

    reg [SCRATCH_WIDTH - 1:0] main_mem [SCRATCH_DEPTH - 1:0];
    reg [FILT_ADDR_LEN - 1:0] write_count [SCRATCH_DEPTH - 1:0]; // شمارنده نوشتن برای هر آدرس

    assign dout = main_mem[raddr];

    integer i;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            for (i = 0; i < SCRATCH_DEPTH; i = i + 1) begin
                main_mem[i] <= 0;
                write_count[i] <= 0; // بازنشانی شمارنده‌ها
            end
        end else if (wen) begin
            if (write_count[waddr] < filt_len) begin
                main_mem[waddr] <= din; // نوشتن در حافظه
                if (din != 0) begin
                    write_count[waddr] <= write_count[waddr] + 1; // افزایش شمارنده فقط اگر din صفر نباشد
                end
            end
        end
    end

endmodule
