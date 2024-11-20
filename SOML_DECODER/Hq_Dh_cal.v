//`timescale 10ns/1ps
module Hq_Dh_cal(
        input clk,
        input rst,
	input start,
        output [15:0] D_h,
        output  [31:0] out_rowHr0,
        output  [31:0] out_rowHr1,
        output  [31:0] out_rowHr2,
        output  [31:0] out_rowHr3,
        output  [31:0] out_rowHi0,
        output  [31:0] out_rowHi1,
        output  [31:0] out_rowHi2,
        output  [31:0] out_rowHi3,
	output ready_Hq,
	inout done_Dh
);

reg [15:0] reg_Hq_r, reg_Hq_i, reg_tmp_pw1, reg_tmp_pw2;

wire [15:0] tmp_pw1, tmp_pw2;
wire ovr_pw1, ovr_pw2;
wire [15:0] out_add_ri;
wire [15:0] Hq_r,Hq_i;
reg [2:0] counter;

wire start_cal_Dh;
wire start_genRowHq;

assign start_cal_Dh = (counter == 7) ? 1:0;
assign start_genRowHq = (counter == 5) ? 1:0;
// Instance tính Hq_r và Hq_i
Hq_Cal dut(
         .clk(clk),
         .rst(rst),
	 .start(start),
         .Hq_r(Hq_r),
         .Hq_i(Hq_i)
	// .ready(ready)
);
genRowHq genrowHq0 (
	.clk(clk),
	.rst(rst),
	.sdr(Hq_r),
	.start(start_genRowHq|ready_Hq),
	.sdi(Hq_i),
	.out_rowHr0(out_rowHr0),
	.out_rowHr1(out_rowHr1),
	.out_rowHr2(out_rowHr2),
	.out_rowHr3(out_rowHr3),
	.out_rowHi0(out_rowHi0),
	.out_rowHi1(out_rowHi1),
	.out_rowHi2(out_rowHi2),
	.out_rowHi3(out_rowHi3),
	.finish(ready_Hq)
);

// Lấy giá trị Hq_r và Hq_i
always @(posedge clk) begin
        if(rst) begin
                reg_Hq_r <= 0;
                reg_Hq_i <= 0;
        end else begin
                reg_Hq_r <= Hq_r;
                reg_Hq_i <= Hq_i;
        end
end

// Tính bình phương Hq_r và Hq_i
qmult #(.Q(8), .N(16)) pow1 (
.i_multiplicand(reg_Hq_r),
.i_multiplier(reg_Hq_r),
.o_result(tmp_pw1),
.ovr(ovr_pw1)
);

qmult #(.Q(8), .N(16)) pow2 (
.i_multiplicand(reg_Hq_i),
.i_multiplier(reg_Hq_i),
.o_result(tmp_pw2),
.ovr(ovr_pw2)
);

// Lưu giá trị bình phương
always @(posedge clk) begin
        if(rst) begin
                reg_tmp_pw1 <= 0;
                reg_tmp_pw2 <= 0;
        end else begin
                reg_tmp_pw1 <= tmp_pw1;
                reg_tmp_pw2 <= tmp_pw2;
        end
end

// Cộng bình phương của Hq_r và Hq_i
vadd #(8,16) add_ri(
        .a(reg_tmp_pw1),
        .b(reg_tmp_pw2),
        .c(out_add_ri)
);
reg tx_en;
always @(posedge clk) begin
	if(rst) tx_en <= 1'b0;
	else if(start) tx_en <= 1'b1;
end

// counter 
reg done;
always @(posedge clk) begin
	if(rst) begin
		counter <= 0;
		done <= 0;
	end
	else if(start) counter <= 0;
	else if(tx_en) begin
	 	if(!done) begin
			if(counter < 7) begin
				counter <= counter + 1;
			end
			else begin		
				counter <= 0;
				done <= 1;
			end
		end
	end
end
reg reg_start_cal_Dh;
always @(posedge clk) begin
	if(rst) begin
		reg_start_cal_Dh <= 1'b0;
	end else begin
		reg_start_cal_Dh <= start_cal_Dh;
	end
end
// cong tich luy
accDh acc(
	.clk(clk),
	.rst(rst),
	.start(reg_start_cal_Dh | done_Dh),
	.sdi(out_add_ri),
	.out(D_h),
	.finish(done_Dh)	
);
endmodule

