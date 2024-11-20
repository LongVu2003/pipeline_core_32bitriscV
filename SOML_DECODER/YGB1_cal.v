module YGB1_cal(
	input clk,
	input rst,
	input start,
	input [63:0]  col0_r,
	input [63:0]  col0_i,
	input [63:0]  col1_r,
	input [63:0]  col1_i,
	output [15:0] out_r
	//output [15:0] ready
);

wire [1:0]  addr_col;
wire [1:0] addr_rowY;

AddrGenY AddrGen0(
	.clk(clk),
	.rst(rst),
	.ena(start),
	.addr_colS(addr_col),
	.addr_rowH(addr_rowY)
);

wire [63:0] rowY_r;
wire [63:0] rowY_i;

wire [63:0] col_r;
wire [63:0] col_i;

wire [63:0] tableYR_ [1:0];
wire [63:0] tableYI_ [1:0];

wire [63:0] tableR_ [1:0];
wire [63:0] tableI_ [1:0];

assign tableYR_[0] = 64'hffdd0183004d0108;
assign tableYR_[1] = 64'hffba00b700830111;

assign tableYI_[0] = 64'h00c1fff4003cfed8;
assign tableYI_[1] = 64'hff4a003fffb4004a;

assign tableR_[0] = col0_r;
assign tableR_[1] = col1_r;

assign tableI_[0] = col0_i;
assign tableI_[1] = col1_i;


assign rowY_r = tableYR_[addr_rowY];// {-0.1367    1.5117    0.3008    1.0313}
assign rowY_i = tableYI_[addr_rowY];// { 0.7539   -0.0469    0.2344   -1.1563}

assign col_r = tableR_[addr_col]; //{0,5; -0,5 ; 0,5 ; -0,5} temp_colS_r;
assign col_i = tableI_[addr_col];//temp_colS_i;


wire [15:0] out_reg_c0_r;
wire [15:0] out_reg_c0_i;
wire [15:0] out_reg_c1_r;
wire [15:0] out_reg_c1_i;
wire [15:0] out_reg_c2_r;
wire [15:0] out_reg_c2_i;
wire [15:0] out_reg_c3_r;
wire [15:0] out_reg_c3_i;

cmult #(8,16) c0(
	.clk(clk),
	.rst(rst),
	.ar(rowY_r[63:48]),
	.ai(rowY_i[63:48]),
	.br(col_r[63:48]),
	.bi(col_i[63:48]),
	.pr(out_reg_c0_r),
	.pi(out_reg_c0_i)
);
cmult #(8,16) c1(
	.clk(clk),
	.rst(rst),
	.ar(rowY_r[47:32]),
	.ai(rowY_i[47:32]),
	.br(col_r[47:32]),
	.bi(col_i[47:32]),
	.pr(out_reg_c1_r),
	.pi(out_reg_c1_i)
);

cmult #(8,16) c2(
	.clk(clk),
	.rst(rst),
	.ar(rowY_r[31:16]),
	.ai(rowY_i[31:16]),
	.br(col_r[31:16]),
	.bi(col_i[31:16]),
	.pr(out_reg_c2_r),
	.pi(out_reg_c2_i)
);

cmult #(8,16) c3(
	.clk(clk),
	.rst(rst),
	.ar(rowY_r[15:0]),
	.ai(rowY_i[15:0]),
	.br(col_r[15:0]),
	.bi(col_i[15:0]),
	.pr(out_reg_c3_r),
	.pi(out_reg_c3_i)
);

wire [15:0] out_add0_r,out_add1_r;
wire [15:0] out_add0_i,out_add1_i;

// add real number
vadd #(8,16) add0(
	.a(out_reg_c0_r),
	.b(out_reg_c1_r),
	.c(out_add0_r)
);

vadd #(8,16) add1(
	.a(out_reg_c2_r),
	.b(out_reg_c3_r),
	.c(out_add1_r)
);
vadd #(8,16) add2(
	.a(out_add0_r),
	.b(out_add1_r),
	.c(out_r)
);
endmodule
