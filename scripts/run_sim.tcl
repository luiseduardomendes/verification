# Load the necessary libraries
load_library {typical}

# Read RTL files
read_hdl -sv ../rtl/alu_top.sv
read_hdl -sv ../rtl/alu_core.sv
read_hdl -sv ../rtl/parity_core.sv

# Read verification files
read_hdl -sv ../dv/alu_if.sv
read_hdl -sv ../dv/alu_pkg.sv
read_hdl -sv ../dv/components/alu_agent.sv
read_hdl -sv ../dv/components/alu_driver.sv
read_hdl -sv ../dv/components/alu_monitor.sv
read_hdl -sv ../dv/objects/alu_sequencer.sv
read_hdl -sv ../dv/objects/alu_tx.sv
read_hdl -sv ../dv/testbench.sv

# Elaborate the design
elaborate alu_top

# Set up simulation
simvision -input ../scripts/wave.tcl &
simulate -uvm -uvmtop testbench -uvmtest alu_test