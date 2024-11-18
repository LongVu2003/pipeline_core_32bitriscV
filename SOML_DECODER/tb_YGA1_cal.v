`timescale 10ns/1ps
module tb_YGA1_cal;

reg clk;
reg rst;

wire [15:0] out_r;
wire [15:0] out_i;
// instance
YGA1_cal dut(
	 .clk(clk),
	 .rst(rst),
	 .out_r(out_r),
	 .out_i(out_i)
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
	$dumpfile("tbYGA1.vcd");
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

	
	
	
