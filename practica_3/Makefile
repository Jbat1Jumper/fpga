board_build: board.vhd board_tb.vhd
	ghdl -a board.vhd board_tb.vhd
	ghdl -e Board_tb

board_run: build
	ghdl -r Board_tb --vcd=board_tb.vcd --stop-time=1us

build: cordic.vhd cordiciter.vhd cordic_tb.vhd 
	ghdl -a --std=08 cordic.vhd cordiciter.vhd cordic_tb.vhd
	ghdl -e --std=08 cordic_tb

run: build
	ghdl -r --std=08 cordic_tb --vcd=cordic_tb.vcd --stop-time=100us

run-n-see: run
	gtkwave cordic_tb.vcd

practica_3.svf:
	echo "You need to create the svf from Quartus first"
	exit(-1)

program-board: practica_3.svf
	sudo killall jtagd || true
	echo "!!! If it hands try closing Quartus and restarting the board !!!"
	sudo jtag program_board.jtag
