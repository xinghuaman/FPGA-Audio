module snd_srcbuffer
 (
  /*system signals*/
  input         ACLK,
  input         ARST,

  /*fifo signals*/
  input         srcBUF_WR,
  //input         srcBUF_RD,
  input         ppBUF_WREADY,
  output        srcBUF_WREADY,
  output        srcBUF_RREADY,
  output [15:0] doutRch,
  output [15:0] doutLch,
  output        dout_valid,
  input  [31:0] din,
  output        OVER,
  output        UNDER,

  input  [1:0]  COMMAND,
  input  [5:0]  ip_wait
  //input         ip_wait
  );

wire [10:0]  data_count;
wire [31:0]  srcBUF_OUT;
wire         FIFORST,comdown, FULL, EMPTY;
reg          srcBUF_RD;
fifo_32in32out_2048depth fifo_32in32out_2048depth(
  .clk          (ACLK),
  .srst         (FIFORST),
  .din          (din),
  .wr_en        (srcBUF_WR),
  .rd_en        (srcBUF_RD),
  .dout         (srcBUF_OUT),
  .full         (FULL),
  .overflow     (OVER),
  .empty        (EMPTY),
  .valid        (dout_valid),
  .underflow    (UNDER),
  .data_count(data_count)
);

//assign doutRch = doutRch_reg;
//assign doutLch = doutLch_reg;

/*
reg  [15:0] doutRch;
always @ ( posedge ACLK ) begin
if(ARST)
  doutRch_reg <= 15'b0;
else
  doutRch_reg <= srcBUF_OUT[15:0];
end

reg  [15:0] doutLch;
always @ ( posedge ACLK ) begin
if(ARST)
  doutLch_reg <= 15'b0;
else
  doutLch_reg <= srcBUF_OUT[31:16];
end
*/
assign doutRch = srcBUF_OUT[15:0];
assign doutLch = srcBUF_OUT[31:16];

reg  [1:0] COM_reg;
always @ ( posedge ACLK ) begin
if(ARST)
  COM_reg <= 2'b0;
else
  COM_reg <= COMMAND;
end

//assign comdown = (~(COM_M[5:4]==2'b11) & COM_M[3:2]==2'b11)?1:0;
assign comdown = (COM_reg == 2'b11)? 1:0;
assign srcBUF_WREADY = (data_count < 10'b1100000000-10'b11)? 1:0;
//assign srcBUF_RREADY = (data_count > 10'b0)? 1:0;
assign srcBUF_RREADY =  ~EMPTY;
assign FIFORST = (ARST | comdown)? 1:0;
//assign srcBUF_RD_wait = (rd_wait_cnt == 6'b0)? 1'b0 : 1'b1;

reg [5:0] rd_wait_cnt;
always @ ( posedge ACLK ) begin
  if(ARST)
    rd_wait_cnt <= 6'b0;
  else if(rd_wait_cnt == 6'b0)
    rd_wait_cnt <= 6'b1;
  else if(rd_wait_cnt >= ip_wait)
    rd_wait_cnt <= 6'b0;
  else if(rd_wait_cnt > 6'b0)
    rd_wait_cnt <= rd_wait_cnt + 6'b1;
end

always @ (posedge ACLK ) begin
  if(ARST)
    srcBUF_RD <= 1'b0;
  //else if(filBUF_WREADY_reg & srcBUF_RREADY & COM_reg == 2'b1)
  else if(rd_wait_cnt == 6'd0 & ppBUF_WREADY & srcBUF_RREADY & COM_reg == 2'b1)
    srcBUF_RD <= 1'b1;
  else
    srcBUF_RD <= 1'b0;
end

endmodule
