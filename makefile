SIM ?= questa

run:
ifeq ($(SIM),questa)
	vsim -do scripts/run_questa.tcl
else ifeq ($(SIM),vcs)
	vcs -R -sverilog +v2k -timescale=1ns/1ps \
	    -ntb_opts uvm \
	    -LDFLAGS -Wl,--no-as-needed \
	    -debug_access+all \
	    -top top_tb \
	    rtl/*.sv dv/*.sv dv/components/*.sv dv/objects/*.sv
else ifeq ($(SIM),xcelium)
	xrun -64bit -uvm -access +rwc \
	     -timescale 1ns/1ps \
	     rtl/*.sv dv/*.sv dv/components/*.sv dv/objects/*.sv
endif

clean:
	rm -rf work *.log *.vcd *.wlf *.vdb *.key *.dsn *.trn *.out simv* csrc INCA_libs