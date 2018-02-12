module spdif_rx(
    input           ACLK,
    input           ARST,
    input           din,
    output [23:0]   dout_rch,
    output [23:0]   dout_lch,
    output          dout_valid_l,
    output          dout_valid_r
);

reg [5:0] A_din;
always @(posedge ACLK) begin
  if(ARST)
    A_din <= 6'b0;
  else if()
    
end

endmodule