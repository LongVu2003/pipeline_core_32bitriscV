module xQ1_cal (
	input clk,
	input rst,
	input start,
	input [15:0] Dh,
	input [63:0] col0_r,
	input [63:0] col0_i,
	input [63:0] col1_r,
	input [63:0] col1_i,
	output [15:0] xQ1
);

wire [15:0] out_r;
wire [15:0] trace_result;
wire done_trace;
wire [63:0] tmp_col0_r,tmp_col0_i,tmp_col1_r,tmp_col1_i;
// instance YxGA1
YGB1_cal Ygb1cal0 (
	.clk(clk),
	.rst(rst),
	.start(start),
	.col0_r(col0_r),
	.col0_i(col0_i),
	.col1_r(col1_r),
	.col1_i(col1_i),
	.out_r(out_r)
);
trace_cal trace0(
	.clk(clk),
	.rst(rst),
	.enc(start),
	.sdi(out_r),
	.out(trace_result),
	.finish(done_trace)
);


wire odivo;

fxp_div_pipe # (
    .WIIA     ( 8     ),
    .WIFA     ( 8     ),
    .WIIB     ( 8     ),
    .WIFB     ( 8     ),
    .WOI      ( 8      ),
    .WOF      ( 8      ),
    .ROUND    ( 1        )
) fxp_div_pipe_i (
    .rstn     ( ~rst     ),
    .clk      ( clk      ),
    .dividend ( trace_result),
    .divisor  ( 16'h0200  ),
    .out      ( xQ1     ),
    .overflow ( odivo    )
);

endmodule
