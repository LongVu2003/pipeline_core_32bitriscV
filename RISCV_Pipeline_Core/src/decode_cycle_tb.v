`timescale 1ns / 1ps

module decode_cycle_tb;

    // Inputs
    reg clk;
    reg rst;
    reg RegWriteW;
    reg [4:0] RDW;
    reg [31:0] InstrD;
    reg [31:0] PCD;
    reg [31:0] PCPlus4D;
    reg [31:0] ResultW;

    // Outputs
    wire RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE;
    wire [2:0] ALUControlE;
    wire [31:0] RD1_E, RD2_E, Imm_Ext_E;
    wire [4:0] RS1_E, RS2_E, RD_E;
    wire [31:0] PCE, PCPlus4E;

    // Instantiate the Unit Under Test (UUT)
    decode_cycle uut (
        .clk(clk),
        .rst(rst),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D),
        .RegWriteW(RegWriteW),
        .RDW(RDW),
        .ResultW(ResultW),
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
        .RS1_E(RS1_E),
        .RS2_E(RS2_E)
    );

    // Clock generation
    always #5 clk = ~clk;

    // Task to wait for N clock cycles
    task wait4clk(input integer n);
        begin
            repeat (n) @(posedge clk);
        end
    endtask

    // Monitor outputs
    always @(posedge clk) begin
        $display("Time=%0t | RegWriteE=%b ALUSrcE=%b MemWriteE=%b ResultSrcE=%b BranchE=%b ALUControlE=%b", 
            $time, RegWriteE, ALUSrcE, MemWriteE, ResultSrcE, BranchE, ALUControlE);
        $display("         | RD1_E=%h RD2_E=%h Imm_Ext_E=%h", RD1_E, RD2_E, Imm_Ext_E);
        $display("         | RS1_E=%d RS2_E=%d RD_E=%d", RS1_E, RS2_E, RD_E);
        $display("         | PCE=%h PCPlus4E=%h\n", PCE, PCPlus4E);
    end

    // Stimulus
    initial begin
        // Dump wave
        $dumpfile("decode_cycle_wave.vcd");
        $dumpvars(0, decode_cycle_tb);

        // Init
        clk = 0;
        rst = 1;
        RegWriteW = 0;
        RDW = 5'd0;
        InstrD = 32'b000000000001_00000_000_00001_0010011; // ADDI x1, x0, 1
        PCD = 32'h00000000;
        PCPlus4D = 32'h00000004;
        ResultW = 32'h00000001;

        wait4clk(1);
        rst = 0;

        wait4clk(1);
        RegWriteW = 1;
        RDW = 5'd1;
        ResultW = 32'h0000000A;

        wait4clk(1);
        InstrD = 32'b000000000010_00001_000_00010_0010011; // ADDI x2, x1, 2
        PCD = 32'h00000004;
        PCPlus4D = 32'h00000008;

        wait4clk(1);
        InstrD = 32'b000000000011_00010_000_00011_0010011; // ADDI x3, x2, 3
        PCD = 32'h00000008;
        PCPlus4D = 32'h0000000C;

        wait4clk(2);
        $finish;
    end

endmodule

