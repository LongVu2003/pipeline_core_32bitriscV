module HqB2_cal(
	input clk,
	input rst,
	input start,
	input [31:0] in_Hqr0,
        input [31:0] in_Hqr1,
        input [31:0] in_Hqr2,
        input [31:0] in_Hqr3,
        input [31:0] in_Hqi0,
        input [31:0] in_Hqi1,
        input [31:0] in_Hqi2,
        input [31:0] in_Hqi3,
	output [63:0] outcol0_r,
	output [63:0] outcol0_i,
	output [63:0] outcol1_r,
	output [63:0] outcol1_i,
	inout         ready
);

wire [1:0]  addr_colB2;
wire [1:0] addr_rowH;
//------------------START READ DATA FORM LUT----------------------------//
AddressGenerator AddrGen0(
	.clk(clk),
	.rst(rst),
	.ena(start),
	.addr_colS(addr_colB2),
	.addr_rowH(addr_rowH)
);

wire [31:0] rowH_r;
wire [31:0] rowH_i;

wire [31:0] tableHR_ [3:0];
wire [31:0] tableHI_ [3:0];

wire [31:0] tableB2_r [1:0];
wire [31:0] tableB2_i [1:0];

assign tableHR_[0] = in_Hqr0;//32'hffdd0183;
assign tableHR_[1] = in_Hqr1;//32'hffba00b7;
assign tableHR_[2] = in_Hqr2;//32'hff9c0005;
assign tableHR_[3] = in_Hqr3;//32'h00dbffad;

assign tableHI_[0] = in_Hqr0;//32'h00c1fff4;
assign tableHI_[1] = in_Hqr1;//32'hff4a003f;
assign tableHI_[2] = in_Hqr2;//32'hff2afea3;
assign tableHI_[3] = in_Hqr3;//32'h000cffea;

 //------------B2--------------

assign tableB2_r[0] = (start)?32'h00000100:tableB2_r[0];
assign tableB2_r[1] = (start)?32'h01000000:tableB2_r[1];

assign tableB2_i[0] = (start)?32'h00000000:tableB2_i[0];
assign tableB2_i[1] = (start)?32'h00000000:tableB2_i[1];


assign rowH_r = tableHR_[addr_rowH];// {-0.1367    1.5117    0.3008    1.0313}
assign rowH_i = tableHI_[addr_rowH];// { 0.7539   -0.0469    0.2344   -1.1563}
/*
*/

wire [31:0] out_colB2_r;
wire [31:0] out_colB2_i;

assign out_colB2_r = tableB2_r[addr_colB2];//tableSR_[addr_colS]; //{0,5; -0,5 ; 0,5 ; -0,5} temp_colS_r;
assign out_colB2_i = tableB2_i[addr_colB2];//tableSI_[addr_colS];//temp_colS_i;

//--------DONE GET DATA FROM LUT------------------
//--------START MUL ROW AND COL-------------------
wire [15:0] out_reg_c2_r;
wire [15:0] out_reg_c2_i;
wire [15:0] out_reg_c3_r;
wire [15:0] out_reg_c3_i;

cmult #(8,16) c2(
	.clk(clk),
	.rst(rst),
	.ar(rowH_r[31:16]),
	.ai(rowH_i[31:16]),
	.br(out_colB2_r[31:16]),
	.bi(out_colB2_i[31:16]),
	.pr(out_reg_c2_r),
	.pi(out_reg_c2_i)
);

cmult #(8,16) c3(
	.clk(clk),
	.rst(rst),
	.ar(rowH_r[15:0]),
	.ai(rowH_i[15:0]),
	.br(out_colB2_r[15:0]),
	.bi(out_colB2_i[15:0]),
	.pr(out_reg_c3_r),
	.pi(out_reg_c3_i)
);
wire [15:0] out_r,out_i;
// add real number
vadd #(8,16) add1(
	.a(out_reg_c2_r),
	.b(out_reg_c3_r),
	.c(out_r)
);
// add im number
vadd #(8,16) add4(
	.a(out_reg_c2_i),
	.b(out_reg_c3_i),
	.c(out_i)
);
assign start_cal = (counter == 5) ? 1:0;
reg tx_en;
always @(posedge clk) begin
        if(rst) tx_en <= 1'b0;
        else if(start) tx_en <= 1'b1;
end

// counter
reg done;
reg [2:0] counter;
always @(posedge clk) begin
        if(rst) begin
                counter <= 0;
                done <= 0;
        end
        else if(start) counter <= 0;
        else if(tx_en) begin
                if(!done) begin
                        if(counter < 5) begin
                                counter <= counter + 1;
                        end
                        else begin
                                counter <= 0;
                                done <= 1;
                        end
                end
        end
end
reg reg_start_cal;
always @(posedge clk) begin
        if(rst) begin
                reg_start_cal <= 1'b0;
        end else begin
                reg_start_cal <= start_cal;
        end
end
genColout gencol0(
	.clk(clk),
	.rst(rst),
	.sdr(out_r),
	.sdi(out_i),
	.start(start_cal | ready),
	.col0_r(outcol0_r),
	.col0_i(outcol0_i),
	.col1_r(outcol1_r),
	.col1_i(outcol1_i),
	.finish(ready)
);

endmodule
