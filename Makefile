
build: dimmer.vhdl dimmer_tb.vhdl contador.vhdl
	ghdl -a contador.vhdl dimmer.vhdl dimmer_tb.vhdl 
	ghdl -e dimmer_tb

run: build
	ghdl -r dimmer_tb --vcd=dimmer_tb.vcd
