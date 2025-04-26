//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Main Testbench Module
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
module writeback_cycle_tb;

    // Parameters
    parameter CLK_PERIOD = 10; // Clock period in ns

    // Testbench Signals (reg for inputs, wire for outputs)
    reg clk, rst;
    reg ResultSrcW; // Control signal for the mux
    reg [31:0] PCPlus4W;   // Input, not directly used by DUT logic but needed for port connection
    reg [31:0] ALU_ResultW; // Input from ALU result (or pass-through from M)
    reg [31:0] ReadDataW;   // Input from Memory Read Data (or pass-through from M)

    wire [31:0] ResultW;   // Output of the DUT (final result to be written back)

    // Instantiate the Unit Under Test (DUT)
    writeback_cycle dut (
        .clk(clk),             // Clock input
        .rst(rst),             // Reset input
        .ResultSrcW(ResultSrcW), // Mux select input
        .PCPlus4W(PCPlus4W),     // Pass-through value (not used in DUT logic)
        .ALU_ResultW(ALU_ResultW), // Input A for the mux
        .ReadDataW(ReadDataW),     // Input B for the mux
        .ResultW(ResultW)          // Mux output
    );

    // Clock Generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk; // Toggle clock every half period
    end

    // Waveform Dumping
    initial begin
        $dumpfile("writeback_cycle_wave.vcd"); // Specify VCD file name
        $dumpvars(0, writeback_cycle_tb);     // Dump all signals in this TB and DUT instance
    end

    // Test Sequence
    initial begin
        $display("------------------------------------------------------");
        $display("Starting Writeback Cycle Testbench at %0t", $time);
        $display("Waveform dumping to writeback_cycle_wave.vcd");
        $display("------------------------------------------------------");

        // 1. Initialize and Reset
        rst = 1'b0; // Apply active low reset
        ResultSrcW = 1'bx; // Initialize inputs to unknown
        PCPlus4W = 32'hxxxxxxxx;
        ALU_ResultW = 32'hxxxxxxxx;
        ReadDataW = 32'hxxxxxxxx;

        $display("[%0t] Applying Reset...", $time);
        #(CLK_PERIOD * 1.5); // Hold reset for 1.5 clock cycles
        rst = 1'b1; // Release reset
        $display("[%0t] Releasing Reset.", $time);
        // No registers inside DUT, so no need to wait for posedge clk after reset for DUT state

        // --- Test Scenario 1: Select ALU Result ---
        // ResultSrcW = 0 should select ALU_ResultW
        $display("\n[%0t] Test 1: Select ALU Result (ResultSrcW = 0)", $time);
        ResultSrcW = 1'b0;
        PCPlus4W = 32'h00001004; // Example value
        ALU_ResultW = 32'hAAAAAAAA; // Test value for ALU result
        ReadDataW = 32'hBBBBBBBB; // Test value for Memory data (should not be selected)

        #1; // Allow combinational logic to settle
        $display("[%0t] Inputs: ResultSrcW=%b, ALU_ResultW=%h, ReadDataW=%h",
                 $time, ResultSrcW, ALU_ResultW, ReadDataW);
        $display("[%0t] Output: ResultW=%h (Expected %h)",
                 $time, ResultW, 32'hAAAAAAAA);
        if (ResultW !== 32'hAAAAAAAA) $display("[%0t] ERROR: ResultW mismatch!", $time);

        #(CLK_PERIOD); // Wait for one clock cycle

        // --- Test Scenario 2: Select Memory Read Data ---
        // ResultSrcW = 1 should select ReadDataW
        $display("\n[%0t] Test 2: Select Memory Data (ResultSrcW = 1)", $time);
        ResultSrcW = 1'b1;
        PCPlus4W = 32'h00002008; // Another example value
        ALU_ResultW = 32'hCCCCCCCC; // Test value for ALU result (should not be selected)
        ReadDataW = 32'hDDDDDDDD; // Test value for Memory data

        #1; // Allow combinational logic to settle
        $display("[%0t] Inputs: ResultSrcW=%b, ALU_ResultW=%h, ReadDataW=%h",
                 $time, ResultSrcW, ALU_ResultW, ReadDataW);
        $display("[%0t] Output: ResultW=%h (Expected %h)",
                 $time, ResultW, 32'hDDDDDDDD);
        if (ResultW !== 32'hDDDDDDDD) $display("[%0t] ERROR: ResultW mismatch!", $time);

        #(CLK_PERIOD); // Wait for one clock cycle

        // --- End Simulation ---
        $display("\n------------------------------------------------------");
        $display("Finished Testbench at %0t", $time);
        $display("------------------------------------------------------");
        #(CLK_PERIOD * 2); // Wait a bit longer for waves
        $finish; // Stop the simulation
    end

endmodule
