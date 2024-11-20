module accDh(
	input clk,
	input rst,
	input start,
	input [15:0] sdi,
	output[15:0] out,
	output reg finish
);

reg rx_en;
reg [3:0] counter;
reg [15:0] shift_reg;

assign out = (finish)? shift_reg:out;
//assign finish = (counter == 4'd7) ? 1 : 0;

always @(posedge clk) begin
	if(rst) rx_en <= 1'b0;
	else if (start) rx_en <= 1'b1;
	else if (counter == 4'd6) rx_en <= 1'b0;
end
// counter
always @(posedge clk) begin
	if(rst) counter <= 0;
	else if(start) counter <= 0;
	else if(rx_en) counter <= counter + 1;
end
//finish
always @(posedge clk) begin
	if(rst) finish <= 1'b0;
	else if(counter == 4'd6)finish <= 1'b1;
	else finish <= 1'b0;
end
// receive and shift data
always @(posedge clk) begin
	if(rst) shift_reg <= 15'd0;
	else if(start) shift_reg[15:0] <= sdi;
	else if (rx_en) shift_reg [15:0] <= shift_reg + sdi;
end

endmodule


