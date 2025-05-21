typedef enum bit [(`SEL_WIDTH -1):0] {
  ALU_ADD 	= 'b000,
  ALU_SUB 	= 'b001,
  ALU_MULT 	= 'b010,
  ALU_LSH 	= 'b011,
  ALU_RSH 	= 'b100,
  ALU_INCR 	= 'b101,
  ALU_DECR 	= 'b110
} sel_t;

class alu_tx extends uvm_sequence_item;
  
  // Variables
  rand bit [`DATA_WIDTH - 1: 0]	data_ip_1;
  rand bit [`DATA_WIDTH - 1: 0]	data_ip_2;
  bit [`DATA_WIDTH*2 - 1: 0]	data_op;
  sel_t sel_ip;
  
  `uvm_object_utils_begin(alu_tx)
  	`uvm_field_int (data_ip_1, 	UVM_DEFAULT|UVM_DEC)
  	`uvm_field_int (data_ip_2, 	UVM_DEFAULT|UVM_DEC)
  	`uvm_field_int (data_op, 	UVM_DEFAULT|UVM_DEC)
  	`uvm_field_enum(sel_t, sel_ip,  	UVM_DEFAULT)
  `uvm_object_utils_end
  
  // Constraints
  constraint c_sub {
    if (sel_ip == ALU_SUB){
    	data_ip_2 <= data_ip_1;
    }
  }
  constraint c_shift {
    if (sel_ip == ALU_RSH || sel_ip == ALU_LSH) {
    	data_ip_2 <= `DATA_WIDTH;
    }
  }
  constraint c_incr {
    if (sel_ip == ALU_INCR || sel_ip == ALU_DECR) {
      data_ip_2 inside {0, 1};
    }
  }

  function void print_2;
    `uvm_info("PRINT_ITEM", $sformatf("%p", this), UVM_LOW)
  endfunction : print_2

      
  function new (string name = "alu_tx");
     super.new(name);
   endfunction : new

  
  
endclass : alu_tx
