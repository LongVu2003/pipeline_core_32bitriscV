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
read_verilog -sv -lib /home/vu/RISCV_Pipeline_Core/src/runs/RUN_2025-04-26_14-05-49/tmp/2be610182f634494ab23013c0155fc74.bb.v
set ::env(SYNTH_LIBS) /home/vu/RISCV_Pipeline_Core/src/runs/RUN_2025-04-26_14-05-49/tmp/75f5fc3dccdb4013ac030b333dcd56d6.lib
