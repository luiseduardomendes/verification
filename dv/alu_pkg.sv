package alu_pkg;
    import uvm_pkg::*;
	`include "uvm_macros.svh"
	
	// define constants
	`define DATA_WIDTH 	8
	`define SEL_WIDTH 	3

	// include files
    `include "dv/objects/alu_tx.sv"
    `include "dv/objects/alu_sequencer.sv"
    `include "dv/components/alu_driver.sv"
    `include "dv/components/alu_monitor.sv"
    `include "dv/components/alu_agent.sv" 
endpackage: alu_pkg
