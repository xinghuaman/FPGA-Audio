//-----------------------------------------------------------------------------
// Title       : ???��?��??��?��T???��?��??��?��E???��?��??��?��???��?��??��?��???��?��??��?��h???��?��??��?��???��?��??��?��???��?��??��?��H???��?��??��?��ŏ�???��?��??��?��ʊK???��?��??��?��w???��?��??��?��i???��?��??��?��???��?��??��?��???��?��??��?��u???��?��??��?��Ґ݌v???��?��??��?��Ώہj
// Project     : sound
// Filename    : sound.v
//-----------------------------------------------------------------------------
// Description :
//
//-----------------------------------------------------------------------------
// Revisions   :
// Date        Version  Author        Description
// 201?/??/??  1.00     ???????????   Created
//-----------------------------------------------------------------------------


module sound #
  (
    parameter integer C_M_AXI_THREAD_ID_WIDTH       = 1,
    parameter integer C_M_AXI_ADDR_WIDTH            = 32,
    parameter integer C_M_AXI_DATA_WIDTH            = 32,
    parameter integer C_M_AXI_AWUSER_WIDTH          = 1,
    parameter integer C_M_AXI_ARUSER_WIDTH          = 1,
    parameter integer C_M_AXI_WUSER_WIDTH           = 1,
    parameter integer C_M_AXI_RUSER_WIDTH           = 1,
    parameter integer C_M_AXI_BUSER_WIDTH           = 1,

    /* ???��?��??��?��ȉ�???��?��??��?��͖�???��?��??��?��Ή�???��?��??��?��???��?��??��?��???��?��??��?��???��?��??��?��???��?��??��?��ǃR???��?��??��?��???��?��??��?��???��?��??��?��p???��?��??��?��C???��?��??��?��???��?��??��?��???��?��??��?��G???��?��??��?��???��?��??��?��???��?��??��?��[???��?��??��?��???��?��??��?��???��?��??��?��???��?��??��?��???��?��??��?��̂�???��?��??��?��ߕt???��?��??��?��???��?��??��?��???��?��??��?��???��?��??��?��???��?��??��?��Ă�???��?��??��?��???��?��??��?�� */
    parameter integer C_INTERCONNECT_M_AXI_WRITE_ISSUING = 0,
    parameter integer C_M_AXI_SUPPORTS_READ              = 0,
    parameter integer C_M_AXI_SUPPORTS_WRITE             = 1,
    parameter integer C_M_AXI_TARGET                     = 0,
    parameter integer C_M_AXI_BURST_LEN                  = 0,
    parameter integer C_OFFSET_WIDTH                     = 0
   )
  (
    // System Signals
    input wire        ACLK,
    input wire        ARESETN,

    // Master Interface Write Address
    output wire [C_M_AXI_THREAD_ID_WIDTH-1:0]    M_AXI_AWID,
    output wire [C_M_AXI_ADDR_WIDTH-1:0]         M_AXI_AWADDR,
    output wire [8-1:0]                          M_AXI_AWLEN,
    output wire [3-1:0]                          M_AXI_AWSIZE,
    output wire [2-1:0]                          M_AXI_AWBURST,
    output wire [2-1:0]                          M_AXI_AWLOCK,
    output wire [4-1:0]                          M_AXI_AWCACHE,
    output wire [3-1:0]                          M_AXI_AWPROT,
    // AXI3 output wire [4-1:0]                  M_AXI_AWREGION,
    output wire [4-1:0]                          M_AXI_AWQOS,
    output wire [C_M_AXI_AWUSER_WIDTH-1:0]       M_AXI_AWUSER,
    output wire                                  M_AXI_AWVALID,
    input  wire                                  M_AXI_AWREADY,

    // Master Interface Write Data
    // AXI3 output wire [C_M_AXI_THREAD_ID_WIDTH-1:0]     M_AXI_WID,
    output wire [C_M_AXI_DATA_WIDTH-1:0]         M_AXI_WDATA,
    output wire [C_M_AXI_DATA_WIDTH/8-1:0]       M_AXI_WSTRB,
    output wire                                  M_AXI_WLAST,
    output wire [C_M_AXI_WUSER_WIDTH-1:0]        M_AXI_WUSER,
    output wire                                  M_AXI_WVALID,
    input  wire                                  M_AXI_WREADY,

    // Master Interface Write Response
    input  wire [C_M_AXI_THREAD_ID_WIDTH-1:0]    M_AXI_BID,
    input  wire [2-1:0]                          M_AXI_BRESP,
    input  wire [C_M_AXI_BUSER_WIDTH-1:0]        M_AXI_BUSER,
    input  wire                                  M_AXI_BVALID,
    output wire                                  M_AXI_BREADY,

    // Master Interface Read Address
    output wire [C_M_AXI_THREAD_ID_WIDTH-1:0]    M_AXI_ARID,
    output wire [C_M_AXI_ADDR_WIDTH-1:0]         M_AXI_ARADDR,
    output wire [8-1:0]                          M_AXI_ARLEN,
    output wire [3-1:0]                          M_AXI_ARSIZE,
    output wire [2-1:0]                          M_AXI_ARBURST,
    output wire [2-1:0]                          M_AXI_ARLOCK,
    output wire [4-1:0]                          M_AXI_ARCACHE,
    output wire [3-1:0]                          M_AXI_ARPROT,
    // AXI3 output wire [4-1:0]                  M_AXI_ARREGION,
    output wire [4-1:0]                          M_AXI_ARQOS,
    output wire [C_M_AXI_ARUSER_WIDTH-1:0]       M_AXI_ARUSER,
    output wire                                  M_AXI_ARVALID,
    input  wire                                  M_AXI_ARREADY,

    // Master Interface Read Data
    input  wire [C_M_AXI_THREAD_ID_WIDTH-1:0]    M_AXI_RID,
    input  wire [C_M_AXI_DATA_WIDTH-1:0]         M_AXI_RDATA,
    input  wire [2-1:0]                          M_AXI_RRESP,
    input  wire                                  M_AXI_RLAST,
    input  wire [C_M_AXI_RUSER_WIDTH-1:0]        M_AXI_RUSER,
    input  wire                                  M_AXI_RVALID,
    output wire                                  M_AXI_RREADY,

    /* ???��?��??��?��???��?��??��?��???��?��??��?��???��?��??��?��???��?��??��?��֘A???��?��??��?��M???��?��??��?��???��?��??��?�� */
    input               CLK40,
    output              SND_DOUT_L, SND_DOUT_R,

    output              SND_MCLK,

    /*SPI 追加*/
    input               SCK,
    input               SSEL, MOSI,
    //output              MISO,

    /* ???��?��??��?��???��?��??��?��???��?��??��?��W???��?��??��?��X???��?��??��?��^???��?��??��?��o???��?��??��?��X */
    input   [15:0]      WRADDR,
    input   [3:0]       BYTEEN,
    input               WREN,
    input   [31:0]      WDATA,
    input   [15:0]      RDADDR,
    input               RDEN,
    output  [31:0]      RDATA,

    /* FIFO???��?��??��?��t???��?��??��?��???��?��??��?��???��?��??��?��O???��?��??��?��iLED[4]???��?��??��?��ALED[5]???��?��??��?��ɂ�???��?��??��?��ꂼ???��?��??��?��???��?��??��?��???��?��??��?��ڑ�???��?��??��?��???��?��??��?��???��?��??��?��Ă�???��?��??��?��???��?��??��?��???��?��??��?��j*/
    output              SND_FIFO_UNDER, SND_FIFO_OVER
    );

