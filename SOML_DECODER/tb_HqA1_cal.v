`timescale 10ns/1ps
module tb_HqA1_cal;

reg clk;
reg rst;

wire [63:0] outcol0_r;
wire [63:0] outcol0_i;
wire [63:0] outcol1_r;
wire [63:0] outcol1_i;
wire ready;
// instance
HqA1_cal dut(
	 .clk(clk),
	 .rst(rst),
	 .outcol0_r(outcol0_r),
	 .outcol0_i(outcol0_i),
	 .outcol1_r(outcol1_r),
	 .outcol1_i(outcol1_i),
	 .ready(ready)
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
	$dumpfile("tbHqA1.vcd");
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

	
	
	
