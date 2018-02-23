module snd_mclkdiv
  (
    //system signals
    input MCLK,
    input MRST,
    output BCLK
    );

reg [8:0] clkcnt;
reg BCLK_tmp;
//reg LRCLK_tmp, invBCLK_tmp;
//wire invBCLK;

assign BCLK = BCLK_tmp;
//assign LRCLK = LRCLK_tmp;
//assign invBCLK = invBCLK_tmp;

always@(posedge MCLK) begin
  if(MRST)
    clkcnt <= 9'b0;
  else
    clkcnt <= clkcnt +9'b1;
end

always@(posedge MCLK) begin
  if(MRST)
    BCLK_tmp <= 1'b0;
  else if(clkcnt[0])
    BCLK_tmp <= 1'b1;
  else
    BCLK_tmp <= 1'b0;
end

endmodule
