module i2s_rx(
    /*System signal*/
    input         ACLK,
    input         ARST,
    /*Input I2S*/
    input         MCLK,
    input         BCLK,
    input         LRCLK,
    input         DIN,
    /*Output PCM*/
    //output [63:0] DOUT,
    output [31:0] DOUT_L,
    output [31:0] DOUT_R,
    output        DOUT_VALID  
);

reg [3:0] A_MCLK, A_BCLK, A_LRCLK, A_DIN;

/*ACLKで同期化*/
always@(posedge ACLK) begin
    if(ARST)
        A_MCLK <= 4'b0;
    else 
        A_MCLK <= {A_MCLK[2:0], MCLK};
end

always@(posedge ACLK) begin
    if(ARST)
        A_BCLK <= 4'b0;
    else 
        A_BCLK <= {A_BCLK[2:0], BCLK};
end

always@(posedge ACLK) begin
    if(ARST)
        A_LRCLK <= 4'b0;
    else 
        A_LRCLK <= {A_LRCLK[2:0], LRCLK};
end

always@(posedge ACLK) begin
    if(ARST)
        A_DIN <= 4'b0;
    else 
        A_DIN <= {A_DIN[2:0], DIN};
end

/**/
reg [6:0] BCNT;
reg [63:0] DIN_BUF;

wire pos_bclk, pos_mclk;
wire pos_lrclk, neg_lrclk;

assign pos_bclk = ~A_BCLK[3] & A_BCLK[2];
assign pos_mclk = ~A_MCLK[3] & A_MCLK[2];
assign pos_lrclk = ~A_LRCLK[3] & A_LRCLK[2];
assign neg_lrclk = A_LRCLK[3] & ~A_LRCLK[2];

always@(posedge ACLK) begin
    if(ARST)
        BCNT <= 7'b0;
    else if(neg_lrclk)
        BCNT <= 7'b0;
    else if(pos_bclk)
        BCNT <= BCNT + 7'b1;
end 

always @(posedge ACLK) begin
    if(ARST)
        DIN_BUF <= 64'b0;
    else if(pos_bclk)
        DIN_BUF <= {DIN_BUF[62:0], A_DIN[2]};
end

/*
assign DOUT = DIN_BUF;
assign DOUT_VALID = (BCNT == 7'd1 & pos_bclk)? 1'b1: 1'b0;
*/

assign DOUT_L = DIN_BUF[63:32];
assign DOUT_R = DIN_BUF[31:0];
assign DOUT_VALID = (BCNT == 7'd1 & pos_bclk)? 1'b1: 1'b0;
endmodule