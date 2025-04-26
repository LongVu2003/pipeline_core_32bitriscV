//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Main Testbench Module
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
module memory_cycle_tb;

    // Parameters
    parameter CLK_PERIOD = 10; // Clock period in ns

    // Testbench Signals (reg for inputs, wire for outputs)
    reg clk, rst;
    reg RegWriteM, MemWriteM, ResultSrcM;
    reg [4:0] RD_M;
    reg [31:0] PCPlus4M, WriteDataM, ALU_ResultM;

    wire RegWriteW, ResultSrcW;
    wire [4:0] RD_W;
    wire [31:0] PCPlus4W, ALU_ResultW, ReadDataW;

    // Instantiate the Unit Under Test (DUT)
    memory_cycle dut (
        .clk(clk),
        .rst(rst),
        .RegWriteM(RegWriteM),
        .MemWriteM(MemWriteM),
        .ResultSrcM(ResultSrcM),
        .RD_M(RD_M),
        .PCPlus4M(PCPlus4M),
        .WriteDataM(WriteDataM),
        .ALU_ResultM(ALU_ResultM),

        // Outputs
        .RegWriteW(RegWriteW),
        .ResultSrcW(ResultSrcW),
        .RD_W(RD_W),
        .PCPlus4W(PCPlus4W),
        .ALU_ResultW(ALU_ResultW),
        .ReadDataW(ReadDataW)
    );

    // Clock Generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Waveform Dumping
    initial begin
        $dumpfile("memory_cycle_wave.vcd");
        $dumpvars(0, memory_cycle_tb); // Dump all signals in TB and DUT
    end

    // Test Sequence
    initial begin
        $display("------------------------------------------------------");
        $display("Starting Memory Cycle Testbench at %0t", $time);
        $display("Waveform dumping to memory_cycle_wave.vcd");
        $display("------------------------------------------------------");

        // 1. Initialize and Reset
        rst = 1'b0; // Apply active low reset
        RegWriteM = 1'b0; MemWriteM = 1'b0; ResultSrcM = 1'b0;
        RD_M = 5'hxx;
        PCPlus4M = 32'hxxxxxxxx; WriteDataM = 32'hxxxxxxxx; ALU_ResultM = 32'hxxxxxxxx;

        $display("[%0t] Applying Reset...", $time);
        #(CLK_PERIOD * 1.5);
        rst = 1'b1; // Release reset
        $display("[%0t] Releasing Reset.", $time);
        @(posedge clk); // Wait for first clock edge after reset release

        // --- Test Scenario 1: Load Word (LW) ---
        // Simulate LW rd, offset(rs1) -> rd = Memory[ALU_ResultM]
        $display("\n[%0t] Test 1: Load Word (LW)", $time);
        RegWriteM = 1'b1;      // Write to register in WB stage
        MemWriteM = 1'b0;      // Read from memory
        ResultSrcM = 1'b1;     // Result comes from memory read data
        RD_M = 5'd10;         // Destination register rd = x10
        PCPlus4M = 32'h000000A4; // PC+4 value (passed through)
        WriteDataM = 32'hxxxxxxxx; // Not used for LW
        ALU_ResultM = 32'h00000040; // Memory address calculated in EX stage (e.g., base + offset = 0x40)

        @(posedge clk);
        $display("[%0t] LW Result: ReadDataW=%h (Expected %h), ALU_ResultW=%h, RD_W=%d, ResultSrcW=%b, RegWriteW=%b",
                 $time, ReadDataW, 32'hCAFEBABE, ALU_ResultW, RD_W, ResultSrcW, RegWriteW);

        // --- Test Scenario 2: Store Word (SW) ---
        // Simulate SW rs2, offset(rs1) -> Memory[ALU_ResultM] = WriteDataM
        $display("\n[%0t] Test 2: Store Word (SW)", $time);
        RegWriteM = 1'b0;      // No register write for SW
        MemWriteM = 1'b1;      // Write to memory
        ResultSrcM = 1'bx;     // Don't care (Result not used for WB)
        RD_M = 5'hxx;         // Don't care
        PCPlus4M = 32'h000000A8; // PC+4 value
        WriteDataM = 32'h12345678; // Data to be written (from RD2_E/rs2)
        ALU_ResultM = 32'h00000044; // Memory address calculated in EX stage (e.g., 0x44)

        @(posedge clk);
        // Check the pipelined outputs. ReadDataW might show old data from the read port.
        $display("[%0t] SW Cycle End: ReadDataW=%h, ALU_ResultW=%h, RD_W=%d, ResultSrcW=%b, RegWriteW=%b",
                 $time, ReadDataW, ALU_ResultW, RD_W, ResultSrcW, RegWriteW);
        // The actual memory write happens inside the dummy memory module on this clock edge.

        // --- Test Scenario 3: Verify Store Word (LW from the same address) ---
        $display("\n[%0t] Test 3: Verify SW with LW", $time);
        RegWriteM = 1'b1;      // Write to register
        MemWriteM = 1'b0;      // Read from memory
        ResultSrcM = 1'b1;     // Result from memory
        RD_M = 5'd11;         // Destination register rd = x11
        PCPlus4M = 32'h000000AC; // PC+4 value
        WriteDataM = 32'hxxxxxxxx; // Not used
        ALU_ResultM = 32'h00000044; // Read from the same address we just wrote to (0x44)

        @(posedge clk);
        $display("[%0t] Verify LW Result: ReadDataW=%h (Expected %h), ALU_ResultW=%h, RD_W=%d",
                 $time, ReadDataW, 32'h12345678, ALU_ResultW, RD_W);

        // --- Test Scenario 4: R-type/I-type (ALU result pass-through) ---
        // Simulate ADD rd, rs1, rs2 -> Result comes from ALU_ResultM
        $display("\n[%0t] Test 4: R-type/I-type Pass-through", $time);
        RegWriteM = 1'b1;      // Write to register
        MemWriteM = 1'b0;      // No memory write/read relevant to result
        ResultSrcM = 1'b0;     // Result comes from ALU (passed through M stage)
        RD_M = 5'd12;         // Destination register rd = x12
        PCPlus4M = 32'h000000B0; // PC+4 value
        WriteDataM = 32'hxxxxxxxx; // Not used for result
        ALU_ResultM = 32'hBEEFBEEF; // ALU result calculated in EX stage

        @(posedge clk);
        // ReadDataW will show whatever is at memory address BEEFBEEF, but it's not the result source.
        $display("[%0t] R/I-type Result: ALU_ResultW=%h (Expected %h), ReadDataW=%h, RD_W=%d, ResultSrcW=%b, RegWriteW=%b",
                 $time, ALU_ResultW, 32'hBEEFBEEF, ReadDataW, RD_W, ResultSrcW, RegWriteW);


        // --- End Simulation ---
        $display("\n------------------------------------------------------");
        $display("Finished Testbench at %0t", $time);
        $display("------------------------------------------------------");
        #(CLK_PERIOD * 2); // Wait a bit longer for waves
        $finish;
    end

endmodule
