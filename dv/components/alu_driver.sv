//  Class: alu_driver
//
class alu_driver extends uvm_driver #(alu_tx);
`uvm_component_utils(alu_driver)

virtual alu_if vif;
protected uvm_active_passive_enum is_active = UVM_ACTIVE;

function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info("START_PHASE", $sformatf("Starting build_phase for %s", 
            get_full_name()), UVM_NONE)  
  
  uvm_config_db#(uvm_active_passive_enum)::get(this, "", "is_active", 			               							 is_active);
  
  if (!uvm_config_db#(virtual alu_if)::get(this, "", "vif", vif))
    `uvm_fatal("DRV_IF", $sformatf("Error to get vif for %s", get_full_name)) 

  `uvm_info("END_PHASE", $sformatf("Finishing build_phase for %s", 
            get_full_name()), UVM_NONE)    
endfunction: build_phase
    
  task run_phase(uvm_phase phase);
      super.run_phase(phase)
  `uvm_info("START_PHASE", $sformatf("Starting run_phase for %s", 
            get_full_name()), UVM_NONE)  
  initial_rst();
  if (is_active == UVM_ACTIVE) begin
    forever begin
      alu_tx m_item;
      seq_item_port.get_next_item(m_item);
      drive_active(m_item);
      seq_item_port.item_done();
    end
  end else begin
    forever
        drive_passive();
  end
  
  endtask : run_phase
  
  
  task initial_rst();
    vif.rst <= 1'b1;
    vif.data_ip_1 <= 'b0;
    vif.data_ip_2 <= 'b0;
    vif.sel_ip <= 'b0;
    vif.valid_ip <= 'b0;
    
    repeat (2)
      @(posedge vif.clk);
    vif.rst <= 1'b0;
  endtask : initial_rst
  
  task drive_active(alu_tx m_item);
    @ (posedge vif.clk);
    vif.data_ip_1 <= m_item.data_ip_1;
    vif.data_ip_2 <= m_item.data_ip_2;
    vif.sel_ip	<= m_item.sel_ip;
    vif.valid_ip  <= 1'b1;
    `uvm_info("DRIVER", "ITEM WAS PUT IN THE IF:", UVM_LOW)
    m_item.print();
    
    wait (vif.ready_op == 1'b1);
    
    vif.valid_ip < = 1'b0;
  endtask : drive_active
  
  task drive_passive();
    vif.ready_ip <= 1'b0;
    
    @(negedge vif.clk)
    while(vif.valid_op == 0)
      @(negedge vif.clk);
    
    @(posedge vif.clk);
    vif.ready_ip <= 1'b1;
    
    @(posedge vif.clk);
  endtask : drive_passive
    
  function new(string name = "alu_driver", uvm_component parent);
    super.new(name, parent);
  endfunction : new
endclass : alu_driver