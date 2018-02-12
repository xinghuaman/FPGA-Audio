/*
localparam signed a0 =   231;
localparam signed a1 =   274;
localparam signed a2 =   383;
localparam signed a3 =   562;
localparam signed a4 =   809;
localparam signed a5 =  1121;
localparam signed a6 =  1486;
localparam signed a7 =  1890;
localparam signed a8 =  2317;
localparam signed a9 =  2746;
localparam signed a10 =  3156;
localparam signed a11 =  3526;
localparam signed a12 =  3837;
localparam signed a13 =  4072;
localparam signed a14 =  4219;
localparam signed a15 =  4268;
*/
localparam signed b0 =   -37;
localparam signed b1 =    28;
localparam signed b2 =   -14;
localparam signed b3 =   -21;
localparam signed b4 =    92;
localparam signed b5 =  -215;
localparam signed b6 =   402;
localparam signed b7 =  -657;
localparam signed b8 =   974;
localparam signed b9 = -1339;
localparam signed b10 =  1729;
localparam signed b11 = -2112;
localparam signed b12 =  2457;
localparam signed b13 = -2730;
localparam signed b14 =  2906;
localparam signed b15 = 34114;

localparam signed c0 =     0;
localparam signed c1 =   -80;
localparam signed c2 =   -71;
localparam signed c3 =   107;
localparam signed c4 =   262;
localparam signed c5 =     0;
localparam signed c6 =  -549;
localparam signed c7 =  -472;
localparam signed c8 =   645;
localparam signed c9 =  1413;
localparam signed c10 =     0;
localparam signed c11 = -2634;
localparam signed c12 = -2335;
localparam signed c13 =  3687;
localparam signed c14 = 12302;
localparam signed c15 = 16420;

localparam signed d0 =  -109;
localparam signed d1 =  -125;
localparam signed d2 =  -152;
localparam signed d3 =  -168;
localparam signed d4 =  -133;
localparam signed d5 =     0;
localparam signed d6 =   279;
localparam signed d7 =   737;
localparam signed d8 =  1387;
localparam signed d9 =  2206;
localparam signed d10 =  3142;
localparam signed d11 =  4112;
localparam signed d12 =  5018;
localparam signed d13 =  5757;
localparam signed d14 =  6240;
localparam signed d15 =  6409;

localparam signed e0 =   123;
localparam signed e1 =   142;
localparam signed e2 =   181;
localparam signed e3 =   228;
localparam signed e4 =   256;
localparam signed e5 =   233;
localparam signed e6 =   128;
localparam signed e7 =   -83;
localparam signed e8 =  -412;
localparam signed e9 =  -848;
localparam signed e10 = -1361;
localparam signed e11 = -1905;
localparam signed e12 = -2418;
localparam signed e13 = -2841;
localparam signed e14 = -3119;
localparam signed e15 = 36979;

wire signed [16:0] a0;
wire signed [16:0] a1;
wire signed [16:0] a2;
wire signed [16:0] a3;
wire signed [16:0] a4;
wire signed [16:0] a5;
wire signed [16:0] a6;
wire signed [16:0] a7;
wire signed [16:0] a8;
wire signed [16:0] a9;
wire signed [16:0] a10;
wire signed [16:0] a11;
wire signed [16:0] a12;
wire signed [16:0] a13;
wire signed [16:0] a14;
wire signed [16:0] a15;

assign a0 =  (FIL_PARAM < 4'd2)? b0:
             (FIL_PARAM < 4'd4)? c0:
             (FIL_PARAM < 4'd6)? d0:
                                 e0;
assign a1 =  (FIL_PARAM < 4'd2)? b1:
             (FIL_PARAM < 4'd4)? c1:
             (FIL_PARAM < 4'd6)? d1:e1;
assign a2 =  (FIL_PARAM < 4'd2)? b2:
             (FIL_PARAM < 4'd4)? c2:
             (FIL_PARAM < 4'd6)? d2:e2;
assign a3 =  (FIL_PARAM < 4'd2)? b3:
             (FIL_PARAM < 4'd4)? c3:
             (FIL_PARAM < 4'd6)? d3:e3;
assign a4 =  (FIL_PARAM < 4'd2)? b4:
             (FIL_PARAM < 4'd4)? c4:
             (FIL_PARAM < 4'd6)? d4:e4;
assign a5 =  (FIL_PARAM < 4'd2)? b5:
             (FIL_PARAM < 4'd4)? c5:
             (FIL_PARAM < 4'd6)? d5:e5;
assign a6 =  (FIL_PARAM < 4'd2)? b6:
             (FIL_PARAM < 4'd4)? c6:
             (FIL_PARAM < 4'd6)? d6:e6;
assign a7 =  (FIL_PARAM < 4'd2)? b7:
             (FIL_PARAM < 4'd4)? c7:
             (FIL_PARAM < 4'd6)? d7:e7;
assign a8 =  (FIL_PARAM < 4'd2)? b8:
             (FIL_PARAM < 4'd4)? c8:
             (FIL_PARAM < 4'd6)? d8:e8;
assign a9 =  (FIL_PARAM < 4'd2)? b9:
             (FIL_PARAM < 4'd4)? c9:
             (FIL_PARAM < 4'd6)? d9:e9;
assign a10 = (FIL_PARAM < 4'd2)? b10:
             (FIL_PARAM < 4'd4)? c10:
             (FIL_PARAM < 4'd6)? d10:e10;
assign a11 = (FIL_PARAM < 4'd2)? b11:
             (FIL_PARAM < 4'd4)? c11:
             (FIL_PARAM < 4'd6)? d11:e11;
assign a12 = (FIL_PARAM < 4'd2)? b12:
             (FIL_PARAM < 4'd4)? c12:
             (FIL_PARAM < 4'd6)? d12:e12;
assign a13 = (FIL_PARAM < 4'd2)? b13:
             (FIL_PARAM < 4'd4)? c13:
             (FIL_PARAM < 4'd6)? d13:e13;
assign a14 = (FIL_PARAM < 4'd2)? b14:
             (FIL_PARAM < 4'd4)? c14:
             (FIL_PARAM < 4'd6)? d14:e14;
assign a15 = (FIL_PARAM < 4'd2)? b15:
             (FIL_PARAM < 4'd4)? c15:
             (FIL_PARAM < 4'd6)? d15:e15;
