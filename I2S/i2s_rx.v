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
    output [31:0] DOUT_L,
    output [31:0] DOUT_R,
    output        DOUT_L_VALID,
    output        DOUT_R_VALID  
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
reg [5:0] BCNT;
reg [31:0] DIN_L_BUF, DIN_R_BUF;

wire pos_bclk, pos_mclk;
wire pos_lrclk, neg_lrclk;

assign pos_bclk = ~A_BCLK[3] & A_BCLK[2];
assign pos_mclk = ~A_MCLK[3] & A_MCLK[2];
assign pos_lrclk = ~A_LRCLK[3] & A_LRCLK[2];
assign neg_lrclk = A_LRCLK[3] & ~A_LRCLK[2];

always@(posedge ACLK) begin
    if(ARST)
        BCNT <= 5'b0;
    else if(pos_lrclk | neg_lrclk)
        BCNT <= 5'b0;
    else if(pos_bclk)
        BCNT <= BCNT + 5'b1;
end 

always @(posedge ACLK) begin
    if(ARST)
        DIN_L_BUF <= 32'b0;
    else if(A_LRCLK[2])
        DIN_L_BUF <= 32'b0;
    else if(pos_bclk & ~A_LRCLK[2])
        DIN_L_BUF <= {DIN_L_BUF[30:0], A_DIN[2]};
end

always@(posedge ACLK) begin
    if(ARST)
        DIN_R_BUF <= 32'b0;
    else if(~A_LRCLK[2])
        DIN_R_BUF <= 32'b0;
    else if(pos_bclk & A_LRCLK[2])
        DIN_R_BUF <= {DIN_R_BUF[30:0], A_DIN[2]};
end 

assign DOUT_L = DIN_L_BUF[30:0];
assign DOUT_R = DIN_R_BUF[30:0];
assign DOUT_L_VALID = (BCNT == 6'd32 & pos_lrclk)? 1'b1: 1'b0;
assign DOUT_R_VALID = (BCNT == 6'd32 & neg_lrclk)? 1'b1: 1'b0;

endmodule