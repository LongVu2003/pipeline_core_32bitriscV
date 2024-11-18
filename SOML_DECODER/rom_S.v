module rom_S (
	input          clk,
	input  [1:0]   colS,
	input  [3:0]   Si,
	output [63:0]  out_colS_r,
	output [63:0]  out_colS_i
	);
	
	wire [63:0] romS_r [15:0][1:0];
	wire [63:0] romS_i [15:0][1:0];
	
    assign romS_r[0][0] = 64'h0080ff800080ff80;
    assign romS_r[0][1] = 64'h0080008000800080;

    assign romS_r[1][0] = 64'h0080ff8000800000;
    assign romS_r[1][1] = 64'h0080008000000080;

    assign romS_r[2][0] = 64'h0080ff8000800080;
    assign romS_r[2][1] = 64'h00800080ff800080;

    assign romS_r[3][0] = 64'h0080ff8000800000;
    assign romS_r[3][1] = 64'h0080008000000080;
	 
    assign romS_r[4][0] = 64'h0080ff80ff80ff80;
    assign romS_r[4][1] = 64'h008000800080ff80;

    assign romS_r[5][0] = 64'h0080ff80ff800000;
    assign romS_r[5][1] = 64'h008000800000ff80;

    assign romS_r[6][0] = 64'h0080ff80ff800080;
    assign romS_r[6][1] = 64'h00800080ff80ff80;

    assign romS_r[7][0] = 64'h0080ff80ff800000;
    assign romS_r[7][1] = 64'h008000800000ff80;

    assign romS_r[8][0] = 64'h0080ff800000ff80;
    assign romS_r[8][1] = 64'h0080008000800000;

    assign romS_r[9][0] = 64'h0080ff8000000000;
    assign romS_r[9][1] = 64'h0080008000000000;

    assign romS_r[10][0] = 64'h0080ff8000000080;
    assign romS_r[10][1] = 64'h00800080ff800000;

    assign romS_r[11][0] = 64'h0080ff8000000000;
    assign romS_r[11][1] = 64'h0080008000000000;

    assign romS_r[12][0] = 64'h0080ff800000ff80;
    assign romS_r[12][1] = 64'h0080008000800000;

    assign romS_r[13][0] = 64'h0080ff8000000000;
    assign romS_r[13][1] = 64'h0080008000000000;

    assign romS_r[14][0] = 64'h0080ff8000000080;
    assign romS_r[14][1] = 64'h00800080ff800000;

    assign romS_r[15][0] = 64'h0080ff8000000000;
    assign romS_r[15][1] = 64'h0080008000000000;

	 //=============S_i=========
	 
	 assign romS_i[0][0] = 64'h0000000000000000;
    assign romS_i[0][1] = 64'h0000000000000000;
   
    assign romS_i[1][0] = 64'h0000000000000080;
    assign romS_i[1][1] = 64'h0000000000800000;
    
    assign romS_i[2][0] = 64'h0000000000000000;
    assign romS_i[2][1] = 64'h0000000000000000;

    assign romS_i[3][0] = 64'h000000000000ff80;
    assign romS_i[3][1] = 64'h00000000ff800000;
	 
    assign romS_i[4][0] = 64'h0000000000000000;
    assign romS_i[4][1] = 64'h0000000000000000;

    assign romS_i[5][0] = 64'h0000000000000080;
    assign romS_i[5][1] = 64'h0000000000800000;

    assign romS_i[6][0] = 64'h0000000000000000;
    assign romS_i[6][1] = 64'h0000000000000000;

    assign romS_i[7][0] = 64'h000000000000ff80;
    assign romS_i[7][1] = 64'h00000000ff800000;

    assign romS_i[8][0] = 64'h0000000000800000;
    assign romS_i[8][1] = 64'h0000000000000080;

    assign romS_i[9][0] = 64'h0000000000800080;
    assign romS_i[9][1] = 64'h0000000000800080;

    assign romS_i[10][0] = 64'h0000000000800000;
    assign romS_i[10][1] = 64'h0000000000000080;
  
    assign romS_i[11][0] = 64'h000000000080ff80;
    assign romS_i[11][1] = 64'h00000000ff800080;
 
    assign romS_i[12][0] = 64'h00000000ff800000;
    assign romS_i[12][1] = 64'h000000000000ff80;
  
    assign romS_i[13][0] = 64'h00000000ff800080;
    assign romS_i[13][1] = 64'h000000000080ff80;
  
    assign romS_i[14][0] = 64'h00000000ff800000;
    assign romS_i[14][1] = 64'h000000000000ff80;

    assign romS_i[15][0] = 64'h00000000ff80ff80;
    assign romS_i[15][1] = 64'h00000000ff80ff80;
/*	 
	always @(posedge clk) begin
		out_colS_r <=  romS_r[Si][colS];
		out_colS_i <=  romS_i[Si][colS];
	end
endmodule

*/
assign out_colS_r = romS_r[Si][colS];
assign out_colS_i = romS_i[Si][colS];

 endmodule
