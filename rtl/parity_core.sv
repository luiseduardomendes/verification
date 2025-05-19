//  Module: parity_core
//
module parity_core
  #(
    parameter DATA_WIDTH  = 16,
    parameter SEL_WIDTH   = 3
  )(
    input       [(DATA_WIDTH-1):0 ]     data_ip_1,
    input       [(DATA_WIDTH-1):0 ]     data_ip_2,
    input       [(SEL_WIDTH-1):0  ]     sel_ip,
    input								parity_ip,
    output wire   						err_op
  );

  assign err_op = (parity_ip == ^{data_ip_1, data_ip_2, sel_ip}) ? 'b0 : 'b1;
endmodule: parity_core