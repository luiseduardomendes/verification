vlib work
vlog -sv \
     -L uvm \
     ../rtl/alu_top.sv \
     ../rtl/alu_core.sv \
     ../rtl/parity_core.sv \
     ../dv/alu_if.sv \
     ../dv/alu_pkg.sv \
     ../dv/components/*.sv \
     ../dv/objects/*.sv \
     ../dv/testbench.sv

vsim -voptargs=+acc -L uvm top_tb
add wave -position insertpoint sim:/top_tb/dut_if/*
add wave -position insertpoint sim:/top_tb/dut/*
run -all