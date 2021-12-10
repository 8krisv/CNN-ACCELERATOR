/*#########################################################################
//# Avalon interface for hardware accelerator 
//#########################################################################
//#
//# Copyright (C) 2021 Jose Maria Jaramillo Hoyos
//# 
//# This program is free software: you can redistribute it and/or modify
//# it under the terms of the GNU General Public License as published by
//# the Free Software Foundation, either version 3 of the License, or
//# (at your option) any later version.
//#
//# This program is distributed in the hope that it will be useful,
//# but WITHOUT ANY WARRANTY; without even the implied warranty of
//# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//# GNU General Public License for more details.
//#
//# You should have received a copy of the GNU General Public License
//# along with this program.  If not, see <https://www.gnu.org/licenses/>.
//#
//########################################################################*/

module ACCELERATOR_AVALON_INTERFACE(

//////////// INPUTS //////////
AVS_Clk,
AVS_Reset,
AVS_m0_readdata,
AVS_m0_waitrequest,
AVS_s0_adress,
AVS_s0_read,
AVS_s0_write,
AVS_s0_writedata,
AVS_s0_chipselect,
AVS_Counduit_Same_W,
AVS_Counduit_Start,
AVS_Counduit_Finished_Ok,

//////////// OUTPUTS //////////
AVS_m0_adress,
AVS_m0_byteenable,
AVS_m0_read,
AVS_s0_readdata,
AVS_m0_write,
AVS_m0_writedata,
AVS_Counduit_Finished

);

//=======================================================
//  Parameter declarations
//=======================================================
parameter OFFMEM_DATA_WIDTH=16;
parameter OFFMEM_ADDR_WIDTH = 32;
parameter BITWIDTH_DATA_OUT=16; 
parameter BITWIDTH_IF_ROWS=10; 
parameter BITWIDTH_IF_COLUMS = 11; 
parameter BITWIDTH_W_ROWS=4;
parameter BITWIDTH_W_COLUMS=4; 
parameter BITWIDTH_IF_CHANNELS=2;
parameter BITWIDTH_STRIDE=4; 

localparam [3:0] BYTEENABLE = 4'b1111;
localparam [2:0] DATA4 = 3'd4;

localparam [31:0]  Addr_Offset=9;
localparam [31:0]  If_Rows=8;
localparam [31:0]  If_Colums=8;
localparam [31:0]  If_Channels=3;
localparam [31:0]  Of_Rows=7;
localparam [31:0]  Of_Colums=5;
localparam [31:0]  W_Rows=2;
localparam [31:0]  W_Colums=4;
localparam [31:0]  W_Channels=3;
localparam [31:0]  Stride=1;

//=======================================================
//  PORT declarations
//=======================================================
input AVS_Clk;
input AVS_Reset;
input [31:0] AVS_m0_readdata;
input AVS_m0_waitrequest;
input [3:0] AVS_s0_adress;
input AVS_s0_read;
input AVS_s0_write;
input [31:0] AVS_s0_writedata;
input AVS_s0_chipselect;
input AVS_Counduit_Same_W;
input AVS_Counduit_Start;
input AVS_Counduit_Finished_Ok;

output [17:0] AVS_m0_adress;
output AVS_m0_read;
output AVS_m0_write;
output [31:0] AVS_m0_writedata;
output [3:0] AVS_m0_byteenable;
output [31:0] AVS_s0_readdata;
output AVS_Counduit_Finished;


//=======================================================
//  REG/WIRE declarations
//=======================================================

reg[17:0] addr;
wire Conf_Regs_We;
wire Conf_Regs_Re;
wire [OFFMEM_DATA_WIDTH-1:0]  Cnn_Accelerator_Input_Data;
wire [31:0]	Cnn_Accelerator_Addr_Offset;
wire [31:0] Cnn_Accelerator_If_Rows;
wire [31:0] Cnn_Accelerator_If_Colums;
wire [31:0] Cnn_Accelerator_If_Channels;
wire [31:0] Cnn_Accelerator_Of_Rows;
wire [31:0] Cnn_Accelerator_Of_Colums;
wire [31:0] Cnn_Accelerator_W_Rows;
wire [31:0] Cnn_Accelerator_W_Colums;
wire [31:0] Cnn_Accelerator_W_Channels;
wire [31:0] Cnn_Accelerator_Stride;
wire [BITWIDTH_DATA_OUT-1:0] Cnn_Accelerator_Data_Out;
wire [OFFMEM_ADDR_WIDTH-1:0] Cnn_Accelerator_Addr;


//=======================================================
// Assign statements
//=======================================================

assign Conf_Regs_We=(AVS_s0_write& AVS_s0_chipselect);
assign Conf_Regs_Re=(AVS_s0_read& AVS_s0_chipselect);
assign Cnn_Accelerator_Input_Data = AVS_m0_readdata[OFFMEM_DATA_WIDTH-1:0];

