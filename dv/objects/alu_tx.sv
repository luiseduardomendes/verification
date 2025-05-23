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
  rand bit [  `DATA_WIDTH - 1: 0]	data_ip_1;
  rand bit [  `DATA_WIDTH - 1: 0]	data_ip_2;
  rand bit [                0: 0]	parity_ip;
  bit      [`DATA_WIDTH*2 - 1: 0]	data_op;
  bit					err_op;
  rand sel_t                           sel_ip;
  
  `uvm_object_utils_begin(alu_tx)
  	`uvm_field_int (data_ip_1, 	UVM_DEFAULT|UVM_DEC)
  	`uvm_field_int (data_ip_2, 	UVM_DEFAULT|UVM_DEC)
  	`uvm_field_int (data_op, 	  UVM_DEFAULT|UVM_DEC)
	`uvm_field_int (err_op,		UVM_DEFAULT|UVM_DEC)
        `uvm_field_int (parity_ip, 	UVM_DEFAULT|UVM_DEC)
  	`uvm_field_enum(sel_t, sel_ip,  	UVM_DEFAULT)
  `uvm_object_utils_end
  
  // Constraints
  // Constraint 1
  constraint c_sub {
    if (sel_ip == ALU_SUB){
    	data_ip_2 <= data_ip_1;
    }
  }
  // Constraint 2
  constraint c_shift {
    if (sel_ip == ALU_RSH || sel_ip == ALU_LSH) {
    	data_ip_2 <= `DATA_WIDTH;
    }
  }
  // Constraint 3
  constraint c_incr {
    if (sel_ip == ALU_INCR || sel_ip == ALU_DECR) {
      data_ip_2 inside {0, 1};
    }
  }

  // Constraint 4
  constraint c_add_higher_freq {
    sel_ip dist {
      ALU_ADD 	:= 3,
      ALU_SUB 	:= 1,
      ALU_MULT 	:= 1,
      ALU_LSH 	:= 1,
      ALU_RSH 	:= 1,
      ALU_INCR 	:= 1,
      ALU_DECR 	:= 1
    };
  }

  // Constraint 5
  constraint c_mult {
    if (sel_ip == ALU_MULT) {
      data_ip_2 <= 63;
    }
  }

  function void print_item;
    `uvm_info("PRINT_ITEM", $sformatf("%p", this), UVM_LOW)
  endfunction : print_item

  function string get_item_str;
    return $sformatf("%p", this);
  endfunction : get_item_str
      
  function new (string name = "alu_tx");
     super.new(name);
   endfunction : new

  
  
endclass : alu_tx
