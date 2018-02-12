module snd_pwmbuffer
 (
   /*system signals*/
   input         ACLK,
   input         ARST,
   input         MCLK,
   input         MRST,

   /*fifo signals*/
   input         pwmBUF_WR,
   //input         pwm_RD,
   output        dout_valid,
   output        pwmBUF_WREADY,
   //output        pwmBUF_RREADY,
   output [3:0] dout,
   input  [3:0] din,
   input  [1:0]  COMMAND,
   output [3:0] cnt
  );

wire [10:0]     rd_data_count; //FIFOの深さによって要変更
wire [10:0]     wr_data_count;
//wire [31:0]     FIFOOUT_tmp;
wire            FIFORST,comdown;
reg             pwmBUF_RD;
wire            OVER, UNDER, FULL, EMPTY;
reg  [3:0]      pwmCNT;


fifo_4in4out_2048depth fifo_4in4out_2048depth(
  .rst          (FIFORST), //***
  .wr_clk       (ACLK),
  .rd_clk       (MCLK),
  .din          (din),
  .wr_en        (pwmBUF_WR),
  .rd_en        (pwmBUF_RD),
  .dout         (dout),
  .full         (FULL),
  .overflow     (OVER),
  .empty        (EMPTY),
  .valid        (dout_valid),
  .underflow    (UNDER),
  .wr_data_count(wr_data_count),
  .rd_data_count(rd_data_count)
);

//COMMAND同期��?
reg  [1:0] COM_reg;
always @ ( posedge ACLK ) begin
if(ARST)
  COM_reg <= 2'b0;
else
  COM_reg <= COMMAND;
end

assign comdown = (COM_reg == 2'b11)? 1:0;
assign pwmBUF_WREADY = (wr_data_count < 10'd1500)? 1:0;
assign pwmBUF_RREADY = (rd_data_count > 10'd0)? 1:0;
assign FIFORST = (ARST | comdown)? 1:0;

reg [3:0] COM_M;
always @ ( posedge MCLK ) begin
    if(MRST)
      COM_M <= 4'b0;
    else
      COM_M <= {COM_M[1:0],COMMAND};
end

always @ (posedge MCLK ) begin
  if(MRST)
    pwmBUF_RD <= 1'b0;
  //if(~CNT_BCLK[4] & pre_BCLK[5] & BUF_RREADY & COMMAND[1:0]==2'b1)
  else if(pwmCNT== 4'd9 & pwmBUF_RREADY & COM_M[3:2] == 2'b1)
    pwmBUF_RD <= 1'b1;
  else
    pwmBUF_RD <= 1'b0;
end

always @ (posedge MCLK) begin
  if(MRST)
    pwmCNT <= 4'b0;
  else if(pwmCNT == 4'd11)
    pwmCNT <= 4'b0;
  else
    pwmCNT <= pwmCNT +4'b1;
end
assign cnt = pwmCNT;

endmodule // snd_buffer
