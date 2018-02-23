module interpolate32(
    input                ACLK,
    input                ARST,
    input         [15:0] din,
    output signed [15:0] dout,
    input                din_valid,
    output               dout_valid
    //output        [5:0]  ip_wait
  );
  `include "interpolate_param.vh"

  //reg signed [16:0] a_sw[0], coef1, coef2, coef3;
  reg signed [15:0] shiftdata[0:4];
  reg signed [31:0] dout_reg;
  reg        [5:0]  cnt;
  reg signed [15:0] din_sw [0:4];
  reg signed [16:0] a_sw [0:4];
  //reg        [5:0] din_valid_reg;
  reg        [1:0]  dout_valid_reg;
  wire              conv_dinval, conv_doutval;
  wire       [36:0] conv_dout;

  //assign ip_wait =  6'd32;
  assign dout = dout_reg[31:16];
  //assign dout_valid = (cnt>6'd0 & cnt <= 6'd32)?1'b1:1'b0;
  assign dout_valid = dout_valid_reg[0];
  assign conv_dinval = (cnt>6'd0 & cnt <= 6'd32)? 1'b1: 1'b0;

  always @ (posedge ACLK) begin
    if(ARST)
      dout_valid_reg <= 3'b0;
    else
      dout_valid_reg <= {dout_valid_reg[0], conv_doutval};
  end

  always @ ( posedge ACLK ) begin
    if(ARST)
      dout_reg <= 32'b0;
    else if(conv_doutval)
      dout_reg <= {conv_dout[36],conv_dout[30:0]};
  end

  always @ ( * ) begin
    if(ARST) begin
      a_sw[0] <= 17'b0;
      a_sw[1] <= 17'b0;
      a_sw[2] <= 17'b0;
      a_sw[3] <= 17'b0;
      a_sw[4] <= 17'b0;
    end
    else if(cnt == 6'd1) begin
      a_sw[0] <= a0;
      a_sw[1] <= a32;
      a_sw[2] <= a64;
      a_sw[3] <= a32;
      a_sw[4] <= a0;
    end
    else if(cnt == 6'd2) begin
      a_sw[0] <= a1;
      a_sw[1] <= a33;
      a_sw[2] <= a63;
      a_sw[3] <= a31;
      a_sw[4] <= 17'b0;
    end
    else if(cnt == 6'd3) begin
      a_sw[0] <= a2;
      a_sw[1] <= a34;
      a_sw[2] <= a62;
      a_sw[3] <= a30;
      a_sw[4] <= 17'b0;
    end
    else if(cnt == 6'd4) begin
      a_sw[0] <= a3;
      a_sw[1] <= a35;
      a_sw[2] <= a61;
      a_sw[3] <= a29;
      a_sw[4] <= 17'b0;
    end
    else if(cnt == 6'd5) begin
      a_sw[0] <= a4;
      a_sw[1] <= a36;
      a_sw[2] <= a60;
      a_sw[3] <= a28;
      a_sw[4] <= 17'b0;
    end
    else if(cnt == 6'd6) begin
      a_sw[0] <= a5;
      a_sw[1] <= a37;
      a_sw[2] <= a59;
      a_sw[3] <= a27;
      a_sw[4] <= 17'b0;
    end
    else if(cnt == 6'd7) begin
      a_sw[0] <= a6;
      a_sw[1] <= a38;
      a_sw[2] <= a58;
      a_sw[3] <= a26;
      a_sw[4] <= 17'b0;
    end
    else if(cnt == 6'd8) begin
      a_sw[0] <= a7;
      a_sw[1] <= a39;
      a_sw[2] <= a57;
      a_sw[3] <= a25;
      a_sw[4] <= 17'b0;
   end
    else if(cnt == 6'd9) begin
      a_sw[0] <= a8;
      a_sw[1] <= a40;
      a_sw[2] <= a56;
      a_sw[3] <= a24;
      a_sw[4] <= 17'b0;
    end
    else if(cnt == 6'd10) begin
      a_sw[0] <= a9;
      a_sw[1] <= a41;
      a_sw[2] <= a55;
      a_sw[3] <= a23;
      a_sw[4] <= 17'b0;
    end
    else if(cnt == 6'd11) begin
      a_sw[0] <= a10;
      a_sw[1] <= a42;
      a_sw[2] <= a54;
      a_sw[3] <= a22;
      a_sw[4] <= 17'b0;
    end
    else if(cnt == 6'd12) begin
      a_sw[0] <= a11;
      a_sw[1] <= a43;
      a_sw[2] <= a53;
      a_sw[3] <= a21;
      a_sw[4] <= 17'b0;
    end
    else if(cnt == 6'd13) begin
      a_sw[0] <= a12;
      a_sw[1] <= a44;
      a_sw[2] <= a52;
      a_sw[3] <= a20;
      a_sw[4] <= 17'b0;
    end
    else if(cnt == 6'd14) begin
      a_sw[0] <= a13;
      a_sw[1] <= a45;
      a_sw[2] <= a51;
      a_sw[3] <= a19;
      a_sw[4] <= 17'b0;
    end
    else if(cnt == 6'd15) begin
      a_sw[0] <= a14;
      a_sw[1] <= a46;
      a_sw[2] <= a50;
      a_sw[3] <= a18;
      a_sw[4] <= 17'b0;
    end
    else if(cnt == 6'd16) begin
      a_sw[0] <= a15;
      a_sw[1] <= a47;
      a_sw[2] <= a49;
      a_sw[3] <= a17;
      a_sw[4] <= 17'b0;
    end
    else if(cnt == 6'd17) begin
      a_sw[0] <= a16;
      a_sw[1] <= a48;
      a_sw[2] <= a48;
      a_sw[3] <= a16;
      a_sw[4] <= a0;
    end
    else if(cnt == 6'd18) begin
      a_sw[0] <= a17;
      a_sw[1] <= a49;
      a_sw[2] <= a47;
      a_sw[3] <= a15;
      a_sw[4] <= 17'b0;
    end
    else if(cnt == 6'd19) begin
      a_sw[0] <= a18;
      a_sw[1] <= a50;
      a_sw[2] <= a46;
      a_sw[3] <= a14;
      a_sw[4] <= 17'b0;
    end
    else if(cnt == 6'd20) begin
      a_sw[0] <= a19;
      a_sw[1] <= a51;
      a_sw[2] <= a45;
      a_sw[3] <= a13;
      a_sw[4] <= 17'b0;
    end
    else if(cnt == 6'd21) begin
      a_sw[0] <= a20;
      a_sw[1] <= a52;
      a_sw[2] <= a44;
      a_sw[3] <= a12;
      a_sw[4] <= 17'b0;
    end
    else if(cnt == 6'd22) begin
      a_sw[0] <= a21;
      a_sw[1] <= a53;
      a_sw[2] <= a43;
      a_sw[3] <= a11;
      a_sw[4] <= 17'b0;
    end
    else if(cnt == 6'd23) begin
      a_sw[0] <= a22;
      a_sw[1] <= a54;
      a_sw[2] <= a42;
      a_sw[3] <= a10;
      a_sw[4] <= 17'b0;
    end
    else if(cnt == 6'd24) begin
      a_sw[0] <= a23;
      a_sw[1] <= a55;
      a_sw[2] <= a41;
      a_sw[3] <= a9;
      a_sw[4] <= 17'b0;
    end
    else if(cnt == 6'd25) begin
      a_sw[0] <= a24;
      a_sw[1] <= a56;
      a_sw[2] <= a40;
      a_sw[3] <= a8;
      a_sw[4] <= 17'b0;
    end
    else if(cnt == 6'd26) begin
      a_sw[0] <= a25;
      a_sw[1] <= a57;
      a_sw[2] <= a39;
      a_sw[3] <= a7;
      a_sw[4] <= 17'b0;
    end
    else if(cnt == 6'd27) begin
      a_sw[0] <= a26;
      a_sw[1] <= a58;
      a_sw[2] <= a38;
      a_sw[3] <= a6;
      a_sw[4] <= 17'b0;
    end
    else if(cnt == 6'd28) begin
      a_sw[0] <= a27;
      a_sw[1] <= a59;
      a_sw[2] <= a37;
      a_sw[3] <= a5;
      a_sw[4] <= 17'b0;
    end
    else if(cnt == 6'd29) begin
      a_sw[0] <= a28;
      a_sw[1] <= a60;
      a_sw[2] <= a36;
      a_sw[3] <= a4;
      a_sw[4] <= 17'b0;
    end
    else if(cnt == 6'd30) begin
      a_sw[0] <= a29;
      a_sw[1] <= a61;
      a_sw[2] <= a35;
      a_sw[3] <= a3;
      a_sw[4] <= 17'b0;
    end
    else if(cnt == 6'd31) begin
      a_sw[0] <= a30;
      a_sw[1] <= a62;
      a_sw[2] <= a34;
      a_sw[3] <= a2;
      a_sw[4] <= 17'b0;
    end
    else if(cnt == 6'd32) begin
      a_sw[0] <= a31;
      a_sw[1] <= a63;
      a_sw[2] <= a33;
      a_sw[3] <= a1;
      a_sw[4] <= 17'b0;
    end
  end
  wire signed [16:0] dummy;
  assign dummy = 17'b0;
  conv1616in32out_8block conv1616in32out_8block(
    .ACLK(ACLK),
    .ARST(ARST),
    .dinval(conv_dinval),
    .din0(shiftdata[0]),
    .din1(shiftdata[1]),
    .din2(shiftdata[2]),
    .din3(shiftdata[3]),
    .din4(shiftdata[4]),
    .din5(dummy[15:0]),
    .din6(dummy[15:0]),
    .din7(dummy[15:0]),
    .a0(a_sw[0]),
    .a1(a_sw[1]),
    .a2(a_sw[2]),
    .a3(a_sw[3]),
    .a4(a_sw[4]),
    .a5(dummy),
    .a6(dummy),
    .a7(dummy),
    .dout(conv_dout),
    .doutval(conv_doutval)
    );

  always @ (posedge ACLK ) begin
    if(ARST)
      shiftdata [0] <= 16'b0;
    else if(din_valid)
      shiftdata [0] <= $signed({din[15],din[14:0]});
  end

  always @ (posedge ACLK ) begin
    if(ARST)
      shiftdata [1] <= 16'b0;
    else if(din_valid)
      shiftdata [1] <= shiftdata[0];
  end

  always @ (posedge ACLK ) begin
    if(ARST)
      shiftdata [2] <= 16'b0;
    else if(din_valid)
      shiftdata [2] <= shiftdata[1];
  end

  always @ (posedge ACLK ) begin
    if(ARST)
      shiftdata [3] <= 16'b0;
    else if(din_valid)
      shiftdata [3] <= shiftdata[2];
  end
  always @ (posedge ACLK ) begin
    if(ARST)
      shiftdata [4] <= 16'b0;
    else if(din_valid)
      shiftdata [4] <= shiftdata[3];
  end

  always @ (posedge ACLK) begin
    if(ARST)
      cnt <= 6'b0;
    else if(cnt==6'b0 & din_valid)
      cnt <= 6'b1;
    else if(cnt >= 32)
      cnt <= 6'b0;
    else if(cnt >0)
      cnt <= cnt+6'b1;
  end

endmodule
