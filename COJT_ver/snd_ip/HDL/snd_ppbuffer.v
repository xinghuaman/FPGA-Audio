module snd_ppbuffer
 (
  /*system signals*/
  input         ACLK,
  input         ARST,

  /*fifo signals*/
  input         ppBUF_WR,
  //input         ppBUF_RD,
  input         pwmBUF_WREADY,
  output        dout_valid,
  output        ppBUF_WREADY,
  output        ppBUF_RREADY,
  output [15:0] dout,
  input  [15:0] din,
  //output        OVER,
  //output        UNDER,
  input  [2:0]  fir_wait,
  input  [1:0]  COMMAND
  );

wire [10:0]  data_count; //FIFOの深さによって要変更
//wire [31:0]  FIFOOUT_tmp;
wire         FIFORST,comdown;
wire EMPTY, FULL;
reg ppBUF_RD;

fifo_16in16out_2048depth fifo_16in16out_2048depth(
  .srst         (FIFORST),
  .clk          (ACLK),
  .din          (din),
  .wr_en        (ppBUF_WR),
  .rd_en        (ppBUF_RD),
  .dout         (dout),
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

reg  [1:0] COM_reg;
always @ ( posedge ACLK ) begin
if(ARST)
  COM_reg <= 2'b0;
else
  COM_reg <= COMMAND;
end

//assign comdown = (~(COM_M[5:4]==2'b11) & COM_M[3:2]==2'b11)?1:0;
assign comdown = (COM_reg == 2'b11)? 1:0;
assign ppBUF_WREADY = (data_count < 11'b1100000000-10'b11)? 1:0;
//assign ppBUF_RREADY = (data_count > 11'b0)? 1:0;
assign FIFORST = (ARST | comdown)? 1:0;

assign ppBUF_RREADY = ~EMPTY;

reg [2:0] rd_wait_cnt;
always @ (posedge ACLK ) begin
  if(ARST)
    ppBUF_RD <= 1'b0;
  //else if(filBUF_WREADY_reg & srcBUF_RREADY & COM_reg == 2'b1)
  else if(rd_wait_cnt == 3'd0 & pwmBUF_WREADY & ppBUF_RREADY & COM_reg == 2'b1)
    ppBUF_RD <= 1'b1;
  else
    ppBUF_RD <= 1'b0;
end

always @ ( posedge ACLK ) begin
  if(ARST)
    rd_wait_cnt <= 3'b0;
  else if(rd_wait_cnt == 3'b0)
    rd_wait_cnt <= 3'b1;
  else if(rd_wait_cnt >= fir_wait)
    rd_wait_cnt <= 3'b0;
  else if(rd_wait_cnt > 3'b0)
    rd_wait_cnt <= rd_wait_cnt + 3'b1;
end

endmodule // snd_buffer
