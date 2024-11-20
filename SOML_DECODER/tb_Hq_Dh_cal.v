`timescale 10ns/1ps
module tb_Hq_Dh_cal;

        reg clk;
        reg rst;
	reg start;
        wire [15:0] D_h;
        wire  [31:0] out_rowHr0;
        wire  [31:0] out_rowHr1;
        wire  [31:0] out_rowHr2;
        wire  [31:0] out_rowHr3;
        wire  [31:0] out_rowHi0;
        wire  [31:0] out_rowHi1;
        wire  [31:0] out_rowHi2;
        wire  [31:0] out_rowHi3;
        wire ready_Hq;
        wire done_Dh;
// instance
Hq_Dh_cal dut(
	 .clk(clk),
	 .rst(rst),
	 .start(start),
	 .out_rowHr0(out_rowHr0),
	 .out_rowHr1(out_rowHr1),
	 .out_rowHr2(out_rowHr2),
	 .out_rowHr3(out_rowHr3),
	 .out_rowHi0(out_rowHi0),
	 .out_rowHi1(out_rowHi1),
	 .out_rowHi2(out_rowHi2),
	 .out_rowHi3(out_rowHi3),
	 .D_h(D_h),
	 .ready_Hq(ready_Hq),
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
	start = 1;
	rst = 0;
	wait4clk(1);
	start = 0;
	wait4clk(200);
	$finish();
end

endmodule

	
	
	
