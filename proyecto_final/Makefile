build: board.vhd board_tb.vhd pulse_generator.vhd uart-for-fpga/rtl/comp/uart_clk_div.vhd  uart-for-fpga/rtl/comp/uart_debouncer.vhd uart-for-fpga/rtl/comp/uart_parity.vhd uart-for-fpga/rtl/comp/uart_rx.vhd uart-for-fpga/rtl/comp/uart_tx.vhd uart-for-fpga/rtl/uart.vhd midi_frontend.vhd
	ghdl -a --std=08 \
		uart-for-fpga/rtl/comp/uart_clk_div.vhd \
		uart-for-fpga/rtl/comp/uart_debouncer.vhd \
		uart-for-fpga/rtl/comp/uart_parity.vhd \
		uart-for-fpga/rtl/comp/uart_rx.vhd \
		uart-for-fpga/rtl/comp/uart_tx.vhd \
		uart-for-fpga/rtl/uart.vhd \
		pulse_generator.vhd \
		midi_frontend.vhd \
		board.vhd \
		board_tb.vhd
	ghdl -e --std=08 Board_tb

run: build
	ghdl -r --std=08 Board_tb --vcd=board_tb.vcd --stop-time=100ms

test-synth:
	ghdl -a synth.vhd synth_tb.vhd
	ghdl -e Synth_tb
	ghdl -r Synth_tb --vcd=Synth_tb.vcd --stop-time=1us

test-sample-clock:
	ghdl -a sample_clock.vhd sample_clock_tb.vhd
	ghdl -e SampleClock_tb
	ghdl -r SampleClock_tb --vcd=SampleClock_tb.vcd --stop-time=1us

test-midi-frontend:
	ghdl -a midi_frontend.vhd midi_frontend_tb.vhd
	ghdl -e MidiFrontend_tb
	ghdl -r MidiFrontend_tb --vcd=MidiFrontend_tb.vcd --stop-time=1us

proyecto_final.svf:
	python3 gen_svf.py

program-board: proyecto_final.svf
	sudo killall jtagd || true
	echo "!!! If it hangs try closing Quartus and restarting the board !!!"
	sudo jtag program_board.jtag
