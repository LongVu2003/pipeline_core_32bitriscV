module xIxQ_cal (
	input clk,
	input rst,
	input start,
	output [15:0] out_xI1,
	output [15:0] out_xI2,
	output [15:0] out_xQ1,
	output [15:0] out_xQ2
);

// caculate Hq matrix and Dh
wire [31:0] out_rowHr0,out_rowHr1,out_rowHr2,out_rowHr3;
wire [31:0] out_rowHi0,out_rowHi1,out_rowHi2,out_rowHi3;
wire ready_Hq;
wire done_Dh;
wire [15:0] Dh;
Hq_Dh_cal aHqDh(
	.clk(clk),
	.rst(rst),
	.start(start),
	.D_h(Dh),
	.out_rowHr0(out_rowHr0),
	.out_rowHr1(out_rowHr1),
	.out_rowHr2(out_rowHr2),
	.out_rowHr3(out_rowHr3),
	.out_rowHi0(out_rowHi0),
	.out_rowHi1(out_rowHi1),
	.out_rowHi2(out_rowHi2),
	.out_rowHi3(out_rowHi3),
	.ready_Hq(ready_Hq),
	.done_Dh(done_Dh)
);



//mul Hq vs A1
wire GA1_done;
wire [63:0] GA1col0_r,GA1col0_i,GA1col1_r,GA1col1_i;
HqA1_cal bGA1(
	.clk(clk),
	.rst(rst),
	.start(ready_Hq),
	.in_Hqr0(out_rowHr0),
	.in_Hqr1(out_rowHr1),
	.in_Hqr2(out_rowHr2),
	.in_Hqr3(out_rowHr3),
	.in_Hqi0(out_rowHi0),
	.in_Hqi1(out_rowHi1),
	.in_Hqi2(out_rowHi2),
	.in_Hqi3(out_rowHi3),
	.outcol0_r(GA1col0_r),
	.outcol0_i(GA1col0_i),
	.outcol1_r(GA1col1_r),
	.outcol1_i(GA1col1_i),
	.ready(GA1_done)
);


//mul Hq vs A2
wire GA2_done;
wire [63:0] GA2col0_r,GA2col0_i,GA2col1_r,GA2col1_i;
HqA2_cal bGA2(
        .clk(clk),
        .rst(rst),
        .start(ready_Hq),
        .in_Hqr0(out_rowHr0),
        .in_Hqr1(out_rowHr1),
        .in_Hqr2(out_rowHr2),
        .in_Hqr3(out_rowHr3),
        .in_Hqi0(out_rowHi0),
        .in_Hqi1(out_rowHi1),
        .in_Hqi2(out_rowHi2),
        .in_Hqi3(out_rowHi3),
        .outcol0_r(GA2col0_r),
        .outcol0_i(GA2col0_i),
        .outcol1_r(GA2col1_r),
        .outcol1_i(GA2col1_i),
        .ready(GA2_done)
);

//mul Hq vs A1
wire GB1_done;
wire [63:0] GB1col0_r,GB1col0_i,GB1col1_r,GB1col1_i;
HqB1_cal bGB1(
        .clk(clk),
        .rst(rst),
        .start(ready_Hq),
        .in_Hqr0(out_rowHr0),
        .in_Hqr1(out_rowHr1),
        .in_Hqr2(out_rowHr2),
        .in_Hqr3(out_rowHr3),
        .in_Hqi0(out_rowHi0),
        .in_Hqi1(out_rowHi1),
        .in_Hqi2(out_rowHi2),
        .in_Hqi3(out_rowHi3),
        .outcol0_r(GB1col0_r),
        .outcol0_i(GB1col0_i),
        .outcol1_r(GB1col1_r),
        .outcol1_i(GB1col1_i),
        .ready(GB1_done)
);

//mul Hq vs B2
wire GB2_done;
wire [63:0] GB2col0_r,GB2col0_i,GB2col1_r,GB2col1_i;
HqB2_cal bGB2(
        .clk(clk),
        .rst(rst),
        .start(ready_Hq),
        .in_Hqr0(out_rowHr0),
        .in_Hqr1(out_rowHr1),
        .in_Hqr2(out_rowHr2),
        .in_Hqr3(out_rowHr3),
        .in_Hqi0(out_rowHi0),
        .in_Hqi1(out_rowHi1),
        .in_Hqi2(out_rowHi2),
        .in_Hqi3(out_rowHi3),
        .outcol0_r(GB2col0_r),
        .outcol0_i(GB2col0_i),
        .outcol1_r(GB2col1_r),
        .outcol1_i(GB2col1_i),
        .ready(GB2_done)
);
xI1_cal cxI1(
	.clk(clk),
	.rst(rst),
	.start(GA1_done),
	.Dh(Dh),
	.col0_r(GA1col0_r),
	.col0_i(GA1col0_i),
	.col1_r(GA1col1_r),
	.col1_i(GA1col1_i),
	.xI1(out_xI1)
);

xI2_cal cxI2(
        .clk(clk),
        .rst(rst),
        .start(GA2_done),
        .Dh(Dh),
        .col0_r(GA2col0_r),
        .col0_i(GA2col0_i),
        .col1_r(GA2col1_r),
        .col1_i(GA2col1_i),
        .xI2(out_xI2)
);

xQ1_cal cxQ1(
        .clk(clk),
        .rst(rst),
        .start(GB1_done),
        .Dh(Dh),
        .col0_r(GB1col0_r),
        .col0_i(GB1col0_i),
        .col1_r(GB1col1_r),
        .col1_i(GB1col1_i),
        .xQ1(out_xQ1)
);
xQ2_cal cxQ2(
        .clk(clk),
        .rst(rst),
        .start(GB2_done),
        .Dh(Dh),
        .col0_r(GB2col0_r),
        .col0_i(GB2col0_i),
        .col1_r(GB2col1_r),
        .col1_i(GB2col1_i),
        .xQ2(out_xQ2)
);
endmodule

