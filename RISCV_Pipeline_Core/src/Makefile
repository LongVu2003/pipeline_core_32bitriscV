a.out_decode : *.v
	iverilog Fetch_Cycle.v Mux.v Instruction_Memory.v PC_Module.v PC_Adder.v fetch_cycle_tb.v
tb.vcd_decode : a.out_decode
	./a.out
debugDecode : tb.vcd_decode
	gtkwave fetch_cycle_wave.vcd
clean : *.out *.vcd
	rm -f *.out *.vcd

