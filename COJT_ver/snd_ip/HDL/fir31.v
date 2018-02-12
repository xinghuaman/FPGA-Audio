module fir31(
    input                ACLK,
    input                ARST,
    input  signed [15:0] din,
    output signed [15:0] dout,
    input                din_valid,
    output               dout_valid,
    //output               fir_wait
    output        [2:0]  fir_wait,
    input         [3:0]  FIL_PARAM
  );
  `include "fir_param.vh"

  reg signed [15:0] din_sw  [0:7];
  reg signed [16:0] a_sw    [0:7];
  reg signed [40:0] acm;
  reg signed [15:0] din_reg [0:30];
  reg signed [15:0] dout_reg;
  //reg        [2:0]  cnt;
  wire              conv_doutval;
  wire signed [36:0] conv_dout;
  wire              conv_dinval;
  reg         [2:0] conv_dout_cnt;
  reg         [4:0] din_valid_reg;
  reg               conv_doutval_reg;

  assign fir_wait = 3'd4;
  //assign fir_wait = (din_valid_reg[2:0] == 3'b0) ? 1'b0: 1'b1;
  assign conv_dinval = (din_valid_reg[0] | din_valid_reg[1] | din_valid_reg[2] | din_valid_reg[3])? 1'b1: 1'b0;
  //assign dout = acm[34]? $signed({1'b1, acm[30:16]}) : $signed({1'b0, acm[30:16]}); //
  assign dout = dout_reg;
  assign dout_valid =(conv_dout_cnt == 3'd4)? 1'b1: 1'b0;


  always @ (posedge ACLK) begin
    if(ARST)
      acm <= 40'h0;
    else if(conv_dout_cnt >= 3'd4 & ~conv_doutval)
      acm <= 40'h0;
    else if(conv_dout_cnt >= 3'd4 & conv_doutval)
      //acm <= $signed({{6{conv_dout[34]}},conv_dout[33:0]});
        acm <= conv_dout;
    else if(conv_dout_cnt < 3'd4 & conv_doutval)
      //acm <= acm + $signed({{6{conv_dout[34]}},conv_dout[33:0]});
        acm <= conv_dout + acm;
  end

  always @ (posedge ACLK) begin
    if(ARST)
      dout_reg <= 17'h0;
    else if(conv_dout_cnt == 3'd4 & acm[40])
      dout_reg <= $signed({1'b1, acm[30:16]});
    else if(conv_dout_cnt == 3'd4& ~acm[40])
      dout_reg <= $signed({1'b0, acm[30:16]});
  end

  always @ (posedge ACLK) begin
    if(ARST)
      conv_dout_cnt <= 3'b0;
    else if(conv_dout_cnt == 3'd4& ~conv_doutval)
      conv_dout_cnt <= 3'b0;
    else if(conv_dout_cnt == 3'd4 & conv_doutval)
      conv_dout_cnt <= 3'b1;
    else if(conv_doutval)
      conv_dout_cnt <= conv_dout_cnt + 3'b1;
  end

  always @ (posedge ACLK) begin
    if(ARST)
      conv_doutval_reg <= 1'b0;
    else
      conv_doutval_reg <= dout_valid;
  end


/*
  always @ (posedge ACLK) begin
    if(ARST)
      cnt <= 3'b0;
    else if(cnt ==3'd0 & din_valid)
      cnt <= 3'd1;
    else if(cnt >= 3'd4)
      cnt <= 3'b0;
    else if(cnt >0)
      cnt <= cnt+3'b1;
  end
  */


  always @ (posedge ACLK) begin
    if(ARST)
      din_valid_reg <= 5'b0;
    else
      din_valid_reg <= {din_valid_reg[3:0], din_valid};
  end

  always @ ( * ) begin
    if(ARST) begin
      din_sw[0] <= 16'b0;
      din_sw[1] <= 16'b0;
      din_sw[2] <= 16'b0;
      din_sw[3] <= 16'b0;
      din_sw[4] <= 16'b0;
      din_sw[5] <= 16'b0;
      din_sw[6] <= 16'b0;
      din_sw[7] <= 16'b0;
    end
    else if(din_valid_reg[0]) begin
      din_sw[0] <= din_reg[0];
      din_sw[1] <= din_reg[1];
      din_sw[2] <= din_reg[2];
      din_sw[3] <= din_reg[3];
      din_sw[4] <= din_reg[4];
      din_sw[5] <= din_reg[5];
      din_sw[6] <= din_reg[6];
      din_sw[7] <= din_reg[7];
    end
    else if(din_valid_reg[1]) begin
      din_sw[0] <= din_reg[8];
      din_sw[1] <= din_reg[9];
      din_sw[2] <= din_reg[10];
      din_sw[3] <= din_reg[11];
      din_sw[4] <= din_reg[12];
      din_sw[5] <= din_reg[13];
      din_sw[6] <= din_reg[14];
      din_sw[7] <= din_reg[15];
    end
    else if(din_valid_reg[2]) begin
      din_sw[0] <= din_reg[16];
      din_sw[1] <= din_reg[17];
      din_sw[2] <= din_reg[18];
      din_sw[3] <= din_reg[19];
      din_sw[4] <= din_reg[20];
      din_sw[5] <= din_reg[21];
      din_sw[6] <= din_reg[22];
      din_sw[7] <= din_reg[23];
    end
    else if(din_valid_reg[3]) begin
      din_sw[0] <= din_reg[24];
      din_sw[1] <= din_reg[25];
      din_sw[2] <= din_reg[26];
      din_sw[3] <= din_reg[27];
      din_sw[4] <= din_reg[28];
      din_sw[5] <= din_reg[29];
      din_sw[6] <= din_reg[30];
      din_sw[7] <= $signed(16'b0);
    end
  end

  always @ ( * ) begin
    if(ARST) begin
      a_sw[0] <= 17'b0;
      a_sw[1] <= 17'b0;
      a_sw[2] <= 17'b0;
      a_sw[3] <= 17'b0;
      a_sw[4] <= 17'b0;
      a_sw[5] <= 17'b0;
      a_sw[6] <= 17'b0;
      a_sw[7] <= 17'b0;
    end
    else if(din_valid_reg[0]) begin
      a_sw[0] <= a0;
      a_sw[1] <= a1;
      a_sw[2] <= a2;
      a_sw[3] <= a3;
      a_sw[4] <= a4;
      a_sw[5] <= a5;
      a_sw[6] <= a6;
      a_sw[7] <= a7;
    end
    else if(din_valid_reg[1]) begin
      a_sw[0] <= a8;
      a_sw[1] <= a9;
      a_sw[2] <= a10;
      a_sw[3] <= a11;
      a_sw[4] <= a12;
      a_sw[5] <= a13;
      a_sw[6] <= a14;
      a_sw[7] <= a15;
    end
    else if(din_valid_reg[2]) begin
      a_sw[0] <= a14;
      a_sw[1] <= a13;
      a_sw[2] <= a12;
      a_sw[3] <= a11;
      a_sw[4] <= a10;
      a_sw[5] <= a9;
      a_sw[6] <= a8;
      a_sw[7] <= a7;
    end
    else if(din_valid_reg[3]) begin
      a_sw[0] <= a6;
      a_sw[1] <= a5;
      a_sw[2] <= a4;
      a_sw[3] <= a3;
      a_sw[4] <= a2;
      a_sw[5] <= a1;
      a_sw[6] <= a0;
      a_sw[7] <= $signed(16'b0);
    end
  end

  conv1616in32out_8block conv1616in32out_8block(
    .ACLK(ACLK),
    .ARST(ARST),
    .dinval(conv_dinval),
    .din0(din_sw[0]),
    .din1(din_sw[1]),
    .din2(din_sw[2]),
    .din3(din_sw[3]),
    .din4(din_sw[4]),
    .din5(din_sw[5]),
    .din6(din_sw[6]),
    .din7(din_sw[7]),
    .a0(a_sw[0]),
    .a1(a_sw[1]),
    .a2(a_sw[2]),
    .a3(a_sw[3]),
    .a4(a_sw[4]),
    .a5(a_sw[5]),
    .a6(a_sw[6]),
    .a7(a_sw[7]),
    .dout(conv_dout),
    .doutval(conv_doutval)
    );


/*
  always @ ( posedge ACLK ) begin
    if(ARST)
      interval <= 17'b0;
    else if(cnt == 6'd0)
      interval = a0*shiftdata[0] + a1*shiftdata[1] + a2*shiftdata[2] + a3*shiftdata[3] + a4*shiftdata[4] + a5*shiftdata[5] + a6*shiftdata[6] + a7*shiftdata[7];
    else if(cnt == 6'd1)
      interval = a8*shiftdata[8] + a9*shiftdata[9] + a10*shiftdata[10] + a11*shiftdata[11] + a12*shiftdata[12] + a13*shiftdata[13] + a14*shiftdata[14] + a15*shiftdata[15];
    else if(cnt == 6'd2)
      interval = a14*shiftdata[16] + a13*shiftdata[17] + a12*shiftdata[18] + a11*shiftdata[19] + a10*shiftdata[20] + a9*shiftdata[21] + a8*shiftdata[22] + a7*shiftdata[23];
    else if(cnt == 6'd3)
      interval = a6*shiftdata[24] + a5*shiftdata[25] + a4*shiftdata[26] + a3*shiftdata[27] + a2*shiftdata[28] + a1*shiftdata[29] + a0*shiftdata[30];
  end
*/

  ////条件��?岐追��?
  //入力信号レジスタ
  always @ (posedge ACLK ) begin
    if(ARST) begin
      din_reg [0] <= 16'b0;
      din_reg [1] <= 16'b0;
      din_reg [2] <= 16'b0;
      din_reg [3] <= 16'b0;
      din_reg [4] <= 16'b0;
      din_reg [5] <= 16'b0;
      din_reg [6] <= 16'b0;
      din_reg [7] <= 16'b0;
      din_reg [8] <= 16'b0;
      din_reg [9] <= 16'b0;
      din_reg [10] <= 16'b0;
      din_reg [11] <= 16'b0;
      din_reg [12] <= 16'b0;
      din_reg [13] <= 16'b0;
      din_reg [14] <= 16'b0;
      din_reg [15] <= 16'b0;
      din_reg [16] <= 16'b0;
      din_reg [17] <= 16'b0;
      din_reg [18] <= 16'b0;
      din_reg [19] <= 16'b0;
      din_reg [20] <= 16'b0;
      din_reg [21] <= 16'b0;
      din_reg [22] <= 16'b0;
      din_reg [23] <= 16'b0;
      din_reg [24] <= 16'b0;
      din_reg [25] <= 16'b0;
      din_reg [26] <= 16'b0;
      din_reg [27] <= 16'b0;
      din_reg [28] <= 16'b0;
      din_reg [29] <= 16'b0;
      din_reg [30] <= 16'b0;
    end
    else if(din_valid) begin
      din_reg [0] <= din;
      din_reg [1] <= din_reg[0];
      din_reg [2] <= din_reg[1];
      din_reg [3] <= din_reg[2];
      din_reg [4] <= din_reg[3];
      din_reg [5] <= din_reg[4];
      din_reg [6] <= din_reg[5];
      din_reg [7] <= din_reg[6];
      din_reg [8] <= din_reg[7];
      din_reg [9] <= din_reg[8];
      din_reg [10] <= din_reg[9];
      din_reg [11] <= din_reg[10];
      din_reg [12] <= din_reg[11];
      din_reg [13] <= din_reg[12];
      din_reg [14] <= din_reg[13];
      din_reg [15] <= din_reg[14];
      din_reg [16] <= din_reg[15];
      din_reg [17] <= din_reg[16];
      din_reg [18] <= din_reg[17];
      din_reg [19] <= din_reg[18];
      din_reg [20] <= din_reg[19];
      din_reg [21] <= din_reg[20];
      din_reg [22] <= din_reg[21];
      din_reg [23] <= din_reg[22];
      din_reg [24] <= din_reg[23];
      din_reg [25] <= din_reg[24];
      din_reg [26] <= din_reg[25];
      din_reg [27] <= din_reg[26];
      din_reg [28] <= din_reg[27];
      din_reg [29] <= din_reg[28];
      din_reg [30] <= din_reg[29];
    end
  end

endmodule
