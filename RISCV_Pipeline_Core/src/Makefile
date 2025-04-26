# Makefile for RISC-V Pipeline Core Simulation

# Compiler
IVERILOG = iverilog

# Simulation Runtime
VVP = vvp

# Waveform Viewer
GTKWAVE = gtkwave

# --- Source Files ---

# Biến chứa tất cả các file Verilog thiết kế (RTL)
# Liệt kê tất cả các file .v của bạn NGOẠI TRỪ các file testbench (*_tb.v)
# *** ĐÃ THÊM PC.v ***
RTL_SOURCES = \
	ALU.v \
	ALU_Decoder.v \
	Control_Unit_Top.v \
	Data_Memory.v \
	Decode_Cyle.v \
	Execute_Cycle.v \
	Fetch_Cycle.v \
	Hazard_unit.v \
	Instruction_Memory.v \
	Main_Decoder.v \
	Memory_Cycle.v \
	Mux.v \
	PC_Adder.v \
	PC_Module.v \
	Pipeline_Top.v \
	Register_File.v \
	Sign_Extend.v \
	Writeback_Cycle.v
TOP = Pipeline_Top.v
# Biến chứa các file Testbench
TB_FETCH = fetch_cycle_tb.v
B_DECODE = decode_cycle_tb.v
TB_EXECUTE = execute_cycle_tb.v
TB_MEMORY = memory_cycle_tb.v
TB_WB = writeback_cycle_tb.v
TB_TOP = pipeline_top_tb.v

# --- Executable Names ---
SIM_FETCH = sim_fetch.out
SIM_DECODE = sim_decode.out
SIM_EXECUTE = sim_execute.out
SIM_MEMORY = sim_memory.out
SIM_WB = sim_wb.out
SIM_TOP = sim_top.out

# --- VCD File Names ---
VCD_FETCH = fetch_cycle_wave.vcd
VCD_DECODE = decode_cycle_wave.vcd
VCD_EXECUTE = execute_cycle_wave.vcd
VCD_MEMORY = memory_cycle_wave.vcd
VCD_WB = writeback_cycle_wave.vcd
VCD_TOP = pipeline_top_wave.vcd

# --- Default Target ---
# Chạy mô phỏng top-level theo mặc định khi gõ 'make'
default: debugTop

# --- Compilation Targets ---

# Biên dịch mô phỏng Fetch Stage
# Lưu ý: Liệt kê các file RTL thực sự cần thiết cho tầng Fetch
FETCH_DEPS = Fetch_Cycle.v Mux.v Instruction_Memory.v PC_Module.v PC_Adder.v
$(SIM_FETCH) : $(FETCH_DEPS) $(TB_FETCH)
	$(IVERILOG) -o $(SIM_FETCH) $(FETCH_DEPS) $(TB_FETCH)

# Biên dịch mô phỏng Decode Stage
# Lưu ý: Liệt kê các file RTL thực sự cần thiết cho tầng Decode
DECODE_DEPS = Decode_Cyle.v Control_Unit_Top.v Register_File.v Sign_Extend.v Main_Decoder.v ALU_Decoder.v # Thêm Main_Decoder, ALU_Decoder nếu cần
$(SIM_DECODE) : $(DECODE_DEPS) $(TB_DECODE)
	$(IVERILOG) -o $(SIM_DECODE) $(DECODE_DEPS) $(TB_DECODE)

# Biên dịch mô phỏng Execute Stage
# Lưu ý: Liệt kê các file RTL thực sự cần thiết cho tầng Execute
EXECUTE_DEPS = Execute_Cycle.v Mux.v ALU.v PC_Adder.v # Cần thêm Mux_3_by_1.v nếu bạn có file đó
$(SIM_EXECUTE) : $(EXECUTE_DEPS) $(TB_EXECUTE)
	$(IVERILOG) -o $(SIM_EXECUTE) $(EXECUTE_DEPS) $(TB_EXECUTE)

# Biên dịch mô phỏng Memory Stage
MEMORY_DEPS = Memory_Cycle.v Data_Memory.v
$(SIM_MEMORY) : $(MEMORY_DEPS) $(TB_MEMORY)
	$(IVERILOG) -o $(SIM_MEMORY) $(MEMORY_DEPS) $(TB_MEMORY)

# Biên dịch mô phỏng Writeback Stage
WB_DEPS = Writeback_Cycle.v Mux.v
$(SIM_WB) : $(WB_DEPS) $(TB_WB)
	$(IVERILOG) -o $(SIM_WB) $(WB_DEPS) $(TB_WB)

# Biên dịch mô phỏng Top Level (Pipeline)
# Phụ thuộc vào tất cả các file RTL và testbench top
$(SIM_TOP) : $(TOP) $(TB_TOP)
	$(IVERILOG) -o $(SIM_TOP) $(TOP) $(TB_TOP)

# --- Simulation Targets (Generate VCD) ---

$(VCD_FETCH) : $(SIM_FETCH)
	$(VVP) $(SIM_FETCH)

$(VCD_DECODE) : $(SIM_DECODE)
	$(VVP) $(SIM_DECODE)

$(VCD_EXECUTE) : $(SIM_EXECUTE)
	$(VVP) $(SIM_EXECUTE)

$(VCD_MEMORY) : $(SIM_MEMORY)
	$(VVP) $(SIM_MEMORY)

$(VCD_WB) : $(SIM_WB)
	$(VVP) $(SIM_WB)

$(VCD_TOP) : $(SIM_TOP)
	$(VVP) $(SIM_TOP)

# --- Debug Targets (Run GTKWave) ---

debugFetch : $(VCD_FETCH)
	$(GTKWAVE) $(VCD_FETCH)

debugDecode : $(VCD_DECODE)
	$(GTKWAVE) $(VCD_DECODE)

debugExecute : $(VCD_EXECUTE)
	$(GTKWAVE) $(VCD_EXECUTE)

debugMemory : $(VCD_MEMORY)
	$(GTKWAVE) $(VCD_MEMORY)

debugWB : $(VCD_WB)
	$(GTKWAVE) $(VCD_WB)

debugTop : $(VCD_TOP)
	$(GTKWAVE) $(VCD_TOP)

synthesis:
	openlane --dockerized initial.json --to Yosys.Synthesis

floorplan:
	openlane --dockerized initial.json --to OpenROAD.Floorplan
prepnrsta:
	openlane --dockerized initial.json --to OpenROAD.STAPrePNR
midpnrsta:
	openlane --dockerized initial.json --to OpenROAD.STAMidPNR

postpnrsta:
	openlane --dockerized initial.json --to OpenROAD.STApostpnr


global_pl:
	openlane --dockerized initial.json --to OpenROAD.GlobalPlacementSkipIO

viewlayout:
	openlane --dockerized initial.json --last-run --flow openinopenroad

# --- Clean Target ---
clean :
	rm -f $(SIM_FETCH) $(SIM_DECODE) $(SIM_EXECUTE) $(SIM_MEMORY) $(SIM_WB) $(SIM_TOP) *.out *.vcd

# --- Phony Targets ---
# Khai báo các target không tạo ra file cùng tên
.PHONY: default clean debugFetch debugDecode debugExecute debugMemory debugWB debugTop

