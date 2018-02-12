//-----------------------------------------------------------------------------
// Title       : レジスタ制御??��?��受講�??設計対象??��?
// Project     : display
// Filename    : disp_regctrl.v
//-----------------------------------------------------------------------------
// Description :
//
//-----------------------------------------------------------------------------
// Revisions   :
// Date        Version  Author        Description
// 201?/??/??  1.00     ???????????   Created
//-----------------------------------------------------------------------------

module snd_regctrl
  (
    // System Signals
    input               ACLK,
    input               ARST,

    /*SPI用追?��?��?*/
    input       [7:0]   SPI_GET_DATA,
    //input       [3:0]   SPI_PARAM_ID,
    input               SPI_DATA_VALID,
    output      [7:0]   VOLUME_L,
    output      [7:0]   VOLUME_R,
    output      [3:0]   FIL_PARAM_L,
    output      [3:0]   FIL_PARAM_R,


    /* レジスタバス */
    input       [15:0]  WRADDR,
    input       [3:0]   BYTEEN,
    input               WREN,
    input       [31:0]  WDATA,
    input       [15:0]  RDADDR,
    input               RDEN,
    output      [31:0]  RDATA,

    /* レジスタ出?��?��? */
    output      [1:0]   COMMAND,
    output              LOOP,

    /* 割り込み、FIFOフラグ */
    //output      [7:0]   VOLUME, /*SPI用書き換?��?��?*/
    output      [28:0]  DATASIZE,
    output      [28:0]  SNDADDR

    );

/* 以下�??��記述は消去して?��?��?から作り直?��?��? */
reg [28:0] SNDADDR_tmp;
reg [31:0] RDATA_tmp;
reg [28:0] DATASIZE_tmp;
/*SPI用書き換?��?��?*/
//reg [7:0]  VOLUME_tmp;
reg [15:0] VOLUME_tmp;
reg        LOOP_tmp;
reg [1:0]  COMMAND_tmp;
reg [31:0] SNDSTAT_tmp;
/*SPI追?��?��?*/
//reg [15:0] SPI_VOLUME;
reg [15:0] SPI_FIL_PARAM;
reg [28:0] SNDADDR_select;

// 出力信号の固?��?��?
assign SNDADDR = SNDADDR_tmp; /***/
assign RDATA    = RDATA_tmp;
assign DATASIZE = DATASIZE_tmp;
assign LOOP = LOOP_tmp;
assign COMMAND = COMMAND_tmp;
//assign VOLUME = VOLUME_tmp; /*SPI?��?��?��?��?��?��?��?��*/
/*SPI追?��?��?*/
assign VOLUME_L = VOLUME_tmp[15:8];
assign VOLUME_R = VOLUME_tmp[7:0];
assign FIL_PARAM_L = SPI_FIL_PARAM[3:0];
assign FIL_PARAM_R = SPI_FIL_PARAM[3:0];
//assign FIL_PARAM_R = SPI_FIL_PARAM[3:0];

