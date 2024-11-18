module AddressGenerator (
    input wire clk,       // Clock input
    input wire rst,     // Active low reset
    output reg [1:0] addr_colS, // Đếm mod 2 (0 -> 1)
    output reg [1:0] addr_rowH, // Đếm mod 4 (0 -> 3)
    output reg [3:0] addr_Si    // Đếm mod 16 (0 -> 15)
);
reg done_Si;

    // Process for generating addresses
    always @(posedge clk) begin
        if (rst) begin
            // Reset các địa chỉ về 0
            addr_colS <= 2'b00;
            addr_rowH <= 2'b00;
            addr_Si   <= 4'b0000;
	    done_Si   <= 0;
        end else begin
            // Tăng địa chỉ cột S (mod 2)
            if (addr_colS == 2'b01) begin
                addr_colS <= 2'b00;
		
                // Tăng địa chỉ hàng H (mod 4)
                if (addr_rowH == 2'b11) begin
                    addr_rowH <= 2'b00;

                    // Tăng địa chỉ Si (mod 16)
                    if (addr_Si == 4'b1111) begin
			done_Si <= 1;
                        addr_Si <= 4'b0000;
                    end else if(!done_Si) begin
                        addr_Si <= addr_Si + 1;
                    end
                end else if(!done_Si) begin
                    addr_rowH <= addr_rowH + 1;
                end
            end else if(!done_Si) begin
                addr_colS <= addr_colS + 1;
            end
        end
    end
endmodule

