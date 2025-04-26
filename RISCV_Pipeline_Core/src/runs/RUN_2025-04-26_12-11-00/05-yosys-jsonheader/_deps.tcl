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
read_verilog -sv -lib /home/vu/RISCV_Pipeline_Core/src/runs/RUN_2025-04-26_12-11-00/tmp/ee7825a06fbc4305bcd64116b9ae0afb.bb.v
set ::env(SYNTH_LIBS) /home/vu/RISCV_Pipeline_Core/src/runs/RUN_2025-04-26_12-11-00/tmp/7f87b172482849c5860d78fab2b1d687.lib
