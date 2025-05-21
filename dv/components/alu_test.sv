//  Class: alu_test
//
class alu_test extends uvm_test;
`uvm_component_utils(alu_test)

//  Group: Components
alu_env   m_env;
// alu_scbd  m_scbd;

//  Group: Variables
virtual alu_if vif;

//  Group: Functions
function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info("START_PHASE", $sformatf("Starting build_phase for %s", 
            get_full_name()), UVM_NONE)  

  m_env = alu_env::type_id::create("m_env", this);

  assert(uvm_config_db#(virtual alu_if)::get(this, "", "vif", vif)) 
  else
    `uvm_fatal("TEST_IF", $sformatf("Unable to get vif for %s", get_full_name()))

  uvm_config_db#(virtual alu_if)::set(this, "m_env.m_agt.*", "vif", vif);

  `uvm_info("END_PHASE", $sformatf("Finishing build_phase for %s", 
            get_full_name()), UVM_NONE)    
endfunction: build_phase

function void connect_phase(uvm_phase phase);
  super.connect_phase(phase);
  `uvm_info("START_PHASE", $sformatf("Starting connect_phase for %s", 
            get_full_name()), UVM_NONE)

  // m_env.m_agt.m_mon.mon_analysis_port.connect(m_scbd.m_analysis_imp);

  `uvm_info("END_PHASE", $sformatf("Finishing connect_phase for %s", 
            get_full_name()), UVM_NONE)
endfunction: connect_phase

task run_phase(uvm_phase phase);
  alu_seq seq = alu_seq::type_id::create("seq");
  `uvm_info("START_PHASE", $sformatf("Starting run_phase for %s", 
            get_full_name()), UVM_NONE)

  phase.raise_objection(this);
  `uvm_info(get_name(), "<run_phase> started, objection raised.", UVM_NONE)

  assert(seq.randomize()) else
    `uvm_fatal("TEST_SEQ", $sformatf("Unable to randomize seq for %s", get_full_name()))
  seq.start(m_env.m_agt.m_seqr);

  phase.drop_objection(this);
  `uvm_info(get_name(), "<run_phase> finished, objection dropped.", UVM_NONE)

  `uvm_info("END_PHASE", $sformatf("Finishing run_phase for %s", 
            get_full_name()), UVM_NONE)
endtask: run_phase

//  Constructor: new
function new(string name = "alu_test", uvm_component parent);
  super.new(name, parent);
endfunction: new


endclass: alu_test




