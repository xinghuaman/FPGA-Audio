module i2s_tx
 (
   //system signals
   input        MCLK,
   input        MRST,

   input        BCLK,
   input        LRCLK,
   input [15:0] DIN,

   output       DOUT
   );

wire [4:0]  bitshift;
//wire [15:0] DOUT_tmp;
wire        BCLK_DE, BCLK_PE;
reg         DOUT_tmp;
reg pre_BCLK;
reg [4:0] CNT_BCLK;
//reg [4:0]   CNT_BCLK_tmp;
wire [15:0] outbit;
//assign CNT_BCLK = CNT_BCLK_tmp;
assign DOUT = DOUT_tmp;
//出力するビット数を決定
assign bitshift = (CNT_BCLK < 5'd17)? (5'd16 - CNT_BCLK) : 5'd0;
assign outbit = 16'b0 + DIN >> bitshift;

//BCLK立下り判定用

always @ ( posedge MCLK ) begin
  if(MRST)
    pre_BCLK <= 1'b0;
  else
    pre_BCLK <= BCLK;
end

assign BCLK_DE = pre_BCLK & ~BCLK;
assign BCLK_PE = ~pre_BCLK & BCLK;


//出力データの設定
always@(posedge MCLK) begin
  if(MRST)
    DOUT_tmp <= 16'b0;
  else if(CNT_BCLK == 5'd0 )
    DOUT_tmp <= 16'b0;
  else if(CNT_BCLK < 5'd17 )
    DOUT_tmp <= outbit[0];
  else if(CNT_BCLK >= 5'd17)
    DOUT_tmp <= 16'b0;
end


always @ ( posedge MCLK ) begin
  if(MRST)
    CNT_BCLK <= 5'b0;
  else if(BCLK_PE)
    CNT_BCLK <= CNT_BCLK +5'b1;
end


endmodule
