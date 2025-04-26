set ::_synlig_defines [list]
verilog_defines -DPDK_sky130A
lappend ::_synlig_defines +define+PDK_sky130A
verilog_defines "-DSCL_sky130_fd_sc_hd\""
lappend ::_synlig_defines "+define+SCL_sky130_fd_sc_hd\""
verilog_defines -D__openlane__
lappend ::_synlig_defines +define+__openlane__
verilog_defines -D__pnr__
lappend ::_synlig_defines +define+__pnr__
verilog_defines -DUSE_POWER_PINS
lappend ::_synlig_defines +define+USE_POWER_PINS
read_verilog -sv -lib /home/vu/RISCV_Pipeline_Core/src/runs/RUN_2025-04-26_12-03-50/tmp/d4fee44131844c6fb61a608af8ab8a11.bb.v
set ::env(SYNTH_LIBS) /home/vu/RISCV_Pipeline_Core/src/runs/RUN_2025-04-26_12-03-50/tmp/8f6a58d236ca476db600d383c6d4347b.lib
