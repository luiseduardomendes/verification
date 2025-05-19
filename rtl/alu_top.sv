//  Module: alu_top
//
`include "alu_core.sv"
`include "parity_core.sv"
module alu_top
  /*  package imports  */
  #(
    parameter DATA_WIDTH  = 16,
    parameter SEL_WIDTH   = 3
  )(
    input                               clk, rst,
    input                               valid_ip, ready_ip,
    input       [(DATA_WIDTH-1):0]      data_ip_1, data_ip_2,
    input       [(SEL_WIDTH-1):0]       sel_ip,
    input								parity_ip,
    output reg                          valid_op, ready_op,
    output reg  [((DATA_WIDTH*2)-1):0]  data_op,
    output reg							err_op
  );

  reg                       available_r;  // Shows if the output registers are available.
  reg                       valid_int_ip_r;   // Internal valids for ip
  reg [(DATA_WIDTH-1):0 ]   data_ip_1_r, data_ip_2_r;
  reg [(SEL_WIDTH-1):0  ]   sel_ip_r;
  reg						parity_ip_r;

  // ALU connections
  wire  [(DATA_WIDTH-1):0 ]     data_ip_1_w;
  wire  [(DATA_WIDTH-1):0 ]     data_ip_2_w;
  wire  [((DATA_WIDTH*2)-1):0]  data_op_w;
  wire							err_op_w;

  // ALU Instantiation
  alu_core #(
    .DATA_WIDTH (DATA_WIDTH), 
    .SEL_WIDTH (SEL_WIDTH)
    ) alu (
      .data_ip_1  (data_ip_1_r),
      .data_ip_2  (data_ip_2_r),
      .sel_ip     (sel_ip_r),
      .data_op    (data_op_w)
    );
  
  parity_core #(
  	.DATA_WIDTH (DATA_WIDTH), 
    .SEL_WIDTH (SEL_WIDTH)
  ) parity_check (
  	.data_ip_1  (data_ip_1_r),
    .data_ip_2  (data_ip_2_r),
    .sel_ip     (sel_ip_r),
    .parity_ip	(parity_ip_r),
    .err_op		(err_op_w)
  );

  // Input Registers Block
  always @ (posedge clk) begin
    if(valid_ip) begin
      if(available_r) begin // When the output block is available, receive the new data.
        data_ip_1_r     <= data_ip_1;
        data_ip_2_r     <= data_ip_2;
        sel_ip_r        <= sel_ip;
        parity_ip_r     <= parity_ip;
        valid_int_ip_r  <= 1'b1; 
      end
    end else if(~valid_ip || valid_int_ip_r) begin
      valid_int_ip_r     <= 1'b0;
    end
  end

  // Control for the ready_op signal.
  always @ (posedge clk) begin
    if(ready_op) begin
      ready_op <= 1'b0;
    end else if(valid_ip && available_r) begin
      ready_op <= 1'b1;
    end
  end

  // Output Registers block
  always @ (posedge clk) begin
    if(rst) begin
      // Reset the output flags and internal signals.
      available_r <= 1'b1;
      valid_op    <= 1'b0;
      ready_op    <= 1'b0;
    end else begin
      if(~available_r) begin
        // When there's something valid in the output block
        if(ready_ip) begin  // Wait for the ready from external components to switch back available to '1' and valid to '0'.
          // When the external components already received the data, go back to reset.
          available_r         <= 1'b1;
          valid_op            <= 1'b0;
        end
      end else if(available_r) begin
        // When the output is available
        if(valid_int_ip_r) begin
          // When the output block is available and the input block is valid
          data_op     <= data_op_w;   // Set the output from the ALU into data_op register.
          err_op	  <= err_op_w;	  // Set the error flag if parity did not match
          valid_op    <= 1'b1;        // Set the output flag for valid to '1' as the output data is now valid.
          available_r <= 1'b0;        // Set the internal available flag for the output block to '0' as output is now 
                                      // occupied.
        end
      end
    end
  end
  
endmodule: alu_top