
a.outHqDh : *.v
	iverilog Hq_Dh_cal.v AddressGenerator.v Hq_Cal.v cmult.v qmult.v rom_S.v sipo.v vadd.v tb_Hq_Dh_cal.v
a.outHqA1 : *.v
	iverilog HqA1_cal.v AddressGenerator.v cmult.v qmult.v vadd.v genColout.v tb_HqA1_cal.v
tb.vcd : a.outHqDh
	./a.out
tbHqA1.vcd : a.outHqA1
	./a.out
debugHqDh : tb.vcd
	gtkwave tb.vcd
debugHqA1 : tbHqA1.vcd
	gtkwave tbHqA1.vcd
clean : *.out *.vcd
	rm -f *.out *.vcd

	
