module pwmout(
  input MCLK,
  input MRST,
  input [3:0] din,
  input din_valid,
  input [3:0] cnt,
  output dout
  );
//reg [2:0] cnt;
reg signed [3:0]din_reg;
reg dout_reg;

assign dout = dout_reg;

always @ ( posedge MCLK ) begin
  if(MRST)
    din_reg <= 4'd0;
  else if(din_valid)
    //din_reg <= $signed({din[3], din}) + $signed(5'd7);
    din_reg = din;
end

always @ (posedge MCLK) begin
  if(MRST)
    dout_reg <= 1'b0;
  else if(cnt < din_reg)
    dout_reg <= 1'b1;
  else
    dout_reg <= 1'b0;
end
/*
always @ (posedge MCLK) begin
  if(MRST)
    cnt <= 3'b0;
  else
    cnt <= cnt + 3'b1;
end
*/
endmodule