/* VRAM???��?��??��?��???��?��??��?��???��?��??��?��䕔�???��?��??��?��ARADDR???��?��??��?��???��?��??��?��VRAMCTRL_ARADDR???��?��??��?��???��?��??��?��???��?��??��?��ڑ�???��?��??��?��???��?��??��?��???��?��??��?��邱???��?��??��?��Ƃ� */
/* ???��?��??��?��A???��?��??��?��N???��?��??��?��Z???��?��??��?��X???��?��??��?��͈͂�0x20000000???��?��??��?��`0x3FFFFFFF???��?��??��?��Ɍ�???��?��??��?��肷???��?��??��?��???��?��??��?��      */
// Write Address (AW)
assign M_AXI_AWID    = 'b0;
assign M_AXI_AWADDR  = 0;
assign M_AXI_AWLEN   = 0;
assign M_AXI_AWSIZE  = 0;
assign M_AXI_AWBURST = 2'b01;
assign M_AXI_AWLOCK  = 2'b00;
assign M_AXI_AWCACHE = 4'b0010;
assign M_AXI_AWPROT  = 3'h0;
assign M_AXI_AWQOS   = 4'h0;
assign M_AXI_AWUSER  = 'b0;
assign M_AXI_AWVALID = 0;

// Write Data(W)
assign M_AXI_WDATA  = 0;
assign M_AXI_WSTRB  = 0;
assign M_AXI_WLAST  = 0;
assign M_AXI_WUSER  = 'b0;
assign M_AXI_WVALID = 0;

