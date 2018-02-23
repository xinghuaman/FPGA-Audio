module ppbuffer
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
  input  [2:0]  ds_wait
  );

wire [10:0]  data_count; //FIFOの深さによって要変更
wire         FIFORST;
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

assign ppBUF_WREADY = (data_count < 11'b1100000000-10'b11)? 1:0;
//assign ppBUF_RREADY = (data_count > 11'b0)? 1:0;
assign FIFORST = ARST? 1:0;

assign ppBUF_RREADY = ~EMPTY;

reg [2:0] rd_wait_cnt;
always @ (posedge ACLK ) begin
  if(ARST)
    ppBUF_RD <= 1'b0;
  else if(rd_wait_cnt == 3'd0 & pwmBUF_WREADY & ppBUF_RREADY)
    ppBUF_RD <= 1'b1;
  else
    ppBUF_RD <= 1'b0;
end

always @ ( posedge ACLK ) begin
  if(ARST)
    rd_wait_cnt <= 3'b0;
  else if(rd_wait_cnt == 3'b0)
    rd_wait_cnt <= 3'b1;
  else if(rd_wait_cnt >= ds_wait)
    rd_wait_cnt <= 3'b0;
  else if(rd_wait_cnt > 3'b0)
    rd_wait_cnt <= rd_wait_cnt + 3'b1;
end

endmodule
