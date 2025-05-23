class alu_agent extends uvm_agent;
  `uvm_component_utils(alu_agent)
  
  alu_sequencer m_seqr;
  alu_driver    m_drv;
  alu_monitor   m_mon;
  
  protected uvm_active_passive_enum is_active = UVM_ACTIVE;
  
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("START_PHASE", $sformatf("Starting build_phase for %s", get_full_name()), UVM_NONE)  
    
    uvm_config_db#(uvm_active_passive_enum)::get(this, "", "is_active", is_active);
    
    // Always create monitor (needed in both modes)
    m_mon = alu_monitor::type_id::create("m_mon", this);
    
    // Only create sequencer and driver in ACTIVE mode
    if (is_active == UVM_ACTIVE) begin
      m_seqr = alu_sequencer::type_id::create("m_seqr", this);
      m_drv = alu_driver::type_id::create("m_drv", this);
    end
    
    // Pass the mode to subcomponents
    uvm_config_db#(uvm_active_passive_enum)::set(this, "m_drv", "is_active", is_active);
    uvm_config_db#(uvm_active_passive_enum)::set(this, "m_mon", "is_active", is_active);
  endfunction: build_phase
                                        
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    
    if (is_active == UVM_ACTIVE) begin
      // Connect driver to sequencer only in ACTIVE mode
      m_drv.seq_item_port.connect(m_seqr.seq_item_export);
      `uvm_info("AGENT_CONNECT", "Connected driver to sequencer", UVM_DEBUG)
    end
  endfunction: connect_phase
                                        
  function new(string name = "alu_agent", uvm_component parent);
    super.new(name, parent);
  endfunction: new
      
endclass: alu_agent