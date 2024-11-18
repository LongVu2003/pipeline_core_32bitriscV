module Hq_Cal(
	input clk,
	input rst,
	output [15:0] Hq_r,
	output [15:0] Hq_i
	//output [15:0] ready
);

wire [1:0]  addr_colS;
wire  [3:0] addr_Si;
wire [1:0] addr_rowH;
/*
reg addr_cols0d,addr_cols1d,addr_cols2d,addr_cols3d,addr_cols4d,addr_cols5d;
reg [3:0] addr_Si0d,addr_Si1d,addr_Si2d,addr_Si3d,addr_Si4d,addr_Si5d;
reg [1:0] addr_rowH0d,addr_rowH1d,addr_rowH2d,addr_rowH3d,addr_rowH4d,addr_rowH5d;

always @(posedge clk) begin
	if(rst) begin
		addr_cols0d <= 0;
		addr_Si0d   <= 0;
		addr_rowH0d <= 0;
	end
	else begin
		addr_cols0d <= addr_colS;
		addr_cols1d <= addr_cols0d;
		addr_cols2d <= addr_cols1d;
		addr_cols3d <= addr_cols2d;
		addr_cols4d <= addr_cols3d;
		addr_cols5d <= addr_cols4d;
		
		addr_Si0d   <= addr_Si;
		addr_Si1d   <= addr_Si0d;
		addr_Si2d   <= addr_Si1d;
		addr_Si3d   <= addr_Si2d;
		addr_Si4d   <= addr_Si3d;
		addr_Si5d   <= addr_Si4d;
		
		addr_rowH0d <= addr_rowH;
		addr_rowH1d <= addr_rowH0d;
		addr_rowH2d <= addr_rowH1d;
		addr_rowH3d <= addr_rowH2d;
		addr_rowH4d <= addr_rowH3d;
		addr_rowH5d <= addr_rowH4d;
		
		
	end
end

*/

AddressGenerator AddrGen0(
	.clk(clk),
	.rst(rst),
	.addr_colS(addr_colS),
	.addr_Si(addr_Si),
	.addr_rowH(addr_rowH)
);

wire [63:0] rowH_r;
wire [63:0] rowH_i;

wire [63:0] tableHR_ [3:0];
wire [63:0] tableHI_ [3:0];

wire [63:0] tableSR_ [1:0];
wire [63:0] tableSI_ [1:0];

//`include "C:\Users\DELL\OneDrive - ptit.edu.vn\Documents\FPGA\NhatKyCongViec\240709\Project\Synth\simulation\modelsim\tableHR.vh"
//`include "C:\Users\DELL\OneDrive - ptit.edu.vn\Documents\FPGA\NhatKyCongViec\240709\Project\Synth\simulation\modelsim\tableHI.vh"
assign tableHR_[0] = 64'hffdd0183004d0108;
assign tableHR_[1] = 64'hffba00b700830111;
assign tableHR_[2] = 64'hff9c000500c1ff39;
assign tableHR_[3] = 64'h00dbffad00acff16;

assign tableHI_[0] = 64'h00c1fff4003cfed8;
assign tableHI_[1] = 64'hff4a003fffb4004a;
assign tableHI_[2] = 64'hff2afea30097004b;
assign tableHI_[3] = 64'h000cffeaffb80003;

assign tableSR_[0] = 64'h0080ff800080ff80;
assign tableSR_[1] = 64'h0080008000800080;

assign tableSI_[0] = 64'h0000000000000000;
assign tableSI_[1] = 64'h0000000000000000;

reg [63:0] reg_rowH_r;
reg [63:0] reg_rowH_i;
reg [63:0] reg_out_colS_r;
reg [63:0] reg_out_colS_i;

assign rowH_r = tableHR_[addr_rowH];// {-0.1367    1.5117    0.3008    1.0313}
assign rowH_i = tableHI_[addr_rowH];// { 0.7539   -0.0469    0.2344   -1.1563}
/*
assign ready = (count == 5)? 1:0;

reg [2:0] count;

always @(posedge clk) begin
	if(rst) begin
		count <= 0;
	end else if(count == 5) begin
:		count <= 0;
	end else begin
		count <= count + 1;
	end
end
*/
/*
always @(posedge clk) begin
	if(rst) begin
		reg_rowH_r <= 0;
		reg_rowH_i <= 0;
		reg_out_colS_r <= 0;
		reg_out_colS_i <= 0;
	end else begin
		reg_rowH_r <= rowH_r;
		reg_rowH_i <= rowH_i;
		reg_out_colS_r <= out_colS_r;
		reg_out_colS_i <= out_colS_i;
	end
end

always @(posedge clk) begin
	if(rst) begin
		rowH_r <= 0;
		rowH_i <= 0;
		end
	else begin
		rowH_r <= tableHR_[addr_rowH5d];
		rowH_i <= tableHI_[addr_rowH5d];
		end
end
*/
wire [63:0] out_colS_r;
wire [63:0] out_colS_i;
wire [63:0] temp_colS_r;
wire [63:0] temp_colS_i;

assign out_colS_r = temp_colS_r;//tableSR_[addr_colS]; //{0,5; -0,5 ; 0,5 ; -0,5} temp_colS_r;
assign out_colS_i = temp_colS_i;//tableSI_[addr_colS];//temp_colS_i;

rom_S romS0 (
	.clk(clk),
	//.rst(rst),
	.colS(addr_colS),
	.Si(addr_Si),
	.out_colS_r(temp_colS_r),
	.out_colS_i(temp_colS_i)
);

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
	.ar(rowH_r[63:48]),
	.ai(rowH_i[63:48]),
	.br(out_colS_r[63:48]),
	.bi(out_colS_i[63:48]),
	.pr(out_reg_c0_r),
	.pi(out_reg_c0_i)
);
cmult #(8,16) c1(
	.clk(clk),
	.rst(rst),
	.ar(rowH_r[47:32]),
	.ai(rowH_i[47:32]),
	.br(out_colS_r[47:32]),
	.bi(out_colS_i[47:32]),
	.pr(out_reg_c1_r),
	.pi(out_reg_c1_i)
);

cmult #(8,16) c2(
	.clk(clk),
	.rst(rst),
	.ar(rowH_r[31:16]),
	.ai(rowH_i[31:16]),
	.br(out_colS_r[31:16]),
	.bi(out_colS_i[31:16]),
	.pr(out_reg_c2_r),
	.pi(out_reg_c2_i)
);

cmult #(8,16) c3(
	.clk(clk),
	.rst(rst),
	.ar(rowH_r[15:0]),
	.ai(rowH_i[15:0]),
	.br(out_colS_r[15:0]),
	.bi(out_colS_i[15:0]),
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
	.c(Hq_r)
);

// add im number

vadd #(8,16) add3(
	.a(out_reg_c0_i),
	.b(out_reg_c1_i),
	.c(out_add0_i)
);

vadd #(8,16) add4(
	.a(out_reg_c2_i),
	.b(out_reg_c3_i),
	.c(out_add1_i)
);

vadd #(8,16) add5(
	.a(out_add0_i),
	.b(out_add1_i),
	.c(Hq_i)
);

endmodule
