
a.outHqDh : *.v
	iverilog Hq_Dh_cal.v AddressGenerator.v Hq_Cal.v cmult.v qmult.v rom_S.v accDh.v vadd.v genRowHq.v tb_Hq_Dh_cal.v
a.outHqA1 : *.v
	iverilog HqA1_cal.v AddressGenerator.v cmult.v qmult.v vadd.v genColout.v tb_HqA1_cal.v
a.outxIxQ : *.v
	 iverilog xIxQ_cal.v Hq_Dh_cal.v HqA1_cal.v HqA2_cal.v HqB1_cal.v HqB2_cal.v xI1_cal.v xI2_cal.v xQ1_cal.v xQ2_cal.v AddressGenerator.v Hq_Cal.v cmult.v qmult.v rom_S.v accDh.v vadd.v genColout.v genRowHq.v YGA1_cal.v YGA2_cal.v YGB1_cal.v YGB2_cal.v fxp_div_pipe.v fxp_zoom.v trace_cal.v AddrGenY.v tb_xIxQ_cal.v 
tb.vcd : a.outHqDh
	./a.out
tbxIxQ.vcd : a.outxIxQ
	./a.out
tbHqA1.vcd : a.outHqA1
	./a.out
debugHqDh : tb.vcd
	gtkwave tb.vcd
debugHqA1 : tbHqA1.vcd
	gtkwave tbHqA1.vcd
debugxIxQ : tbxIxQ.vcd
	gtkwave tbxIxQ.vcd
clean : *.out *.vcd
	rm -f *.out *.vcd

	
