module fetch_cycle_tb;

    // Tham số
    parameter CLK_PERIOD = 10; // Chu kỳ clock (ns)

    // Tín hiệu cho testbench
    reg clk_tb;
    reg rst_tb;
    reg PCSrcE_tb;
    reg [31:0] PCTargetE_tb;

    wire [31:0] InstrD_tb;
    wire [31:0] PCD_tb;
    wire [31:0] PCPlus4D_tb;

    // Instantiate the Unit Under Test (UUT)
    // Giả sử module fetch_cycle được định nghĩa trong file fetch_cycle.v
    fetch_cycle dut (
        .clk(clk_tb),
        .rst(rst_tb),
        .PCSrcE(PCSrcE_tb),
        .PCTargetE(PCTargetE_tb),
        .InstrD(InstrD_tb),
        .PCD(PCD_tb),
        .PCPlus4D(PCPlus4D_tb)
    );

    // Tạo xung clock
    initial begin
        clk_tb = 0;
        forever #(CLK_PERIOD/2) clk_tb = ~clk_tb; // Toggle clock mỗi nửa chu kỳ
    end

    // Waveform Dumping Setup
    initial begin
        // Tạo file VCD (Value Change Dump) để lưu sóng
        $dumpfile("fetch_cycle_wave.vcd");
        // Dump tất cả các biến trong module testbench và các module con (level 0)
        // bao gồm cả các tín hiệu bên trong DUT (fetch_cycle)
        $dumpvars();
    end

    // Quy trình kiểm thử
    initial begin
        $display("------------------------------------------------------");
        $display("Bắt đầu Testbench cho fetch_cycle lúc %0t", $time);
        $display("Waveform đang được ghi vào fetch_cycle_wave.vcd");
        $display("------------------------------------------------------");

        // 1. Khởi tạo và Reset
        rst_tb = 1'b0; // Áp dụng reset (active low)
        PCSrcE_tb = 1'b0;
        PCTargetE_tb = 32'hxxxxxxxx; // Không quan trọng khi đang reset
        $display("[%0t] Đang áp dụng Reset (rst_tb = %b)", $time, rst_tb);

        #(CLK_PERIOD * 1.5); // Giữ reset

        rst_tb = 1'b1; // Nhả reset
        $display("[%0t] Nhả Reset (rst_tb = %b)", $time, rst_tb);
        @(posedge clk_tb); // Chờ cạnh lên clock đầu tiên sau khi nhả reset

        $display("[%0t] Sau Reset: PCD=%h, PCPlus4D=%h, InstrD=%h", $time, PCD_tb, PCPlus4D_tb, InstrD_tb);


        // 2. Chạy fetch tuần tự (không branch)
        $display("\n[%0t] Bắt đầu fetch tuần tự (PCSrcE = 0)", $time);
        PCSrcE_tb = 1'b0;
        PCTargetE_tb = 32'hCAFEBABE; // Giá trị không dùng đến

        repeat (5) begin // Fetch 5 lệnh tuần tự
            @(posedge clk_tb);
            $display("[%0t] Fetch: PCSrcE=%b -> PCD=%h, PCPlus4D=%h, InstrD=%h",
                     $time, PCSrcE_tb, PCD_tb, PCPlus4D_tb, InstrD_tb);
        end

        // 3. Mô phỏng Branch (nhảy có điều kiện/không điều kiện)
        $display("\n[%0t] Mô phỏng tín hiệu Branch (PCSrcE = 1)", $time);
        PCSrcE_tb = 1'b1;
        // Sửa địa chỉ đích để nằm trong phạm vi bộ nhớ giả lập
        PCTargetE_tb = 32'h0000003C; // Nhảy đến địa chỉ 0x3C (lệnh cuối trong mem)
        $display("[%0t] Kích hoạt branch: PCSrcE=%b, PCTargetE=%h", $time, PCSrcE_tb, PCTargetE_tb);

        @(posedge clk_tb);
        $display("[%0t] Sau cạnh clock 1 (Branch): PCD=%h, PCPlus4D=%h, InstrD=%h (Giá trị cũ)",
                 $time, PCD_tb, PCPlus4D_tb, InstrD_tb);

        @(posedge clk_tb);
        $display("[%0t] Sau cạnh clock 2 (Branch): PCD=%h, PCPlus4D=%h, InstrD=%h (Giá trị mới tại %h)",
                 $time, PCD_tb, PCPlus4D_tb, InstrD_tb, PCTargetE_tb);

        // 4. Tiếp tục fetch tuần tự sau branch
        $display("\n[%0t] Tiếp tục fetch tuần tự sau branch (PCSrcE = 0)", $time);
        PCSrcE_tb = 1'b0; // Tắt tín hiệu branch
        PCTargetE_tb = 32'hDEADBEEF; // Không dùng đến
        $display("[%0t] Tắt branch: PCSrcE=%b", $time);

        // Chỉ fetch 1 lệnh nữa vì đã ở cuối bộ nhớ giả lập
        @(posedge clk_tb);
         $display("[%0t] Fetch: PCSrcE=%b -> PCD=%h, PCPlus4D=%h, InstrD=%h",
                  $time, PCSrcE_tb, PCD_tb, PCPlus4D_tb, InstrD_tb);
        // Fetch tiếp theo sẽ ra địa chỉ không hợp lệ (nếu PC+4 > 0x3C)
        @(posedge clk_tb);
         $display("[%0t] Fetch: PCSrcE=%b -> PCD=%h, PCPlus4D=%h, InstrD=%h (Dự kiến địa chỉ không hợp lệ)",
                  $time, PCSrcE_tb, PCD_tb, PCPlus4D_tb, InstrD_tb);


        // 5. Kết thúc mô phỏng
        #(CLK_PERIOD * 2); // Chờ thêm một chút để sóng ổn định
        $display("\n------------------------------------------------------");
        $display("Kết thúc Testbench lúc %0t", $time);
        $display("Kiểm tra file fetch_cycle_wave.vcd để xem waveform.");
        $display("------------------------------------------------------");
        $finish; // Dừng mô phỏng
    end

    // $monitor có thể hữu ích khi debug bằng console song song với waveform
    // initial begin
    //     $monitor("[%0t] clk=%b rst=%b PCSrcE=%b PCTargetE=%h | PCD=%h PCPlus4D=%h InstrD=%h",
    //              $time, clk_tb, rst_tb, PCSrcE_tb, PCTargetE_tb, PCD_tb, PCPlus4D_tb, InstrD_tb);
    // end

endmodule
