class alu_monitor extends uvm_monitor;
  `uvm_component_utils(alu_monitor)

  virtual alu_if vif;
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;
  lass alu_monitor extends uvm_monitor;
  `uvm_component_utils(alu_monitor)

  virtual alu_if vif;
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  uvm_analysis_port #(alu_tx) mon_analysis_port;
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("START_PHASE", $sformatf("Starting build_phase for %s", 
              get_full_name()), UVM_NONE)  
	
    uvm_config_db#(uvm_active_passive_enum)::get(this, "", "is_active", 			               							 is_active);
    
    if (!uvm_config_db#(virtual alu_if)::get(this, "", "vif", vif))
      `uvm_fatal("MON_IF", $sformatf("Error to get vif for %s", get_full_name)) 
      
      mon_analysis_port = new("mon_analysis_po
  uvm_analysis_port #(alu_tx) mon_analysis_port;
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("START_PHASE", $sformatf("Starting build_phase for %s", 
              get_full_name()), UVM_NONE)  
	
    uvm_config_db#(uvm_active_passive_enum)::get(this, "", "is_active", 			               							 is_active);
    
    if (!uvm_config_db#(virtual alu_if)::get(this, "", "vif", vif))
      `uvm_fatal("MON_IF", $sformatf("Error to get vif for %s", get_full_name)) 
      
      mon_analysis_port = new("mon_analysis_port", this);

    `uvm_info("END_PHASE", $sformatf("Finishing build_phase for %s", 
              get_full_name()), UVM_NONE)    
  endfunction: build_phase
      
   task run_phase(uvm_phase phase);
    super.run_phase(phase);
    if (is_active == UVM_ACTIVE)
      active_mon();
    else
      passive_mon();
   endtask : run_phase
    
    
    task active_mon();
      alu_tx item;
      
      forever begin
        @(negedge vif.clk);
        if (vif.valid_ip == 1'b1 && vif.ready_op == 1'b1) begin
          item = new();
          item.data_ip_1 = vif.data_ip_1;
          item.data_ip_2 = vif.data_ip_2;
          $cast(item.sel_ip, vif.sel_ip);
          `uvm_info("ACTIVE MON", "ITEM WAS CAPTURED:", UVM_LOW)
     	   item.print();
          mon_analysis_port.write(item);
        end
      end
    endtask : active_mon
  
  task passive_mon();
    alu_tx item;
    forever begin
    	 @(negedge vif.clk);
      if (vif.valid_op == 1'b1 && vif.ready_ip == 1'b1) begin
          item = new();
          item.data_op = vif.data_op;
        `uvm_info("PASSIVE MON", "ITEM WAS CAPTURED:", UVM_LOW)
     	   item.print();
          mon_analysis_port.write(item);
        end
    end
  endtask : passive_mon
  
  function new(string name = "alu_monitor", uvm_component parent);
      super.new(name, parent);
  endfunction : new
  
endclass : alu_monitor