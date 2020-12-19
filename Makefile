
.PHONY: cpu_tb

cpu_tb: cpu_tb.vcd
	gtkwave cpu_tb.vcd

%.vvp: src/%.v $(wildcard src/*.v)
	cd src && iverilog -y. -o ../$@ ../$<

%.vcd: %.vvp
	vvp $<
