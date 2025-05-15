package alu_pkg;
	`include "uvm_macros.svh
	import uvm_pkg::*;
	
	// define constants
	`define DATA_WIDTH 	8
	`define SEL_WIDTH 	3

	// include files
	`include "alu_tx.sv"
    `include "alu_seq.sv"
    `include "alu_sequencer.sv"
    `include "alu_driver.sv"
    `include "alu_monitor.sv"
    `include "alu_agent.sv"
    `include "alu_scoreboard.sv"
    `include "alu_env.sv"  
    `include "alu_test.sv"

endpackage: alu_pkg