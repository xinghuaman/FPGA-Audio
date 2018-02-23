//-----------------------------------------------------------------------------
// Title       : Degital to Analog Converter
// Filename    : dsdac.v
//-----------------------------------------------------------------------------
// Description : 
//
//-----------------------------------------------------------------------------
// Revisions   :
// Date        Version  Author        Description
// 2017/02/22  1.00     s9upepper     Created
//-----------------------------------------------------------------------------


module dsdac 
  (
    // System Signals
    input wire        ACLK,
    input wire        ARESETN,

    /*i2s入力*/
    input             I2S_MCLK,
    input             I2S_BCLK,
    input             I2S_LRCLK,
    input             I2S_DIN,
   
    input               CLK40,
   
    output            DAC_DOUT_L
  );

wire [7:0]  VOLUME;

wire srcBUF_RREADY, srcBUF_WREADY, srcBUF_valid;
wire signed [15:0] srcBUF_doutLch, srcBUF_doutRch;

wire ppBUF_WREADY_L,ppBUF_RREADY_L;
wire signed [15:0]  ppBUF_dout_L;

wire pwmBUF_WREADY_L, pwmBUF_valid_L;
wire [3:0] pwmBUF_dout_L;

wire ppBUF_WREADY_R,ppBUF_RREADY_R;
wire signed [15:0]  ppBUF_dout_R;

wire pwmBUF_WREADY_R, pwmBUF_valid_R;
wire [3:0] pwmBUF_dout_R;

reg [1:0] arst_ff;
always @ (posedge ACLK) begin
    arst_ff <= {arst_ff[0], ~ARESETN};
end
wire ARST = arst_ff[1];

reg[1:0] mrst_ff;
always @ (posedge SND_MCLK) begin
    mrst_ff <= {mrst_ff[0], ~ARESETN};
end
wire MRST = mrst_ff[1];

/* MCLK生�?? */
snd_mclkgen snd_mclkgen (
    .CLK40      (CLK40),
    .SND_MCLK   (SND_MCLK)
);

wire [63:0] i2s_dout;
wire [31:0] i2s_dout_L, i2s_dout_R;
wire        i2s_dout_valid;

i2s_rx i2s_rx(
  .ACLK(ACLK),
  .ARST(ARST),
  .MCLK(I2S_MCLK),
  .BCLK(I2S_BCLK),
  .LRCLK(I2S_LRCLK),
  .DIN(I2S_DIN),
  //.DOUT(i2s_dout),
  .DOUT_L(i2s_dout_L),
  .DOUT_R(i2s_dout_R),
  .DOUT_VALID(i2s_dout_valid)
);

/*補間フィルタ*/
wire [15:0] ip_dout_L;
wire        ip_dout_valid_L;
interpolate32 interpolate32_L(
  .ACLK(ACLK),
  .ARST(ARST),
  .din(i2s_dout_L[31:16]),
  .dout(ip_dout_L),
  .din_valid(i2s_dout_valid),
  .dout_valid(ip_dout_valid_L)
  //.ip_wait(ip_wait_L)
  );

/*ボリューム調整*/
/*
wire [15:0] volume_dout_L;
wire        volume_dout_valid_L;
volume volume_L (
  .ACLK(ACLK),
  .ARST(ARST),
  .VOLUME(VOLUME_L),
  .din(ip_dout_L),
  .dout(volume_dout_L),
  .din_valid(ip_dout_valid_L),
  .dout_valid(volume_dout_valid_L)
  );
*/

/*補間フィルタ-変調器間バッファ*/
wire       ppBUF_valid_L;
wire [2:0] ds_wait_L;
assign ds_wait_L = 3'd5;
ppbuffer ppbuffer_L (
  .ACLK(ACLK),
  .ARST(ARST),
  .ppBUF_WR(ip_dout_valid_L),
  .pwmBUF_WREADY(pwmBUF_WREADY_L),
  .dout_valid(ppBUF_valid_L),
  .ppBUF_WREADY(ppBUF_WREADY_L),
  .ppBUF_RREADY(ppBUF_RREADY_L),
  .dout(ppBUF_dout_L),
  .din(ip_dout_L),
  .ds_wait(ds_wait_L)
);

/*ΔΣ変調器*/
wire [3:0] ds_dout_L;
wire        ds_dout_valid_L;
delsig3 delsig3_L(
  .ACLK(ACLK),
  .ARST(ARST),
  .din(ppBUF_dout_L),
  .dout(ds_dout_L),
  .din_valid(ppBUF_valid_L),
  .dout_valid(ds_dout_valid_L)
  );

/*ΔΣ - pwm間バ??��?��??��?��?ファ*/
wire [3:0] pwm_cnt_L;
pwmbuffer pwmbuffer_L(
  .ACLK(ACLK),
  .ARST(ARST),
  .MCLK(SND_MCLK),
  .MRST(MRST),
  .pwmBUF_WR(ds_dout_valid_L),
  .dout_valid(pwmBUF_valid_L),
  .pwmBUF_WREADY(pwmBUF_WREADY_L),
  .dout(pwmBUF_dout_L),
  .din(ds_dout_L),
  .cnt(pwm_cnt_L)
  );

pwmout pwmout_L(
  .MCLK(SND_MCLK), // 4値なので32*4Fs
  .MRST(MRST),
  .din(pwmBUF_dout_L),
  .dout(DAC_DOUT_L),
  .cnt(pwm_cnt_L),
  .din_valid(pwmBUF_valid_L)
  //.dout_valid(),
  );

endmodule
