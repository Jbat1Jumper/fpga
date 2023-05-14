build: dimmer.vhd dimmer_tb.vhd contador.vhd
	ghdl -a contador.vhd dimmer.vhd dimmer_tb.vhd 
	ghdl -e dimmer_tb

run: build
	ghdl -r dimmer_tb --vcd=dimmer_tb.vcd --stop-time=100us

run-n-see: run
	gtkwave dimmer_tb.vcd

practica_1.svf:
	python3 gen_svf.py

program-board: practica_1.svf
	sudo killall jtagd || true
	echo "!!! If it hands try closing Quartus and restarting the board !!!"
	sudo jtag program_board.jtag
