build: board.vhd board_tb.vhd
	ghdl -a board.vhd board_tb.vhd
	ghdl -e Board_tb

run: build
	ghdl -r Board_tb --vcd=board_tb.vcd --stop-time=1us

run-n-see: run
	gtkwave board_tb.vcd

program-board: __project_template__.svf
	sudo killall jtagd
	sudo jtag program_board.jtag
