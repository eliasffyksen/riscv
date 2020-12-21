
.PHONY: core_tb

core_tb: core_tb.vcd
	gtkwave core_tb.vcd

%.vvp: src/%.v $(wildcard src/*.v)
	cd src && iverilog -y. -o ../$@ ../$<

%.vcd: %.vvp
	vvp $<
