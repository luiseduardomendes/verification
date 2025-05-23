//  Class: alu_seq
//
class alu_seq extends uvm_sequence;
`uvm_object_utils(alu_seq)

//  Group: Variables
int num_samples = 10;

//  Group: Functions
task body();
  alu_tx m_item;
  repeat(10) begin
    m_item = alu_tx::type_id::create("m_item");
    start_item(m_item);
    assert(m_item.randomize()) else
      `uvm_fatal("SEQ_RAND", $sformatf("Unable to randomize for %s", 
                get_full_name()))
    // m_item.print();
    m_item.print_item();
    finish_item(m_item);
  end
endtask : body

//  Constructor: new
function new(string name = "alu_seq");
  super.new(name);
endfunction: new

endclass: alu_seq