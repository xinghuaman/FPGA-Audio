module snd_paramctrl(
  input ACLK,
  input ARST,
  input SCK,
  //input SRST,
  input SSEL,
  input MOSI,
  //output MISO,
  output [7:0] SPI_GET_DATA,
  output SPI_RDATA_VALID
  );

/*SCK系*/
reg [3:0] bitcnt;
reg [5:0] A_SCK, A_SSEL, A_MOSI;
reg [7:0] SPI_RDATA_tmp;

always @(posedge ACLK) begin
  if(ARST | A_SSEL[5])
    bitcnt <= 4'b0;
  else if(bitcnt == 4'd8)
    bitcnt <= 4'b0;
  else if(~A_SSEL[4] &  ~A_SCK[5] & A_SCK[4])
    bitcnt <= bitcnt + 4'b1;
end

always @(posedge ACLK) begin
  if(ARST)
    A_SCK <= 6'b0;
  else
    A_SCK <= {A_SCK[4:0], SCK};
end

always @ ( posedge ACLK ) begin
  if(ARST)
    A_SSEL <= 6'b0;
  else
    A_SSEL <= {A_SSEL[4:0], SSEL};
end

always @(posedge ACLK) begin
  if(ARST)
    A_MOSI <= 6'b0;
  else
    A_MOSI <= {A_MOSI[4:0], MOSI};
end

always @ ( posedge ACLK ) begin
  if(ARST | A_SSEL[4])
     SPI_RDATA_tmp <= 8'b0;
  else if(~A_SSEL[4] & ~A_SCK[5] & A_SCK[4])
     SPI_RDATA_tmp <= {SPI_RDATA_tmp[6:0], A_MOSI[4]};
end

assign SPI_RDATA_VALID = (bitcnt == 4'd8)? 1'b1: 1'b0;
assign SPI_GET_DATA = SPI_RDATA_tmp;
endmodule
