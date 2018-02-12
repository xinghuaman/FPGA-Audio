module snd_volume
  (
    //system signals
    input                ACLK,
    input                ARST,
    input         [7:0]  VOLUME,
    //
    input         [15:0] din,
    output        [15:0] dout,
    output               dout_valid,
    input                din_valid,
    input         [1:0]  COMMAND

    );
//��?部信号定義
reg  [15:0] dout_tmp2;
//wire [15:0] din_tmp;
reg [15:0] din_tmp;
wire [24:0] VOLpala;
reg  [8:0] VOLUME_reg;
reg  [2:0]  COMMAND_reg;

always @ ( posedge ACLK ) begin
if(ARST)
  VOLUME_reg <= 9'b0;
else if(VOLUME >8'b0)
  VOLUME_reg <= VOLUME + 9'b1;
else
  VOLUME_reg <= 9'b0;
end

always @ ( posedge ACLK ) begin
if(ARST)
  COMMAND_reg <= 2'b0;
else
  COMMAND_reg <= COMMAND;
end
 
reg [2:0] dout_valid_reg;
always @ ( posedge ACLK ) begin
  if(ARST)
    dout_valid_reg <= 3'b0;
  else
    dout_valid_reg <= {dout_valid_reg[1], dout_valid_reg[0], din_valid};
end
assign dout_valid = dout_valid_reg[2];

//assign din_tmp = din[15]? (~din+16'b1) : din;
always @ ( posedge ACLK ) begin
  if(ARST)
    din_tmp <= 16'b0;
  else if(din_valid & din[15])
    din_tmp <= ~din+16'b1;
  else if(din_valid & ~din[15])
    din_tmp <= din;
end

assign VOLpala = VOLUME_reg * din_tmp;

reg [24:0] dout_tmp1;
always @ ( posedge ACLK ) begin
  if(ARST)
    dout_tmp1 <= 25'b0;
  else if(dout_valid_reg[0])
    dout_tmp1 <= VOLpala;
end

wire [15:0] VOLpala2, VOLpala2_inv;
assign VOLpala2 = dout_tmp1[23:8];
assign VOLpala2_inv = ~dout_tmp1[23:8] + 16'b1;

always @ ( posedge ACLK ) begin
  if(ARST)
    dout_tmp2 <= 15'b0;
  else if(VOLUME_reg == 8'b0)
    dout_tmp2 <= 16'b0;
  else if(COMMAND_reg==2'b01 & ~din[15] & dout_valid_reg[1])
    dout_tmp2 <= VOLpala2;
  else if(COMMAND_reg==2'b01 &  din[15] & dout_valid_reg[1])
    dout_tmp2 <= VOLpala2_inv;
  else
    dout_tmp2 <= 16'b0;
end

assign dout = dout_tmp2;

endmodule
