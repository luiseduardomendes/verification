//  Class: alu_env
//
class alu_env extends uvm_env;
`uvm_component_utils(alu_env)

//  Group: Components
alu_agent m_agt;

//  Group: Variables

//  Group: Functions
function void build_phase(uvm_phase phase);
  super.build_phase(phase);
  `uvm_info("START_PHASE", $sformatf("Starting build_phase for %s", 
            get_full_name()), UVM_NONE)  
  m_agt = alu_agent::type_id::create("m_agt", this);

  `uvm_info("END_PHASE", $sformatf("Finishing build_phase for %s", 
            get_full_name()), UVM_NONE)        
endfunction: build_phase

//  Constructor: new
function new(string name = "alu_env", uvm_component parent);
  super.new(name, parent);
endfunction: new


endclass: alu_env



