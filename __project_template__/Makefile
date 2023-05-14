build: board.vhd board_tb.vhd
	ghdl -a board.vhd board_tb.vhd
	ghdl -e Board_tb

run: build
	ghdl -r Board_tb --vcd=board_tb.vcd --stop-time=1us

run-n-see: run
	gtkwave board_tb.vcd

__project_template__.svf:
	python3 gen_svf.py

program-board: __project_template__.svf
	sudo killall jtagd || true
	echo "!!! If it hands try closing Quartus and restarting the board !!!"
	sudo jtag program_board.jtag