assign Cnn_Accelerator_Addr_Offset = Addr_Offset; 
assign Cnn_Accelerator_If_Rows     = If_Rows; 
assign Cnn_Accelerator_If_Colums   = If_Colums; 
assign Cnn_Accelerator_If_Channels = If_Channels; 
assign Cnn_Accelerator_W_Rows      = W_Rows; 
assign Cnn_Accelerator_W_Colums    = W_Colums; 
assign Cnn_Accelerator_W_Channels  = W_Channels; 
assign Cnn_Accelerator_Of_Rows     = Of_Rows; 
assign Cnn_Accelerator_Of_Colums   = Of_Colums;
assign Cnn_Accelerator_Stride 	  = Stride;


//=======================================================
//  Structural coding
//=======================================================

/*
CONFI_REGS Conf_Regs(

/////// INPUTS ///////
.CONFI_REGS_Clk(AVS_Clk),
.CONFI_REGS_Reset(AVS_Reset),
.CONFI_REGS_Addr(AVS_s0_adress),
.CONFI_REGS_Writedata(AVS_s0_writedata),
.CONFI_REGS_We(Conf_Regs_We),
.CONFI_REGS_Re(Conf_Regs_Re),

/////// OUTPUTS ///////
.CONFI_REGS_Readdata(AVS_s0_readdata),
.CONFI_REGS_Reg_Addr_Offset(Cnn_Accelerator_Addr_Offset),
.CONFI_REGS_Reg_If_Rows(Cnn_Accelerator_If_Rows),
.CONFI_REGS_Reg_If_Colums(Cnn_Accelerator_If_Colums),
.CONFI_REGS_Reg_If_Channels(Cnn_Accelerator_If_Channels),
.CONFI_REGS_Reg_W_Rows(Cnn_Accelerator_W_Rows),
.CONFI_REGS_Reg_W_Colums(Cnn_Accelerator_W_Colums),
.CONFI_REGS_Reg_W_Channels(Cnn_Accelerator_W_Channels),
.CONFI_REGS_Reg_Of_Rows(Cnn_Accelerator_Of_Rows),
.CONFI_REGS_Reg_Of_Colums(Cnn_Accelerator_Of_Colums),
.CONFI_REGS_Reg_Stride(Cnn_Accelerator_Stride)

);
*/

ACCELERATOR Cnn_Accelerator(

//////////// INPUTS //////////
.ACCELERATOR_Clk_50(AVS_Clk),
.ACCELERATOR_Reset(AVS_Reset),
.ACCELERATOR_DATA_IN(Cnn_Accelerator_Input_Data),
.ACCELERATOR_ADDR_OFFSET(Cnn_Accelerator_Addr_Offset[OFFMEM_ADDR_WIDTH-1:0]),
.ACCELERATOR_IF_ROWS(Cnn_Accelerator_If_Rows[BITWIDTH_IF_ROWS-1:0]),
.ACCELERATOR_IF_COLUMS(Cnn_Accelerator_If_Colums[BITWIDTH_IF_COLUMS-1:0]),
.ACCELERATOR_IF_CHANNELS(Cnn_Accelerator_If_Channels[BITWIDTH_IF_CHANNELS-1:0]),
.ACCELERATOR_OF_ROWS(Cnn_Accelerator_Of_Rows[BITWIDTH_IF_ROWS-1:0]),
.ACCELERATOR_OF_COLUMS(Cnn_Accelerator_Of_Colums[BITWIDTH_IF_COLUMS-1:0]),
.ACCELERATOR_W_ROWS(Cnn_Accelerator_W_Rows[BITWIDTH_W_ROWS-1:0]),
.ACCELERATOR_W_COLUMS(Cnn_Accelerator_W_Colums[BITWIDTH_W_COLUMS-1:0]),
.ACCELERATOR_W_CHANNELS(Cnn_Accelerator_W_Channels[BITWIDTH_IF_CHANNELS-1:0]),
.ACCELERATOR_SAME_W(AVS_Counduit_Same_W),
.ACCELERATOR_CONV_STRIDE(Cnn_Accelerator_Stride[BITWIDTH_STRIDE-1:0]),
.ACCELERATOR_START(AVS_Counduit_Start),
.ACCELERATOR_FINISHED_OK(AVS_Counduit_Finished_Ok),

//////////// OUTPUTS //////////
.ACCELERATOR_DATA_OUT(Cnn_Accelerator_Data_Out),
.ACCELERATOR_MEM_ADDR(Cnn_Accelerator_Addr),
.ACCELERATOR_MEM_WE(AVS_m0_write),
.ACCELERATOR_MEM_RE(AVS_m0_read),
.ACCELERATOR_FINISHED(AVS_Counduit_Finished)
);




always@(Cnn_Accelerator_Addr)
begin
	addr=Cnn_Accelerator_Addr[15:0]*DATA4;
end

//=======================================================
//  Combinational logic output
//=======================================================
assign AVS_m0_writedata= {{16{Cnn_Accelerator_Data_Out[15]}},Cnn_Accelerator_Data_Out};
assign AVS_m0_adress = addr;
assign AVS_m0_byteenable=BYTEENABLE;



endmodule
