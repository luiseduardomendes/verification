class alu_simple_seq extends uvm_sequence;
  `uvm_object_utils(alu_simple_seq)
  
  // Group: Variables
  int num_samples = 10;
  
  // Group: Functions
  task body();
    alu_tx m_item;
    repeat(num_samples) begin
      m_item = alu_tx::type_id::create("m_item");
      start_item(m_item);
      assert(m_item.randomize()) else
        `uvm_fatal("SEQ_RAND", $sformatf("Unable to randomize for %s", 
                  get_full_name()))
      m_item.print_item();
      finish_item(m_item);
    end
  endtask : body
  
  function new(string name = "alu_simple_seq");
    super.new(name);
  endfunction: new
endclass: alu_simple_seq


class alu_err_seq extends uvm_sequence;
  `uvm_object_utils(alu_err_seq)
  
  // Group: Variables
  int num_samples = 10;
  
  // Group: Functions
  task body();
    alu_tx m_item;
    repeat(num_samples) begin
      m_item = alu_tx::type_id::create("m_item");
      start_item(m_item);
      
      // Inline constraint to force incorrect parity
      assert(m_item.randomize() with {
        parity_ip != ^{data_ip_1, data_ip_2, sel_ip};
      }) else
        `uvm_fatal("SEQ_RAND", $sformatf("Unable to randomize with incorrect parity for %s", 
                  get_full_name()))
      
      m_item.print_item();
      finish_item(m_item);
    end
  endtask : body
  
  function new(string name = "alu_err_seq");
    super.new(name);
  endfunction: new
endclass: alu_err_seq