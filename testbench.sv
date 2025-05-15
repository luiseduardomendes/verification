// Code your testbench here
// or browse Examples
`include "alu_if.sv"
`include "alu_pkg.sv"
`include "uvm_macros.svh"

module top_tb;
  import alu_pkg::*;
  
  logic clk;
  
  alu_if #(
    .DATA_WIDTH	(`DATA_WIDTH),
    .SEL_WIDTH	(`SEL_WIDTH)
  ) dut_id (
    .clk		(clk)
  );
  
  alu_top #(
  	.DATA_WIDTH	(`DATA_WIDTH),
    .SEL_WIDTH	(`SEL_WIDTH)
  ) dut (
    // Reset
    .rst		(dut_if.rst),
    
    // Input Interface
    .valid_ip	( dut_if.valid_ip	);
    .sel_ip		( dut_if.sel_ip		);
    .data_ip_1	( dut_if.data_ip_1	);
    .data_ip_2	( dut_if.data_ip_2	);
    .ready_op	( dut_if.ready_op	);

    // Output Interface
    .valid_op	( dut_if.valid_op	);
    .data_op	( dut_if.data_op	);
    .ready_ip	( dut_if.ready_ip	);
  );
  
  initial begin
    clk = 1'b0;
    forever
      #2 clk = ~clk;
  end
  
  initial begin
    uvm_config_db#(virtual alu_if)::set(
      null, 
      "uvm_test_top", 
      "vif",
      dut_if
    );
    
    run_test("alu_test")
  end
  
endmodule : top_tb