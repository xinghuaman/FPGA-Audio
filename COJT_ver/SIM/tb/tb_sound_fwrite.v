//-----------------------------------------------------------------------------
// Title       : sound��H�̃e�X�g�x���`�i�X���[�uBFM�ƒ����j
// Project     : sound
// Filename    : tb_sound.v
//-----------------------------------------------------------------------------
// Description :
//
//-----------------------------------------------------------------------------
// Revisions   :
// Date        Version  Author        Description
// 2014/07/28  1.00     M.Kobayashi   Created
// 2015/12/16  1.10     M.Kobayashi   regbus2�Ή��A�ڑ�������include file��
//-----------------------------------------------------------------------------


`timescale 100ps/1ps

module tb_sound_fwrite;

/* �e��萔 */
localparam integer C_AXI_DATA_WIDTH = 32;
localparam integer STEP  = 80;
localparam integer STEP_CLK40 = 250;
localparam integer C_OFFSET_WIDTH = 24;

/* �V�X�e���N���b�N����у��Z�b�g */
reg ACLK;
reg ARESETN;

/* �T�E���h��H�M�� */
reg             CLK40;
wire            SND_MCLK, SND_BCLK, SND_LRCLK, SND_DOUT;
wire            SND_FIFO_OVER, SND_FIFO_UNDER;

/* ���W�X�^�o�X */
reg   [15:0]    WRADDR;
reg   [3:0]     BYTEEN;
reg             WREN;
reg   [31:0]    WDATA;
reg   [15:0]    RDADDR;
reg             RDEN;
wire  [31:0]    RDATA;

reg   [31:0]    status;

/* ���ʉ������ڑ������̋L�q��ǂݍ��� */
`include "sound_axibfm.vh"

/* ���W�X�^�������� */
task write_reg;
input [15:0] wraddr;
input [3:0]  byteen;
input [31:0] wdata;
begin
    WRADDR = wraddr;
    BYTEEN = byteen;
    WDATA  = wdata;
    #STEP;
    WREN = 1;
    #STEP;
    WREN = 0;
end
endtask

/* �N���b�N */
always begin
    ACLK = 0; #(STEP/2);
    ACLK = 1; #(STEP/2);
end

always begin
    CLK40 = 0; #(STEP_CLK40/2);
    CLK40 = 1; #(STEP_CLK40/2);
end

integer size;

/* �C���N�������g�f�[�^���������ɏ��� */
task setup_data;
reg [15:0] data_l, data_r;
integer i;
localparam PCM_SAMPLE = 4096;
begin
    data_l = 16'h0000;
    data_r = 16'h7FFF;
    for ( i=0; i<PCM_SAMPLE/4; i=i+1 ) begin
        axi_slave_bfm.ram_array[i][15:0]  = data_l;
        axi_slave_bfm.ram_array[i][31:16] = data_r;
        data_l = data_l + 16'h1;
        data_r = data_r - 16'h1;
    end
    size = PCM_SAMPLE;
end
endtask

/* �R�}���h */
localparam PLAY=2'b01, PAUSE=2'b10, STOP=2'b11;
localparam LOOP=3'b100;

/* �t�@�C���o�͗p */
integer fd;
/* �e�X�g�x���`�{�� */
initial begin
    fd = $fopen("snddata.txt");

    setup_data;
    ARESETN = 1;
    WRADDR = 0; BYTEEN = 0; WDATA = 0; WREN = 0; RDADDR = 0; RDEN = 0;
    #STEP;
    ARESETN = 0;
    #(STEP*10);
    ARESETN = 1;
    #(STEP*1000); /* MMCM�ɂ�鐶���N���b�N�����������܂ő҂� */
    ARESETN = 0;  /* ������x���Z�b�g */
    #(STEP*10);
    ARESETN = 1;
    #(STEP*100);
    write_reg(16'h3000, 4'hf, 32'h0);
    write_reg(16'h3004, 4'hf, size);
    write_reg(16'h3008, 4'hf, 8'hff);
    write_reg(16'h300c, 4'hf, PLAY);
    $messagelog("PLAY, VOL=FF");
    #(STEP*100000);
    write_reg(16'h3008, 4'hf, 8'h7f); // VOL=7F
    write_reg(16'h300c, 4'hf, PAUSE);
    $messagelog("PAUSE, VOL=7F");
    #(STEP*2000);
    write_reg(16'h300c, 4'hf, PLAY);
    $messagelog("PLAY");
    #(STEP*40000);
    write_reg(16'h300c, 4'hf, STOP);
    $messagelog("STOP");
    #(STEP*20000);
    write_reg(16'h3004, 4'hf, 32'd256); // DATASIZE=256
    write_reg(16'h300c, 4'hf, PLAY);
    $messagelog("PLAY, DATASIZE=256");
    #(STEP*20000);
    write_reg(16'h3008, 4'hf, 8'h40); // VOL=40
    $messagelog("VOL=40");
    #(STEP*20000);
    write_reg(16'h3008, 4'hf, 8'h20); // VOL=20
    $messagelog("VOL=20");
    #(STEP*20000);
    write_reg(16'h3008, 4'hf, 8'h00); // VOL=00
    $messagelog("VOL=00");
    #(STEP*20000);
    write_reg(16'h3008, 4'hf, 8'hff); // VOL=FF
    $messagelog("VOL=FF");
    #(STEP*20000);
    write_reg(16'h300c, 4'hf, STOP);
    write_reg(16'h300c, 4'hf, LOOP | PLAY); // LOOP
    $messagelog("PLAY, LOOP");
    #(STEP*100000);
    $fclose(fd);
    $stop;
end
integer pre_LR;
/*�o�͐M�����t�@�C���ɏ�������*/
always @(posedge SND_BCLK) begin
        $fdisplay(fd, "%01d", SND_DOUT);
end

endmodule