// Write Response (B)
assign M_AXI_BREADY = 0;

// Read Address (AR)
/* ???��?��??��?��???��?��??��?��???��?��??��?��ȉ�???��?��??��?��???��?��??��?��3???��?��??��?��???��?��??��?��???��?��??��?��???��?��??��?��???��?��??��?��???��?��??��?��??????��?��??��?��???��?��??��?��???��?��??��?��A???��?��??��?��???��?��??��?��???��?��??��?��???��?��??��?��???��?��??��?��???��?��??��?��???��?��??��?��ݒ�???��?��??��?��l???��?��??��?��ɂ�???��?��??��?��Ă�???��?��??��?��???��?��??��?��???��?��??��?��???��?��??��?�� */
assign M_AXI_ARID    = 'b0;
assign M_AXI_ARLEN   = 6'b11111; //BURST length = 32
assign M_AXI_ARSIZE  = 3'b010; //data size = 32 bit = 4 byte
assign M_AXI_ARBURST = 2'b01; //2'b01???��?��??��?��Œ�
assign M_AXI_ARLOCK  = 1'b0;
assign M_AXI_ARCACHE = 4'b0010;
assign M_AXI_ARPROT  = 3'h0;
assign M_AXI_ARQOS   = 4'h0;
assign M_AXI_ARUSER  = 'b0;

