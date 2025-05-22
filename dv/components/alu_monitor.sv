class alu_monitor extends uvm_monitor;
  `uvm_component_utils(alu_monitor)

  protected uvm_active_passive_enum is_active = UVM_ACTIVE;
  virtual alu_if vif;
  uvm_analysis_port #(alu_tx) mon_analysis_port;
  
  function new(string name = "alu_monitor", uvm_component parent);
    super.new(name, parent);
  endfunction : new
 
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("START_PHASE", $sformatf("Starting build_phase for %s", 
              get_full_name()), UVM_NONE)  
    
    // Get configuration
    if (!uvm_config_db#(uvm_active_passive_enum)::get(this, "", "is_active", is_active)) begin
      `uvm_warning("CFG_DB", "Using default monitor mode (ACTIVE)")
    end
    
    if (!uvm_config_db#(virtual alu_if)::get(this, "", "vif", vif))
      `uvm_fatal("MON_IF", $sformatf("Error to get vif for %s", get_full_name())) 
      
    mon_analysis_port = new("mon_analysis_port", this);
    `uvm_info("END_PHASE", $sformatf("Finishing build_phase for %s", 
              get_full_name()), UVM_NONE)
  endfunction : build_phase

  task run_phase(uvm_phase phase);
    super.run_phase(phase);
    if (is_active == UVM_ACTIVE)
    active_monitor();
    else
      passive_monitor();
  endtask : run_phase
    
  task active_monitor();
    alu_tx item;
    
    forever begin
      @(negedge vif.clk);
      if (vif.valid_ip == 1'b1 && vif.ready_op == 1'b1) begin
        item = alu_tx::type_id::create("item");
        // Capture input signals
        item.data_ip_1 = vif.data_ip_1;
        item.data_ip_2 = vif.data_ip_2;
        item.sel_ip   = sel_t'(vif.sel_ip);  // Proper enum casting
        item.parity_ip = vif.parity_ip;
        
        `uvm_info("ACTIVE_MON", $sformatf("Captured input transaction:\n%s", item.get_item_str()),
                  UVM_HIGH)
        mon_analysis_port.write(item);
      end
    end
  endtask : active_monitor
  
  task passive_monitor();
    alu_tx item;
    forever begin
      @(negedge vif.clk);
      if (vif.valid_op == 1'b1 && vif.ready_ip == 1'b1) begin
        item = alu_tx::type_id::create("item");
        // Capture output signals
        item.data_op   = vif.data_op;
        item.parity_ip = vif.parity_ip;
        item.err_op    = vif.err_op;
        
        `uvm_info("PASSIVE_MON", $sformatf("Captured output transaction:\n%s", 
                  item.get_item_str()), UVM_HIGH)
        mon_analysis_port.write(item);
      end
    end
  endtask : passive_monitor
endclass : alu_monitor
