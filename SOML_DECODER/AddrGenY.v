module AddrGenY (
    input wire clk,       // Clock input
    input wire rst,     // Active low reset
    input ena,
    output reg [1:0] addr_colS, // Đếm mod 2 (0 -> 1)
    output reg [1:0] addr_rowH // Đếm mod 4 (0 -> 1)
);
reg rx_en;
always @(posedge clk) begin
        if(rst) rx_en <= 1'b0;
        else if(ena) rx_en <= 1'b1;
       // else if(addr_Si == 4'b1111) rx_en <= 1'b0;
end
    // Process for generating addresses
    always @(posedge clk) begin
        if (rst) begin
            // Reset các địa chỉ về 0
            addr_colS <= 2'b00;
            addr_rowH <= 2'b00;
        end 
	 else if(ena) begin
                addr_colS <= 0;
                addr_rowH <= 0;
        end
	else if(rx_en) begin
            // Tăng địa chỉ cột S (mod 2)
            if (addr_colS == 2'b01) begin
                addr_colS <= 2'b00;
		
                // Tăng địa chỉ hàng H (mod 4)
                if (addr_rowH == 2'b01) begin
                    addr_rowH <= 2'b00;
                end else begin
                    addr_rowH <= addr_rowH + 1;
                end
            end else begin
                addr_colS <= addr_colS + 1;
            end
        end
    end
endmodule

