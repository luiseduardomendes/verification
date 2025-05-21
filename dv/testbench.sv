`include "uvm_macros.svh"
//`include "dv/alu_if.sv"
//`include "dv/alu_pkg.sv"

module top_tb;
  import uvm_pkg::*;
  import alu_pkg::*;
  
  // Clock generation
  logic clk;
  
  // Instantiate the interface with parameters
  alu_if #(
    .DATA_WIDTH(`DATA_WIDTH),
    .SEL_WIDTH(`SEL_WIDTH)
  ) dut_if (
    .clk(clk)
  );
  
  // Instantiate the DUT with parameters
  alu_top #(
    .DATA_WIDTH(`DATA_WIDTH),
    .SEL_WIDTH(`SEL_WIDTH)
  ) dut (
    // Reset
    .rst(dut_if.rst),
    
    // Input Interface
    .valid_ip(dut_if.valid_ip),
    .sel_ip(dut_if.sel_ip),
    .data_ip_1(dut_if.data_ip_1),
    .data_ip_2(dut_if.data_ip_2),
    .ready_op(dut_if.ready_op),

    // Output Interface
    .valid_op(dut_if.valid_op),
    .data_op(dut_if.data_op),
    .ready_ip(dut_if.ready_ip)
  );
  
  // Clock generator
  initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;  // Changed to #5 for 100MHz clock (10ns period)
  end
  
  // Reset generation and test start
  initial begin
    // Apply reset
    //dut_if.rst = 1'b1;
    //repeat(5) @(posedge clk);
    //dut_if.rst = 1'b0;
    
    // Store the interface in config DB
    uvm_config_db#(virtual alu_if#(.DATA_WIDTH(`DATA_WIDTH), .SEL_WIDTH(`SEL_WIDTH)))::set(
      null, 
      "uvm_test_top", 
      "vif",
      dut_if
    );
    
    // Start the test
    run_test("alu_test");
  end
  
  // End simulation after timeout
  initial begin
    #100000; // 100us timeout
    $display("Timeout: Simulation ended because no UVM phase stopped it");
    $finish;
  end
  
endmodule : top_tb
