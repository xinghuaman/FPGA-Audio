module conv1616in32out_8block(
  input                ACLK,
  input                ARST,
  input                dinval,
  input  signed [15:0] din0,
  input  signed [15:0] din1,
  input  signed [15:0] din2,
  input  signed [15:0] din3,
  input  signed [15:0] din4,
  input  signed [15:0] din5,
  input  signed [15:0] din6,
  input  signed [15:0] din7,
  input  signed [16:0] a0,
  input  signed [16:0] a1,
  input  signed [16:0] a2,
  input  signed [16:0] a3,
  input  signed [16:0] a4,
  input  signed [16:0] a5,
  input  signed [16:0] a6,
  input  signed [16:0] a7,
  output signed [36:0] dout,
  output               doutval
  );
  reg    signed [15:0] din_reg [0:7];
  reg    signed [16:0] a_reg [0:7];
  reg    signed [33:0] mult1_reg [0:7];
  reg    signed [34:0] add1_reg [0:3];
  reg    signed [35:0] add2_reg [0:1];
  reg    signed [36:0] dout_reg;
  reg           [5:0]  doutval_reg;
  //wire                 conven;

  assign dout = dout_reg;
  assign doutval = doutval_reg[4];
  //assign conven = dinval;

  always @ ( posedge ACLK ) begin
    if(ARST) begin
      din_reg[0] <= 16'b0;
      din_reg[1] <= 16'b0;
      din_reg[2] <= 16'b0;
      din_reg[3] <= 16'b0;
      din_reg[4] <= 16'b0;
      din_reg[5] <= 16'b0;
      din_reg[6] <= 16'b0;
      din_reg[7] <= 16'b0;
    end
    else if(dinval) begin
      din_reg[0] <= din0;
      din_reg[1] <= din1;
      din_reg[2] <= din2;
      din_reg[3] <= din3;
      din_reg[4] <= din4;
      din_reg[5] <= din5;
      din_reg[6] <= din6;
      din_reg[7] <= din7;
    end
  end

  always @ ( posedge ACLK ) begin
    if(ARST) begin
      a_reg[0] <= 17'b0;
      a_reg[1] <= 17'b0;
      a_reg[2] <= 17'b0;
      a_reg[3] <= 17'b0;
      a_reg[4] <= 17'b0;
      a_reg[5] <= 17'b0;
      a_reg[6] <= 17'b0;
      a_reg[7] <= 17'b0;
    end
    else if(dinval) begin
      a_reg[0] <= a0;
      a_reg[1] <= a1;
      a_reg[2] <= a2;
      a_reg[3] <= a3;
      a_reg[4] <= a4;
      a_reg[5] <= a5;
      a_reg[6] <= a6;
      a_reg[7] <= a7;
    end
  end

  always @ ( posedge ACLK ) begin
    if(ARST) begin
      mult1_reg[0] <= 34'b0;
      mult1_reg[1] <= 34'b0;
      mult1_reg[2] <= 34'b0;
      mult1_reg[3] <= 34'b0;
      mult1_reg[4] <= 34'b0;
      mult1_reg[5] <= 34'b0;
      mult1_reg[6] <= 34'b0;
      mult1_reg[7] <= 34'b0;
    end
    else if(doutval_reg[0]) begin
      mult1_reg[0] <= din_reg[0] * a_reg[0];
      mult1_reg[1] <= din_reg[1] * a_reg[1];
      mult1_reg[2] <= din_reg[2] * a_reg[2];
      mult1_reg[3] <= din_reg[3] * a_reg[3];
      mult1_reg[4] <= din_reg[4] * a_reg[4];
      mult1_reg[5] <= din_reg[5] * a_reg[5];
      mult1_reg[6] <= din_reg[6] * a_reg[6];
      mult1_reg[7] <= din_reg[7] * a_reg[7];
    end
  end

  always @ ( posedge ACLK ) begin
    if(ARST) begin
      add1_reg[0] <= 35'b0;
      add1_reg[1] <= 35'b0;
      add1_reg[2] <= 35'b0;
      add1_reg[3] <= 35'b0;
    end
    else if(doutval_reg[1]) begin
      add1_reg[0] <= mult1_reg[0] + mult1_reg[1];
      add1_reg[1] <= mult1_reg[2] + mult1_reg[3];
      add1_reg[2] <= mult1_reg[4] + mult1_reg[5];
      add1_reg[3] <= mult1_reg[6] + mult1_reg[7];
    end
  end

  always @ ( posedge ACLK ) begin
    if(ARST) begin
      add2_reg[0] <= 36'b0;
      add2_reg[1] <= 36'b0;
    end
    else if(doutval_reg[2]) begin
      add2_reg[0] <= add1_reg[0] + add1_reg[1];
      add2_reg[1] <= add1_reg[2] + add1_reg[3];
    end
  end

  always @ ( posedge ACLK ) begin
    if(ARST) begin
      dout_reg <= 37'b0;
    end
    else if(doutval_reg[3]) begin
      dout_reg <= add2_reg[0] + add2_reg[1];
    end
  end

  always @ ( posedge ACLK ) begin
    if(ARST)
      doutval_reg <= 6'd0;
    else
      doutval_reg <= {doutval_reg[5:0], dinval};
  end

endmodule
