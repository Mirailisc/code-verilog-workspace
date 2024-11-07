run:
	iverilog -g2012 -o alu_tb tb/ALU_tb.sv src/ALU.sv && vvp alu_tb