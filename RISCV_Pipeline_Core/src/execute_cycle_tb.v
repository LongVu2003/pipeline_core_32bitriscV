//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
// Main Testbench Module
//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
module execute_cycle_tb;

    // Parameters
    parameter CLK_PERIOD = 10; // Clock period in ns

    // Testbench Signals (reg for inputs, wire for outputs)
    reg clk, rst;
    reg RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE;
    reg [2:0] ALUControlE;
    reg [31:0] RD1_E, RD2_E, Imm_Ext_E;
    reg [4:0] RD_E;
    reg [31:0] PCE, PCPlus4E;
    reg [31:0] ResultW; // Input from WriteBack stage (for forwarding)
    reg [1:0] ForwardA_E, ForwardB_E;
    // ** REMOVED: reg [31:0] ALU_ResultM_tb_in; **

    wire PCSrcE; // Output: Branch decision
    wire RegWriteM, MemWriteM, ResultSrcM; // Pipelined control signals
    wire [4:0] RD_M; // Pipelined destination register
    wire [31:0] PCPlus4M, WriteDataM, ALU_ResultM; // Pipelined data
    wire [31:0] PCTargetE; // Output: Branch target address

    // Instantiate the Unit Under Test (DUT)
    execute_cycle dut (
        .clk(clk),
        .rst(rst),
        .RegWriteE(RegWriteE),
        .ALUSrcE(ALUSrcE),
        .MemWriteE(MemWriteE),
        .ResultSrcE(ResultSrcE),
        .BranchE(BranchE),
        .ALUControlE(ALUControlE),
        .RD1_E(RD1_E),
        .RD2_E(RD2_E),
        .Imm_Ext_E(Imm_Ext_E),
        .RD_E(RD_E),
        .PCE(PCE),
        .PCPlus4E(PCPlus4E),
        .ResultW(ResultW), // Connect WB result
        .ForwardA_E(ForwardA_E),
        .ForwardB_E(ForwardB_E),
        // ** REMOVED incorrect binding: .ALU_ResultM(ALU_ResultM_tb_in), **

        // Outputs
        .PCSrcE(PCSrcE),
        .PCTargetE(PCTargetE),
        .RegWriteM(RegWriteM),
        .MemWriteM(MemWriteM),
        .ResultSrcM(ResultSrcM),
        .RD_M(RD_M),
        .PCPlus4M(PCPlus4M),
        .WriteDataM(WriteDataM),      // Data to be written to memory in M stage
        .ALU_ResultM(ALU_ResultM) // << Correct: Connect DUT output to TB wire
    );

    // Clock Generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Waveform Dumping
    initial begin
        $dumpfile("execute_cycle_wave.vcd");
        $dumpvars(0, execute_cycle_tb); // Dump all signals in TB and DUT
    end

    // Test Sequence
    initial begin
        $display("------------------------------------------------------");
        $display("Starting Execute Cycle Testbench at %0t", $time);
        $display("Waveform dumping to execute_cycle_wave.vcd");
        $display("------------------------------------------------------");

        // 1. Initialize and Reset
        rst = 1'b0; // Apply active low reset
        RegWriteE = 1'b0; ALUSrcE = 1'b0; MemWriteE = 1'b0; ResultSrcE = 1'b0; BranchE = 1'b0;
        ALUControlE = 3'bxxx;
        RD1_E = 32'hxxxxxxxx; RD2_E = 32'hxxxxxxxx; Imm_Ext_E = 32'hxxxxxxxx;
        RD_E = 5'hxx;
        PCE = 32'h00000000; PCPlus4E = 32'h00000004;
        ResultW = 32'hxxxxxxxx;
        ForwardA_E = 2'b00; ForwardB_E = 2'b00;

        $display("[%0t] Applying Reset...", $time);
        #(CLK_PERIOD * 1.5);
        rst = 1'b1; // Release reset
        $display("[%0t] Releasing Reset.", $time);
        @(posedge clk);

        // --- Test Scenario 1: R-type ADD (rd = rs1 + rs2) ---
        $display("\n[%0t] Test 1: R-type ADD (No Forwarding)", $time);
        RegWriteE = 1'b1; ALUSrcE = 1'b0; MemWriteE = 1'b0; ResultSrcE = 1'b0; BranchE = 1'b0;
        ALUControlE = 3'b000; RD1_E = 32'h0000000A; RD2_E = 32'h00000014; RD_E = 5'd5;
        PCE = 32'h00000010; PCPlus4E = 32'h00000014; ResultW = 32'hDEADBEEF;
        ForwardA_E = 2'b00; ForwardB_E = 2'b00;
        @(posedge clk);
        $display("[%0t] ADD Result: ALU_ResultM=%h (Expected %h), WriteDataM=%h, RD_M=%d, RegWriteM=%b",
                 $time, ALU_ResultM, 32'h0000001E, WriteDataM, RD_M, RegWriteM); // Expected 10+20=30=1E

        // --- Test Scenario 2: I-type ADDI (rd = rs1 + imm) ---
        $display("\n[%0t] Test 2: I-type ADDI (No Forwarding)", $time);
        RegWriteE = 1'b1; ALUSrcE = 1'b1; MemWriteE = 1'b0; ResultSrcE = 1'b0; BranchE = 1'b0;
        ALUControlE = 3'b000; RD1_E = 32'h00000050; Imm_Ext_E = 32'hFFFFFFE0; RD_E = 5'd6; // imm = -32
        PCE = 32'h00000014; PCPlus4E = 32'h00000018;
        ForwardA_E = 2'b00; ForwardB_E = 2'b00;
        @(posedge clk);
        $display("[%0t] ADDI Result: ALU_ResultM=%h (Expected %h), RD_M=%d",
                 $time, ALU_ResultM, 32'h00000030, RD_M); // Expected 80+(-32)=48=30

        // --- Test Scenario 3: BEQ - Branch Taken ---
        $display("\n[%0t] Test 3: BEQ Branch Taken (rs1 == rs2)", $time);
        RegWriteE = 1'b0; ALUSrcE = 1'b0; MemWriteE = 1'b0; ResultSrcE = 1'b0; BranchE = 1'b1;
        ALUControlE = 3'b001; RD1_E = 32'h000000AA; RD2_E = 32'h000000AA; Imm_Ext_E = 32'h00000020;
        RD_E = 5'hxx; PCE = 32'h00000018; PCPlus4E = 32'h0000001C;
        ForwardA_E = 2'b00; ForwardB_E = 2'b00;
        #1; // Allow combinational logic
        $display("[%0t] BEQ Taken Check: ZeroE=%b (internal), BranchE=%b -> PCSrcE=%b (Expected 1), PCTargetE=%h (Expected %h)",
                 $time, dut.ZeroE, BranchE, PCSrcE, PCTargetE, 32'h00000038);
        @(posedge clk);
        $display("[%0t] BEQ Taken Cycle End: ALU_ResultM=%h (SUB result 0), RD_M=%d, RegWriteM=%b",
                 $time, ALU_ResultM, RD_M, RegWriteM); // ALU_ResultM should be 0

        // --- Test Scenario 4: BEQ - Branch Not Taken ---
        $display("\n[%0t] Test 4: BEQ Branch Not Taken (rs1 != rs2)", $time);
        RegWriteE = 1'b0; ALUSrcE = 1'b0; MemWriteE = 1'b0; ResultSrcE = 1'b0; BranchE = 1'b1;
        ALUControlE = 3'b001; RD1_E = 32'h000000AB; RD2_E = 32'h000000AA; Imm_Ext_E = 32'h00000020;
        RD_E = 5'hxx; PCE = 32'h0000001C; PCPlus4E = 32'h00000020;
        ForwardA_E = 2'b00; ForwardB_E = 2'b00;
        #1; // Allow combinational logic
        $display("[%0t] BEQ Not Taken Check: ZeroE=%b (internal), BranchE=%b -> PCSrcE=%b (Expected 0), PCTargetE=%h",
                 $time, dut.ZeroE, BranchE, PCSrcE, PCTargetE);
        @(posedge clk);
        $display("[%0t] BEQ Not Taken Cycle End: ALU_ResultM=%h (SUB result non-zero), RD_M=%d, RegWriteM=%b",
                 $time, ALU_ResultM, RD_M, RegWriteM); // ALU_ResultM should be 1

        // --- Test Scenario 5: Forwarding Case '10' (Using DUT's *own* previous output) ---
        // Simulate ADD x7, x5, x6 where x5 is supposedly from M stage.
        // **NOTE:** Due to DUT design, ForwardA=10 uses ALU_ResultM output from the *previous* cycle (Test 4's result).
        $display("\n[%0t] Test 5: Forwarding Case '10' (ForwardA=10)", $time);
        RegWriteE = 1'b1; ALUSrcE = 1'b0; MemWriteE = 1'b0; ResultSrcE = 1'b0; BranchE = 1'b0;
        ALUControlE = 3'b000; // ADD
        RD1_E = 32'hAAAAAAAA; // Original value of x5 (will be bypassed)
        RD2_E = 32'h00000005; // Value of x6 = 5
        RD_E = 5'd7;          // rd = x7
        PCE = 32'h00000020; PCPlus4E = 32'h00000024;
        ResultW = 32'hDEADBEEF;
        ForwardA_E = 2'b10; // <<< Forward previous ALU_ResultM to SrcA
        ForwardB_E = 2'b00;
        // Previous ALU_ResultM (from Test 4 BEQ Not Taken) was 0x00000001
        @(posedge clk);
        $display("[%0t] Forward 'M' (Self) Result: ALU_ResultM=%h (Expected %h), Src_A=%h (Internal), Src_B=%h (Internal)",
                 $time, ALU_ResultM, 32'h00000006, dut.Src_A, dut.Src_B); // Expected 1 (prev ALU_ResultM) + 5 = 6

        // --- Test Scenario 6: Forwarding from WriteBack Stage (ResultW) ---
        $display("\n[%0t] Test 6: Forwarding from WB stage (ForwardB=01)", $time);
        RegWriteE = 1'b1; ALUSrcE = 1'b0; MemWriteE = 1'b0; ResultSrcE = 1'b0; BranchE = 1'b0;
        ALUControlE = 3'b000; // ADD
        RD1_E = 32'h00000006; // Value of x7 (from previous cycle's result)
        RD2_E = 32'hBBBBBBBB; // Original value of x5 (will be bypassed)
        RD_E = 5'd8;          // rd = x8
        PCE = 32'h00000024; PCPlus4E = 32'h00000028;
        ResultW = 32'h00000010; // <<< Value of x5 coming from WB stage = 16
        ForwardA_E = 2'b00;
        ForwardB_E = 2'b01; // <<< Forward ResultW to SrcB
        @(posedge clk);
        $display("[%0t] Forward WB Result: ALU_ResultM=%h (Expected %h), Src_A=%h (Internal), Src_B=%h (Internal)",
                 $time, ALU_ResultM, 32'h00000016, dut.Src_A, dut.Src_B); // Expected 6 + 16 = 22 = 16

        // --- Test Scenario 7: Store Word (SW) ---
        $display("\n[%0t] Test 7: Store Word (SW)", $time);
        RegWriteE = 1'b0; ALUSrcE = 1'b1; MemWriteE = 1'b1; ResultSrcE = 1'b0; BranchE = 1'b0;
        ALUControlE = 3'b000; // ADD for address calculation
        RD1_E = 32'h10000000; // Base address (rs1)
        RD2_E = 32'hABCDEF01; // Data to store (rs2)
        Imm_Ext_E = 32'h00000040; // Offset = 64
        RD_E = 5'hxx;
        PCE = 32'h00000028; PCPlus4E = 32'h0000002C;
        ForwardA_E = 2'b00; ForwardB_E = 2'b00;
        @(posedge clk);
        $display("[%0t] SW Result: ALU_ResultM=%h (Address Expected %h), WriteDataM=%h (Data Expected %h), MemWriteM=%b",
                 $time, ALU_ResultM, 32'h10000040, WriteDataM, 32'hABCDEF01, MemWriteM);

        // --- End Simulation ---
        $display("\n------------------------------------------------------");
        $display("Finished Testbench at %0t", $time);
        $display("------------------------------------------------------");
        #(CLK_PERIOD * 2);
        $finish;
    end

endmodule
