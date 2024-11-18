module trace_cal(
	input clk,
	input rst,
	input enc,
	input [15:0] sdi,
	output[15:0] out,
	output reg finish
);

reg rx_en;
reg [1:0] counter;
reg [15:0] shift_reg;
reg start,enc_d,enc_dd,enc_ddd,enc_dddd;

always @(posedge clk) begin
	if(rst) enc_d <= 0;
	else begin
		enc_d   <= enc;
		enc_dd  <= enc_d;
		enc_ddd <= enc_dd;
		enc_dddd <= enc_ddd;
		start    <= enc_dddd;
	end
end
	
/*
//gen statrt signal
wire start;
assign start = (counter_ == 5) ? 1:0;
// counter
reg [2:0] counter_;
reg done;
always @(posedge clk) begin
        if(rst) begin
                counter_ <= 0;
                done <= 0;
        end
	else if (!enc) begin
		counter_ <= 0;
		done <= 0;
	end
        else if(!done) begin
                if(counter_ < 5) begin
                        counter_ <= counter_ + 1;
                end
                else begin
                        counter_ <= 0;
                        done <= 1;
                end
        end
end
*/
assign out = (finish)? shift_reg:out;
//assign finish = (counter == 4'd7) ? 1 : 0;

always @(posedge clk) begin
	if(rst) rx_en <= 1'b0;
	else if (start) rx_en <= 1'b1;
	else if (counter == 2'd3) rx_en <= 1'b0;
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
	else if(counter == 2'd3)finish <= 1'b1;
	else finish <= 1'b0;
end
// receive and shift data
always @(posedge clk) begin
	if(rst) shift_reg <= 15'd0;
	else if(start) shift_reg[15:0] <= 0;
	else if (rx_en) begin
		if(counter  == 0 || counter == 3)
			shift_reg [15:0] <= shift_reg + sdi;
		else shift_reg [15:0] <= shift_reg;
	end
end

endmodule
