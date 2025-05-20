# VCS typically uses command line rather than TCL for compilation
# But you can create a shell script instead (run_vcs.sh):
#!/bin/bash

vcs -full64 -sverilog -timescale=1ns/1ps \
    -debug_access+all \
    -ntb_opts uvm \
    -top top_tb \
    +incdir+../rtl \
    ../rtl/alu_top.sv \
    ../rtl/alu_core.sv \
    ../rtl/parity_core.sv \
    ../dv/alu_if.sv \
    ../dv/alu_pkg.sv \
    ../dv/components/*.sv \
    ../dv/objects/*.sv \
    ../dv/testbench.sv

./simv +UVM_TESTNAME=alu_test
