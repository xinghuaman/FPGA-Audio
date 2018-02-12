//-----------------------------------------------------------------------------
// Title       : VRAM制御回路
// Project     : display
// Filename    : disp_vramctrl.v
//-----------------------------------------------------------------------------
// Description :
//
//-----------------------------------------------------------------------------
// Revisions   :
// Date        Version  Author        Description
// 201?/??/??  1.00     ???????????   Created
//-----------------------------------------------------------------------------

module snd_vramctrl
  (
    // System Signals
    input           ACLK,
    input           ARST,

    // Read Address
    output  [31:0]  ARADDR,
    output          ARVALID,
    input           ARREADY,
    // Read Data
    input           RLAST,
    input           RVALID,
    output          RREADY,

    /* 解像度設定信号 */
    input   [28:0]   DATASIZE,

    /* 他ブロック信号 */
    input   [7:0]   ARLEN,
    input   [28:0]  SNDADDR,
    input           BUF_WREADY,
    input   [1:0]   COMMAND,
    input           LOOP
);
reg [1:0] state;
parameter S_IDLE = 2'b0, S_SETADDR = 2'b1, S_READ = 2'b10, S_WAIT = 2'b11;
parameter S_NON=2'b00, S_PLAY=2'b1, S_PAUSE = 2'b10, S_STOP=2'b11;
reg [22:0] TRANSACTION;
wire READEND, FCOUNT;
reg [31:0] NEXTADDR;
reg [22:0] transcount;
wire [6:0] bitshift;
reg        LOOPSIG;

assign PLAY = (COMMAND == 2'b1)? 1:0;
assign PAUSE = (COMMAND == 2'b10)? 1:0;
assign STOP = (COMMAND == 2'b11)? 1:0;
/*
reg [1:0] combuf;
always @(posedge ACLK) begin
  if(ARST)
    combuf <= 2'b00;
  else
    combuf <= COMMAND;
end
*/
//VRAM読み出しのための状態

always@(posedge ACLK) begin
  if(ARST) begin
    state <= S_IDLE;
  end
  else
    case(state)
      S_IDLE    :
                  if(LOOPSIG & PLAY)
                    state <= S_SETADDR;
                  else
                    state <= S_IDLE;
      S_SETADDR :
                  if(STOP)
                    state <= S_IDLE;
                  else if(ARVALID & ARREADY)
                    state <= S_READ;
                  else
                    state <= S_SETADDR;
      S_READ    :
                  if(STOP)
                    state <= S_IDLE;
                  else if (READEND & ~BUF_WREADY & FCOUNT)
                    state <= S_WAIT;
                  else if(READEND & FCOUNT)
                    state <= S_SETADDR;
                  else if(READEND)
                    state <= S_IDLE;
                  else
                    state <= S_READ;
      S_WAIT    :
                  if(STOP)
                    state <= S_IDLE;
                  else if(BUF_WREADY)
                    state <= S_SETADDR;
                  else
                    state <= S_WAIT;
    endcase
end

always @ ( posedge ACLK ) begin
  if(ARST)
    LOOPSIG <= 1'b1;
  else if (READEND & ~FCOUNT  & ~LOOP)
    LOOPSIG <= 1'b0;
  else if(LOOP | STOP)
    LOOPSIG <= 1'b1;
  else
    LOOPSIG <= LOOPSIG;
end


always @ ( posedge ACLK ) begin
  if(ARST  ||transcount == transcount-1)
  //if(ARST)
    transcount <= 23'b0;
  //else if(state == S_SETADDR)
  else if(ARREADY & ARVALID)
    transcount <= transcount+1;
  else if(state == S_IDLE)
    transcount <= 23'b0;
  else
    transcount <= transcount;
end

//output信号
assign ARADDR = NEXTADDR;
assign ARVALID = (state ==S_SETADDR) ? 1'b1 : 1'b0;
assign RREADY = ((state == S_READ) & RVALID)? 1'b1:1'b0;

//新規で定義
assign READEND = RLAST & RREADY & RVALID;
//assign FCOUNT = (NEXTADDR[28:8] < TRANSACTION-1) ?1:0;
assign FCOUNT = (transcount < TRANSACTION) ?1:0;

always@(posedge ACLK) begin
  if(ARST)
    NEXTADDR <= (3'b010 <<28)+SNDADDR;
  else if(state == S_IDLE)
    NEXTADDR <= (3'b010 << 28)+SNDADDR;
  else if(state == S_READ & READEND & FCOUNT)
    NEXTADDR <= NEXTADDR + 8'b10000000;
  else
    NEXTADDR <= NEXTADDR;
end

/*解像度信号ごとに全トランザクション数設定*/
assign bitshift = 7'h2 + 7'h5;
always@(*) begin
  TRANSACTION <= (DATASIZE >> bitshift);
end

endmodule
