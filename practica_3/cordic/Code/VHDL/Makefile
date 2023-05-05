build: Cordic.vhd CordicIter.vhd Cordic_tb.vhd 
	ghdl -a --std=08 Cordic.vhd CordicIter.vhd Cordic_tb.vhd
	ghdl -e --std=08 Cordic_tb

run: build
	ghdl -r --std=08 Cordic_tb --vcd=Cordic_tb.vcd --stop-time=100us

run-n-see: run
	gtkwave Cordic_tb.vcd
