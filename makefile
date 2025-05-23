SIM ?= questa

run:
ifeq ($(SIM),questa)
	vsim -do scripts/run_questa.tcl
else ifeq ($(SIM),vcs)
	vcs -sverilog -timescale=1ns/1ps \
	    -debug_access+all \
	    -ntb_opts uvm \
	    +incdir+./rtl +incdir+ \
	    -top top_tb \
	    ./dv/alu_pkg.sv \
	    ./dv/alu_if.sv \
	    ./rtl/alu_top.sv \
	    ./dv/testbench.sv \
	    -R
else ifeq ($(SIM),xcelium)
	xrun -64bit -uvm -access +rwc \
	     -timescale 1ns/1ps \
	     rtl/*.sv dv/*.sv dv/components/*.sv dv/objects/*.sv
endif

clean:
	rm -rf work *.log *.vcd *.wlf *.vdb *.key *.dsn *.trn *.out simv* csrc INCA_libs
