`timescale 10ns/1ps
module tb_xIxQ_cal;

reg clk;
reg rst;
reg start;

wire [15:0] out_xI1,out_xI2,out_xQ1,out_xQ2;
// instance
xIxQ_cal dut(
	 .clk(clk),
	 .rst(rst),
	 .start(start),
	 .out_xI1(out_xI1),
	 .out_xI2(out_xI2),
	 .out_xQ1(out_xQ1),
	 .out_xQ2(out_xQ2)
	 
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
	$dumpfile("tbxIxQ.vcd");
	$dumpvars();
	rst = 0;
	#5;
	rst = 1;
	//start = 1;
	wait4clk(2);
	rst = 0;
	start = 1;
	wait4clk(2);
	start = 0;
	wait4clk(1);
	wait4clk(200);
	$finish();
end

endmodule
