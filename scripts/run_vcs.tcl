# VCS typically uses command line rather than TCL for compilation
# But you can create a shell script instead (run_vcs.sh):
#!/bin/bash
vcs -R -sverilog +v2k -timescale=1ns/1ps \
    -ntb_opts uvm \
    -debug_access+all \
    -top top_tb \
    rtl/*.sv dv/*.sv dv/components/*.sv dv/objects/*.sv