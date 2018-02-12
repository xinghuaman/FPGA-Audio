/*
  1次ΔΣ変調器 MASH2段接??��?��??��?��?
  input 符号??��?��??��?��?16bit 32倍補間
*/
module delsig3(
  input        ACLK,
  input        ARST,
  input [15:0] din,
  output [3:0] dout,
  input        din_valid,
  output       dout_valid
  );

  reg signed [23:0] dinz1;
  reg signed [23:0] sig1, sig2a, sig2b;
  //reg signed [23:0] sig1z1, siga2z1, sig2bz1;
  reg signed [23:0] sx1, sx2, sx1z1, sx2z1;
  reg signed [4:0] sx1o, sx2o, sx1z1o, sx2z1o;

  reg signed [4:0]  out;
  wire signed [23:0] din24;
  reg [3:0] din_valid_reg;
  //wire signed [2:0] sx1out, sx2out, sx2z1out, sx1z1out;

  assign din24 = $signed({{8{din[15]}}, din[15:0]});
  assign dout = out[3:0];

  //!
  always @(posedge ACLK) begin
    if(ARST)
      out <= 5'h0;
    else if(din_valid_reg[2])
      out <= $signed(5'd5) + sx1z1o + sx2o - sx2z1o;
    //out <= sx2out;
  end

  always @(posedge ACLK) begin
    if(ARST)
      sx1z1 <= 24'h0;
    else if(din_valid_reg[1])
      sx1z1 <= sx1;
  end

  always @(posedge ACLK) begin
    if(ARST)
      sx2z1 <= 24'h0;
    else if(din_valid_reg[1])
      sx2z1 <= sx2;
  end

  always @(posedge ACLK) begin
    if(ARST)
      sig1 <= 24'h0;
    else if(din_valid_reg[0])
      sig1 <= sig1 + dinz1 -sx1;
      //sig1 <= sig1z1 + dinz1 + $signed(~sx1z1 + 24'h1);
  end

  always @(posedge ACLK) begin
    if(ARST)
      sig2a <= 24'h0;
    else if(din_valid_reg[0])
      sig2a <= sig2a + sig1 - sx1 - sx2;
      //sig2 <= sig2z1 + sig1z1 + $signed(~sx1z1 + 24'h1) + $signed(~sc2z1+24'h1);
  end

  always @(posedge ACLK) begin
    if(ARST)
      sig2b <= 24'h0;
    else if(din_valid_reg[0])
      sig2b <= sig2b + sig2a  - {sx2[23],sx2[21:0],1'b0};
      //sig2 <= sig2z1 + sig1z1 + $signed(~sx1z1 + 24'h1) + $signed(~sc2z1+24'h1);
  end

  always @(posedge ACLK) begin
    if(ARST)
      dinz1 <= 24'h0;
    else if(din_valid_reg[0])
      dinz1 <= din24;
  end

  always @(posedge ACLK) begin
    if(ARST)
      sx1 <= 24'h0;
    else if(sig1 >= $signed(24'h008000) &  din_valid_reg[1])
      sx1 <= 24'h008000; //if sig1=> 0 : sx1 = 2^15
    else if(sig1 >= $signed(24'h005555) & din_valid_reg[1])
      sx1 <= 24'h005555;
    else if(sig1 >= $signed(24'h002AAB) & din_valid_reg[1])
      sx1 <= 24'h002AAB;
    else if(sig1 >= $signed(24'h0) & din_valid_reg[1])
      sx1 <= 24'h0;
    else if(sig1 >= $signed(24'hFFD555) &  din_valid_reg[1])
      sx1 <= 24'hFFD555; //if sig1=> 0 : sx1 = 2^15
    else if(sig1 >= $signed(24'hFFAAAB) & din_valid_reg[1])
      sx1 <= 24'hFFAAAB;
    else if(din_valid_reg[1])
      sx1 <= 24'hFF8000;
  end

  always @(posedge ACLK) begin
    if(ARST)
      sx2 <= 24'h0;
    else if(sig2b >= $signed(24'h008000)  & din_valid_reg[1])
      sx2 <= 24'h008000;
    else if(sig2b >= $signed(24'hFF8000) & din_valid_reg[1])
      sx2 <= 24'h000000;
    else if(din_valid_reg[1])
      sx2 <= 24'hFF8000;
  end

  always @(posedge ACLK) begin
    if(ARST)
      sx1o <= 5'h0;
    else if(sig1 >= $signed(24'h008000) &  din_valid_reg[1])
      sx1o <= 5'h03; //if sig1=> 0 : sx1 = 2^15
    else if(sig1 >= $signed(24'h005555) & din_valid_reg[1])
      sx1o <= 5'h02;
    else if(sig1 >= $signed(24'h002AAB) & din_valid_reg[1])
      sx1o <= 5'h01;
    else if(sig1 >= $signed(24'h0) & din_valid_reg[1])
      sx1o <= 5'h0;
    else if(sig1 >= $signed(24'hFFD555) &  din_valid_reg[1])
      sx1o <= 5'h1F; //if sig1=> 0 : sx1 = 2^15
    else if(sig1 >= $signed(24'hFFAAAB) & din_valid_reg[1])
      sx1o <= 5'h1E;
    else if(din_valid_reg[1])
      sx1o <= 5'h1D;
  end

  always @(posedge ACLK) begin
    if(ARST)
      sx2o <= 5'h0;
    else if(sig2b >= $signed(24'h008000)  & din_valid_reg[1])
      sx2o <= 5'h01;
    else if(sig2b >= $signed(24'hFF8000) & din_valid_reg[1])
      sx2o <= 5'h0;
    else if(din_valid_reg[1])
      sx2o <= 5'h1F;
  end

  always @ ( posedge ACLK ) begin
    if(ARST)
      sx1z1o <= 5'b0;
    else if(din_valid_reg[1])
      sx1z1o <= sx1o;
  end

  always @ ( posedge ACLK ) begin
    if(ARST)
      sx2z1o <= 5'b0;
    else if(din_valid_reg[1])
      sx2z1o = sx2o;
  end

  always @ ( posedge ACLK ) begin
    if(ARST)
      din_valid_reg <= 4'b0;
    else
      din_valid_reg <= {din_valid_reg[2:0], din_valid};
  end

  assign dout_valid = din_valid_reg[3];

endmodule
