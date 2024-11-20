module genColout(
	input clk,
	input rst,
	input start,
	input  [15:0] sdr,
	input  [15:0] sdi,
	output [63:0] col0_r,
	output [63:0] col0_i,
	output [63:0] col1_r,
	output [63:0] col1_i, 
	output reg finish
);
reg rx_en;
reg [2:0] counter;
reg [63:0] shift_reg_col0_r;
reg [63:0] shift_reg_col1_r;
reg [63:0] shift_reg_col0_i;
reg [63:0] shift_reg_col1_i;

assign col0_r = (finish)? shift_reg_col0_r:col0_r;
assign col1_r = (finish)? shift_reg_col1_r:col1_r;
assign col0_i = (finish)? shift_reg_col0_i:col0_i;
assign col1_i = (finish)? shift_reg_col1_i:col1_i;

//assign finish = (counter == 4'd7) ? 1 : 0;

always @(posedge clk) begin
	if(rst) rx_en <= 1'b0;
	else if (start) rx_en <= 1'b1;
	//else if (counter == 3'd7) rx_en <= 1'b0;
end
// counter
always @(posedge clk) begin
	if(rst) counter <= 0;
	//else if(start) counter <= 0;
	else if(rx_en) counter <= counter + 1;
end
//finish
always @(posedge clk) begin
	if(rst) finish <= 1'b0;
	else if(counter == 3'd7)finish <= 1'b1;
	else finish <= 1'b0;
end
// receive and shift data
always @(posedge clk) begin
	if(rst) begin
		shift_reg_col0_r[63:0] <= 0;
		shift_reg_col1_r[63:0] <= 0;
		shift_reg_col0_i[63:0] <= 0;
		shift_reg_col1_i[63:0] <= 0;
	end
	else if(start) begin
		if(counter == 0 || counter == 2 || counter == 4 || counter == 6)
		begin	
			shift_reg_col0_r [63:0] <= {63'd0,sdr};
			shift_reg_col0_i [63:0] <= {63'd0,sdi};
		end else begin
			shift_reg_col1_r [63:0] <= {63'd0,sdr};
			shift_reg_col1_i [63:0] <= {63'd0,sdi};
		end
	end
	else if (rx_en) begin
		if(counter == 0 || counter == 2 || counter == 4 || counter == 6)
		begin	
			shift_reg_col0_r [63:0] <= {shift_reg_col0_r[47:0],sdr};
			shift_reg_col0_i [63:0] <= {shift_reg_col0_i[47:0],sdi};
		end else begin
			shift_reg_col1_r [63:0] <= {shift_reg_col1_r[47:0],sdr};
			shift_reg_col1_i [63:0] <= {shift_reg_col1_i[47:0],sdi};
		end
	end
end

endmodule

