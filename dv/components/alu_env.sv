class alu_env extends uvm_env;
  `uvm_component_utils(alu_env)

  // Agent instances
  alu_agent m_agt_inputs;   // Active agent (drives inputs)
  alu_agent m_agt_outputs;  // Passive agent (monitors outputs)

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info("START_PHASE", $sformatf("Starting build_phase for %s", 
            get_full_name()), UVM_NONE)
    
    // Create and configure input agent (ACTIVE)
    m_agt_inputs = alu_agent::type_id::create("m_agt_inputs", this);
    uvm_config_db#(uvm_active_passive_enum)::set(this, "m_agt_inputs", "is_active", UVM_ACTIVE);
    
    // Create and configure output agent (PASSIVE)
    m_agt_outputs = alu_agent::type_id::create("m_agt_outputs", this);
    uvm_config_db#(uvm_active_passive_enum)::set(this, "m_agt_outputs", "is_active", UVM_PASSIVE);

    `uvm_info("END_PHASE", $sformatf("Finishing build_phase for %s", 
            get_full_name()), UVM_NONE)
  endfunction: build_phase

    // is this really needed?
  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info(get_type_name(), "Connecting ALU environment", UVM_MEDIUM)
    // No connections needed between agents in basic implementation
  endfunction: connect_phase

  function new(string name = "alu_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction: new
endclass: alu_env