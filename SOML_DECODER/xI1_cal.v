module xI1_cal (
	input clk,
	input rst,
	input Dh,
	output [15:0] xI1
);

wire [15:0] out_r;
wire [15:0] trace_result;
wire done_trace;
wire done_Ga1;
wire [63:0] tmp_col0_r,tmp_col0_i,tmp_col1_r,tmp_col1_i;
//

//instance Hq x A1
HqA1_cal HqxA10(
	.clk(clk),
	.rst(rst),
	.outcol0_r(tmp_col0_r),
	.outcol0_i(tmp_col0_i),
	.outcol1_r(tmp_col1_r),
	.outcol1_i(tmp_col1_i),
	.ready(done_Ga1)
);

// instance YxGA1
YGA1_cal Yga1cal0 (
	.clk(clk),
	.rst(rst),
	.col0_r(tmp_col0_r),
	.col0_i(tmp_col0_i),
	.col1_r(tmp_col1_r),
	.col1_i(tmp_col1_i),
	.out_r(out_r)
);
/*
// trace
assign start = (counter == 5) ? 1:0;
// counter
reg [2:0] counter;
reg done;
always @(posedge clk) begin
        if(rst) begin
                counter <= 0;
                done <= 0;
        end
        else if(!done) begin
                if(counter < 5) begin
                        counter <= counter + 1;
                end
                else begin
                        counter <= 0;
                        done <= 1;
                end
        end
end
*/
trace_cal trace0(
	.clk(clk),
	.rst(rst),
	.enc(done_Ga1),
	.sdi(out_r),
	.out(trace_result),
	.finish(done_trace)
);
wire ovf,done_div;
qdiv #(
	.Q(8),
	.N(16)
) div0(
	.i_clk(clk),
	.i_start(done_trace),
	.i_dividend(trace_result),
	.i_divisor(trace_result),
	.o_quotient_out(xI1),
	.o_complete(done_div),
	.o_overflow(ovf)
);

endmodule
