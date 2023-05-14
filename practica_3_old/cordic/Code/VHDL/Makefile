build: cordic.vhd cordiciter.vhd cordic_tb.vhd 
	ghdl -a --std=08 cordic.vhd cordiciter.vhd cordic_tb.vhd
	ghdl -e --std=08 cordic_tb

run: build
	ghdl -r --std=08 cordic_tb --vcd=cordic_tb.vcd --stop-time=100us

run-n-see: run
	gtkwave cordic_tb.vcd
