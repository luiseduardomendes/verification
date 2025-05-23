interface alu_if #(
	parameter DATA_WIDTH 	= 8,
  	parameter SEL_WIDTH 	= 3
)(
	input clk
);
  // Reset
  logic 						rst;
  
  // Input Interface
  logic 						valid_ip;
  logic [SEL_WIDTH-1:0] 		sel_ip;
  logic [DATA_WIDTH-1:0]		data_ip_1;
  logic [DATA_WIDTH-1:0]		data_ip_2;
  logic 						parity_ip;
  logic 						ready_op;
  
  // Output Interface
  logic 						valid_op;
  logic [(DATA_WIDTH*2)-1:0]	data_op;
  logic 						ready_ip;
  logic 						err_op;
  
endinterface : alu_if
