`timescale 10ns/1ps
module tb_xI1_cal;

reg clk;
reg rst;

wire [15:0] xI1;
wire [15:0] Dh;
// instance
xI1_cal dut(
	 .clk(clk),
	 .rst(rst),
	 .xI1(xI1)
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
	$dumpfile("tbxI1.vcd");
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

	
	
	
