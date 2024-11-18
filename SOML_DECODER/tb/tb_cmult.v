`timescale 1ns / 1ps
module tb_cmult;	
	localparam Q = 8;
	localparam N = 16;
	reg clk;
	reg rst;
	reg signed  [N-1:0] ar, ai;
	reg signed  [N-1:0] br, bi;
	wire signed [N-1:0] pr, pi;
	
	cmult #(8,16) c0(.clk(clk),.rst(rst),.ar(ar),.ai(ai),.br(br),.bi(bi),.pr(pr),.pi(pi));

	initial begin
	clk = 0;
	forever #5 clk = !clk;
	end
	
task wait4clk(input integer n);
	repeat(n) 
		@(posedge clk);
endtask

task transdata(
	input [63:0] rowH_r, 
	input [63:0] rowH_i,
	input [63:0] colS_r,
	input [63:0] colS_i
); 
begin
	ar <= rowH_r[63:48];
	ai <= rowH_i[63:48];
	br <= colS_r[63:48];
	bi <= colS_i[63:48];
	@(posedge clk);
	ar <= rowH_r[47:32];         
	ai <= rowH_i[47:32];
        br <= colS_r[47:32];
        bi <= colS_i[47:32];
	@(posedge clk);
	ar <= rowH_r[31:16];
        ai <= rowH_i[31:16];
        br <= colS_r[31:16];
        bi <= colS_i[31:16];
 	@(posedge clk);
        ar <= rowH_r[15:0];
        ai <= rowH_i[15:0];
        br <= colS_r[15:0];
        bi <= colS_i[15:0];
end
endtask

	initial begin
		$dumpfile("tb_cmult.vcd");
		$dumpvars();
		rst = 1;
		wait4clk(2);
		rst = 0;
		//#10;
		transdata(64'hffdd0183004d0108,64'h00c1fff4003cfed8,64'h0080ff800080ff80,64'h0000000000000000);
		//64'hffdd0183004d0108,64'h00c1fff4003cfed8,64'h0080ff800080ff80,64'h0000000000000000
		//#10;
	/*
		ar = 16'hffdd;
		ai = 16'h00c1;
          	br = 16'h0080;
          	bi = 16'h0000;
           	//#10;
		@(posedge clk);
          	ar = 16'h0183;
          	ai = 16'hfff4;
          	br = 16'hff80;
          	bi = 16'h0000;
          	//#10;
		@(posedge clk);
          	ar = 16'h004d;
          	ai = 16'h003c;
          	br = 16'h0080;
          	bi = 16'h0000;
          	//#10
		@(posedge clk);
          	ar = 16'h0108;
          	ai = 16'hfed8;
          	br = 16'hff80;
          	bi = 16'h0000;
		 @(posedge clk);
                  ar = 16'h004d;
                  ai = 16'h003c;
                  br = 16'h0080;
                 bi = 16'h0000;
	*/
		#5000 $finish();
	end
endmodule


		
