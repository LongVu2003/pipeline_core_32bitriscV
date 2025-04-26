// Filename: pipeline_top_tb.v
// Testbench for the top-level Pipeline_top module

`timescale 1ns / 1ps // Define time unit and precision

// Include the top-level module definition if it's in a separate file
// (Although the provided code includes submodules, including the top itself might be needed depending on setup)
// `include "Pipeline_top.v"

module pipeline_top_tb;

    // Parameters
    parameter CLK_PERIOD = 10; // Clock period in ns
    parameter SIM_CYCLES = 50; // Number of clock cycles to simulate after reset

    // Testbench Signals
    reg clk;
    reg rst;

    // Instantiate the Unit Under Test (DUT)
    // Assuming Pipeline_top module is defined (either directly or via include)
    Pipeline_top dut (
        .clk(clk),
        .rst(rst)
    );

    // Clock Generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk; // Toggle clock every half period
    end

    // Waveform Dumping Setup
    initial begin
        $dumpfile("pipeline_top_wave.vcd"); // Specify VCD file name
        // Dump all signals within the testbench (level 0) and the DUT instance 'dut' (level 1)
        // Use level 0 to capture all signals within the DUT and its submodules
        $dumpvars(0, pipeline_top_tb);
    end

    // Test Sequence
    initial begin
        $display("------------------------------------------------------");
        $display("Starting Pipeline Top Testbench at %0t", $time);
        $display("Waveform dumping to pipeline_top_wave.vcd");
        $display("Simulation will run for %0d cycles after reset.", SIM_CYCLES);
        $display("------------------------------------------------------");

        // 1. Initialize and Reset
        rst = 1'b0; // Apply active low reset

        $display("[%0t] Applying Reset...", $time);
        #(CLK_PERIOD * 2.5); // Hold reset for 2.5 clock cycles

        rst = 1'b1; // Release reset
        $display("[%0t] Releasing Reset.", $time);

        // 2. Run simulation for a defined number of cycles
        $display("[%0t] Running simulation...", $time);
        repeat (SIM_CYCLES) begin
            @(posedge clk);
        end

        // --- End Simulation ---
        $display("\n[%0t] Finished simulation after %0d cycles.", $time, SIM_CYCLES);
        $display("------------------------------------------------------");
        $finish; // Stop the simulation
    end

    // Optional: Monitor specific internal signals if needed for console debugging
    // Example: Monitor the Program Counter in the Fetch stage (adjust path if needed)
    // initial begin
    //     #1; // Wait a bit for hierarchy to exist
    //     if ($isunknown(dut.Fetch.PCF)) begin // Check if signal exists before monitoring
    //        $display("Warning: Cannot monitor dut.Fetch.PCF");
    //     end else begin
    //        $monitor("[%0t] PCF = %h, InstrD = %h", $time, dut.Fetch.PCF, dut.InstrD);
    //     end
    // end

endmodule