wire    [31:0] VRAMCTRL_ARADDR;
assign M_AXI_ARADDR = {3'b001, VRAMCTRL_ARADDR[28:0]};

//??��?��??��?��?ミ�???��?��信号
//assign SND_LRCLK = 1'b0;

wire [1:0] COMMAND;
wire        LOOP;
wire [7:0]  VOLUME;
wire [28:0] DATASIZE, SNDADDR;
//wire SND_MCLK;
wire SND_BCLK;
//wire [15:0] SNDDATA;
//wire FIFORD;
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

wire fil_rst = arst_ff | COMMAND == 2'b11;

reg[1:0] srst_ff;
always @ (posedge SCK) begin
    srst_ff <= {srst_ff[0], ~ARESETN};
end
wire SRST = srst_ff[1];

/* MCLK生�?? */
snd_mclkgen snd_mclkgen (
    .CLK40      (CLK40),
    .SND_MCLK   (SND_MCLK)
);

/*??��?��??��?��?周回路*/
snd_mclkdiv snd_mclkdiv (
    .MCLK(SND_MCLK), //256Fs
    .MRST(MRST),
    .BCLK(SND_BCLK) //128Fs
  );

/*SPI 追加*/
wire [7:0] SPI_GET_DATA;
wire       SPI_DATA_VALID;
wire [3:0] FIL_PARAM_L, FIL_PARAM_R;
wire [7:0] VOLUME_L, VOLUME_R;

/*レジスタ操�??��?��?*/
snd_regctrl snd_regctrl (
  .ACLK(ACLK),
  .ARST(ARST),
  .WRADDR(WRADDR),
  .BYTEEN(BYTEEN),
  .WREN(WREN),
  .WDATA(WDATA),
  .RDADDR(RDADDR),
  .RDEN(RDEN),
  .RDATA(RDATA),
  .COMMAND(COMMAND),
  .LOOP(LOOP),
  //.VOLUME(VOLUME), /*SPI用　書き換え*/
  .DATASIZE(DATASIZE),
  .SNDADDR(SNDADDR),
  /*SPI追加*/
  .SPI_GET_DATA(SPI_GET_DATA),
  .SPI_DATA_VALID(SPI_DATA_VALID),
  .FIL_PARAM_L(FIL_PARAM_L),
  .FIL_PARAM_R(FIL_PARAM_R),
  .VOLUME_R(VOLUME_R),
  .VOLUME_L(VOLUME_L)
  //.TRFIN(TRFIN)
  );


snd_paramctrl snd_paramctrl(
  .ACLK(ACLK),
  .ARST(ARST),
  .SCK(SCK),
  //.SRST(SRST),
  .SSEL(SSEL),
  .MOSI(MOSI),
  //.MISO(MISO),
  .SPI_GET_DATA(SPI_GET_DATA),
  .SPI_RDATA_VALID(SPI_DATA_VALID)
  );


/*VRAM制御*/

snd_vramctrl snd_vramctrl (
  .ACLK(ACLK),
  .ARST(ARST),
  .ARADDR(VRAMCTRL_ARADDR),
  .ARREADY(M_AXI_ARREADY),
  .ARVALID(M_AXI_ARVALID),
  .RLAST(M_AXI_RLAST),
  .RVALID(M_AXI_RVALID),
  .RREADY(M_AXI_RREADY),
  .SNDADDR(SNDADDR),
  .ARLEN(M_AXI_ARLEN),
  .DATASIZE(DATASIZE),
  .BUF_WREADY(srcBUF_WREADY),
  .COMMAND(COMMAND),
  .LOOP(LOOP)
  );

/*FIFO*/
wire [5:0] ip_wait_L, ip_wait_R;
snd_srcbuffer snd_srcbuffer (
  .ACLK(ACLK),
  .ARST(ARST),
  .srcBUF_WR(M_AXI_RVALID),
  .ppBUF_WREADY(ppBUF_WREADY_L),
  .dout_valid(srcBUF_valid),
  .srcBUF_WREADY(srcBUF_WREADY),
  .srcBUF_RREADY(srcBUF_RREADY),
  .doutRch(srcBUF_doutRch),
  .doutLch(srcBUF_doutLch),
  .din(M_AXI_RDATA),
  .COMMAND(COMMAND),
  .ip_wait(ip_wait_L),
  .OVER(SND_FIFO_OVER),
  .UNDER(SND_FIFO_UNDER)
  );

/*ボリュー??��?��??��?��?調整*/
wire [15:0] volume_dout_L;
wire        volume_dout_valid_L;
snd_volume snd_volume_L (
  .ACLK(ACLK),
  .ARST(ARST),
  .VOLUME(VOLUME_L),
  .din(srcBUF_doutLch),
  .dout(volume_dout_L),
  .din_valid(srcBUF_valid),
  .dout_valid(volume_dout_valid_L),
  .COMMAND(COMMAND)
  );

/*FIRフィルタ31次*/
wire [15:0] fir_dout_L;
wire        fir_dout_valid_L;
wire [2:0] fir_wait_L;
fir31 fir31_L(
  .ACLK(ACLK),
  .ARST(fil_rst),
  .din(volume_dout_L),
  .dout(fir_dout_L),
  .din_valid(volume_dout_valid_L),
  .dout_valid(fir_dout_valid_L),
  .fir_wait(fir_wait_L),
  .FIL_PARAM(FIL_PARAM_L)
  );

/*補間フィルタ*/
wire [15:0] ip_dout_L;
wire        ip_dout_valid_L;
interpolate32 interpolate32_L(
  .ACLK(ACLK),
  .ARST(fil_rst),
  //.din(volume_dout_L),
  .din(fir_dout_L),
  .dout(ip_dout_L),
  //.din_valid(volume_dout_valid_L),
  .din_valid(fir_dout_valid_L),
  .dout_valid(ip_dout_valid_L),
  .ip_wait(ip_wait_L)
  );

/*ppf - fir間バ??��?��??��?��?ファ*/
wire       ppBUF_valid_L;
snd_ppbuffer snd_ppbuffer_L (
  .ACLK(ACLK),
  .ARST(ARST),
  .ppBUF_WR(ip_dout_valid_L),
  .pwmBUF_WREADY(pwmBUF_WREADY_L),
  .dout_valid(ppBUF_valid_L),
  .ppBUF_WREADY(ppBUF_WREADY_L),
  .ppBUF_RREADY(ppBUF_RREADY_L),
  .dout(ppBUF_dout_L),
  .din(ip_dout_L),
  .fir_wait(fir_wait_L),
  .COMMAND(COMMAND)
  );

/*ΔΣ変調器*/
wire [3:0] ds_dout_L;
wire        ds_dout_valid_L;
delsig3 delsig2_L(
  .ACLK(ACLK),
  .ARST(fil_rst),
  //.din(fir_dout_L),
  .din(ppBUF_dout_L),
  .dout(ds_dout_L),
  //.din_valid(fir_dout_valid_L),
  .din_valid(ppBUF_valid_L),
  .dout_valid(ds_dout_valid_L)
  );

/*ΔΣ - pwm間バ??��?��??��?��?ファ*/
wire [3:0] pwm_cnt_L;
snd_pwmbuffer snd_pwmbuffer_L(
  .ACLK(ACLK),
  .ARST(ARST),
  .MCLK(SND_MCLK),
  .MRST(MRST),
  .pwmBUF_WR(ds_dout_valid_L),
  .dout_valid(pwmBUF_valid_L),
  .pwmBUF_WREADY(pwmBUF_WREADY_L),
  .dout(pwmBUF_dout_L),
  .din(ds_dout_L),
  .COMMAND(COMMAND),
  .cnt(pwm_cnt_L)
  );

pwmout pwmout_L(
  .MCLK(SND_MCLK), // 4値なので32*4Fs
  .MRST(MRST),
  .din(pwmBUF_dout_L),
  .dout(SND_DOUT_L),
  .cnt(pwm_cnt_L),
  .din_valid(pwmBUF_valid_L)
  //.dout_valid(),
  );

/*ボリュー??��?��??��?��?調整*/
wire [15:0] volume_dout_R;
wire        volume_dout_valid_R;
snd_volume snd_volume_R (
  .ACLK(ACLK),
  .ARST(ARST),
  .VOLUME(VOLUME_R),
  .din(srcBUF_doutRch),
  .dout(volume_dout_R),
  .din_valid(srcBUF_valid),
  .dout_valid(volume_dout_valid_R),
  .COMMAND(COMMAND)
  );
  /*FIRフィルタ31次*/
wire [2:0] fir_wait_R;
wire [15:0] fir_dout_R;
wire        fir_dout_valid_R;
fir31 fir31_R(
  .ACLK(ACLK),
  .ARST(fil_rst),
  .din(volume_dout_R),
  .dout(fir_dout_R),
  .din_valid(volume_dout_valid_R),
  .dout_valid(fir_dout_valid_R),
  .fir_wait(fir_wait_R),
  .FIL_PARAM(FIL_PARAM_R)
  );

/*補間フィルタ*/
wire [15:0] ip_dout_R;
wire        ip_dout_valid_R;
interpolate32 interpolate32_R(
  .ACLK(ACLK),
  .ARST(fil_rst),
  //.din(volume_dout_R),
  .din(fir_dout_R),
  .dout(ip_dout_R),
  //.din_valid(volume_dout_valid_R),
  .din_valid(fir_dout_valid_R),
  .dout_valid(ip_dout_valid_R),
  .ip_wait(ip_wait_R)
  );

/*ppf - fir間バ??��?��??��?��?ファ*/
wire       ppBUF_valid_R;
snd_ppbuffer snd_ppbuffer_R (
  .ACLK(ACLK),
  .ARST(ARST),
  .ppBUF_WR(ip_dout_valid_R),
  .pwmBUF_WREADY(pwmBUF_WREADY_R),
  .dout_valid(ppBUF_valid_R),
  .ppBUF_WREADY(ppBUF_WREADY_R),
  .ppBUF_RREADY(ppBUF_RREADY_R),
  .dout(ppBUF_dout_R),
  .din(ip_dout_R),
  .fir_wait(fir_wait_R),
  .COMMAND(COMMAND)
  );


/*ΔΣ変調器*/
wire [3:0] ds_dout_R;
wire        ds_dout_valid_R;
delsig3 delsig2_R(
  .ACLK(ACLK),
  .ARST(fil_rst),
  //.din(fir_dout_R),
  .din(ppBUF_dout_R),
  .dout(ds_dout_R),
  //.din_valid(fir_dout_valid_R),
  .din_valid(ppBUF_valid_R),
  .dout_valid(ds_dout_valid_R)
  );

/*ΔΣ - pwm間バ??��?��??��?��?ファ*/
wire [3:0] pwm_cnt_R;
snd_pwmbuffer snd_pwmbuffer_R(
  .ACLK(ACLK),
  .ARST(ARST),
  .MCLK(SND_MCLK),
  .MRST(MRST),
  .pwmBUF_WR(ds_dout_valid_R),
  .dout_valid(pwmBUF_valid_R),
  .pwmBUF_WREADY(pwmBUF_WREADY_R),
  .dout(pwmBUF_dout_R),
  .din(ds_dout_R),
  .COMMAND(COMMAND),
  .cnt(pwm_cnt_R)
  );

pwmout pwmout_R(
  .MCLK(SND_MCLK), // 4値なので32*4Fs
  .MRST(MRST),
  .din(pwmBUF_dout_R),
  .dout(SND_DOUT_R),
  .cnt(pwm_cnt_R),
  .din_valid(pwmBUF_valid_R)
  //.dout_valid(),
  );

endmodule
