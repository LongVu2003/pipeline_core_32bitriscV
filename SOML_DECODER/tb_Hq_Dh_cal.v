`timescale 10ns/1ps
module tb_Hq_Dh_cal;

reg clk;
reg rst;
wire [15:0] Hq_r;
wire [15:0] Hq_i;
wire [15:0] D_h;
wire done_Dh;
// instance
Hq_Dh_cal dut(
	 .clk(clk),
	 .rst(rst),
	 .Hq_r(Hq_r),
	 .Hq_i(Hq_i),
	 .D_h(D_h),
	 .done_Dh(done_Dh)
);

initial begin
	clk = 0;
	forever #5 clk = ~clk;
end

task wait4clk(input integer n);
	repeat(n)
			@(posedge clk);
endtask

initial begin
	$dumpfile("tb.vcd");
	$dumpvars();
	rst = 0;
	#5;
	rst = 1;
	wait4clk(2);
	rst = 0;
	wait4clk(1);
	wait4clk(200);
	$finish();
end

endmodule

	
	
	
