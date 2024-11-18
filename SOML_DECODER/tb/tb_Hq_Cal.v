`timescale 10ns/1ps
module tb_Hq_Cal;

reg clk;
reg rst;
wire [15:0] Hq_r;
wire [15:0] Hq_i;
	
// instance
Hq_Cal dut(
	 .clk(clk),
	 .rst(rst),
	 .Hq_r(Hq_r),
	 .Hq_i(Hq_i)
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

	
	
	
