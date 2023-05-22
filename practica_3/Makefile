board_build: board.vhd board_tb.vhd
	ghdl -a board.vhd board_tb.vhd
	ghdl -e Board_tb

board_run: build
	ghdl -r Board_tb --vcd=board_tb.vcd --stop-time=1us

build: Cordic.vhd CordicIter.vhd Cordic_tb.vhd 
	ghdl -a --std=08 Cordic.vhd CordicIter.vhd Cordic_tb.vhd
	ghdl -e --std=08 Cordic_tb

run: build
	ghdl -r --std=08 Cordic_tb --vcd=Cordic_tb.vcd --stop-time=1us

run-n-see: run
	gtkwave Cordic_tb.vcd

practica_3.svf:
	python3 gen_svf.py

program-board: practica_3.svf
	sudo killall jtagd || true
	echo "!!! If it hands try closing Quartus and restarting the board !!!"
	sudo jtag program_board.jtag