wire    write_reg  = WREN && WRADDR[15:12]==4'h3;
wire    read_reg   = RDEN && RDADDR[15:12]==4'h3;
wire    addrreg_wr = (write_reg && WRADDR[11:2]==10'h000);
wire    sndsize_wr = (write_reg && WRADDR[11:2]==10'h001 && BYTEEN[0]);
wire    sndvol_wr  = (write_reg && WRADDR[11:2]==10'h002 && BYTEEN[0]);
wire    sndctrl_wr = (write_reg && WRADDR[11:2]==10'h003 && BYTEEN[0]);
wire    sndstat_wr = (write_reg && WRADDR[11:2]==10'h004 && BYTEEN[0]);
/*SPI 追?��?��?*/
wire    sndequ_wr  = (write_reg && WRADDR[11:2]==10'h005 && BYTEEN[0]);
wire    addrreg1_wr = (write_reg && WRADDR[11:2]==10'h006);
/*
wire    addrreg1_wr = (write_reg && WRADDR[11:2]==10'h007);
wire    addrreg2_wr = (write_reg && WRADDR[11:2]==10'h008);
wire    addrreg3_wr = (write_reg && WRADDR[11:2]==10'h009);
wire    addrreg4_wr = (write_reg && WRADDR[11:2]==10'h00A);
*/
wire [7:0]   addr0 = BYTEEN[0] && addrreg_wr? WDATA[7:0] : SNDADDR_tmp[7:0];
wire [7:0]   addr1 = BYTEEN[1] && addrreg_wr? WDATA[15:8] : SNDADDR_tmp[15:8];
wire [7:0]   addr2 = BYTEEN[2] && addrreg_wr? WDATA[23:16] : SNDADDR_tmp[23:16];
wire [4:0]   addr3 = BYTEEN[3] && addrreg_wr? WDATA[28:24] : SNDADDR_tmp[28:24];

/*
wire [7:0]   addr10 = BYTEEN[0] && addrreg1_wr? WDATA[7:0] : SNDADDR1_tmp[7:0];
wire [7:0]   addr11 = BYTEEN[1] && addrreg1_wr? WDATA[15:8] : SNDADDR1_tmp[15:8];
wire [7:0]   addr12 = BYTEEN[2] && addrreg1_wr? WDATA[23:16] : SNDADDR1_tmp[23:16];
wire [4:0]   addr13 = BYTEEN[3] && addrreg1_wr? WDATA[28:24] : SNDADDR1_tmp[28:24];

wire [7:0]   addr20 = BYTEEN[0] && addrreg2_wr? WDATA[7:0] : SNDADDR2_tmp[7:0];
wire [7:0]   addr21 = BYTEEN[1] && addrreg2_wr? WDATA[15:8] : SNDADDR2_tmp[15:8];
wire [7:0]   addr22 = BYTEEN[2] && addrreg2_wr? WDATA[23:16] : SNDADDR2_tmp[23:16];
wire [4:0]   addr23 = BYTEEN[3] && addrreg2_wr? WDATA[28:24] : SNDADDR2_tmp[28:24];

wire [7:0]   addr30 = BYTEEN[0] && addrreg3_wr? WDATA[7:0] : SNDADDR3_tmp[7:0];
wire [7:0]   addr31 = BYTEEN[1] && addrreg3_wr? WDATA[15:8] : SNDADDR3_tmp[15:8];
wire [7:0]   addr32 = BYTEEN[2] && addrreg3_wr? WDATA[23:16] : SNDADDR3_tmp[23:16];
wire [4:0]   addr33 = BYTEEN[3] && addrreg3_wr? WDATA[28:24] : SNDADDR3_tmp[28:24];

wire [7:0]   addr40 = BYTEEN[0] && addrreg4_wr? WDATA[7:0] : SNDADDR4_tmp[7:0];
wire [7:0]   addr41 = BYTEEN[1] && addrreg4_wr? WDATA[15:8] : SNDADDR4_tmp[15:8];
wire [7:0]   addr42 = BYTEEN[2] && addrreg4_wr? WDATA[23:16] : SNDADDR4_tmp[23:16];
wire [4:0]   addr43 = BYTEEN[3] && addrreg4_wr? WDATA[28:24] : SNDADDR4_tmp[28:24];


//SNDADDR_tmp
always@( posedge ACLK) begin
  if(ARST)
      SNDADDR1_tmp <= 29'b0;
  else if(addrreg_wr1) begin//BYTEEN?��?��?慮する
      SNDADDR1_tmp <= {addr13, addr12,addr11,addr10};
  end
end

always@( posedge ACLK) begin
  if(ARST)
      SNDADDR2_tmp <= 29'b0;
  else if(addrreg_wr2) begin//BYTEEN?��?��?慮する
      SNDADDR2_tmp <= {addr23, addr22,addr21,addr20};
  else if
  end
end

always@( posedge ACLK) begin
  if(ARST)
      SNDADDR3_tmp <= 29'b0;
  else if(addrreg_wr3) begin//BYTEEN?��?��?慮する
      SNDADDR3_tmp <= {addr33, addr32,addr31,addr30};
  end
end

always@( posedge ACLK) begin
  if(ARST)
      SNDADDR4_tmp <= 29'b0;
  else if(addrreg_wr4) begin//BYTEEN?��?��?慮する
      SNDADDR4_tmp <= {addr43, addr42,addr41,addr40};
  end
end
*/
reg[1:0] SNDADDR_CNT;

always @ ( posedge ACLK ) begin
  if(ARST)
    SNDADDR_CNT <= 2'b0;
  else if (SPI_DATA_VALID & SPI_GET_DATA[7:5] == 3'b001) begin
    SNDADDR_CNT <= SNDADDR_CNT + SPI_GET_DATA[1:0];
  end
end

always@( posedge ACLK) begin
  if(ARST)
      SNDADDR_tmp <= 29'b0;
  else if(addrreg_wr)  //BYTEEN?��?��?慮する
      SNDADDR_tmp <= {addr3, addr2,addr1,addr0};
  /*
  else if(SNDADDR_CNT == 2'b0)
      SNDADDR_tmp <= SNDADDR1_tmp;
  else if(SNDADDR_CNT == 2'b1)
      SNDADDR_tmp <= SNDADDR2_tmp;
  else if(SNDADDR_CNT == 2'b10)
      SNDADDR_tmp <= SNDADDR3_tmp;
  else if(SNDADDR_CNT == 2'b11)
      SNDADDR_tmp <= SNDADDR4_tmp;
  */
end

/*SNDSIZE*/
always @(posedge ACLK) begin
if(ARST)
    DATASIZE_tmp <= 29'b0;
else if(sndsize_wr)
    DATASIZE_tmp <= WDATA[29:0];
end

/*SNDVOL*/
/*SPI_VOLUMEを追?��?��?*/
always @(posedge ACLK) begin
  if(ARST)
    VOLUME_tmp <= 16'b0;
  else if(sndvol_wr)
    VOLUME_tmp <= {WDATA[7:0], WDATA[7:0]};
  else if(SPI_DATA_VALID & SPI_GET_DATA[7:6] == 2'b10)
    VOLUME_tmp <= {VOLUME_tmp[15:8], SPI_GET_DATA[5:0], 2'b0};
  else if(SPI_DATA_VALID & SPI_GET_DATA[7:6] == 2'b11)
    VOLUME_tmp <= {SPI_GET_DATA[5:0] , 2'b0, VOLUME_tmp[7:0]};
end

/*SNDCTRL*/
//LOOP
always@(posedge ACLK) begin
    if(ARST)
      LOOP_tmp <= 1'b0;
    else if(sndctrl_wr)
      LOOP_tmp <= WDATA[2];
end

//COMMAND

always @(posedge ACLK) begin
if(ARST)
    COMMAND_tmp <= 2'b0;
else if(sndctrl_wr)
    COMMAND_tmp <= WDATA[1:0];
else if(SPI_DATA_VALID & SPI_GET_DATA[7:5] == 3'b011)
    COMMAND_tmp <= SPI_GET_DATA[1:0];
end

//SNDSTAT (現時点で意味な?��?��?)
always @(posedge ACLK) begin
if(ARST)
    SNDSTAT_tmp <= 32'b0;
else if(sndstat_wr)
    SNDSTAT_tmp <= {24'b0, WDATA[7:0]};
else if(SPI_DATA_VALID)begin
    //SNDSTAT_tmp <= {24'b0,SPI_GET_DATA};
    SNDSTAT_tmp <= SPI_GET_DATA_reg;
end
end

reg[31:0] SPI_GET_DATA_reg;
always @ ( posedge ACLK ) begin
  if(ARST)
    SPI_GET_DATA_reg <= 32'b0;
  else if(SPI_DATA_VALID)
    SPI_GET_DATA_reg <= {SPI_GET_DATA_reg[23:0] , SPI_GET_DATA};
end

/*SPI用?��?��?追?��?��?*/
/*
always @ ( posedge ACLK ) begin
  if(ARST)
    SPI_FIL_PARAM <= 16'b0;
  else if(SPI_DATA_VALID & SPI_GET_DATA[7:5] == 4'd0)
    SPI_FIL_PARAM <= {SPI_FIL_PARAM[15:4], SPI_GET_DATA[3:0]};
  else if(SPI_DATA_VALID & SPI_GET_DATA[7:5] == 4'd1)
    SPI_FIL_PARAM <= {SPI_FIL_PARAM[15:8], SPI_GET_DATA[3:0], SPI_FIL_PARAM[3:0]};
//  else if(SPI_DATA_VALID & SPI_GET_DATA[7:5] == 4'd2)
//    SPI_FIL_PARAM <= {SPI_FIL_PARAM[15:12], SPI_GET_DATA[3:0], SPI_FIL_PARAM[7:0]};
//  else if(SPI_DATA_VALID & SPI_GET_DATA[7:5] == 4'd3)
//    SPI_FIL_PARAM <= {SPI_GET_DATA[3:0], SPI_FIL_PARAM[11:0]};
end
*/
always @ ( posedge ACLK ) begin
  if(ARST)
    SPI_FIL_PARAM <= 16'b0;
  else if(SPI_DATA_VALID & SPI_GET_DATA[7:5] == 3'b010)
    SPI_FIL_PARAM <= {SPI_FIL_PARAM[15:4], SPI_GET_DATA[3:0]};
end



/*読み出し部*/
//読み出しデータ
always @ ( posedge ACLK )begin
  if(ARST)
    RDATA_tmp <= 32'b0;
  else if(RDADDR[11:2] ==10'b000 & read_reg)
    RDATA_tmp <= {3'b0,  SNDADDR_tmp};
  else if(RDADDR[11:2] == 10'h001 & read_reg)
    RDATA_tmp <= {3'b0, DATASIZE_tmp};
  else if(RDADDR[11:2] == 10'h002 & read_reg) //SPI用書き換?��?��?
    RDATA_tmp <= {16'b0, VOLUME_tmp};
    //RDATA_tmp <= {24'b0, VOLUME_tmp};
  else if(RDADDR[11:2] == 10'h003 & read_reg)
    RDATA_tmp <= {29'b0, LOOP_tmp, COMMAND_tmp};
  else if(RDADDR[11:2] == 10'h004 & read_reg)
    RDATA_tmp <= {SNDSTAT_tmp};
  /*SPI 追?��?��?*/
  else if(RDADDR[11:2] == 10'h005 & read_reg)
    RDATA_tmp <= {16'b0, SPI_FIL_PARAM};
  else if(RDADDR[11:2] == 10'h006 & read_reg)
    RDATA_tmp <= {30'b0, SNDADDR_CNT};
end

endmodule
