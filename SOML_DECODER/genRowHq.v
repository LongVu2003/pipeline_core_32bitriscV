module genRowHq(
	input clk,
	input rst,
	input start,
	input [15:0] sdr,
	input [15:0] sdi,
	output  [31:0] out_rowHr0,
        output  [31:0] out_rowHr1,
        output  [31:0] out_rowHr2,
        output  [31:0] out_rowHr3,
        output  [31:0] out_rowHi0,
        output  [31:0] out_rowHi1,
        output  [31:0] out_rowHi2,
        output  [31:0] out_rowHi3,
	output reg finish
);

reg rx_en;
reg [2:0] counter;
reg [31:0] shift_reg_Hr0,shift_reg_Hr1,shift_reg_Hr2,shift_reg_Hr3;
reg [31:0] shift_reg_Hi0,shift_reg_Hi1,shift_reg_Hi2,shift_reg_Hi3;

assign out_rowHr0 = (finish)? shift_reg_Hr0:out_rowHr0;
assign out_rowHr1 = (finish)? shift_reg_Hr1:out_rowHr1;
assign out_rowHr2 = (finish)? shift_reg_Hr2:out_rowHr2;
assign out_rowHr3 = (finish)? shift_reg_Hr3:out_rowHr3;

assign out_rowHi0 = (finish)? shift_reg_Hi0:out_rowHi0;
assign out_rowHi1 = (finish)? shift_reg_Hi1:out_rowHi1;
assign out_rowHi2 = (finish)? shift_reg_Hi2:out_rowHi2;
assign out_rowHi3 = (finish)? shift_reg_Hi3:out_rowHi3;

//assign finish = (counter == 4'd7) ? 1 : 0;

always @(posedge clk) begin
	if(rst) rx_en <= 1'b0;
	else if (start) rx_en <= 1'b1;
	else if (counter == 3'd7) rx_en <= 1'b0;
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
	else if(counter == 3'd6) finish <= 1'b1;
	else finish <= 1'b0;
end
// receive and shift data
always @(posedge clk) begin
	if(rst) begin
		shift_reg_Hr0[31:0] <= 0;//{16'd0,sdr};
		shift_reg_Hi0[31:0] <= 0;//{16'd0,sdi};
		shift_reg_Hr1[31:0] <= 0;//{16'd0,sdr};
		shift_reg_Hi1[31:0] <= 0;//{16'd0,sdi};
		shift_reg_Hr2[31:0] <= 0;//{16'd0,sdr};
		shift_reg_Hi2[31:0] <= 0;//{16'd0,sdi};
		shift_reg_Hr3[31:0] <= 0;//{16'd0,sdr};
		shift_reg_Hi3[31:0] <= 0;//{16'd0,sdi};
	end else if(start) begin
		if(counter == 0 || counter == 1) begin
                        shift_reg_Hr0[31:0] <= {16'd0,sdr};
                        shift_reg_Hi0[31:0] <= {16'd0,sdi};
                end
                else if(counter == 2 || counter == 3) begin
                        shift_reg_Hr1[31:0] <= {16'd0,sdr};
                        shift_reg_Hi1[31:0] <= {16'd0,sdi};
                end
                else if(counter == 4 || counter == 5) begin
                        shift_reg_Hr2[31:0] <= {16'd0,sdr};
                        shift_reg_Hi2[31:0] <= {16'd0,sdi};
                end
                else if(counter == 6 || counter == 7) begin
                        shift_reg_Hr3[31:0] <= {16'd0,sdr};
                        shift_reg_Hi3[31:0] <= {16'd0,sdi};
                end
	end
	else if (rx_en) begin
		if(counter == 0 || counter == 1) begin
			shift_reg_Hr0[31:0] <= {shift_reg_Hr0[15:0],sdr};
			shift_reg_Hi0[31:0] <= {shift_reg_Hi0[15:0],sdi};	
		end
		else if(counter == 2 || counter == 3) begin
			shift_reg_Hr1[31:0] <= {shift_reg_Hr1[15:0],sdr};
			shift_reg_Hi1[31:0] <= {shift_reg_Hi1[15:0],sdi};
		end
		else if(counter == 4 || counter == 5) begin
			shift_reg_Hr2[31:0] <= {shift_reg_Hr2[15:0],sdr};
			shift_reg_Hi2[31:0] <= {shift_reg_Hi2[15:0],sdi};
		end
		else if(counter == 6 || counter == 7) begin
			shift_reg_Hr3[31:0] <= {shift_reg_Hr3[15:0],sdr};
			shift_reg_Hi3[31:0] <= {shift_reg_Hi3[15:0],sdi};
		end
	end
end

endmodule


