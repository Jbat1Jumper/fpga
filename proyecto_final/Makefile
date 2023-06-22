build: board.vhd board_tb.vhd
	ghdl -a board.vhd board_tb.vhd
	ghdl -e Board_tb

run: build
	ghdl -r Board_tb --vcd=board_tb.vcd --stop-time=1us


test-sample-clock:
	ghdl -a sample_clock.vhd sample_clock_tb.vhd
	ghdl -e SampleClock_tb
	ghdl -r SampleClock_tb --vcd=SampleClock_tb.vcd --stop-time=1us

proyecto_final.svf:
	python3 gen_svf.py

program-board: proyecto_final.svf
	sudo killall jtagd || true
	echo "!!! If it hands try closing Quartus and restarting the board !!!"
	sudo jtag program_board.jtag
