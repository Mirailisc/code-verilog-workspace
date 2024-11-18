run:
	iverilog -g2012 -o alu_tb tb/Traffic_tb.sv src/Traffic.sv && vvp alu_tb