class alu_test extends uvm_test;
  `uvm_component_utils(alu_test)

  // Group: Components
  alu_env m_env;
  // alu_scbd m_scbd;

  // Group: Variables
  virtual alu_if vif;

  // Group: Functions
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    `uvm_info(get_type_name(), "Building test components", UVM_MEDIUM)

    m_env = alu_env::type_id::create("m_env", this);

    if (!uvm_config_db#(virtual alu_if)::get(this, "", "vif", vif)) begin
      `uvm_fatal("NO_VIF", "Virtual interface not found!")
    end

    uvm_config_db#(virtual alu_if)::set(this, "m_env.m_agt_inputs*", "vif", vif);
    uvm_config_db#(virtual alu_if)::set(this, "m_env.m_agt_outputs*", "vif", vif);
  endfunction: build_phase

  task run_phase(uvm_phase phase);
    alu_simple_seq simple_seq;
    alu_err_seq err_seq;
    
    `uvm_info(get_type_name(), "Starting test run", UVM_MEDIUM)
    
    phase.raise_objection(this);
    
    // Run simple sequence (normal operations)
    simple_seq = alu_simple_seq::type_id::create("simple_seq");
    `uvm_info("TEST", "Running simple sequence", UVM_MEDIUM)
    simple_seq.start(m_env.m_agt_inputs.m_seqr);
    
    // Run error sequence (with parity errors)
    err_seq = alu_err_seq::type_id::create("err_seq");
    `uvm_info("TEST", "Running error sequence", UVM_MEDIUM)
    err_seq.start(m_env.m_agt_inputs.m_seqr);
    
    phase.drop_objection(this);
    `uvm_info(get_type_name(), "Test complete", UVM_MEDIUM)
  endtask: run_phase

  function new(string name = "alu_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction: new
endclass: alu_test
