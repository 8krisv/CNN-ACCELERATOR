/*#########################################################################
//# Top mododule For the convolution hardware accelerator
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

module ACCELERATOR(

//////////// INPUTS //////////
ACCELERATOR_Clk_50,
ACCELERATOR_Reset,
ACCELERATOR_DATA_IN,
ACCELERATOR_ADDR_OFFSET,
ACCELERATOR_IF_ROWS,
ACCELERATOR_IF_COLUMS,
ACCELERATOR_IF_CHANNELS,
ACCELERATOR_OF_ROWS,
ACCELERATOR_OF_COLUMS,
ACCELERATOR_W_ROWS,
ACCELERATOR_W_COLUMS,
ACCELERATOR_W_CHANNELS,
ACCELERATOR_SAME_W,
ACCELERATOR_CONV_STRIDE,
ACCELERATOR_START,
ACCELERATOR_FINISHED_OK,

//////////// OUTPUTS //////////

ACCELERATOR_DATA_OUT,
ACCELERATOR_MEM_ADDR,
ACCELERATOR_MEM_WE,
ACCELERATOR_MEM_RE,
ACCELERATOR_FINISHED

);


//=======================================================
//  Parameter declarations
//=======================================================

parameter OFFMEM_DATA_WIDTH=16;
parameter OFFMEM_ADDR_WIDTH = 32;
parameter BITWIDTH_DATA_OUT=16; 
parameter BITWIDTH_ROW_W=4; 
parameter BITWIDTH_IF_ROWS=10; 
parameter BITWIDTH_IF_COLUMS = 11; 
parameter BITWIDTH_W_ROWS=4;
parameter BITWIDTH_W_COLUMS=4; 
parameter BITWIDTH_MAX_W_SIZE=9;
parameter BITWIDTH_STRIDE=4; 
parameter BITWIDTH_IF_CHANNELS=2; 
parameter W_MEM_DATAWIDTH = 16;
parameter W_MAX_MEM_SIZE = 507;
parameter W_MEM_ADDR_WIDTH = 9;
parameter IF_DATAWIDTH = 16;
parameter IF_BITWIDTH_MAXSIZE = 22;
parameter PE_DATAOUT_WIDTH = 16;
parameter FIFO_SIZE=720;
parameter FIFO_ADDR_WIDTH=10;
parameter LENGTHBUS=36;
localparam FIFO_Rdinc=1'b1;
localparam FIFO_Wrinc=1'b1;
localparam [PE_DATAOUT_WIDTH-1:0] PEO_IS= 0;

//=======================================================
//  PORT declarations
//=======================================================

input ACCELERATOR_Clk_50;
input ACCELERATOR_Reset;
input [OFFMEM_DATA_WIDTH-1:0] ACCELERATOR_DATA_IN;
input [OFFMEM_ADDR_WIDTH-1:0] ACCELERATOR_ADDR_OFFSET;
input [BITWIDTH_IF_ROWS-1:0] ACCELERATOR_IF_ROWS;
input [BITWIDTH_IF_COLUMS-1:0] ACCELERATOR_IF_COLUMS;
input [BITWIDTH_IF_CHANNELS-1:0] ACCELERATOR_IF_CHANNELS;
input [BITWIDTH_IF_ROWS-1:0] ACCELERATOR_OF_ROWS;
input [BITWIDTH_IF_COLUMS-1:0] ACCELERATOR_OF_COLUMS;
input [BITWIDTH_W_ROWS-1:0] ACCELERATOR_W_ROWS;
input [BITWIDTH_W_COLUMS-1:0] ACCELERATOR_W_COLUMS;
input [BITWIDTH_IF_CHANNELS-1:0] ACCELERATOR_W_CHANNELS;
input ACCELERATOR_SAME_W;
input [BITWIDTH_STRIDE-1:0] ACCELERATOR_CONV_STRIDE;
input ACCELERATOR_START;
input ACCELERATOR_FINISHED_OK;

output [BITWIDTH_DATA_OUT-1:0] ACCELERATOR_DATA_OUT;
output [OFFMEM_ADDR_WIDTH-1:0] ACCELERATOR_MEM_ADDR;
output ACCELERATOR_MEM_WE;
output ACCELERATOR_MEM_RE;
output ACCELERATOR_FINISHED;



//=======================================================
//  REG/WIRE declarations
//=======================================================

//Owmc output wires//
wire Owmc_Loading_Weights_Already;
wire Owmc_Loading_Regs_Already;
wire [W_MEM_DATAWIDTH-1:0] Owmc_Output_Data;
wire Owmc_Muxes_En;
wire [W_MEM_ADDR_WIDTH-1:0] Owmc_Muxes_Sel;


//OMDC output wires//
wire Omdc_Routine_Finished_Already;
wire Omdc_control_channel_select_en;
wire Omdc_new_channel_flag;
wire Omdc_In_Output_Routine;

wire Omdc_SetEn0;
wire Omdc_SetEn1;
wire Omdc_SetEn2;
wire Omdc_SetEn3;
wire Omdc_SetEn4;
wire Omdc_SetEn5;
wire Omdc_SetEn6;
wire Omdc_SetEn7;
wire Omdc_SetEn8;
wire Omdc_SetEn9;
wire Omdc_SetEn10;
wire Omdc_SetEn11;
wire Omdc_SetEn12;
wire Omdc_OEn0;
wire Omdc_OEn1;
wire Omdc_OEn2;
wire Omdc_OEn3;
wire Omdc_OEn4;
wire Omdc_OEn5;
wire Omdc_OEn6;
wire Omdc_OEn7;
wire Omdc_OEn8;
wire Omdc_OEn9;
wire Omdc_OEn10;
wire Omdc_OEn11;
wire Omdc_OEn12;
wire Omdc_Wptclr0;
wire Omdc_Wptclr1;
wire Omdc_Wptclr2;
wire Omdc_Wptclr3;
wire Omdc_Wptclr4;
wire Omdc_Wptclr5;
wire Omdc_Wptclr6;
wire Omdc_Wptclr7;
wire Omdc_Wptclr8;
wire Omdc_Wptclr9;
wire Omdc_Wptclr10;
wire Omdc_Wptclr11;
wire Omdc_Wptclr12;
wire Omdc_Rptclr0;
wire Omdc_Rptclr1;
wire Omdc_Rptclr2;
wire Omdc_Rptclr3;
wire Omdc_Rptclr4;
wire Omdc_Rptclr5;
wire Omdc_Rptclr6;
wire Omdc_Rptclr7;
wire Omdc_Rptclr8;
wire Omdc_Rptclr9;
wire Omdc_Rptclr10;
wire Omdc_Rptclr11;
wire Omdc_Rptclr12;


//Ofmi output wires//
wire Ofmi_Mux_Sel;
wire Ofmi_Mux_En;
wire Ofmi_Loading_Weights_Already;
wire Ofmi_Feeding_Datapath_Finished;
wire Ofmi_Writing_Data_Already;

//Demux_1_2 output wires//
wire [OFFMEM_DATA_WIDTH-1:0] Demux_1_2_W;
wire [OFFMEM_DATA_WIDTH-1:0] Demux_1_2_If;

//Demux_Data output wires//
wire [W_MEM_DATAWIDTH-1:0] Demux_Data_Out0;
wire [W_MEM_DATAWIDTH-1:0] Demux_Data_Out1;
wire [W_MEM_DATAWIDTH-1:0] Demux_Data_Out2;
wire [W_MEM_DATAWIDTH-1:0] Demux_Data_Out3;
wire [W_MEM_DATAWIDTH-1:0] Demux_Data_Out4;
wire [W_MEM_DATAWIDTH-1:0] Demux_Data_Out5;
wire [W_MEM_DATAWIDTH-1:0] Demux_Data_Out6;
wire [W_MEM_DATAWIDTH-1:0] Demux_Data_Out7;
wire [W_MEM_DATAWIDTH-1:0] Demux_Data_Out8;
wire [W_MEM_DATAWIDTH-1:0] Demux_Data_Out9;
wire [W_MEM_DATAWIDTH-1:0] Demux_Data_Out10;
wire [W_MEM_DATAWIDTH-1:0] Demux_Data_Out11;
wire [W_MEM_DATAWIDTH-1:0] Demux_Data_Out12;
wire [W_MEM_DATAWIDTH-1:0] Demux_Data_Out13;
wire [W_MEM_DATAWIDTH-1:0] Demux_Data_Out14;
wire [W_MEM_DATAWIDTH-1:0] Demux_Data_Out15;
wire [W_MEM_DATAWIDTH-1:0] Demux_Data_Out16;
wire [W_MEM_DATAWIDTH-1:0] Demux_Data_Out17;
wire [W_MEM_DATAWIDTH-1:0] Demux_Data_Out18;
wire [W_MEM_DATAWIDTH-1:0] Demux_Data_Out19;
wire [W_MEM_DATAWIDTH-1:0] Demux_Data_Out20;
wire [W_MEM_DATAWIDTH-1:0] Demux_Data_Out21;
wire [W_MEM_DATAWIDTH-1:0] Demux_Data_Out22;
wire [W_MEM_DATAWIDTH-1:0] Demux_Data_Out23;
wire [W_MEM_DATAWIDTH-1:0] Demux_Data_Out24;
wire [W_MEM_DATAWIDTH-1:0] Demux_Data_Out25;
wire [W_MEM_DATAWIDTH-1:0] Demux_Data_Out26;
wire [W_MEM_DATAWIDTH-1:0] Demux_Data_Out27;
wire [W_MEM_DATAWIDTH-1:0] Demux_Data_Out28;
wire [W_MEM_DATAWIDTH-1:0] Demux_Data_Out29;
wire [W_MEM_DATAWIDTH-1:0] Demux_Data_Out30;
wire [W_MEM_DATAWIDTH-1:0] Demux_Data_Out31;
wire [W_MEM_DATAWIDTH-1:0] Demux_Data_Out32;
wire [W_MEM_DATAWIDTH-1:0] Demux_Data_Out33;
wire [W_MEM_DATAWIDTH-1:0] Demux_Data_Out34;
wire [W_MEM_DATAWIDTH-1:0] Demux_Data_Out35;

//Demux_Set output wires//
wire Demux_Set_Out0;
wire Demux_Set_Out1;
wire Demux_Set_Out2;
wire Demux_Set_Out3;
wire Demux_Set_Out4;
wire Demux_Set_Out5;
wire Demux_Set_Out6;
wire Demux_Set_Out7;
wire Demux_Set_Out8;
wire Demux_Set_Out9;
wire Demux_Set_Out10;
wire Demux_Set_Out11;
wire Demux_Set_Out12;
wire Demux_Set_Out13;
wire Demux_Set_Out14;
wire Demux_Set_Out15;
wire Demux_Set_Out16;
wire Demux_Set_Out17;
wire Demux_Set_Out18;
wire Demux_Set_Out19;
wire Demux_Set_Out20;
wire Demux_Set_Out21;
wire Demux_Set_Out22;
wire Demux_Set_Out23;
wire Demux_Set_Out24;
wire Demux_Set_Out25;
wire Demux_Set_Out26;
wire Demux_Set_Out27;
wire Demux_Set_Out28;
wire Demux_Set_Out29;
wire Demux_Set_Out30;
wire Demux_Set_Out31;
wire Demux_Set_Out32;
wire Demux_Set_Out33;
wire Demux_Set_Out34;
wire Demux_Set_Out35;

//Weight register output wires//
wire [W_MEM_DATAWIDTH-1:0] Wreg0_Output_Data;
wire [W_MEM_DATAWIDTH-1:0] Wreg1_Output_Data;
wire [W_MEM_DATAWIDTH-1:0] Wreg2_Output_Data;
wire [W_MEM_DATAWIDTH-1:0] Wreg3_Output_Data;
wire [W_MEM_DATAWIDTH-1:0] Wreg4_Output_Data;
wire [W_MEM_DATAWIDTH-1:0] Wreg5_Output_Data;
wire [W_MEM_DATAWIDTH-1:0] Wreg6_Output_Data;
wire [W_MEM_DATAWIDTH-1:0] Wreg7_Output_Data;
wire [W_MEM_DATAWIDTH-1:0] Wreg8_Output_Data;
wire [W_MEM_DATAWIDTH-1:0] Wreg9_Output_Data;
wire [W_MEM_DATAWIDTH-1:0] Wreg10_Output_Data;
wire [W_MEM_DATAWIDTH-1:0] Wreg11_Output_Data;
wire [W_MEM_DATAWIDTH-1:0] Wreg12_Output_Data;
wire [W_MEM_DATAWIDTH-1:0] Wreg13_Output_Data;
wire [W_MEM_DATAWIDTH-1:0] Wreg14_Output_Data;
wire [W_MEM_DATAWIDTH-1:0] Wreg15_Output_Data;
wire [W_MEM_DATAWIDTH-1:0] Wreg16_Output_Data;
wire [W_MEM_DATAWIDTH-1:0] Wreg17_Output_Data;
wire [W_MEM_DATAWIDTH-1:0] Wreg18_Output_Data;
wire [W_MEM_DATAWIDTH-1:0] Wreg19_Output_Data;
wire [W_MEM_DATAWIDTH-1:0] Wreg20_Output_Data;
wire [W_MEM_DATAWIDTH-1:0] Wreg21_Output_Data;
wire [W_MEM_DATAWIDTH-1:0] Wreg22_Output_Data;
wire [W_MEM_DATAWIDTH-1:0] Wreg23_Output_Data;
wire [W_MEM_DATAWIDTH-1:0] Wreg24_Output_Data;
wire [W_MEM_DATAWIDTH-1:0] Wreg25_Output_Data;
wire [W_MEM_DATAWIDTH-1:0] Wreg26_Output_Data;
wire [W_MEM_DATAWIDTH-1:0] Wreg27_Output_Data;
wire [W_MEM_DATAWIDTH-1:0] Wreg28_Output_Data;
wire [W_MEM_DATAWIDTH-1:0] Wreg29_Output_Data;
wire [W_MEM_DATAWIDTH-1:0] Wreg30_Output_Data;
wire [W_MEM_DATAWIDTH-1:0] Wreg31_Output_Data;
wire [W_MEM_DATAWIDTH-1:0] Wreg32_Output_Data;
wire [W_MEM_DATAWIDTH-1:0] Wreg33_Output_Data;
wire [W_MEM_DATAWIDTH-1:0] Wreg34_Output_Data;
wire [W_MEM_DATAWIDTH-1:0] Wreg35_Output_Data;


//Processing elements output wires//
wire [PE_DATAOUT_WIDTH-1:0] Pe0_Output;
wire [PE_DATAOUT_WIDTH-1:0] Pe1_Output;
wire [PE_DATAOUT_WIDTH-1:0] Pe2_Output;
wire [PE_DATAOUT_WIDTH-1:0] Pe3_Output;
wire [PE_DATAOUT_WIDTH-1:0] Pe4_Output;
wire [PE_DATAOUT_WIDTH-1:0] Pe5_Output;
wire [PE_DATAOUT_WIDTH-1:0] Pe6_Output;
wire [PE_DATAOUT_WIDTH-1:0] Pe7_Output;
wire [PE_DATAOUT_WIDTH-1:0] Pe8_Output;
wire [PE_DATAOUT_WIDTH-1:0] Pe9_Output;
wire [PE_DATAOUT_WIDTH-1:0] Pe10_Output;
wire [PE_DATAOUT_WIDTH-1:0] Pe11_Output;
wire [PE_DATAOUT_WIDTH-1:0] Pe12_Output;
wire [PE_DATAOUT_WIDTH-1:0] Pe13_Output;
wire [PE_DATAOUT_WIDTH-1:0] Pe14_Output;
wire [PE_DATAOUT_WIDTH-1:0] Pe15_Output;
wire [PE_DATAOUT_WIDTH-1:0] Pe16_Output;
wire [PE_DATAOUT_WIDTH-1:0] Pe17_Output;
wire [PE_DATAOUT_WIDTH-1:0] Pe18_Output;
wire [PE_DATAOUT_WIDTH-1:0] Pe19_Output;
wire [PE_DATAOUT_WIDTH-1:0] Pe20_Output;
wire [PE_DATAOUT_WIDTH-1:0] Pe21_Output;
wire [PE_DATAOUT_WIDTH-1:0] Pe22_Output;
wire [PE_DATAOUT_WIDTH-1:0] Pe23_Output;
wire [PE_DATAOUT_WIDTH-1:0] Pe24_Output;
wire [PE_DATAOUT_WIDTH-1:0] Pe25_Output;
wire [PE_DATAOUT_WIDTH-1:0] Pe26_Output;
wire [PE_DATAOUT_WIDTH-1:0] Pe27_Output;
wire [PE_DATAOUT_WIDTH-1:0] Pe28_Output;
wire [PE_DATAOUT_WIDTH-1:0] Pe29_Output;
wire [PE_DATAOUT_WIDTH-1:0] Pe30_Output;
wire [PE_DATAOUT_WIDTH-1:0] Pe31_Output;
wire [PE_DATAOUT_WIDTH-1:0] Pe32_Output;
wire [PE_DATAOUT_WIDTH-1:0] Pe33_Output;
wire [PE_DATAOUT_WIDTH-1:0] Pe34_Output;
wire [PE_DATAOUT_WIDTH-1:0] Pe35_Output;

//Processing elements dataflow controller output wires//
wire Pedc_OutReg_Set;
wire Pedc_Reset;

//Fclock output wire//
wire Fclock_clk;

//On-chip fifo memories output wires//
wire [PE_DATAOUT_WIDTH-1:0] Ofifo0_Output;
wire [PE_DATAOUT_WIDTH-1:0] Ofifo1_Output;
wire [PE_DATAOUT_WIDTH-1:0] Ofifo2_Output;
wire [PE_DATAOUT_WIDTH-1:0] Ofifo3_Output;
wire [PE_DATAOUT_WIDTH-1:0] Ofifo4_Output;
wire [PE_DATAOUT_WIDTH-1:0] Ofifo5_Output;
wire [PE_DATAOUT_WIDTH-1:0] Ofifo6_Output;
wire [PE_DATAOUT_WIDTH-1:0] Ofifo7_Output;
wire [PE_DATAOUT_WIDTH-1:0] Ofifo8_Output;
wire [PE_DATAOUT_WIDTH-1:0] Ofifo9_Output;
wire [PE_DATAOUT_WIDTH-1:0] Ofifo10_Output;
wire [PE_DATAOUT_WIDTH-1:0] Ofifo11_Output;
wire [PE_DATAOUT_WIDTH-1:0] Ofifo12_Output;
wire [PE_DATAOUT_WIDTH-1:0] Ofifo13_Output;
wire [PE_DATAOUT_WIDTH-1:0] Ofifo14_Output;
wire [PE_DATAOUT_WIDTH-1:0] Ofifo15_Output;
wire [PE_DATAOUT_WIDTH-1:0] Ofifo16_Output;
wire [PE_DATAOUT_WIDTH-1:0] Ofifo17_Output;
wire [PE_DATAOUT_WIDTH-1:0] Ofifo18_Output;
wire [PE_DATAOUT_WIDTH-1:0] Ofifo19_Output;
wire [PE_DATAOUT_WIDTH-1:0] Ofifo20_Output;
wire [PE_DATAOUT_WIDTH-1:0] Ofifo21_Output;
wire [PE_DATAOUT_WIDTH-1:0] Ofifo22_Output;
wire [PE_DATAOUT_WIDTH-1:0] Ofifo23_Output;
wire [PE_DATAOUT_WIDTH-1:0] Ofifo24_Output;
wire [PE_DATAOUT_WIDTH-1:0] Ofifo25_Output;
wire [PE_DATAOUT_WIDTH-1:0] Ofifo26_Output;
wire [PE_DATAOUT_WIDTH-1:0] Ofifo27_Output;
wire [PE_DATAOUT_WIDTH-1:0] Ofifo28_Output;
wire [PE_DATAOUT_WIDTH-1:0] Ofifo29_Output;
wire [PE_DATAOUT_WIDTH-1:0] Ofifo30_Output;
wire [PE_DATAOUT_WIDTH-1:0] Ofifo31_Output;
wire [PE_DATAOUT_WIDTH-1:0] Ofifo32_Output;
wire [PE_DATAOUT_WIDTH-1:0] Ofifo33_Output;
wire [PE_DATAOUT_WIDTH-1:0] Ofifo34_Output;
wire [PE_DATAOUT_WIDTH-1:0] Ofifo35_Output;

//2 to 1 multiplexer output wires//
wire [PE_DATAOUT_WIDTH-1:0] Mux0_Output;
wire [PE_DATAOUT_WIDTH-1:0] Mux1_Output;
wire [PE_DATAOUT_WIDTH-1:0] Mux2_Output;
wire [PE_DATAOUT_WIDTH-1:0] Mux3_Output;
wire [PE_DATAOUT_WIDTH-1:0] Mux4_Output;
wire [PE_DATAOUT_WIDTH-1:0] Mux5_Output;
wire [PE_DATAOUT_WIDTH-1:0] Mux6_Output;
wire [PE_DATAOUT_WIDTH-1:0] Mux7_Output;
wire [PE_DATAOUT_WIDTH-1:0] Mux8_Output;
wire [PE_DATAOUT_WIDTH-1:0] Mux9_Output;
wire [PE_DATAOUT_WIDTH-1:0] Mux10_Output;
wire [PE_DATAOUT_WIDTH-1:0] Mux11_Output;
wire [PE_DATAOUT_WIDTH-1:0] Mux12_Output;
wire [PE_DATAOUT_WIDTH-1:0] Mux13_Output;
wire [PE_DATAOUT_WIDTH-1:0] Mux14_Output;
wire [PE_DATAOUT_WIDTH-1:0] Mux15_Output;
wire [PE_DATAOUT_WIDTH-1:0] Mux16_Output;
wire [PE_DATAOUT_WIDTH-1:0] Mux17_Output;
wire [PE_DATAOUT_WIDTH-1:0] Mux18_Output;
wire [PE_DATAOUT_WIDTH-1:0] Mux19_Output;
wire [PE_DATAOUT_WIDTH-1:0] Mux20_Output;
wire [PE_DATAOUT_WIDTH-1:0] Mux21_Output;
wire [PE_DATAOUT_WIDTH-1:0] Mux22_Output;
wire [PE_DATAOUT_WIDTH-1:0] Mux23_Output;
wire [PE_DATAOUT_WIDTH-1:0] Mux24_Output;
wire [PE_DATAOUT_WIDTH-1:0] Mux25_Output;
wire [PE_DATAOUT_WIDTH-1:0] Mux26_Output;
wire [PE_DATAOUT_WIDTH-1:0] Mux27_Output;
wire [PE_DATAOUT_WIDTH-1:0] Mux28_Output;
wire [PE_DATAOUT_WIDTH-1:0] Mux29_Output;
wire [PE_DATAOUT_WIDTH-1:0] Mux30_Output;
wire [PE_DATAOUT_WIDTH-1:0] Mux31_Output;
wire [PE_DATAOUT_WIDTH-1:0] Mux32_Output;
wire [PE_DATAOUT_WIDTH-1:0] Mux33_Output;
wire [PE_DATAOUT_WIDTH-1:0] Mux34_Output;

//Calc unit output wires//
wire [IF_BITWIDTH_MAXSIZE-1:0] Calc_Unit_If_Size_1;
wire [W_MEM_ADDR_WIDTH-1:0] Calc_Unit_W_Size_1;
wire [IF_BITWIDTH_MAXSIZE-1:0] Calc_Unit_Of_Size_1;
wire [W_MEM_ADDR_WIDTH-1:0] Calc_Unit_W_ROXCL_1;
wire [BITWIDTH_W_COLUMS-1:0] Calc_Unit_W_Colums_1;


//Main state machine output wires//
wire Main_Stm_Owmc_Reset;
wire Main_Stm_Owmc_Start_Loading_Weight;
wire Main_Stm_Owmc_Start_Loading_Regs;
wire Main_Stm_Loading_Weights_Already_Ok;
wire Main_Stm_Owmc_Loading_Regs_Already_Ok;
wire Main_Stm_Ofmi_Reset;
wire Main_Stm_Ofmi_Start_Loading_Weights;
wire Main_Stm_Ofmi_Start_Feeding_Datapath;
wire Main_Stm_Ofmi_Stop_Feeding_Datapath;
wire Main_Stm_Ofmi_Feeding_Datapath_finished_OK;
wire Main_Stm_Ofmi_Start_Writing_Data;
wire Main_Stm_Ofmi_Writing_Data_Already_Ok;
wire Main_Stm_Omdc_Reset;
wire Main_Stm_Omdc_Start_Routine;
wire Main_Stm_Omdc_Stop_Routine;
wire Main_Stm_Omdc_Finish_Routine;
wire Main_Stm_Routine_Finished_Ok;
wire Main_Stm_Wregs_Reset;
wire Main_Stm_Pedc_Start_Routine;
wire Main_Stm_Pedc_Stop_Routine;
wire Main_Stm_Channel_Controller_Reset;
wire Main_Stm_Channel_Controller_Start;
wire Main_Stm_Adder_Start_Routine;
wire Main_Stm_Rbus_Reset;
wire Main_Stm_Rbus_Set_Conf;
wire Main_Stm_Rbus_Set_Conf_Already_Ok;
wire Main_Stm_Muxdc_Reset;
wire Main_Stm_Muxdc_Set_Conf;
wire Main_Stm_Muxdc_Set_Conf_Already_Ok;
wire Main_Stm_Adder_Routine_Finished_Already_Ok;

//////////// mux169 output wires //////////
wire [PE_DATAOUT_WIDTH-1:0] Mux169_DataOut;


//////////// Memories_Channel output wires //////////
wire [PE_DATAOUT_WIDTH-1:0] Memories_Channel_Out_Mem1;
wire [PE_DATAOUT_WIDTH-1:0] Memories_Channel_Out_Mem2;
wire [PE_DATAOUT_WIDTH-1:0] Memories_Channel_Out_Mem3;

//////////// Adder output wires //////////
wire Adder_Channel_Mems_Re;
wire Adder_Routine_Finished_Already;

//////////// Reconfigurable bus output wires //////////
wire [0:LENGTHBUS-1] Rbus_Om_SetEn;
wire [0:LENGTHBUS-1] Rbus_Om_OEn;
wire [0:LENGTHBUS-1] Rbus_Om_Wptclr;
wire [0:LENGTHBUS-1] Rbus_Om_Rptclr;
wire Rbus_Set_Conf_Already;


//////////// multiplexers dataflow output wires //////////
wire [0:LENGTHBUS-2] Muxdc_Muxes_Sel;
wire Muxdc_Set_Conf_Already;



//=======================================================
//  Structural coding
//=======================================================

//////////// On-chip weight memory controller instantACCELERATOR_IF_ROWSiation //////////

OWMC #(.W_DATA_WIDTH(W_MEM_DATAWIDTH),.W_MEM_SIZE(W_MAX_MEM_SIZE),.W_ADDR_WIDTH(W_MEM_ADDR_WIDTH)) Owmc
(

/////////// INPUTS //////////
.OWMC_Clk(ACCELERATOR_Clk_50),
.OWMC_Reset(Main_Stm_Owmc_Reset),
.OWMC_W_Size(Calc_Unit_W_Size_1), /*Weight matriz size -1*/
.OWMC_W_COXRW(Calc_Unit_W_ROXCL_1),/*Weight matriz channel size -1*/
.OWMC_Input_Data(Demux_1_2_W[W_MEM_DATAWIDTH-1:0]),
.OWMC_Start_Loading_Weights(Main_Stm_Owmc_Start_Loading_Weight),
.OWMC_Start_Loading_Regs(Main_Stm_Owmc_Start_Loading_Regs),
.OWMC_Loading_Weights_Already_Ok(Main_Stm_Loading_Weights_Already_Ok),
.OWMC_Loading_Regs_Already_Ok(Main_Stm_Owmc_Loading_Regs_Already_Ok),

//////////// OUTPUTS //////////Omdc
.OWMC_Loading_Weights_Already(Owmc_Loading_Weights_Already),
.OWMC_Loading_Regs_Already(Owmc_Loading_Regs_Already),
.OWMC_Output_Data(Owmc_Output_Data),
.OWMC_Muxes_En(Owmc_Muxes_En),
.OWMC_Muxes_Sel(Owmc_Muxes_Sel)

);

//////////// Off-chip memory interface instantiation //////////

OFMI #(.W_ADDR_WIDTH(W_MEM_ADDR_WIDTH),.IF_BITWIDTH_MAXSIZE(IF_BITWIDTH_MAXSIZE), .OFFMEN_ADDR_WIDTH(OFFMEM_ADDR_WIDTH)) Ofmi
(

//////////// INPUTS //////////
.OFMI_Clk(ACCELERATOR_Clk_50),
.OFMI_Reset(Main_Stm_Ofmi_Reset),
.OFMI_If_Size(Calc_Unit_If_Size_1), /*Input feature size -1*/
.OFMI_Of_Size(Calc_Unit_Of_Size_1), /*output feature size -1*/
.OFMI_W_Size(Calc_Unit_W_Size_1), /*Weight matriz size -1*/
.OFMI_Addr_Offset(ACCELERATOR_ADDR_OFFSET),
.OFMI_Mst_Start_Loading_Weights(Main_Stm_Ofmi_Start_Loading_Weights),
.OFMI_Mst_Loading_Weights_Already_Ok(Main_Stm_Loading_Weights_Already_Ok),
.OFMI_Owmc_Loading_Weights_Already(Owmc_Loading_Weights_Already),
.OFMI_Mst_Start_Feeding_Datapath(Main_Stm_Ofmi_Start_Feeding_Datapath),
.OFMI_Mst_Stop_Feeding_Datapath(Main_Stm_Ofmi_Stop_Feeding_Datapath),
.OFMI_Feeding_Datapath_finished_OK(Main_Stm_Ofmi_Feeding_Datapath_finished_OK),
.OFMI_Mst_Start_Writing_Data(Main_Stm_Ofmi_Start_Writing_Data),
.OFMI_Mst_Writing_Data_Already_Ok(Main_Stm_Ofmi_Writing_Data_Already_Ok),

//////////// OUTPUTS //////////
.OFMI_Mst_Loading_Weights_Already(Ofmi_Loading_Weights_Already),
.OFMI_Mst_Feeding_Datapath_finished(Ofmi_Feeding_Datapath_Finished),
.OFMI_Mst_Writing_Data_Already(Ofmi_Writing_Data_Already),
.OFMI_Offmem_We(ACCELERATOR_MEM_WE),
.OFMI_Offmem_Re(ACCELERATOR_MEM_RE),
.OFMI_Offmem_Addr(ACCELERATOR_MEM_ADDR),
.OFMI_Mux_Sel(Ofmi_Mux_Sel),
.OFMI_Mux_En(Ofmi_Mux_En)


);

//////////// 1 to 2 Demultiplexer instantiation //////////

DEMUX_1_2 #(.INPUT_DATA_WIDTH(OFFMEM_DATA_WIDTH)) Demux_1_2
(

//// INPUTS ////
.DEMUX_Data_in(ACCELERATOR_DATA_IN),
.DEMUX_selector(Ofmi_Mux_Sel),
.DEMUX_En(Ofmi_Mux_En),
//// OUTPUTS ////
.DEMUX_out0(Demux_1_2_W),
.DEMUX_out1(Demux_1_2_If)

);

//////////// Off-chip fifo memory dataflow controller instantiation //////////

OMDC #(

.BITWIDTH_ROW(BITWIDTH_ROW_W),
.BITWIDTH_IF_ROWS(BITWIDTH_IF_ROWS),
.BITWIDTH_IF_COLUMS(BITWIDTH_IF_COLUMS),
.BITWIDTH_OF_COLUMS(BITWIDTH_IF_COLUMS),
.BITWIDTH_W_ROWS(BITWIDTH_W_ROWS),
.BITWIDTH_W_COLUMS(BITWIDTH_W_COLUMS),
.BITWIDTH_STRIDE(BITWIDTH_STRIDE)) Omdc
(

//////////// INPUTS //////////
.OMDC_Clk(ACCELERATOR_Clk_50),
.OMDC_Reset(Main_Stm_Omdc_Reset),
.OMDC_W_Colums(Calc_Unit_W_Colums_1),
.OMDC_W_Rows(ACCELERATOR_W_ROWS),
.OMDC_Conv_Stride(ACCELERATOR_CONV_STRIDE),
.OMDC_Of_Colums(ACCELERATOR_OF_COLUMS),
.OMDC_If_Colums(ACCELERATOR_IF_COLUMS),
.OMDC_If_Rows(ACCELERATOR_IF_ROWS),
.OMDC_Start_Routine(Main_Stm_Omdc_Start_Routine),
.OMDC_Stop_Routine(Main_Stm_Omdc_Stop_Routine),
.OMDC_Finish_Routine(Main_Stm_Omdc_Finish_Routine),
.OMDC_Routine_Finished_Ok(Main_Stm_Routine_Finished_Ok),

//////////// OUTPUTS //////////
.OMDC_Routine_Finished_Already(Omdc_Routine_Finished_Already),
.OMDC_control_channel_select_en(Omdc_control_channel_select_en),
.OMDC_new_channel_flag(Omdc_new_channel_flag),
.OMDC_In_Output_Routine(Omdc_In_Output_Routine),

.OMDC_SetEn0(Omdc_SetEn0),
.OMDC_OEn0(Omdc_OEn0),
.OMDC_Wptclr0(Omdc_Wptclr0),
.OMDC_Rptclr0(Omdc_Rptclr0),

.OMDC_SetEn1(Omdc_SetEn1),
.OMDC_OEn1(Omdc_OEn1),
.OMDC_Wptclr1(Omdc_Wptclr1),
.OMDC_Rptclr1(Omdc_Rptclr1),

.OMDC_SetEn2(Omdc_SetEn2),
.OMDC_OEn2(Omdc_OEn2),
.OMDC_Wptclr2(Omdc_Wptclr2),
.OMDC_Rptclr2(Omdc_Rptclr2),

.OMDC_SetEn3(Omdc_SetEn3),
.OMDC_OEn3(Omdc_OEn3),
.OMDC_Wptclr3(Omdc_Wptclr3),
.OMDC_Rptclr3(Omdc_Rptclr3),

.OMDC_SetEn4(Omdc_SetEn4),
.OMDC_OEn4(Omdc_OEn4),
.OMDC_Wptclr4(Omdc_Wptclr4),
.OMDC_Rptclr4(Omdc_Rptclr4),

.OMDC_SetEn5(Omdc_SetEn5),
.OMDC_OEn5(Omdc_OEn5),
.OMDC_Wptclr5(Omdc_Wptclr5),
.OMDC_Rptclr5(Omdc_Rptclr5),

.OMDC_SetEn6(Omdc_SetEn6),
.OMDC_OEn6(Omdc_OEn6),
.OMDC_Wptclr6(Omdc_Wptclr6),
.OMDC_Rptclr6(Omdc_Rptclr6),

.OMDC_SetEn7(Omdc_SetEn7),
.OMDC_OEn7(Omdc_OEn7),
.OMDC_Wptclr7(Omdc_Wptclr7),
.OMDC_Rptclr7(Omdc_Rptclr7),

.OMDC_SetEn8(Omdc_SetEn8),
.OMDC_OEn8(Omdc_OEn8),
.OMDC_Wptclr8(Omdc_Wptclr8),
.OMDC_Rptclr8(Omdc_Rptclr8),

.OMDC_SetEn9(Omdc_SetEn9),
.OMDC_OEn9(Omdc_OEn9),
.OMDC_Wptclr9(Omdc_Wptclr9),
.OMDC_Rptclr9(Omdc_Rptclr9),

.OMDC_SetEn10(Omdc_SetEn10),
.OMDC_OEn10(Omdc_OEn10),
.OMDC_Wptclr10(Omdc_Wptclr10),
.OMDC_Rptclr10(Omdc_Rptclr10),

.OMDC_SetEn11(Omdc_SetEn11),
.OMDC_OEn11(Omdc_OEn11),
.OMDC_Wptclr11(Omdc_Wptclr11),
.OMDC_Rptclr11(Omdc_Rptclr11),

.OMDC_SetEn12(Omdc_SetEn12),
.OMDC_OEn12(Omdc_OEn12),
.OMDC_Wptclr12(Omdc_Wptclr12),
.OMDC_Rptclr12(Omdc_Rptclr12)



);


//////////// Demultiplexer instantiation //////////

DEMUX_169 #(.INPUT_DATA_WIDTH(W_MEM_DATAWIDTH)) Demux_Data
(

//////////// INPUTS ///////////
.DEMUX_Data_in(Owmc_Output_Data),
.DEMUX_selector(Owmc_Muxes_Sel),
.DEMUX_En(Owmc_Muxes_En),

//////////// OUTPUTS //////////
.DEMUX_out0(Demux_Data_Out0),
.DEMUX_out1(Demux_Data_Out1),
.DEMUX_out2(Demux_Data_Out2),
.DEMUX_out3(Demux_Data_Out3),
.DEMUX_out4(Demux_Data_Out4),
.DEMUX_out5(Demux_Data_Out5),
.DEMUX_out6(Demux_Data_Out6),
.DEMUX_out7(Demux_Data_Out7),
.DEMUX_out8(Demux_Data_Out8),
.DEMUX_out9(Demux_Data_Out9),
.DEMUX_out10(Demux_Data_Out10),
.DEMUX_out11(Demux_Data_Out11),
.DEMUX_out12(Demux_Data_Out12),
.DEMUX_out13(Demux_Data_Out13),
.DEMUX_out14(Demux_Data_Out14),
.DEMUX_out15(Demux_Data_Out15),
.DEMUX_out16(Demux_Data_Out16),
.DEMUX_out17(Demux_Data_Out17),
.DEMUX_out18(Demux_Data_Out18),
.DEMUX_out19(Demux_Data_Out19),
.DEMUX_out20(Demux_Data_Out20),
.DEMUX_out21(Demux_Data_Out21),
.DEMUX_out22(Demux_Data_Out22),
.DEMUX_out23(Demux_Data_Out23),
.DEMUX_out24(Demux_Data_Out24),
.DEMUX_out25(Demux_Data_Out25),
.DEMUX_out26(Demux_Data_Out26),
.DEMUX_out27(Demux_Data_Out27),
.DEMUX_out28(Demux_Data_Out28),
.DEMUX_out29(Demux_Data_Out29),
.DEMUX_out30(Demux_Data_Out30),
.DEMUX_out31(Demux_Data_Out31),
.DEMUX_out32(Demux_Data_Out32),
.DEMUX_out33(Demux_Data_Out33),
.DEMUX_out34(Demux_Data_Out34),
.DEMUX_out35(Demux_Data_Out35)

);


DEMUX_169 #(.INPUT_DATA_WIDTH(1)) Demux_Set
(

//////////// INPUTS ///////////
.DEMUX_Data_in(1'b1),
.DEMUX_selector(Owmc_Muxes_Sel),
.DEMUX_En(Owmc_Muxes_En),


//////////// OUTPUTS //////////
.DEMUX_out0(Demux_Set_Out0),
.DEMUX_out1(Demux_Set_Out1),
.DEMUX_out2(Demux_Set_Out2),
.DEMUX_out3(Demux_Set_Out3),
.DEMUX_out4(Demux_Set_Out4),
.DEMUX_out5(Demux_Set_Out5),
.DEMUX_out6(Demux_Set_Out6),
.DEMUX_out7(Demux_Set_Out7),
.DEMUX_out8(Demux_Set_Out8),
.DEMUX_out9(Demux_Set_Out9),
.DEMUX_out10(Demux_Set_Out10),
.DEMUX_out11(Demux_Set_Out11),
.DEMUX_out12(Demux_Set_Out12),
.DEMUX_out13(Demux_Set_Out13),
.DEMUX_out14(Demux_Set_Out14),
.DEMUX_out15(Demux_Set_Out15),
.DEMUX_out16(Demux_Set_Out16),
.DEMUX_out17(Demux_Set_Out17),
.DEMUX_out18(Demux_Set_Out18),
.DEMUX_out19(Demux_Set_Out19),
.DEMUX_out20(Demux_Set_Out20),
.DEMUX_out21(Demux_Set_Out21),
.DEMUX_out22(Demux_Set_Out22),
.DEMUX_out23(Demux_Set_Out23),
.DEMUX_out24(Demux_Set_Out24),
.DEMUX_out25(Demux_Set_Out25),
.DEMUX_out26(Demux_Set_Out26),
.DEMUX_out27(Demux_Set_Out27),
.DEMUX_out28(Demux_Set_Out28),
.DEMUX_out29(Demux_Set_Out29),
.DEMUX_out30(Demux_Set_Out30),
.DEMUX_out31(Demux_Set_Out31),
.DEMUX_out32(Demux_Set_Out32),
.DEMUX_out33(Demux_Set_Out33),
.DEMUX_out34(Demux_Set_Out34),
.DEMUX_out35(Demux_Set_Out35)
);



//////////// Weight register instantiations //////////

WREG #(.WREG_DATA_WIDTH(W_MEM_DATAWIDTH)) Wreg0
(

//////////// INPUTS ///////////
.WREG_Clk(ACCELERATOR_Clk_50),
.WREG_Reset(Main_Stm_Wregs_Reset),
.WREG_Set(Demux_Set_Out0),
.WREG_Input_Data(Demux_Data_Out0),

//////////// OUTPUTS //////////
.WREG_Output_Data(Wreg0_Output_Data)

);


WREG #(.WREG_DATA_WIDTH(W_MEM_DATAWIDTH)) Wreg1
(

//////////// INPUTS ///////////
.WREG_Clk(ACCELERATOR_Clk_50),
.WREG_Reset(Main_Stm_Wregs_Reset),
.WREG_Set(Demux_Set_Out1),
.WREG_Input_Data(Demux_Data_Out1),

//////////// OUTPUTS //////////
.WREG_Output_Data(Wreg1_Output_Data)

);


WREG #(.WREG_DATA_WIDTH(W_MEM_DATAWIDTH)) Wreg2
(

//////////// INPUTS ///////////
.WREG_Clk(ACCELERATOR_Clk_50),
.WREG_Reset(Main_Stm_Wregs_Reset),
.WREG_Set(Demux_Set_Out2),
.WREG_Input_Data(Demux_Data_Out2),

//////////// OUTPUTS //////////
.WREG_Output_Data(Wreg2_Output_Data)

);

WREG #(.WREG_DATA_WIDTH(W_MEM_DATAWIDTH)) Wreg3
(

//////////// INPUTS ///////////
.WREG_Clk(ACCELERATOR_Clk_50),
.WREG_Reset(Main_Stm_Wregs_Reset),
.WREG_Set(Demux_Set_Out3),
.WREG_Input_Data(Demux_Data_Out3),

//////////// OUTPUTS //////////
.WREG_Output_Data(Wreg3_Output_Data)

);

WREG #(.WREG_DATA_WIDTH(W_MEM_DATAWIDTH)) Wreg4
(
//////////// INPUTS ///////////
.WREG_Clk(ACCELERATOR_Clk_50),
.WREG_Reset(Main_Stm_Wregs_Reset),
.WREG_Set(Demux_Set_Out4),
.WREG_Input_Data(Demux_Data_Out4),

//////////// OUTPUTS //////////
.WREG_Output_Data(Wreg4_Output_Data)
);

WREG #(.WREG_DATA_WIDTH(W_MEM_DATAWIDTH)) Wreg5
(

//////////// INPUTS ///////////
.WREG_Clk(ACCELERATOR_Clk_50),
.WREG_Reset(Main_Stm_Wregs_Reset),
.WREG_Set(Demux_Set_Out5),
.WREG_Input_Data(Demux_Data_Out5),

//////////// OUTPUTS //////////
.WREG_Output_Data(Wreg5_Output_Data)

);

WREG #(.WREG_DATA_WIDTH(W_MEM_DATAWIDTH)) Wreg6
(
//////////// INPUTS ///////////
.WREG_Clk(ACCELERATOR_Clk_50),
.WREG_Reset(Main_Stm_Wregs_Reset),
.WREG_Set(Demux_Set_Out6),
.WREG_Input_Data(Demux_Data_Out6),

//////////// OUTPUTS //////////
.WREG_Output_Data(Wreg6_Output_Data)
);

WREG #(.WREG_DATA_WIDTH(W_MEM_DATAWIDTH)) Wreg7
(
//////////// INPUTS ///////////
.WREG_Clk(ACCELERATOR_Clk_50),
.WREG_Reset(Main_Stm_Wregs_Reset),
.WREG_Set(Demux_Set_Out7),
.WREG_Input_Data(Demux_Data_Out7),

//////////// OUTPUTS //////////
.WREG_Output_Data(Wreg7_Output_Data)
);

WREG #(.WREG_DATA_WIDTH(W_MEM_DATAWIDTH)) Wreg8
(
//////////// INPUTS ///////////
.WREG_Clk(ACCELERATOR_Clk_50),
.WREG_Reset(Main_Stm_Wregs_Reset),
.WREG_Set(Demux_Set_Out8),
.WREG_Input_Data(Demux_Data_Out8),

//////////// OUTPUTS //////////
.WREG_Output_Data(Wreg8_Output_Data)
);

WREG #(.WREG_DATA_WIDTH(W_MEM_DATAWIDTH)) Wreg9
(
//////////// INPUTS ///////////
.WREG_Clk(ACCELERATOR_Clk_50),
.WREG_Reset(Main_Stm_Wregs_Reset),
.WREG_Set(Demux_Set_Out9),
.WREG_Input_Data(Demux_Data_Out9),

//////////// OUTPUTS //////////
.WREG_Output_Data(Wreg9_Output_Data)
);



WREG #(.WREG_DATA_WIDTH(W_MEM_DATAWIDTH)) Wreg10
(
//////////// INPUTS ///////////
.WREG_Clk(ACCELERATOR_Clk_50),
.WREG_Reset(Main_Stm_Wregs_Reset),
.WREG_Set(Demux_Set_Out10),
.WREG_Input_Data(Demux_Data_Out10),

//////////// OUTPUTS //////////
.WREG_Output_Data(Wreg10_Output_Data)
);

WREG #(.WREG_DATA_WIDTH(W_MEM_DATAWIDTH)) Wreg11
(
//////////// INPUTS ///////////
.WREG_Clk(ACCELERATOR_Clk_50),
.WREG_Reset(Main_Stm_Wregs_Reset),
.WREG_Set(Demux_Set_Out11),
.WREG_Input_Data(Demux_Data_Out11),

//////////// OUTPUTS //////////
.WREG_Output_Data(Wreg11_Output_Data)
);


WREG #(.WREG_DATA_WIDTH(W_MEM_DATAWIDTH)) Wreg12
(
//////////// INPUTS ///////////
.WREG_Clk(ACCELERATOR_Clk_50),
.WREG_Reset(Main_Stm_Wregs_Reset),
.WREG_Set(Demux_Set_Out12),
.WREG_Input_Data(Demux_Data_Out12),

//////////// OUTPUTS //////////
.WREG_Output_Data(Wreg12_Output_Data)
);


WREG #(.WREG_DATA_WIDTH(W_MEM_DATAWIDTH)) Wreg13
(
//////////// INPUTS ///////////
.WREG_Clk(ACCELERATOR_Clk_50),
.WREG_Reset(Main_Stm_Wregs_Reset),
.WREG_Set(Demux_Set_Out13),
.WREG_Input_Data(Demux_Data_Out13),

//////////// OUTPUTS //////////
.WREG_Output_Data(Wreg13_Output_Data)
);


WREG #(.WREG_DATA_WIDTH(W_MEM_DATAWIDTH)) Wreg14
(
//////////// INPUTS ///////////
.WREG_Clk(ACCELERATOR_Clk_50),
.WREG_Reset(Main_Stm_Wregs_Reset),
.WREG_Set(Demux_Set_Out14),
.WREG_Input_Data(Demux_Data_Out14),

//////////// OUTPUTS //////////
.WREG_Output_Data(Wreg14_Output_Data)
);


WREG #(.WREG_DATA_WIDTH(W_MEM_DATAWIDTH)) Wreg15
(
//////////// INPUTS ///////////
.WREG_Clk(ACCELERATOR_Clk_50),
.WREG_Reset(Main_Stm_Wregs_Reset),
.WREG_Set(Demux_Set_Out15),
.WREG_Input_Data(Demux_Data_Out15),

//////////// OUTPUTS //////////
.WREG_Output_Data(Wreg15_Output_Data)
);


WREG #(.WREG_DATA_WIDTH(W_MEM_DATAWIDTH)) Wreg16
(
//////////// INPUTS ///////////
.WREG_Clk(ACCELERATOR_Clk_50),
.WREG_Reset(Main_Stm_Wregs_Reset),
.WREG_Set(Demux_Set_Out16),
.WREG_Input_Data(Demux_Data_Out16),

//////////// OUTPUTS //////////
.WREG_Output_Data(Wreg16_Output_Data)
);


WREG #(.WREG_DATA_WIDTH(W_MEM_DATAWIDTH)) Wreg17
(
//////////// INPUTS ///////////
.WREG_Clk(ACCELERATOR_Clk_50),
.WREG_Reset(Main_Stm_Wregs_Reset),
.WREG_Set(Demux_Set_Out17),
.WREG_Input_Data(Demux_Data_Out17),

//////////// OUTPUTS //////////
.WREG_Output_Data(Wreg17_Output_Data)
);



WREG #(.WREG_DATA_WIDTH(W_MEM_DATAWIDTH)) Wreg18
(
//////////// INPUTS ///////////
.WREG_Clk(ACCELERATOR_Clk_50),
.WREG_Reset(Main_Stm_Wregs_Reset),
.WREG_Set(Demux_Set_Out18),
.WREG_Input_Data(Demux_Data_Out18),

//////////// OUTPUTS //////////
.WREG_Output_Data(Wreg18_Output_Data)
);


WREG #(.WREG_DATA_WIDTH(W_MEM_DATAWIDTH)) Wreg19
(
//////////// INPUTS ///////////
.WREG_Clk(ACCELERATOR_Clk_50),
.WREG_Reset(Main_Stm_Wregs_Reset),
.WREG_Set(Demux_Set_Out19),
.WREG_Input_Data(Demux_Data_Out19),

//////////// OUTPUTS //////////
.WREG_Output_Data(Wreg19_Output_Data)
);


WREG #(.WREG_DATA_WIDTH(W_MEM_DATAWIDTH)) Wreg20
(
//////////// INPUTS ///////////
.WREG_Clk(ACCELERATOR_Clk_50),
.WREG_Reset(Main_Stm_Wregs_Reset),
.WREG_Set(Demux_Set_Out20),
.WREG_Input_Data(Demux_Data_Out20),

//////////// OUTPUTS //////////
.WREG_Output_Data(Wreg20_Output_Data)
);



WREG #(.WREG_DATA_WIDTH(W_MEM_DATAWIDTH)) Wreg21
(
//////////// INPUTS ///////////
.WREG_Clk(ACCELERATOR_Clk_50),
.WREG_Reset(Main_Stm_Wregs_Reset),
.WREG_Set(Demux_Set_Out21),
.WREG_Input_Data(Demux_Data_Out21),

//////////// OUTPUTS //////////
.WREG_Output_Data(Wreg21_Output_Data)
);



WREG #(.WREG_DATA_WIDTH(W_MEM_DATAWIDTH)) Wreg22
(
//////////// INPUTS ///////////
.WREG_Clk(ACCELERATOR_Clk_50),
.WREG_Reset(Main_Stm_Wregs_Reset),
.WREG_Set(Demux_Set_Out22),
.WREG_Input_Data(Demux_Data_Out22),

//////////// OUTPUTS //////////
.WREG_Output_Data(Wreg22_Output_Data)
);


WREG #(.WREG_DATA_WIDTH(W_MEM_DATAWIDTH)) Wreg23
(
//////////// INPUTS ///////////
.WREG_Clk(ACCELERATOR_Clk_50),
.WREG_Reset(Main_Stm_Wregs_Reset),
.WREG_Set(Demux_Set_Out23),
.WREG_Input_Data(Demux_Data_Out23),

//////////// OUTPUTS //////////
.WREG_Output_Data(Wreg23_Output_Data)
);



WREG #(.WREG_DATA_WIDTH(W_MEM_DATAWIDTH)) Wreg24
(
//////////// INPUTS ///////////
.WREG_Clk(ACCELERATOR_Clk_50),
.WREG_Reset(Main_Stm_Wregs_Reset),
.WREG_Set(Demux_Set_Out24),
.WREG_Input_Data(Demux_Data_Out24),

//////////// OUTPUTS //////////
.WREG_Output_Data(Wreg24_Output_Data)
);


WREG #(.WREG_DATA_WIDTH(W_MEM_DATAWIDTH)) Wreg25
(
//////////// INPUTS ///////////
.WREG_Clk(ACCELERATOR_Clk_50),
.WREG_Reset(Main_Stm_Wregs_Reset),
.WREG_Set(Demux_Set_Out25),
.WREG_Input_Data(Demux_Data_Out25),

//////////// OUTPUTS //////////
.WREG_Output_Data(Wreg25_Output_Data)
);


WREG #(.WREG_DATA_WIDTH(W_MEM_DATAWIDTH)) Wreg26
(
//////////// INPUTS ///////////
.WREG_Clk(ACCELERATOR_Clk_50),
.WREG_Reset(Main_Stm_Wregs_Reset),
.WREG_Set(Demux_Set_Out26),
.WREG_Input_Data(Demux_Data_Out26),

//////////// OUTPUTS //////////
.WREG_Output_Data(Wreg26_Output_Data)
);


WREG #(.WREG_DATA_WIDTH(W_MEM_DATAWIDTH)) Wreg27
(
//////////// INPUTS ///////////
.WREG_Clk(ACCELERATOR_Clk_50),
.WREG_Reset(Main_Stm_Wregs_Reset),
.WREG_Set(Demux_Set_Out27),
.WREG_Input_Data(Demux_Data_Out27),

//////////// OUTPUTS //////////
.WREG_Output_Data(Wreg27_Output_Data)
);


WREG #(.WREG_DATA_WIDTH(W_MEM_DATAWIDTH)) Wreg28
(
//////////// INPUTS ///////////
.WREG_Clk(ACCELERATOR_Clk_50),
.WREG_Reset(Main_Stm_Wregs_Reset),
.WREG_Set(Demux_Set_Out28),
.WREG_Input_Data(Demux_Data_Out28),

//////////// OUTPUTS //////////
.WREG_Output_Data(Wreg28_Output_Data)
);


WREG #(.WREG_DATA_WIDTH(W_MEM_DATAWIDTH)) Wreg29
(
//////////// INPUTS ///////////
.WREG_Clk(ACCELERATOR_Clk_50),
.WREG_Reset(Main_Stm_Wregs_Reset),
.WREG_Set(Demux_Set_Out29),
.WREG_Input_Data(Demux_Data_Out29),

//////////// OUTPUTS //////////
.WREG_Output_Data(Wreg29_Output_Data)
);


WREG #(.WREG_DATA_WIDTH(W_MEM_DATAWIDTH)) Wreg30
(
//////////// INPUTS ///////////
.WREG_Clk(ACCELERATOR_Clk_50),
.WREG_Reset(Main_Stm_Wregs_Reset),
.WREG_Set(Demux_Set_Out30),
.WREG_Input_Data(Demux_Data_Out30),

//////////// OUTPUTS //////////
.WREG_Output_Data(Wreg30_Output_Data)
);


WREG #(.WREG_DATA_WIDTH(W_MEM_DATAWIDTH)) Wreg31
(
//////////// INPUTS ///////////
.WREG_Clk(ACCELERATOR_Clk_50),
.WREG_Reset(Main_Stm_Wregs_Reset),
.WREG_Set(Demux_Set_Out31),
.WREG_Input_Data(Demux_Data_Out31),

//////////// OUTPUTS //////////
.WREG_Output_Data(Wreg31_Output_Data)
);


WREG #(.WREG_DATA_WIDTH(W_MEM_DATAWIDTH)) Wreg32
(
//////////// INPUTS ///////////
.WREG_Clk(ACCELERATOR_Clk_50),
.WREG_Reset(Main_Stm_Wregs_Reset),
.WREG_Set(Demux_Set_Out32),
.WREG_Input_Data(Demux_Data_Out32),

//////////// OUTPUTS //////////
.WREG_Output_Data(Wreg32_Output_Data)
);


WREG #(.WREG_DATA_WIDTH(W_MEM_DATAWIDTH)) Wreg33
(
//////////// INPUTS ///////////
.WREG_Clk(ACCELERATOR_Clk_50),
.WREG_Reset(Main_Stm_Wregs_Reset),
.WREG_Set(Demux_Set_Out33),
.WREG_Input_Data(Demux_Data_Out33),

//////////// OUTPUTS //////////
.WREG_Output_Data(Wreg33_Output_Data)
);




WREG #(.WREG_DATA_WIDTH(W_MEM_DATAWIDTH)) Wreg34
(
//////////// INPUTS ///////////
.WREG_Clk(ACCELERATOR_Clk_50),
.WREG_Reset(Main_Stm_Wregs_Reset),
.WREG_Set(Demux_Set_Out34),
.WREG_Input_Data(Demux_Data_Out34),

//////////// OUTPUTS //////////
.WREG_Output_Data(Wreg34_Output_Data)
);


WREG #(.WREG_DATA_WIDTH(W_MEM_DATAWIDTH)) Wreg35
(
//////////// INPUTS ///////////
.WREG_Clk(ACCELERATOR_Clk_50),
.WREG_Reset(Main_Stm_Wregs_Reset),
.WREG_Set(Demux_Set_Out35),
.WREG_Input_Data(Demux_Data_Out35),

//////////// OUTPUTS //////////
.WREG_Output_Data(Wreg35_Output_Data)
);


//////////// Processing elements instantiation //////////

PE #(.PX_WIDTH(IF_DATAWIDTH), .W_WIDTH(W_MEM_DATAWIDTH),.DATA_OUT_WIDTH(PE_DATAOUT_WIDTH)) Pe0
(
//////////// INPUTS //////////
.PE_Clk(ACCELERATOR_Clk_50),
.PE_Out_Reg_Set(Pedc_OutReg_Set),
.PE_Reset(Pedc_Reset),
.PE_Fifo_Set(Rbus_Om_SetEn[0]),
.PE_Is(PEO_IS),
.PE_If_Px(Demux_1_2_If[IF_DATAWIDTH-1:0]),
.PE_w(Wreg0_Output_Data),
//////////// OUTPUT //////////
.PE_Out(Pe0_Output)

);

PE #(.PX_WIDTH(IF_DATAWIDTH), .W_WIDTH(W_MEM_DATAWIDTH),.DATA_OUT_WIDTH(PE_DATAOUT_WIDTH)) Pe1
(
//////////// INPUTS //////////
.PE_Clk(ACCELERATOR_Clk_50),
.PE_Out_Reg_Set(Pedc_OutReg_Set),
.PE_Reset(Pedc_Reset),
.PE_Fifo_Set(Rbus_Om_SetEn[1]),
.PE_Is(Mux0_Output),
.PE_If_Px(Demux_1_2_If[IF_DATAWIDTH-1:0]),
.PE_w(Wreg1_Output_Data),
//////////// OUTPUT //////////
.PE_Out(Pe1_Output)

);

PE #(.PX_WIDTH(IF_DATAWIDTH), .W_WIDTH(W_MEM_DATAWIDTH),.DATA_OUT_WIDTH(PE_DATAOUT_WIDTH)) Pe2
(
//////////// INPUTS //////////
.PE_Clk(ACCELERATOR_Clk_50),
.PE_Out_Reg_Set(Pedc_OutReg_Set),
.PE_Reset(Pedc_Reset),
.PE_Fifo_Set(Rbus_Om_SetEn[2]),
.PE_Is(Mux1_Output),
.PE_If_Px(Demux_1_2_If[IF_DATAWIDTH-1:0]),
.PE_w(Wreg2_Output_Data),
//////////// OUTPUT //////////
.PE_Out(Pe2_Output)

);


PE #(.PX_WIDTH(IF_DATAWIDTH), .W_WIDTH(W_MEM_DATAWIDTH),.DATA_OUT_WIDTH(PE_DATAOUT_WIDTH)) Pe3
(
//////////// INPUTS //////////
.PE_Clk(ACCELERATOR_Clk_50),
.PE_Out_Reg_Set(Pedc_OutReg_Set),
.PE_Reset(Pedc_Reset),
.PE_Fifo_Set(Rbus_Om_SetEn[3]),
.PE_Is(Mux2_Output),
.PE_If_Px(Demux_1_2_If[IF_DATAWIDTH-1:0]),
.PE_w(Wreg3_Output_Data),
//////////// OUTPUT //////////
.PE_Out(Pe3_Output)

);

PE #(.PX_WIDTH(IF_DATAWIDTH), .W_WIDTH(W_MEM_DATAWIDTH),.DATA_OUT_WIDTH(PE_DATAOUT_WIDTH)) Pe4
(
//////////// INPUTS //////////
.PE_Clk(ACCELERATOR_Clk_50),
.PE_Out_Reg_Set(Pedc_OutReg_Set),
.PE_Reset(Pedc_Reset),
.PE_Fifo_Set(Rbus_Om_SetEn[4]),
.PE_Is(Mux3_Output),
.PE_If_Px(Demux_1_2_If[IF_DATAWIDTH-1:0]),
.PE_w(Wreg4_Output_Data),
//////////// OUTPUT //////////
.PE_Out(Pe4_Output)

);


PE #(.PX_WIDTH(IF_DATAWIDTH), .W_WIDTH(W_MEM_DATAWIDTH),.DATA_OUT_WIDTH(PE_DATAOUT_WIDTH)) Pe5
(
//////////// INPUTS //////////
.PE_Clk(ACCELERATOR_Clk_50),
.PE_Out_Reg_Set(Pedc_OutReg_Set),
.PE_Reset(Pedc_Reset),
.PE_Fifo_Set(Rbus_Om_SetEn[5]),
.PE_Is(Mux4_Output),
.PE_If_Px(Demux_1_2_If[IF_DATAWIDTH-1:0]),
.PE_w(Wreg5_Output_Data),
//////////// OUTPUT //////////
.PE_Out(Pe5_Output)

);


PE #(.PX_WIDTH(IF_DATAWIDTH), .W_WIDTH(W_MEM_DATAWIDTH),.DATA_OUT_WIDTH(PE_DATAOUT_WIDTH)) Pe6
(
//////////// INPUTS //////////
.PE_Clk(ACCELERATOR_Clk_50),
.PE_Out_Reg_Set(Pedc_OutReg_Set),
.PE_Reset(Pedc_Reset),
.PE_Fifo_Set(Rbus_Om_SetEn[6]),
.PE_Is(Mux5_Output),
.PE_If_Px(Demux_1_2_If[IF_DATAWIDTH-1:0]),
.PE_w(Wreg6_Output_Data),
//////////// OUTPUT //////////
.PE_Out(Pe6_Output)

);

PE #(.PX_WIDTH(IF_DATAWIDTH), .W_WIDTH(W_MEM_DATAWIDTH),.DATA_OUT_WIDTH(PE_DATAOUT_WIDTH)) Pe7
(
//////////// INPUTS //////////
.PE_Clk(ACCELERATOR_Clk_50),
.PE_Out_Reg_Set(Pedc_OutReg_Set),
.PE_Reset(Pedc_Reset),
.PE_Fifo_Set(Rbus_Om_SetEn[7]),
.PE_Is(Mux6_Output),
.PE_If_Px(Demux_1_2_If[IF_DATAWIDTH-1:0]),
.PE_w(Wreg7_Output_Data),
//////////// OUTPUT //////////
.PE_Out(Pe7_Output)

);


PE #(.PX_WIDTH(IF_DATAWIDTH), .W_WIDTH(W_MEM_DATAWIDTH),.DATA_OUT_WIDTH(PE_DATAOUT_WIDTH)) Pe8
(
//////////// INPUTS //////////
.PE_Clk(ACCELERATOR_Clk_50),
.PE_Out_Reg_Set(Pedc_OutReg_Set),
.PE_Reset(Pedc_Reset),
.PE_Fifo_Set(Rbus_Om_SetEn[8]),
.PE_Is(Mux7_Output),
.PE_If_Px(Demux_1_2_If[IF_DATAWIDTH-1:0]),
.PE_w(Wreg8_Output_Data),
//////////// OUTPUT //////////
.PE_Out(Pe8_Output)
);

PE #(.PX_WIDTH(IF_DATAWIDTH), .W_WIDTH(W_MEM_DATAWIDTH),.DATA_OUT_WIDTH(PE_DATAOUT_WIDTH)) Pe9
(
//////////// INPUTS //////////
.PE_Clk(ACCELERATOR_Clk_50),
.PE_Out_Reg_Set(Pedc_OutReg_Set),
.PE_Reset(Pedc_Reset),
.PE_Fifo_Set(Rbus_Om_SetEn[9]),
.PE_Is(Mux8_Output),
.PE_If_Px(Demux_1_2_If[IF_DATAWIDTH-1:0]),
.PE_w(Wreg9_Output_Data),
//////////// OUTPUT //////////
.PE_Out(Pe9_Output)
);

PE #(.PX_WIDTH(IF_DATAWIDTH), .W_WIDTH(W_MEM_DATAWIDTH),.DATA_OUT_WIDTH(PE_DATAOUT_WIDTH)) Pe10
(
//////////// INPUTS //////////
.PE_Clk(ACCELERATOR_Clk_50),
.PE_Out_Reg_Set(Pedc_OutReg_Set),
.PE_Reset(Pedc_Reset),
.PE_Fifo_Set(Rbus_Om_SetEn[10]),
.PE_Is(Mux9_Output),
.PE_If_Px(Demux_1_2_If[IF_DATAWIDTH-1:0]),
.PE_w(Wreg10_Output_Data),
//////////// OUTPUT //////////
.PE_Out(Pe10_Output)
);

PE #(.PX_WIDTH(IF_DATAWIDTH), .W_WIDTH(W_MEM_DATAWIDTH),.DATA_OUT_WIDTH(PE_DATAOUT_WIDTH)) Pe11
(
//////////// INPUTS //////////
.PE_Clk(ACCELERATOR_Clk_50),
.PE_Out_Reg_Set(Pedc_OutReg_Set),
.PE_Reset(Pedc_Reset),
.PE_Fifo_Set(Rbus_Om_SetEn[11]),
.PE_Is(Mux10_Output),
.PE_If_Px(Demux_1_2_If[IF_DATAWIDTH-1:0]),
.PE_w(Wreg11_Output_Data),
//////////// OUTPUT //////////
.PE_Out(Pe11_Output)
);

PE #(.PX_WIDTH(IF_DATAWIDTH), .W_WIDTH(W_MEM_DATAWIDTH),.DATA_OUT_WIDTH(PE_DATAOUT_WIDTH)) Pe12
(
//////////// INPUTS //////////
.PE_Clk(ACCELERATOR_Clk_50),
.PE_Out_Reg_Set(Pedc_OutReg_Set),
.PE_Reset(Pedc_Reset),
.PE_Fifo_Set(Rbus_Om_SetEn[12]),
.PE_Is(Mux11_Output),
.PE_If_Px(Demux_1_2_If[IF_DATAWIDTH-1:0]),
.PE_w(Wreg12_Output_Data),
//////////// OUTPUT //////////
.PE_Out(Pe12_Output)
);

PE #(.PX_WIDTH(IF_DATAWIDTH), .W_WIDTH(W_MEM_DATAWIDTH),.DATA_OUT_WIDTH(PE_DATAOUT_WIDTH)) Pe13
(
//////////// INPUTS //////////
.PE_Clk(ACCELERATOR_Clk_50),
.PE_Out_Reg_Set(Pedc_OutReg_Set),
.PE_Reset(Pedc_Reset),
.PE_Fifo_Set(Rbus_Om_SetEn[13]),
.PE_Is(Mux12_Output),
.PE_If_Px(Demux_1_2_If[IF_DATAWIDTH-1:0]),
.PE_w(Wreg13_Output_Data),
//////////// OUTPUT //////////
.PE_Out(Pe13_Output)
);

PE #(.PX_WIDTH(IF_DATAWIDTH), .W_WIDTH(W_MEM_DATAWIDTH),.DATA_OUT_WIDTH(PE_DATAOUT_WIDTH)) Pe14
(
//////////// INPUTS //////////
.PE_Clk(ACCELERATOR_Clk_50),
.PE_Out_Reg_Set(Pedc_OutReg_Set),
.PE_Reset(Pedc_Reset),
.PE_Fifo_Set(Rbus_Om_SetEn[14]),
.PE_Is(Mux13_Output),
.PE_If_Px(Demux_1_2_If[IF_DATAWIDTH-1:0]),
.PE_w(Wreg14_Output_Data),
//////////// OUTPUT //////////
.PE_Out(Pe14_Output)
);

PE #(.PX_WIDTH(IF_DATAWIDTH), .W_WIDTH(W_MEM_DATAWIDTH),.DATA_OUT_WIDTH(PE_DATAOUT_WIDTH)) Pe15
(
//////////// INPUTS //////////
.PE_Clk(ACCELERATOR_Clk_50),
.PE_Out_Reg_Set(Pedc_OutReg_Set),
.PE_Reset(Pedc_Reset),
.PE_Fifo_Set(Rbus_Om_SetEn[15]),
.PE_Is(Mux14_Output),
.PE_If_Px(Demux_1_2_If[IF_DATAWIDTH-1:0]),
.PE_w(Wreg15_Output_Data),
//////////// OUTPUT //////////
.PE_Out(Pe15_Output)
);

PE #(.PX_WIDTH(IF_DATAWIDTH), .W_WIDTH(W_MEM_DATAWIDTH),.DATA_OUT_WIDTH(PE_DATAOUT_WIDTH)) Pe16
(
//////////// INPUTS //////////
.PE_Clk(ACCELERATOR_Clk_50),
.PE_Out_Reg_Set(Pedc_OutReg_Set),
.PE_Reset(Pedc_Reset),
.PE_Fifo_Set(Rbus_Om_SetEn[16]),
.PE_Is(Mux15_Output),
.PE_If_Px(Demux_1_2_If[IF_DATAWIDTH-1:0]),
.PE_w(Wreg16_Output_Data),
//////////// OUTPUT //////////
.PE_Out(Pe16_Output)
);

PE #(.PX_WIDTH(IF_DATAWIDTH), .W_WIDTH(W_MEM_DATAWIDTH),.DATA_OUT_WIDTH(PE_DATAOUT_WIDTH)) Pe17
(
//////////// INPUTS //////////
.PE_Clk(ACCELERATOR_Clk_50),
.PE_Out_Reg_Set(Pedc_OutReg_Set),
.PE_Reset(Pedc_Reset),
.PE_Fifo_Set(Rbus_Om_SetEn[17]),
.PE_Is(Mux16_Output),
.PE_If_Px(Demux_1_2_If[IF_DATAWIDTH-1:0]),
.PE_w(Wreg17_Output_Data),
//////////// OUTPUT //////////
.PE_Out(Pe17_Output)
);

PE #(.PX_WIDTH(IF_DATAWIDTH), .W_WIDTH(W_MEM_DATAWIDTH),.DATA_OUT_WIDTH(PE_DATAOUT_WIDTH)) Pe18
(
//////////// INPUTS //////////
.PE_Clk(ACCELERATOR_Clk_50),
.PE_Out_Reg_Set(Pedc_OutReg_Set),
.PE_Reset(Pedc_Reset),
.PE_Fifo_Set(Rbus_Om_SetEn[18]),
.PE_Is(Mux17_Output),
.PE_If_Px(Demux_1_2_If[IF_DATAWIDTH-1:0]),
.PE_w(Wreg18_Output_Data),
//////////// OUTPUT //////////
.PE_Out(Pe18_Output)
);

PE #(.PX_WIDTH(IF_DATAWIDTH), .W_WIDTH(W_MEM_DATAWIDTH),.DATA_OUT_WIDTH(PE_DATAOUT_WIDTH)) Pe19
(
//////////// INPUTS //////////
.PE_Clk(ACCELERATOR_Clk_50),
.PE_Out_Reg_Set(Pedc_OutReg_Set),
.PE_Reset(Pedc_Reset),
.PE_Fifo_Set(Rbus_Om_SetEn[19]),
.PE_Is(Mux18_Output),
.PE_If_Px(Demux_1_2_If[IF_DATAWIDTH-1:0]),
.PE_w(Wreg19_Output_Data),
//////////// OUTPUT //////////
.PE_Out(Pe19_Output)
);

PE #(.PX_WIDTH(IF_DATAWIDTH), .W_WIDTH(W_MEM_DATAWIDTH),.DATA_OUT_WIDTH(PE_DATAOUT_WIDTH)) Pe20
(
//////////// INPUTS //////////
.PE_Clk(ACCELERATOR_Clk_50),
.PE_Out_Reg_Set(Pedc_OutReg_Set),
.PE_Reset(Pedc_Reset),
.PE_Fifo_Set(Rbus_Om_SetEn[20]),
.PE_Is(Mux19_Output),
.PE_If_Px(Demux_1_2_If[IF_DATAWIDTH-1:0]),
.PE_w(Wreg20_Output_Data),
//////////// OUTPUT //////////
.PE_Out(Pe20_Output)
);

PE #(.PX_WIDTH(IF_DATAWIDTH), .W_WIDTH(W_MEM_DATAWIDTH),.DATA_OUT_WIDTH(PE_DATAOUT_WIDTH)) Pe21
(
//////////// INPUTS //////////
.PE_Clk(ACCELERATOR_Clk_50),
.PE_Out_Reg_Set(Pedc_OutReg_Set),
.PE_Reset(Pedc_Reset),
.PE_Fifo_Set(Rbus_Om_SetEn[21]),
.PE_Is(Mux20_Output),
.PE_If_Px(Demux_1_2_If[IF_DATAWIDTH-1:0]),
.PE_w(Wreg21_Output_Data),
//////////// OUTPUT //////////
.PE_Out(Pe21_Output)
);

PE #(.PX_WIDTH(IF_DATAWIDTH), .W_WIDTH(W_MEM_DATAWIDTH),.DATA_OUT_WIDTH(PE_DATAOUT_WIDTH)) Pe22
(
//////////// INPUTS //////////
.PE_Clk(ACCELERATOR_Clk_50),
.PE_Out_Reg_Set(Pedc_OutReg_Set),
.PE_Reset(Pedc_Reset),
.PE_Fifo_Set(Rbus_Om_SetEn[22]),
.PE_Is(Mux21_Output),
.PE_If_Px(Demux_1_2_If[IF_DATAWIDTH-1:0]),
.PE_w(Wreg22_Output_Data),
//////////// OUTPUT //////////
.PE_Out(Pe22_Output)
);

PE #(.PX_WIDTH(IF_DATAWIDTH), .W_WIDTH(W_MEM_DATAWIDTH),.DATA_OUT_WIDTH(PE_DATAOUT_WIDTH)) Pe23
(
//////////// INPUTS //////////
.PE_Clk(ACCELERATOR_Clk_50),
.PE_Out_Reg_Set(Pedc_OutReg_Set),
.PE_Reset(Pedc_Reset),
.PE_Fifo_Set(Rbus_Om_SetEn[23]),
.PE_Is(Mux22_Output),
.PE_If_Px(Demux_1_2_If[IF_DATAWIDTH-1:0]),
.PE_w(Wreg23_Output_Data),
//////////// OUTPUT //////////
.PE_Out(Pe23_Output)
);

PE #(.PX_WIDTH(IF_DATAWIDTH), .W_WIDTH(W_MEM_DATAWIDTH),.DATA_OUT_WIDTH(PE_DATAOUT_WIDTH)) Pe24
(
//////////// INPUTS //////////
.PE_Clk(ACCELERATOR_Clk_50),
.PE_Out_Reg_Set(Pedc_OutReg_Set),
.PE_Reset(Pedc_Reset),
.PE_Fifo_Set(Rbus_Om_SetEn[24]),
.PE_Is(Mux23_Output),
.PE_If_Px(Demux_1_2_If[IF_DATAWIDTH-1:0]),
.PE_w(Wreg24_Output_Data),
//////////// OUTPUT //////////
.PE_Out(Pe24_Output)
);

PE #(.PX_WIDTH(IF_DATAWIDTH), .W_WIDTH(W_MEM_DATAWIDTH),.DATA_OUT_WIDTH(PE_DATAOUT_WIDTH)) Pe25
(
//////////// INPUTS //////////
.PE_Clk(ACCELERATOR_Clk_50),
.PE_Out_Reg_Set(Pedc_OutReg_Set),
.PE_Reset(Pedc_Reset),
.PE_Fifo_Set(Rbus_Om_SetEn[25]),
.PE_Is(Mux24_Output),
.PE_If_Px(Demux_1_2_If[IF_DATAWIDTH-1:0]),
.PE_w(Wreg25_Output_Data),
//////////// OUTPUT //////////
.PE_Out(Pe25_Output)
);

PE #(.PX_WIDTH(IF_DATAWIDTH), .W_WIDTH(W_MEM_DATAWIDTH),.DATA_OUT_WIDTH(PE_DATAOUT_WIDTH)) Pe26
(
//////////// INPUTS //////////
.PE_Clk(ACCELERATOR_Clk_50),
.PE_Out_Reg_Set(Pedc_OutReg_Set),
.PE_Reset(Pedc_Reset),
.PE_Fifo_Set(Rbus_Om_SetEn[26]),
.PE_Is(Mux25_Output),
.PE_If_Px(Demux_1_2_If[IF_DATAWIDTH-1:0]),
.PE_w(Wreg26_Output_Data),
//////////// OUTPUT //////////
.PE_Out(Pe26_Output)
);

PE #(.PX_WIDTH(IF_DATAWIDTH), .W_WIDTH(W_MEM_DATAWIDTH),.DATA_OUT_WIDTH(PE_DATAOUT_WIDTH)) Pe27
(
//////////// INPUTS //////////
.PE_Clk(ACCELERATOR_Clk_50),
.PE_Out_Reg_Set(Pedc_OutReg_Set),
.PE_Reset(Pedc_Reset),
.PE_Fifo_Set(Rbus_Om_SetEn[27]),
.PE_Is(Mux26_Output),
.PE_If_Px(Demux_1_2_If[IF_DATAWIDTH-1:0]),
.PE_w(Wreg27_Output_Data),
//////////// OUTPUT //////////
.PE_Out(Pe27_Output)
);

PE #(.PX_WIDTH(IF_DATAWIDTH), .W_WIDTH(W_MEM_DATAWIDTH),.DATA_OUT_WIDTH(PE_DATAOUT_WIDTH)) Pe28
(
//////////// INPUTS //////////
.PE_Clk(ACCELERATOR_Clk_50),
.PE_Out_Reg_Set(Pedc_OutReg_Set),
.PE_Reset(Pedc_Reset),
.PE_Fifo_Set(Rbus_Om_SetEn[28]),
.PE_Is(Mux27_Output),
.PE_If_Px(Demux_1_2_If[IF_DATAWIDTH-1:0]),
.PE_w(Wreg28_Output_Data),
//////////// OUTPUT //////////
.PE_Out(Pe28_Output)
);

PE #(.PX_WIDTH(IF_DATAWIDTH), .W_WIDTH(W_MEM_DATAWIDTH),.DATA_OUT_WIDTH(PE_DATAOUT_WIDTH)) Pe29
(
//////////// INPUTS //////////
.PE_Clk(ACCELERATOR_Clk_50),
.PE_Out_Reg_Set(Pedc_OutReg_Set),
.PE_Reset(Pedc_Reset),
.PE_Fifo_Set(Rbus_Om_SetEn[29]),
.PE_Is(Mux28_Output),
.PE_If_Px(Demux_1_2_If[IF_DATAWIDTH-1:0]),
.PE_w(Wreg29_Output_Data),
//////////// OUTPUT //////////
.PE_Out(Pe29_Output)
);

PE #(.PX_WIDTH(IF_DATAWIDTH), .W_WIDTH(W_MEM_DATAWIDTH),.DATA_OUT_WIDTH(PE_DATAOUT_WIDTH)) Pe30
(
//////////// INPUTS //////////
.PE_Clk(ACCELERATOR_Clk_50),
.PE_Out_Reg_Set(Pedc_OutReg_Set),
.PE_Reset(Pedc_Reset),
.PE_Fifo_Set(Rbus_Om_SetEn[30]),
.PE_Is(Mux29_Output),
.PE_If_Px(Demux_1_2_If[IF_DATAWIDTH-1:0]),
.PE_w(Wreg30_Output_Data),
//////////// OUTPUT //////////
.PE_Out(Pe30_Output)
);

PE #(.PX_WIDTH(IF_DATAWIDTH), .W_WIDTH(W_MEM_DATAWIDTH),.DATA_OUT_WIDTH(PE_DATAOUT_WIDTH)) Pe31
(
//////////// INPUTS //////////
.PE_Clk(ACCELERATOR_Clk_50),
.PE_Out_Reg_Set(Pedc_OutReg_Set),
.PE_Reset(Pedc_Reset),
.PE_Fifo_Set(Rbus_Om_SetEn[31]),
.PE_Is(Mux30_Output),
.PE_If_Px(Demux_1_2_If[IF_DATAWIDTH-1:0]),
.PE_w(Wreg31_Output_Data),
//////////// OUTPUT //////////
.PE_Out(Pe31_Output)
);

PE #(.PX_WIDTH(IF_DATAWIDTH), .W_WIDTH(W_MEM_DATAWIDTH),.DATA_OUT_WIDTH(PE_DATAOUT_WIDTH)) Pe32
(
//////////// INPUTS //////////
.PE_Clk(ACCELERATOR_Clk_50),
.PE_Out_Reg_Set(Pedc_OutReg_Set),
.PE_Reset(Pedc_Reset),
.PE_Fifo_Set(Rbus_Om_SetEn[32]),
.PE_Is(Mux31_Output),
.PE_If_Px(Demux_1_2_If[IF_DATAWIDTH-1:0]),
.PE_w(Wreg32_Output_Data),
//////////// OUTPUT //////////
.PE_Out(Pe32_Output)
);

PE #(.PX_WIDTH(IF_DATAWIDTH), .W_WIDTH(W_MEM_DATAWIDTH),.DATA_OUT_WIDTH(PE_DATAOUT_WIDTH)) Pe33
(
//////////// INPUTS //////////
.PE_Clk(ACCELERATOR_Clk_50),
.PE_Out_Reg_Set(Pedc_OutReg_Set),
.PE_Reset(Pedc_Reset),
.PE_Fifo_Set(Rbus_Om_SetEn[33]),
.PE_Is(Mux32_Output),
.PE_If_Px(Demux_1_2_If[IF_DATAWIDTH-1:0]),
.PE_w(Wreg33_Output_Data),
//////////// OUTPUT //////////
.PE_Out(Pe33_Output)
);

PE #(.PX_WIDTH(IF_DATAWIDTH), .W_WIDTH(W_MEM_DATAWIDTH),.DATA_OUT_WIDTH(PE_DATAOUT_WIDTH)) Pe34
(
//////////// INPUTS //////////
.PE_Clk(ACCELERATOR_Clk_50),
.PE_Out_Reg_Set(Pedc_OutReg_Set),
.PE_Reset(Pedc_Reset),
.PE_Fifo_Set(Rbus_Om_SetEn[34]),
.PE_Is(Mux33_Output),
.PE_If_Px(Demux_1_2_If[IF_DATAWIDTH-1:0]),
.PE_w(Wreg34_Output_Data),
//////////// OUTPUT //////////
.PE_Out(Pe34_Output)
);

PE #(.PX_WIDTH(IF_DATAWIDTH), .W_WIDTH(W_MEM_DATAWIDTH),.DATA_OUT_WIDTH(PE_DATAOUT_WIDTH)) Pe35
(
//////////// INPUTS //////////
.PE_Clk(ACCELERATOR_Clk_50),
.PE_Out_Reg_Set(Pedc_OutReg_Set),
.PE_Reset(Pedc_Reset),
.PE_Fifo_Set(Rbus_Om_SetEn[35]),
.PE_Is(Mux34_Output),
.PE_If_Px(Demux_1_2_If[IF_DATAWIDTH-1:0]),
.PE_w(Wreg35_Output_Data),
//////////// OUTPUT //////////
.PE_Out(Pe35_Output)
);


//////////// Processing elements dataflow controller instantiation //////////

PEDC Pedc(
//////////// INPUTS //////////
.PEDC_Clk(ACCELERATOR_Clk_50),
.PEDC_Start_Routine(Main_Stm_Pedc_Start_Routine),
.PEDC_Stop_Routine(Main_Stm_Pedc_Stop_Routine),
//////////// OUTPUT //////////
.PEDC_OutReg_Set(Pedc_OutReg_Set),
.PEDC_Reset(Pedc_Reset)
);


//////////// Flip Clk module instantiation //////////

FCLOCK Fclock(
.FCLOCK_Ref_Clk(ACCELERATOR_Clk_50),
.FCLOCK_Clk(Fclock_clk)
);

//////////// On-chip fifo memory instantiation //////////

FIFO #(
.DATA_WIDTH(PE_DATAOUT_WIDTH),
.FIFO_SIZE(FIFO_SIZE),
.ADDR_WIDTH(FIFO_ADDR_WIDTH)) Ofifo0
(

.FIFO_Clk_1(ACCELERATOR_Clk_50),
.FIFO_Clk_2(Fclock_clk),
.FIFO_Rdptclr(Rbus_Om_Rptclr[0]),
.FIFO_Wrptclr(Rbus_Om_Wptclr[0]),
.FIFO_Rdinc(FIFO_Rdinc),
.FIFO_Wrinc(FIFO_Wrinc),
.FIFO_Wen(Rbus_Om_SetEn[0]),
.FIFO_Ren(Rbus_Om_OEn[0]),
.FIFO_Data_in(Pe0_Output),

//////////// OUTPUT //////////
.FIFO_Data_out(Ofifo0_Output)

);


FIFO #(
.DATA_WIDTH(PE_DATAOUT_WIDTH),
.FIFO_SIZE(FIFO_SIZE),
.ADDR_WIDTH(FIFO_ADDR_WIDTH)) Ofifo1
(

.FIFO_Clk_1(ACCELERATOR_Clk_50),
.FIFO_Clk_2(Fclock_clk),
.FIFO_Rdptclr(Rbus_Om_Rptclr[1]),
.FIFO_Wrptclr(Rbus_Om_Wptclr[1]),
.FIFO_Rdinc(FIFO_Rdinc),
.FIFO_Wrinc(FIFO_Wrinc),
.FIFO_Wen(Rbus_Om_SetEn[1]),
.FIFO_Ren(Rbus_Om_OEn[1]),
.FIFO_Data_in(Pe1_Output),

//////////// OUTPUT //////////
.FIFO_Data_out(Ofifo1_Output)


);

FIFO #(
.DATA_WIDTH(PE_DATAOUT_WIDTH),
.FIFO_SIZE(FIFO_SIZE),
.ADDR_WIDTH(FIFO_ADDR_WIDTH)) Ofifo2
(
.FIFO_Clk_1(ACCELERATOR_Clk_50),
.FIFO_Clk_2(Fclock_clk),
.FIFO_Rdptclr(Rbus_Om_Rptclr[2]),
.FIFO_Wrptclr(Rbus_Om_Wptclr[2]),
.FIFO_Rdinc(FIFO_Rdinc),
.FIFO_Wrinc(FIFO_Wrinc),
.FIFO_Wen(Rbus_Om_SetEn[2]),
.FIFO_Ren(Rbus_Om_OEn[2]),
.FIFO_Data_in(Pe2_Output),

//////////// OUTPUT //////////
.FIFO_Data_out(Ofifo2_Output)


);

FIFO #(
.DATA_WIDTH(PE_DATAOUT_WIDTH),
.FIFO_SIZE(FIFO_SIZE),
.ADDR_WIDTH(FIFO_ADDR_WIDTH)) Ofifo3
(

.FIFO_Clk_1(ACCELERATOR_Clk_50),
.FIFO_Clk_2(Fclock_clk),
.FIFO_Rdptclr(Rbus_Om_Rptclr[3]),
.FIFO_Wrptclr(Rbus_Om_Wptclr[3]),
.FIFO_Rdinc(FIFO_Rdinc),
.FIFO_Wrinc(FIFO_Wrinc),
.FIFO_Wen(Rbus_Om_SetEn[3]),
.FIFO_Ren(Rbus_Om_OEn[3]),
.FIFO_Data_in(Pe3_Output),

//////////// OUTPUT //////////
.FIFO_Data_out(Ofifo3_Output)


);


FIFO #(
.DATA_WIDTH(PE_DATAOUT_WIDTH),
.FIFO_SIZE(FIFO_SIZE),
.ADDR_WIDTH(FIFO_ADDR_WIDTH)) Ofifo4
(
.FIFO_Clk_1(ACCELERATOR_Clk_50),
.FIFO_Clk_2(Fclock_clk),
.FIFO_Rdptclr(Rbus_Om_Rptclr[4]),
.FIFO_Wrptclr(Rbus_Om_Wptclr[4]),
.FIFO_Rdinc(FIFO_Rdinc),
.FIFO_Wrinc(FIFO_Wrinc),
.FIFO_Wen(Rbus_Om_SetEn[4]),
.FIFO_Ren(Rbus_Om_OEn[4]),
.FIFO_Data_in(Pe4_Output),

//////////// OUTPUT //////////
.FIFO_Data_out(Ofifo4_Output)


);


FIFO #(
.DATA_WIDTH(PE_DATAOUT_WIDTH),
.FIFO_SIZE(FIFO_SIZE),
.ADDR_WIDTH(FIFO_ADDR_WIDTH)) Ofifo5
(

.FIFO_Clk_1(ACCELERATOR_Clk_50),
.FIFO_Clk_2(Fclock_clk),
.FIFO_Rdptclr(Rbus_Om_Rptclr[5]),
.FIFO_Wrptclr(Rbus_Om_Wptclr[5]),
.FIFO_Rdinc(FIFO_Rdinc),
.FIFO_Wrinc(FIFO_Wrinc),
.FIFO_Wen(Rbus_Om_SetEn[5]),
.FIFO_Ren(Rbus_Om_OEn[5]),
.FIFO_Data_in(Pe5_Output),

//////////// OUTPUT //////////
.FIFO_Data_out(Ofifo5_Output)

);


FIFO #(
.DATA_WIDTH(PE_DATAOUT_WIDTH),
.FIFO_SIZE(FIFO_SIZE),
.ADDR_WIDTH(FIFO_ADDR_WIDTH)) Ofifo6
(

.FIFO_Clk_1(ACCELERATOR_Clk_50),
.FIFO_Clk_2(Fclock_clk),
.FIFO_Rdptclr(Rbus_Om_Rptclr[6]),
.FIFO_Wrptclr(Rbus_Om_Wptclr[6]),
.FIFO_Rdinc(FIFO_Rdinc),
.FIFO_Wrinc(FIFO_Wrinc),
.FIFO_Wen(Rbus_Om_SetEn[6]),
.FIFO_Ren(Rbus_Om_OEn[6]),
.FIFO_Data_in(Pe6_Output),

//////////// OUTPUT //////////
.FIFO_Data_out(Ofifo6_Output)


);


FIFO #(
.DATA_WIDTH(PE_DATAOUT_WIDTH),
.FIFO_SIZE(FIFO_SIZE),
.ADDR_WIDTH(FIFO_ADDR_WIDTH)) Ofifo7
(

.FIFO_Clk_1(ACCELERATOR_Clk_50),
.FIFO_Clk_2(Fclock_clk),
.FIFO_Rdptclr(Rbus_Om_Rptclr[7]),
.FIFO_Wrptclr(Rbus_Om_Wptclr[7]),
.FIFO_Rdinc(FIFO_Rdinc),
.FIFO_Wrinc(FIFO_Wrinc),
.FIFO_Wen(Rbus_Om_SetEn[7]),
.FIFO_Ren(Rbus_Om_OEn[7]),
.FIFO_Data_in(Pe7_Output),

//////////// OUTPUT //////////
.FIFO_Data_out(Ofifo7_Output)


);

FIFO #(
.DATA_WIDTH(PE_DATAOUT_WIDTH),
.FIFO_SIZE(FIFO_SIZE),
.ADDR_WIDTH(FIFO_ADDR_WIDTH)) Ofifo8
(

.FIFO_Clk_1(ACCELERATOR_Clk_50),
.FIFO_Clk_2(Fclock_clk),
.FIFO_Rdptclr(Rbus_Om_Rptclr[8]),
.FIFO_Wrptclr(Rbus_Om_Wptclr[8]),
.FIFO_Rdinc(FIFO_Rdinc),
.FIFO_Wrinc(FIFO_Wrinc),
.FIFO_Wen(Rbus_Om_SetEn[8]),
.FIFO_Ren(Rbus_Om_OEn[8]),
.FIFO_Data_in(Pe8_Output),

//////////// OUTPUT //////////
.FIFO_Data_out(Ofifo8_Output)
);

FIFO #(
.DATA_WIDTH(PE_DATAOUT_WIDTH),
.FIFO_SIZE(FIFO_SIZE),
.ADDR_WIDTH(FIFO_ADDR_WIDTH)) Ofifo9
(

.FIFO_Clk_1(ACCELERATOR_Clk_50),
.FIFO_Clk_2(Fclock_clk),
.FIFO_Rdptclr(Rbus_Om_Rptclr[9]),
.FIFO_Wrptclr(Rbus_Om_Wptclr[9]),
.FIFO_Rdinc(FIFO_Rdinc),
.FIFO_Wrinc(FIFO_Wrinc),
.FIFO_Wen(Rbus_Om_SetEn[9]),
.FIFO_Ren(Rbus_Om_OEn[9]),
.FIFO_Data_in(Pe9_Output),

//////////// OUTPUT //////////
.FIFO_Data_out(Ofifo9_Output)
);
FIFO #(
.DATA_WIDTH(PE_DATAOUT_WIDTH),
.FIFO_SIZE(FIFO_SIZE),
.ADDR_WIDTH(FIFO_ADDR_WIDTH)) Ofifo10
(

.FIFO_Clk_1(ACCELERATOR_Clk_50),
.FIFO_Clk_2(Fclock_clk),
.FIFO_Rdptclr(Rbus_Om_Rptclr[10]),
.FIFO_Wrptclr(Rbus_Om_Wptclr[10]),
.FIFO_Rdinc(FIFO_Rdinc),
.FIFO_Wrinc(FIFO_Wrinc),
.FIFO_Wen(Rbus_Om_SetEn[10]),
.FIFO_Ren(Rbus_Om_OEn[10]),
.FIFO_Data_in(Pe10_Output),

//////////// OUTPUT //////////
.FIFO_Data_out(Ofifo10_Output)
);

FIFO #(
.DATA_WIDTH(PE_DATAOUT_WIDTH),
.FIFO_SIZE(FIFO_SIZE),
.ADDR_WIDTH(FIFO_ADDR_WIDTH)) Ofifo11
(

.FIFO_Clk_1(ACCELERATOR_Clk_50),
.FIFO_Clk_2(Fclock_clk),
.FIFO_Rdptclr(Rbus_Om_Rptclr[11]),
.FIFO_Wrptclr(Rbus_Om_Wptclr[11]),
.FIFO_Rdinc(FIFO_Rdinc),
.FIFO_Wrinc(FIFO_Wrinc),
.FIFO_Wen(Rbus_Om_SetEn[11]),
.FIFO_Ren(Rbus_Om_OEn[11]),
.FIFO_Data_in(Pe11_Output),

//////////// OUTPUT //////////
.FIFO_Data_out(Ofifo11_Output)
);

FIFO #(
.DATA_WIDTH(PE_DATAOUT_WIDTH),
.FIFO_SIZE(FIFO_SIZE),
.ADDR_WIDTH(FIFO_ADDR_WIDTH)) Ofifo12
(

.FIFO_Clk_1(ACCELERATOR_Clk_50),
.FIFO_Clk_2(Fclock_clk),
.FIFO_Rdptclr(Rbus_Om_Rptclr[12]),
.FIFO_Wrptclr(Rbus_Om_Wptclr[12]),
.FIFO_Rdinc(FIFO_Rdinc),
.FIFO_Wrinc(FIFO_Wrinc),
.FIFO_Wen(Rbus_Om_SetEn[12]),
.FIFO_Ren(Rbus_Om_OEn[12]),
.FIFO_Data_in(Pe12_Output),

//////////// OUTPUT //////////
.FIFO_Data_out(Ofifo12_Output)
);

FIFO #(
.DATA_WIDTH(PE_DATAOUT_WIDTH),
.FIFO_SIZE(FIFO_SIZE),
.ADDR_WIDTH(FIFO_ADDR_WIDTH)) Ofifo13
(

.FIFO_Clk_1(ACCELERATOR_Clk_50),
.FIFO_Clk_2(Fclock_clk),
.FIFO_Rdptclr(Rbus_Om_Rptclr[13]),
.FIFO_Wrptclr(Rbus_Om_Wptclr[13]),
.FIFO_Rdinc(FIFO_Rdinc),
.FIFO_Wrinc(FIFO_Wrinc),
.FIFO_Wen(Rbus_Om_SetEn[13]),
.FIFO_Ren(Rbus_Om_OEn[13]),
.FIFO_Data_in(Pe13_Output),

//////////// OUTPUT //////////
.FIFO_Data_out(Ofifo13_Output)
);

FIFO #(
.DATA_WIDTH(PE_DATAOUT_WIDTH),
.FIFO_SIZE(FIFO_SIZE),
.ADDR_WIDTH(FIFO_ADDR_WIDTH)) Ofifo14
(

.FIFO_Clk_1(ACCELERATOR_Clk_50),
.FIFO_Clk_2(Fclock_clk),
.FIFO_Rdptclr(Rbus_Om_Rptclr[14]),
.FIFO_Wrptclr(Rbus_Om_Wptclr[14]),
.FIFO_Rdinc(FIFO_Rdinc),
.FIFO_Wrinc(FIFO_Wrinc),
.FIFO_Wen(Rbus_Om_SetEn[14]),
.FIFO_Ren(Rbus_Om_OEn[14]),
.FIFO_Data_in(Pe14_Output),

//////////// OUTPUT //////////
.FIFO_Data_out(Ofifo14_Output)
);

FIFO #(
.DATA_WIDTH(PE_DATAOUT_WIDTH),
.FIFO_SIZE(FIFO_SIZE),
.ADDR_WIDTH(FIFO_ADDR_WIDTH)) Ofifo15
(

.FIFO_Clk_1(ACCELERATOR_Clk_50),
.FIFO_Clk_2(Fclock_clk),
.FIFO_Rdptclr(Rbus_Om_Rptclr[15]),
.FIFO_Wrptclr(Rbus_Om_Wptclr[15]),
.FIFO_Rdinc(FIFO_Rdinc),
.FIFO_Wrinc(FIFO_Wrinc),
.FIFO_Wen(Rbus_Om_SetEn[15]),
.FIFO_Ren(Rbus_Om_OEn[15]),
.FIFO_Data_in(Pe15_Output),

//////////// OUTPUT //////////
.FIFO_Data_out(Ofifo15_Output)
);

FIFO #(
.DATA_WIDTH(PE_DATAOUT_WIDTH),
.FIFO_SIZE(FIFO_SIZE),
.ADDR_WIDTH(FIFO_ADDR_WIDTH)) Ofifo16
(

.FIFO_Clk_1(ACCELERATOR_Clk_50),
.FIFO_Clk_2(Fclock_clk),
.FIFO_Rdptclr(Rbus_Om_Rptclr[16]),
.FIFO_Wrptclr(Rbus_Om_Wptclr[16]),
.FIFO_Rdinc(FIFO_Rdinc),
.FIFO_Wrinc(FIFO_Wrinc),
.FIFO_Wen(Rbus_Om_SetEn[16]),
.FIFO_Ren(Rbus_Om_OEn[16]),
.FIFO_Data_in(Pe16_Output),

//////////// OUTPUT //////////
.FIFO_Data_out(Ofifo16_Output)
);


FIFO #(
.DATA_WIDTH(PE_DATAOUT_WIDTH),
.FIFO_SIZE(FIFO_SIZE),
.ADDR_WIDTH(FIFO_ADDR_WIDTH)) Ofifo17
(

.FIFO_Clk_1(ACCELERATOR_Clk_50),
.FIFO_Clk_2(Fclock_clk),
.FIFO_Rdptclr(Rbus_Om_Rptclr[17]),
.FIFO_Wrptclr(Rbus_Om_Wptclr[17]),
.FIFO_Rdinc(FIFO_Rdinc),
.FIFO_Wrinc(FIFO_Wrinc),
.FIFO_Wen(Rbus_Om_SetEn[17]),
.FIFO_Ren(Rbus_Om_OEn[17]),
.FIFO_Data_in(Pe17_Output),

//////////// OUTPUT //////////
.FIFO_Data_out(Ofifo17_Output)
);

FIFO #(
.DATA_WIDTH(PE_DATAOUT_WIDTH),
.FIFO_SIZE(FIFO_SIZE),
.ADDR_WIDTH(FIFO_ADDR_WIDTH)) Ofifo18
(

.FIFO_Clk_1(ACCELERATOR_Clk_50),
.FIFO_Clk_2(Fclock_clk),
.FIFO_Rdptclr(Rbus_Om_Rptclr[18]),
.FIFO_Wrptclr(Rbus_Om_Wptclr[18]),
.FIFO_Rdinc(FIFO_Rdinc),
.FIFO_Wrinc(FIFO_Wrinc),
.FIFO_Wen(Rbus_Om_SetEn[18]),
.FIFO_Ren(Rbus_Om_OEn[18]),
.FIFO_Data_in(Pe18_Output),

//////////// OUTPUT //////////
.FIFO_Data_out(Ofifo18_Output)
);

FIFO #(
.DATA_WIDTH(PE_DATAOUT_WIDTH),
.FIFO_SIZE(FIFO_SIZE),
.ADDR_WIDTH(FIFO_ADDR_WIDTH)) Ofifo19
(

.FIFO_Clk_1(ACCELERATOR_Clk_50),
.FIFO_Clk_2(Fclock_clk),
.FIFO_Rdptclr(Rbus_Om_Rptclr[19]),
.FIFO_Wrptclr(Rbus_Om_Wptclr[19]),
.FIFO_Rdinc(FIFO_Rdinc),
.FIFO_Wrinc(FIFO_Wrinc),
.FIFO_Wen(Rbus_Om_SetEn[19]),
.FIFO_Ren(Rbus_Om_OEn[19]),
.FIFO_Data_in(Pe19_Output),

//////////// OUTPUT //////////
.FIFO_Data_out(Ofifo19_Output)
);

FIFO #(
.DATA_WIDTH(PE_DATAOUT_WIDTH),
.FIFO_SIZE(FIFO_SIZE),
.ADDR_WIDTH(FIFO_ADDR_WIDTH)) Ofifo20
(

.FIFO_Clk_1(ACCELERATOR_Clk_50),
.FIFO_Clk_2(Fclock_clk),
.FIFO_Rdptclr(Rbus_Om_Rptclr[20]),
.FIFO_Wrptclr(Rbus_Om_Wptclr[20]),
.FIFO_Rdinc(FIFO_Rdinc),
.FIFO_Wrinc(FIFO_Wrinc),
.FIFO_Wen(Rbus_Om_SetEn[20]),
.FIFO_Ren(Rbus_Om_OEn[20]),
.FIFO_Data_in(Pe20_Output),

//////////// OUTPUT //////////
.FIFO_Data_out(Ofifo20_Output)
);

FIFO #(
.DATA_WIDTH(PE_DATAOUT_WIDTH),
.FIFO_SIZE(FIFO_SIZE),
.ADDR_WIDTH(FIFO_ADDR_WIDTH)) Ofifo21
(

.FIFO_Clk_1(ACCELERATOR_Clk_50),
.FIFO_Clk_2(Fclock_clk),
.FIFO_Rdptclr(Rbus_Om_Rptclr[21]),
.FIFO_Wrptclr(Rbus_Om_Wptclr[21]),
.FIFO_Rdinc(FIFO_Rdinc),
.FIFO_Wrinc(FIFO_Wrinc),
.FIFO_Wen(Rbus_Om_SetEn[21]),
.FIFO_Ren(Rbus_Om_OEn[21]),
.FIFO_Data_in(Pe21_Output),

//////////// OUTPUT //////////
.FIFO_Data_out(Ofifo21_Output)
);

FIFO #(
.DATA_WIDTH(PE_DATAOUT_WIDTH),
.FIFO_SIZE(FIFO_SIZE),
.ADDR_WIDTH(FIFO_ADDR_WIDTH)) Ofifo22
(

.FIFO_Clk_1(ACCELERATOR_Clk_50),
.FIFO_Clk_2(Fclock_clk),
.FIFO_Rdptclr(Rbus_Om_Rptclr[22]),
.FIFO_Wrptclr(Rbus_Om_Wptclr[22]),
.FIFO_Rdinc(FIFO_Rdinc),
.FIFO_Wrinc(FIFO_Wrinc),
.FIFO_Wen(Rbus_Om_SetEn[22]),
.FIFO_Ren(Rbus_Om_OEn[22]),
.FIFO_Data_in(Pe22_Output),

//////////// OUTPUT //////////
.FIFO_Data_out(Ofifo22_Output)
);

FIFO #(
.DATA_WIDTH(PE_DATAOUT_WIDTH),
.FIFO_SIZE(FIFO_SIZE),
.ADDR_WIDTH(FIFO_ADDR_WIDTH)) Ofifo23
(

.FIFO_Clk_1(ACCELERATOR_Clk_50),
.FIFO_Clk_2(Fclock_clk),
.FIFO_Rdptclr(Rbus_Om_Rptclr[23]),
.FIFO_Wrptclr(Rbus_Om_Wptclr[23]),
.FIFO_Rdinc(FIFO_Rdinc),
.FIFO_Wrinc(FIFO_Wrinc),
.FIFO_Wen(Rbus_Om_SetEn[23]),
.FIFO_Ren(Rbus_Om_OEn[23]),
.FIFO_Data_in(Pe23_Output),

//////////// OUTPUT //////////
.FIFO_Data_out(Ofifo23_Output)
);

FIFO #(
.DATA_WIDTH(PE_DATAOUT_WIDTH),
.FIFO_SIZE(FIFO_SIZE),
.ADDR_WIDTH(FIFO_ADDR_WIDTH)) Ofifo24
(

.FIFO_Clk_1(ACCELERATOR_Clk_50),
.FIFO_Clk_2(Fclock_clk),
.FIFO_Rdptclr(Rbus_Om_Rptclr[24]),
.FIFO_Wrptclr(Rbus_Om_Wptclr[24]),
.FIFO_Rdinc(FIFO_Rdinc),
.FIFO_Wrinc(FIFO_Wrinc),
.FIFO_Wen(Rbus_Om_SetEn[24]),
.FIFO_Ren(Rbus_Om_OEn[24]),
.FIFO_Data_in(Pe24_Output),

//////////// OUTPUT //////////
.FIFO_Data_out(Ofifo24_Output)
);

FIFO #(
.DATA_WIDTH(PE_DATAOUT_WIDTH),
.FIFO_SIZE(FIFO_SIZE),
.ADDR_WIDTH(FIFO_ADDR_WIDTH)) Ofifo25
(

.FIFO_Clk_1(ACCELERATOR_Clk_50),
.FIFO_Clk_2(Fclock_clk),
.FIFO_Rdptclr(Rbus_Om_Rptclr[25]),
.FIFO_Wrptclr(Rbus_Om_Wptclr[25]),
.FIFO_Rdinc(FIFO_Rdinc),
.FIFO_Wrinc(FIFO_Wrinc),
.FIFO_Wen(Rbus_Om_SetEn[25]),
.FIFO_Ren(Rbus_Om_OEn[25]),
.FIFO_Data_in(Pe25_Output),

//////////// OUTPUT //////////
.FIFO_Data_out(Ofifo25_Output)
);

FIFO #(
.DATA_WIDTH(PE_DATAOUT_WIDTH),
.FIFO_SIZE(FIFO_SIZE),
.ADDR_WIDTH(FIFO_ADDR_WIDTH)) Ofifo26
(

.FIFO_Clk_1(ACCELERATOR_Clk_50),
.FIFO_Clk_2(Fclock_clk),
.FIFO_Rdptclr(Rbus_Om_Rptclr[26]),
.FIFO_Wrptclr(Rbus_Om_Wptclr[26]),
.FIFO_Rdinc(FIFO_Rdinc),
.FIFO_Wrinc(FIFO_Wrinc),
.FIFO_Wen(Rbus_Om_SetEn[26]),
.FIFO_Ren(Rbus_Om_OEn[26]),
.FIFO_Data_in(Pe26_Output),

//////////// OUTPUT //////////
.FIFO_Data_out(Ofifo26_Output)
);

FIFO #(
.DATA_WIDTH(PE_DATAOUT_WIDTH),
.FIFO_SIZE(FIFO_SIZE),
.ADDR_WIDTH(FIFO_ADDR_WIDTH)) Ofifo27
(

.FIFO_Clk_1(ACCELERATOR_Clk_50),
.FIFO_Clk_2(Fclock_clk),
.FIFO_Rdptclr(Rbus_Om_Rptclr[27]),
.FIFO_Wrptclr(Rbus_Om_Wptclr[27]),
.FIFO_Rdinc(FIFO_Rdinc),
.FIFO_Wrinc(FIFO_Wrinc),
.FIFO_Wen(Rbus_Om_SetEn[27]),
.FIFO_Ren(Rbus_Om_OEn[27]),
.FIFO_Data_in(Pe27_Output),

//////////// OUTPUT //////////
.FIFO_Data_out(Ofifo27_Output)
);

FIFO #(
.DATA_WIDTH(PE_DATAOUT_WIDTH),
.FIFO_SIZE(FIFO_SIZE),
.ADDR_WIDTH(FIFO_ADDR_WIDTH)) Ofifo28
(

.FIFO_Clk_1(ACCELERATOR_Clk_50),
.FIFO_Clk_2(Fclock_clk),
.FIFO_Rdptclr(Rbus_Om_Rptclr[28]),
.FIFO_Wrptclr(Rbus_Om_Wptclr[28]),
.FIFO_Rdinc(FIFO_Rdinc),
.FIFO_Wrinc(FIFO_Wrinc),
.FIFO_Wen(Rbus_Om_SetEn[28]),
.FIFO_Ren(Rbus_Om_OEn[28]),
.FIFO_Data_in(Pe28_Output),

//////////// OUTPUT //////////
.FIFO_Data_out(Ofifo28_Output)
);

FIFO #(
.DATA_WIDTH(PE_DATAOUT_WIDTH),
.FIFO_SIZE(FIFO_SIZE),
.ADDR_WIDTH(FIFO_ADDR_WIDTH)) Ofifo29
(

.FIFO_Clk_1(ACCELERATOR_Clk_50),
.FIFO_Clk_2(Fclock_clk),
.FIFO_Rdptclr(Rbus_Om_Rptclr[29]),
.FIFO_Wrptclr(Rbus_Om_Wptclr[29]),
.FIFO_Rdinc(FIFO_Rdinc),
.FIFO_Wrinc(FIFO_Wrinc),
.FIFO_Wen(Rbus_Om_SetEn[29]),
.FIFO_Ren(Rbus_Om_OEn[29]),
.FIFO_Data_in(Pe29_Output),

//////////// OUTPUT //////////
.FIFO_Data_out(Ofifo29_Output)
);

FIFO #(
.DATA_WIDTH(PE_DATAOUT_WIDTH),
.FIFO_SIZE(FIFO_SIZE),
.ADDR_WIDTH(FIFO_ADDR_WIDTH)) Ofifo30
(

.FIFO_Clk_1(ACCELERATOR_Clk_50),
.FIFO_Clk_2(Fclock_clk),
.FIFO_Rdptclr(Rbus_Om_Rptclr[30]),
.FIFO_Wrptclr(Rbus_Om_Wptclr[30]),
.FIFO_Rdinc(FIFO_Rdinc),
.FIFO_Wrinc(FIFO_Wrinc),
.FIFO_Wen(Rbus_Om_SetEn[30]),
.FIFO_Ren(Rbus_Om_OEn[30]),
.FIFO_Data_in(Pe30_Output),

//////////// OUTPUT //////////
.FIFO_Data_out(Ofifo30_Output)
);

FIFO #(
.DATA_WIDTH(PE_DATAOUT_WIDTH),
.FIFO_SIZE(FIFO_SIZE),
.ADDR_WIDTH(FIFO_ADDR_WIDTH)) Ofifo31
(

.FIFO_Clk_1(ACCELERATOR_Clk_50),
.FIFO_Clk_2(Fclock_clk),
.FIFO_Rdptclr(Rbus_Om_Rptclr[31]),
.FIFO_Wrptclr(Rbus_Om_Wptclr[31]),
.FIFO_Rdinc(FIFO_Rdinc),
.FIFO_Wrinc(FIFO_Wrinc),
.FIFO_Wen(Rbus_Om_SetEn[31]),
.FIFO_Ren(Rbus_Om_OEn[31]),
.FIFO_Data_in(Pe31_Output),

//////////// OUTPUT //////////
.FIFO_Data_out(Ofifo31_Output)
);

FIFO #(
.DATA_WIDTH(PE_DATAOUT_WIDTH),
.FIFO_SIZE(FIFO_SIZE),
.ADDR_WIDTH(FIFO_ADDR_WIDTH)) Ofifo32
(

.FIFO_Clk_1(ACCELERATOR_Clk_50),
.FIFO_Clk_2(Fclock_clk),
.FIFO_Rdptclr(Rbus_Om_Rptclr[32]),
.FIFO_Wrptclr(Rbus_Om_Wptclr[32]),
.FIFO_Rdinc(FIFO_Rdinc),
.FIFO_Wrinc(FIFO_Wrinc),
.FIFO_Wen(Rbus_Om_SetEn[32]),
.FIFO_Ren(Rbus_Om_OEn[32]),
.FIFO_Data_in(Pe32_Output),

//////////// OUTPUT //////////
.FIFO_Data_out(Ofifo32_Output)
);

FIFO #(
.DATA_WIDTH(PE_DATAOUT_WIDTH),
.FIFO_SIZE(FIFO_SIZE),
.ADDR_WIDTH(FIFO_ADDR_WIDTH)) Ofifo33
(

.FIFO_Clk_1(ACCELERATOR_Clk_50),
.FIFO_Clk_2(Fclock_clk),
.FIFO_Rdptclr(Rbus_Om_Rptclr[33]),
.FIFO_Wrptclr(Rbus_Om_Wptclr[33]),
.FIFO_Rdinc(FIFO_Rdinc),
.FIFO_Wrinc(FIFO_Wrinc),
.FIFO_Wen(Rbus_Om_SetEn[33]),
.FIFO_Ren(Rbus_Om_OEn[33]),
.FIFO_Data_in(Pe33_Output),

//////////// OUTPUT //////////
.FIFO_Data_out(Ofifo33_Output)
);

FIFO #(
.DATA_WIDTH(PE_DATAOUT_WIDTH),
.FIFO_SIZE(FIFO_SIZE),
.ADDR_WIDTH(FIFO_ADDR_WIDTH)) Ofifo34
(

.FIFO_Clk_1(ACCELERATOR_Clk_50),
.FIFO_Clk_2(Fclock_clk),
.FIFO_Rdptclr(Rbus_Om_Rptclr[34]),
.FIFO_Wrptclr(Rbus_Om_Wptclr[34]),
.FIFO_Rdinc(FIFO_Rdinc),
.FIFO_Wrinc(FIFO_Wrinc),
.FIFO_Wen(Rbus_Om_SetEn[34]),
.FIFO_Ren(Rbus_Om_OEn[34]),
.FIFO_Data_in(Pe34_Output),

//////////// OUTPUT //////////
.FIFO_Data_out(Ofifo34_Output)
);

FIFO #(
.DATA_WIDTH(PE_DATAOUT_WIDTH),
.FIFO_SIZE(FIFO_SIZE),
.ADDR_WIDTH(FIFO_ADDR_WIDTH)) Ofifo35
(

.FIFO_Clk_1(ACCELERATOR_Clk_50),
.FIFO_Clk_2(Fclock_clk),
.FIFO_Rdptclr(Rbus_Om_Rptclr[35]),
.FIFO_Wrptclr(Rbus_Om_Wptclr[35]),
.FIFO_Rdinc(FIFO_Rdinc),
.FIFO_Wrinc(FIFO_Wrinc),
.FIFO_Wen(Rbus_Om_SetEn[35]),
.FIFO_Ren(Rbus_Om_OEn[35]),
.FIFO_Data_in(Pe35_Output),

//////////// OUTPUT //////////
.FIFO_Data_out(Ofifo35_Output)
);



//////////// multiplexer instantiation //////////

MUX_2_1 #(.INPUT_DATA_WIDTH(PE_DATAOUT_WIDTH)) Mux0
(
//////////// INPUTS //////////
.MUX_Input_0(Pe0_Output),
.MUX_Input_1(Ofifo0_Output),
.MUX_sel(Muxdc_Muxes_Sel[0]),

//////////// OUTPUT //////////
.MUX_OUTPUT(Mux0_Output)
);

MUX_2_1 #(.INPUT_DATA_WIDTH(PE_DATAOUT_WIDTH)) Mux1
(
//////////// INPUTS //////////
.MUX_Input_0(Pe1_Output),
.MUX_Input_1(Ofifo1_Output),
.MUX_sel(Muxdc_Muxes_Sel[1]),

//////////// OUTPUT //////////
.MUX_OUTPUT(Mux1_Output)
);

MUX_2_1 #(.INPUT_DATA_WIDTH(PE_DATAOUT_WIDTH)) Mux2
(
//////////// INPUTS //////////
.MUX_Input_0(Pe2_Output),
.MUX_Input_1(Ofifo2_Output),
.MUX_sel(Muxdc_Muxes_Sel[2]),

//////////// OUTPUT //////////
.MUX_OUTPUT(Mux2_Output)
);

MUX_2_1 #(.INPUT_DATA_WIDTH(PE_DATAOUT_WIDTH)) Mux3
(
//////////// INPUTS //////////
.MUX_Input_0(Pe3_Output),
.MUX_Input_1(Ofifo3_Output),
.MUX_sel(Muxdc_Muxes_Sel[3]),

//////////// OUTPUT //////////
.MUX_OUTPUT(Mux3_Output)
);

MUX_2_1 #(.INPUT_DATA_WIDTH(PE_DATAOUT_WIDTH)) Mux4
(
//////////// INPUTS //////////
.MUX_Input_0(Pe4_Output),
.MUX_Input_1(Ofifo4_Output),
.MUX_sel(Muxdc_Muxes_Sel[4]),

//////////// OUTPUT //////////
.MUX_OUTPUT(Mux4_Output)
);

MUX_2_1 #(.INPUT_DATA_WIDTH(PE_DATAOUT_WIDTH)) Mux5
(
//////////// INPUTS //////////.MUX_Input_1(Ofifo15_Output),
.MUX_Input_0(Pe5_Output),
.MUX_Input_1(Ofifo5_Output),
.MUX_sel(Muxdc_Muxes_Sel[5]),

//////////// OUTPUT //////////
.MUX_OUTPUT(Mux5_Output)
);

MUX_2_1 #(.INPUT_DATA_WIDTH(PE_DATAOUT_WIDTH)) Mux6
(
//////////// INPUTS //////////
.MUX_Input_0(Pe6_Output),
.MUX_Input_1(Ofifo6_Output),
.MUX_sel(Muxdc_Muxes_Sel[6]),

//////////// OUTPUT //////////
.MUX_OUTPUT(Mux6_Output)
);


MUX_2_1 #(.INPUT_DATA_WIDTH(PE_DATAOUT_WIDTH)) Mux7
(
//////////// INPUTS //////////
.MUX_Input_0(Pe7_Output),
.MUX_Input_1(Ofifo7_Output),
.MUX_sel(Muxdc_Muxes_Sel[7]),

//////////// OUTPUT //////////
.MUX_OUTPUT(Mux7_Output)
);

MUX_2_1 #(.INPUT_DATA_WIDTH(PE_DATAOUT_WIDTH)) Mux8
(
//////////// INPUTS //////////
.MUX_Input_0(Pe8_Output),
.MUX_Input_1(Ofifo8_Output),
.MUX_sel(Muxdc_Muxes_Sel[8]),

//////////// OUTPUT //////////
.MUX_OUTPUT(Mux8_Output)
);

MUX_2_1 #(.INPUT_DATA_WIDTH(PE_DATAOUT_WIDTH)) Mux9
(
//////////// INPUTS //////////
.MUX_Input_0(Pe9_Output),
.MUX_Input_1(Ofifo9_Output),
.MUX_sel(Muxdc_Muxes_Sel[9]),

//////////// OUTPUT //////////
.MUX_OUTPUT(Mux9_Output)
);

MUX_2_1 #(.INPUT_DATA_WIDTH(PE_DATAOUT_WIDTH)) Mux10
(
//////////// INPUTS //////////
.MUX_Input_0(Pe10_Output),
.MUX_Input_1(Ofifo10_Output),
.MUX_sel(Muxdc_Muxes_Sel[10]),

//////////// OUTPUT //////////
.MUX_OUTPUT(Mux10_Output)
);

MUX_2_1 #(.INPUT_DATA_WIDTH(PE_DATAOUT_WIDTH)) Mux11
(
//////////// INPUTS //////////
.MUX_Input_0(Pe11_Output),
.MUX_Input_1(Ofifo11_Output),
.MUX_sel(Muxdc_Muxes_Sel[11]),

//////////// OUTPUT //////////
.MUX_OUTPUT(Mux11_Output)
);

MUX_2_1 #(.INPUT_DATA_WIDTH(PE_DATAOUT_WIDTH)) Mux12
(
//////////// INPUTS //////////
.MUX_Input_0(Pe12_Output),
.MUX_Input_1(Ofifo12_Output),
.MUX_sel(Muxdc_Muxes_Sel[12]),

//////////// OUTPUT //////////
.MUX_OUTPUT(Mux12_Output)
);

MUX_2_1 #(.INPUT_DATA_WIDTH(PE_DATAOUT_WIDTH)) Mux13
(
//////////// INPUTS //////////
.MUX_Input_0(Pe13_Output),
.MUX_Input_1(Ofifo13_Output),
.MUX_sel(Muxdc_Muxes_Sel[13]),

//////////// OUTPUT //////////
.MUX_OUTPUT(Mux13_Output)
);

MUX_2_1 #(.INPUT_DATA_WIDTH(PE_DATAOUT_WIDTH)) Mux14
(
//////////// INPUTS //////////
.MUX_Input_0(Pe14_Output),
.MUX_Input_1(Ofifo14_Output),
.MUX_sel(Muxdc_Muxes_Sel[14]),

//////////// OUTPUT //////////
.MUX_OUTPUT(Mux14_Output)
);

MUX_2_1 #(.INPUT_DATA_WIDTH(PE_DATAOUT_WIDTH)) Mux15
(
//////////// INPUTS //////////
.MUX_Input_0(Pe15_Output),
.MUX_Input_1(Ofifo15_Output),
.MUX_sel(Muxdc_Muxes_Sel[15]),

//////////// OUTPUT //////////
.MUX_OUTPUT(Mux15_Output)
);

MUX_2_1 #(.INPUT_DATA_WIDTH(PE_DATAOUT_WIDTH)) Mux16
(
//////////// INPUTS //////////
.MUX_Input_0(Pe16_Output),
.MUX_Input_1(Ofifo16_Output),
.MUX_sel(Muxdc_Muxes_Sel[16]),

//////////// OUTPUT //////////
.MUX_OUTPUT(Mux16_Output)
);

MUX_2_1 #(.INPUT_DATA_WIDTH(PE_DATAOUT_WIDTH)) Mux17
(
//////////// INPUTS //////////
.MUX_Input_0(Pe17_Output),
.MUX_Input_1(Ofifo17_Output),
.MUX_sel(Muxdc_Muxes_Sel[17]),

//////////// OUTPUT //////////
.MUX_OUTPUT(Mux17_Output)
);

MUX_2_1 #(.INPUT_DATA_WIDTH(PE_DATAOUT_WIDTH)) Mux18
(
//////////// INPUTS //////////
.MUX_Input_0(Pe18_Output),
.MUX_Input_1(Ofifo18_Output),
.MUX_sel(Muxdc_Muxes_Sel[18]),

//////////// OUTPUT //////////
.MUX_OUTPUT(Mux18_Output)
);

MUX_2_1 #(.INPUT_DATA_WIDTH(PE_DATAOUT_WIDTH)) Mux19
(
//////////// INPUTS //////////
.MUX_Input_0(Pe19_Output),
.MUX_Input_1(Ofifo19_Output),
.MUX_sel(Muxdc_Muxes_Sel[19]),

//////////// OUTPUT //////////
.MUX_OUTPUT(Mux19_Output)
);

MUX_2_1 #(.INPUT_DATA_WIDTH(PE_DATAOUT_WIDTH)) Mux20
(
//////////// INPUTS //////////
.MUX_Input_0(Pe20_Output),
.MUX_Input_1(Ofifo20_Output),
.MUX_sel(Muxdc_Muxes_Sel[20]),

//////////// OUTPUT //////////
.MUX_OUTPUT(Mux20_Output)

);


MUX_2_1 #(.INPUT_DATA_WIDTH(PE_DATAOUT_WIDTH)) Mux21
(
//////////// INPUTS //////////
.MUX_Input_0(Pe21_Output),
.MUX_Input_1(Ofifo21_Output),
.MUX_sel(Muxdc_Muxes_Sel[21]),

//////////// OUTPUT //////////
.MUX_OUTPUT(Mux21_Output)
);

MUX_2_1 #(.INPUT_DATA_WIDTH(PE_DATAOUT_WIDTH)) Mux22
(
//////////// INPUTS //////////
.MUX_Input_0(Pe22_Output),
.MUX_Input_1(Ofifo22_Output),
.MUX_sel(Muxdc_Muxes_Sel[22]),

//////////// OUTPUT //////////
.MUX_OUTPUT(Mux22_Output)
);

MUX_2_1 #(.INPUT_DATA_WIDTH(PE_DATAOUT_WIDTH)) Mux23
(
//////////// INPUTS //////////
.MUX_Input_0(Pe23_Output),
.MUX_Input_1(Ofifo23_Output),
.MUX_sel(Muxdc_Muxes_Sel[23]),

//////////// OUTPUT //////////
.MUX_OUTPUT(Mux23_Output)
);

MUX_2_1 #(.INPUT_DATA_WIDTH(PE_DATAOUT_WIDTH)) Mux24
(
//////////// INPUTS //////////
.MUX_Input_0(Pe24_Output),
.MUX_Input_1(Ofifo24_Output),
.MUX_sel(Muxdc_Muxes_Sel[24]),

//////////// OUTPUT //////////
.MUX_OUTPUT(Mux24_Output)
);

MUX_2_1 #(.INPUT_DATA_WIDTH(PE_DATAOUT_WIDTH)) Mux25
(
//////////// INPUTS //////////
.MUX_Input_0(Pe25_Output),
.MUX_Input_1(Ofifo25_Output),
.MUX_sel(Muxdc_Muxes_Sel[25]),

//////////// OUTPUT //////////
.MUX_OUTPUT(Mux25_Output)
);

MUX_2_1 #(.INPUT_DATA_WIDTH(PE_DATAOUT_WIDTH)) Mux26
(
//////////// INPUTS //////////
.MUX_Input_0(Pe26_Output),
.MUX_Input_1(Ofifo26_Output),
.MUX_sel(Muxdc_Muxes_Sel[26]),

//////////// OUTPUT //////////
.MUX_OUTPUT(Mux26_Output)
);

MUX_2_1 #(.INPUT_DATA_WIDTH(PE_DATAOUT_WIDTH)) Mux27
(
//////////// INPUTS //////////
.MUX_Input_0(Pe27_Output),
.MUX_Input_1(Ofifo27_Output),
.MUX_sel(Muxdc_Muxes_Sel[27]),

//////////// OUTPUT //////////
.MUX_OUTPUT(Mux27_Output)
);

MUX_2_1 #(.INPUT_DATA_WIDTH(PE_DATAOUT_WIDTH)) Mux28
(
//////////// INPUTS //////////
.MUX_Input_0(Pe28_Output),
.MUX_Input_1(Ofifo28_Output),
.MUX_sel(Muxdc_Muxes_Sel[28]),

//////////// OUTPUT //////////
.MUX_OUTPUT(Mux28_Output)
);


MUX_2_1 #(.INPUT_DATA_WIDTH(PE_DATAOUT_WIDTH)) Mux29
(
//////////// INPUTS //////////
.MUX_Input_0(Pe29_Output),
.MUX_Input_1(Ofifo29_Output),
.MUX_sel(Muxdc_Muxes_Sel[29]),

//////////// OUTPUT //////////
.MUX_OUTPUT(Mux29_Output)
);


MUX_2_1 #(.INPUT_DATA_WIDTH(PE_DATAOUT_WIDTH)) Mux30
(
//////////// INPUTS //////////
.MUX_Input_0(Pe30_Output),
.MUX_Input_1(Ofifo30_Output),
.MUX_sel(Muxdc_Muxes_Sel[30]),

//////////// OUTPUT //////////
.MUX_OUTPUT(Mux30_Output)
);
MUX_2_1 #(.INPUT_DATA_WIDTH(PE_DATAOUT_WIDTH)) Mux31
(
//////////// INPUTS //////////
.MUX_Input_0(Pe31_Output),
.MUX_Input_1(Ofifo31_Output),
.MUX_sel(Muxdc_Muxes_Sel[31]),

//////////// OUTPUT //////////
.MUX_OUTPUT(Mux31_Output)
);

MUX_2_1 #(.INPUT_DATA_WIDTH(PE_DATAOUT_WIDTH)) Mux32
(
//////////// INPUTS //////////
.MUX_Input_0(Pe32_Output),
.MUX_Input_1(Ofifo32_Output),
.MUX_sel(Muxdc_Muxes_Sel[32]),

//////////// OUTPUT //////////
.MUX_OUTPUT(Mux32_Output)
);

MUX_2_1 #(.INPUT_DATA_WIDTH(PE_DATAOUT_WIDTH)) Mux33
(
//////////// INPUTS //////////
.MUX_Input_0(Pe33_Output),
.MUX_Input_1(Ofifo33_Output),
.MUX_sel(Muxdc_Muxes_Sel[33]),

//////////// OUTPUT //////////
.MUX_OUTPUT(Mux33_Output)
);

MUX_2_1 #(.INPUT_DATA_WIDTH(PE_DATAOUT_WIDTH)) Mux34
(
//////////// INPUTS //////////
.MUX_Input_0(Pe34_Output),
.MUX_Input_1(Ofifo34_Output),
.MUX_sel(Muxdc_Muxes_Sel[34]),

//////////// OUTPUT //////////
.MUX_OUTPUT(Mux34_Output)
);


//////////// Calc unit instantiation //////////

CALC_UNIT Calc_Unit(

//////////// INPUTS //////////If_Size_1
.CALC_UNIT_If_Rows(ACCELERATOR_IF_ROWS),
.CALC_UNIT_If_Colums(ACCELERATOR_IF_COLUMS),
.CALC_UNIT_If_Channels(ACCELERATOR_IF_CHANNELS),
.CALC_UNIT_Of_Rows(ACCELERATOR_OF_ROWS),
.CALC_UNIT_Of_Colums(ACCELERATOR_OF_COLUMS),
.CALC_UNIT_W_Rows(ACCELERATOR_W_ROWS),
.CALC_UNIT_W_Colums(ACCELERATOR_W_COLUMS),
.CALC_UNIT_W_Channels(ACCELERATOR_W_CHANNELS),

//////////// OUTPUTS //////////
.CALC_UNIT_W_Size_1(Calc_Unit_W_Size_1),
.CALC_UNIT_If_Size_1(Calc_Unit_If_Size_1),
.CALC_UNIT_Of_Size_1(Calc_Unit_Of_Size_1),
.CALC_UNIT_W_ROXCL_1(Calc_Unit_W_ROXCL_1),
.CALC_UNIT_W_Colums_1(Calc_Unit_W_Colums_1)
);



//////////// Mux 169 instantiation //////////

MUX_169 #(.INPUT_DATA_WIDTH(PE_DATAOUT_WIDTH)) Mux169(

/////////////// INPUTS ///////////////
.MUX_selector(Calc_Unit_W_ROXCL_1),
.MUX_In0(Ofifo0_Output),
.MUX_In1(Ofifo1_Output),
.MUX_In2(Ofifo2_Output),
.MUX_In3(Ofifo3_Output),
.MUX_In4(Ofifo4_Output),
.MUX_In5(Ofifo5_Output),
.MUX_In6(Ofifo6_Output),
.MUX_In7(Ofifo7_Output),
.MUX_In8(Ofifo8_Output),
.MUX_In9(Ofifo9_Output),
.MUX_In10(Ofifo10_Output),
.MUX_In11(Ofifo11_Output),
.MUX_In12(Ofifo12_Output),
.MUX_In13(Ofifo13_Output),
.MUX_In14(Ofifo14_Output),
.MUX_In15(Ofifo15_Output),
.MUX_In16(Ofifo16_Output),
.MUX_In17(Ofifo17_Output),
.MUX_In18(Ofifo18_Output),
.MUX_In19(Ofifo19_Output),
.MUX_In20(Ofifo20_Output),
.MUX_In21(Ofifo21_Output),
.MUX_In22(Ofifo22_Output),
.MUX_In23(Ofifo23_Output),
.MUX_In24(Ofifo24_Output),
.MUX_In25(Ofifo25_Output),
.MUX_In26(Ofifo26_Output),
.MUX_In27(Ofifo27_Output),
.MUX_In28(Ofifo28_Output),
.MUX_In29(Ofifo29_Output),
.MUX_In30(Ofifo30_Output),
.MUX_In31(Ofifo31_Output),
.MUX_In32(Ofifo32_Output),
.MUX_In33(Ofifo33_Output),
.MUX_In34(Ofifo34_Output),
.MUX_In35(Ofifo35_Output),
/////////////// OUTPUTS ///////////////
.MUX_OUTPUT(Mux169_DataOut)

);


//////////// Memories channel instantiation //////////

MEMORIES_CHANNEL Memories_Channel(


//////////// INPUTS //////////
.MEMORIES_CHANNEL_Clk(ACCELERATOR_Clk_50),
.MEMORIES_CHANNEL_Start(Main_Stm_Channel_Controller_Start),
.MEMORIES_CHANNEL_Reset(Main_Stm_Channel_Controller_Reset),
.MEMORIES_CHANNEL_Select_En(Omdc_control_channel_select_en),
.MEMORIES_CHANNEL_In_Output_Rutine(Omdc_In_Output_Routine),
.MEMORIES_CHANNEL_New_Channel_Flag(Omdc_new_channel_flag),
.MEMORIES_CHANNEL_Re(Adder_Channel_Mems_Re),
.MEMORIES_CHANNEL_Input_Data(Mux169_DataOut),

//////////// OUTPUTS //////////
.MEMORIES_CHANNEL_Out_Mem1(Memories_Channel_Out_Mem1),
.MEMORIES_CHANNEL_Out_Mem2(Memories_Channel_Out_Mem2),
.MEMORIES_CHANNEL_Out_Mem3(Memories_Channel_Out_Mem3)

);


//////////// Adder instantiation //////////

ADDER #(
.MEM_OUT_DATA_WIDTH(PE_DATAOUT_WIDTH),
.BITWIDTH_MAX_IF_SIZE(IF_BITWIDTH_MAXSIZE),
.BITWIDTH_DATA_OUT(BITWIDTH_DATA_OUT),
.BITWIDTH_IF_CHANNELS(BITWIDTH_IF_CHANNELS)) Adder 
(

//////////// INPUTS //////////
.ADDER_Clk(ACCELERATOR_Clk_50),
.ADDER_Start_Routine(Main_Stm_Adder_Start_Routine),
.ADDER_Routine_Finished_Already_Ok(Main_Stm_Adder_Routine_Finished_Already_Ok),
.ADDER_If_Channels(ACCELERATOR_IF_CHANNELS),
.ADDER_Of_Size(Calc_Unit_Of_Size_1), /*output feature size -1*/
.ADDER_Out_Mem1(Memories_Channel_Out_Mem1),
.ADDER_Out_Mem2(Memories_Channel_Out_Mem2),
.ADDER_Out_Mem3(Memories_Channel_Out_Mem3),

//////////// OUTPUTS //////////
.ADDER_Out(ACCELERATOR_DATA_OUT),
.ADDER_Routine_Finished_Already(Adder_Routine_Finished_Already),
.ADDER_Channel_Mems_Re(Adder_Channel_Mems_Re)
);



//////////// Reconfigurable bus instantiation //////////
RBUS #(.LENGTHBUS(LENGTHBUS),
.BITWIDTH_W_COLUMS(BITWIDTH_W_COLUMS),
.BITWIDTH_MAX_W_SIZE(BITWIDTH_MAX_W_SIZE)) Rbus
(

//////////// INPUTS //////////
.RBUS_Clk(ACCELERATOR_Clk_50),
.RBUS_Reset(Main_Stm_Rbus_Reset),
.RBUS_Set_Conf(Main_Stm_Rbus_Set_Conf),
.RBUS_Set_Conf_Already_Ok(Main_Stm_Rbus_Set_Conf_Already_Ok),
.RBUS_W_Colums(ACCELERATOR_W_COLUMS),
.RBUS_W_ROXCL(Calc_Unit_W_ROXCL_1), /*wrows x colums -1*/

.RBUS_SetEn0(Omdc_SetEn0),
.RBUS_SetEn1(Omdc_SetEn1),
.RBUS_SetEn2(Omdc_SetEn2),
.RBUS_SetEn3(Omdc_SetEn3),
.RBUS_SetEn4(Omdc_SetEn4),
.RBUS_SetEn5(Omdc_SetEn5),
.RBUS_SetEn6(Omdc_SetEn6),
.RBUS_SetEn7(Omdc_SetEn7),
.RBUS_SetEn8(Omdc_SetEn8),
.RBUS_SetEn9(Omdc_SetEn9),
.RBUS_SetEn10(Omdc_SetEn10),
.RBUS_SetEn11(Omdc_SetEn11),
.RBUS_SetEn12(Omdc_SetEn12),
.RBUS_OEn0(Omdc_OEn0),
.RBUS_OEn1(Omdc_OEn1),
.RBUS_OEn2(Omdc_OEn2),
.RBUS_OEn3(Omdc_OEn3),
.RBUS_OEn4(Omdc_OEn4),
.RBUS_OEn5(Omdc_OEn5),
.RBUS_OEn6(Omdc_OEn6),
.RBUS_OEn7(Omdc_OEn7),
.RBUS_OEn8(Omdc_OEn8),
.RBUS_OEn9(Omdc_OEn9),
.RBUS_OEn10(Omdc_OEn10),
.RBUS_OEn11(Omdc_OEn11),
.RBUS_OEn12(Omdc_OEn12),
.RBUS_Wptclr0(Omdc_Wptclr0),
.RBUS_Wptclr1(Omdc_Wptclr1),
.RBUS_Wptclr2(Omdc_Wptclr2),
.RBUS_Wptclr3(Omdc_Wptclr3),
.RBUS_Wptclr4(Omdc_Wptclr4),
.RBUS_Wptclr5(Omdc_Wptclr5),
.RBUS_Wptclr6(Omdc_Wptclr6),
.RBUS_Wptclr7(Omdc_Wptclr7),
.RBUS_Wptclr8(Omdc_Wptclr8),
.RBUS_Wptclr9(Omdc_Wptclr9),
.RBUS_Wptclr10(Omdc_Wptclr10),
.RBUS_Wptclr11(Omdc_Wptclr11),
.RBUS_Wptclr12(Omdc_Wptclr12),
.RBUS_Rptclr0(Omdc_Rptclr0),
.RBUS_Rptclr1(Omdc_Rptclr1),
.RBUS_Rptclr2(Omdc_Rptclr2),
.RBUS_Rptclr3(Omdc_Rptclr3),
.RBUS_Rptclr4(Omdc_Rptclr4),
.RBUS_Rptclr5(Omdc_Rptclr5),
.RBUS_Rptclr6(Omdc_Rptclr6),
.RBUS_Rptclr7(Omdc_Rptclr7),
.RBUS_Rptclr8(Omdc_Rptclr8),
.RBUS_Rptclr9(Omdc_Rptclr9),
.RBUS_Rptclr10(Omdc_Rptclr10),
.RBUS_Rptclr11(Omdc_Rptclr11),
.RBUS_Rptclr12(Omdc_Rptclr12),

//////////// OUTPUTS //////////
.RBUS_Om_SetEn(Rbus_Om_SetEn),
.RBUS_Om_OEn(Rbus_Om_OEn),
.RBUS_Om_Wptclr(Rbus_Om_Wptclr),
.RBUS_Om_Rptclr(Rbus_Om_Rptclr),
.RBUS_Set_Conf_Already(Rbus_Set_Conf_Already)
);

//////////// Multiplexers dataflow controller instantiation //////////
MUXDC #(
.LENGTHBUS(LENGTHBUS-1),
.BITWIDTH_W_COLUMS(BITWIDTH_W_COLUMS),
.BITWIDTH_MAX_W_SIZE(BITWIDTH_MAX_W_SIZE)) Muxdc
(

.MUXDC_Clk(ACCELERATOR_Clk_50),
.MUXDC_Reset(Main_Stm_Muxdc_Reset),
.MUXDC_Set_Conf(Main_Stm_Muxdc_Set_Conf),
.MUXDC_Set_Conf_Already_Ok(Main_Stm_Muxdc_Set_Conf_Already_Ok),
.MUXDC_W_Colums(ACCELERATOR_W_COLUMS),
.MUXDC_W_ROXCL(Calc_Unit_W_ROXCL_1),

//////////// OUTPUTS //////////
.MUXDC_Muxes_Sel(Muxdc_Muxes_Sel),
.MUXDC_Set_Conf_Already(Muxdc_Set_Conf_Already)

);



//////////// Main state machine instantiation //////////

MAIN_STM Main_Stm
(
//////////// INPUTS //////////
.MAIN_STM_Clk(ACCELERATOR_Clk_50),
.MAIN_STM_Reset(ACCELERATOR_Reset),
.MAIN_STM_Same_W(ACCELERATOR_SAME_W),
.MAIN_STM_Start_Convolution_Routine(ACCELERATOR_START),
.MAIN_STM_Owmc_Loading_Weights_Already(Owmc_Loading_Weights_Already),
.MAIN_STM_Owmc_Loading_Regs_Already(Owmc_Loading_Regs_Already),
.MAIN_STM_Ofmi_Loading_Weights_Already(Ofmi_Loading_Weights_Already),
.MAIN_STM_Ofmi_Feeding_Datapath_finished(Ofmi_Feeding_Datapath_Finished),
.MAIN_STM_Ofmi_Writing_Data_Already(Ofmi_Writing_Data_Already),
.MAIN_STM_Omdc_Routine_Finished_Already(Omdc_Routine_Finished_Already),
.MAIN_STM_Omdc_New_Channel_Flag(Omdc_new_channel_flag),
.MAIN_STM_Adder_Routine_Finished_Already(Adder_Routine_Finished_Already),
.MAIN_STM_Rbus_Set_Conf_Already(Rbus_Set_Conf_Already),
.MAIN_STM_Muxdc_Set_Conf_Already(Muxdc_Set_Conf_Already),
.MAIN_STM_Usr_Convolution_Routine_Finished_Ok(ACCELERATOR_FINISHED_OK),


//////////// OUTPUTS //////////
.MAIN_STM_Owmc_Reset(Main_Stm_Owmc_Reset),
.MAIN_STM_Owmc_Start_Loading_Weights(Main_Stm_Owmc_Start_Loading_Weight),
.MAIN_STM_Owmc_Start_Loading_Regs(Main_Stm_Owmc_Start_Loading_Regs),
.MAIN_STM_Loading_Weights_Already_Ok(Main_Stm_Loading_Weights_Already_Ok),
.MAIN_STM_Owmc_Loading_Regs_Already_Ok(Main_Stm_Owmc_Loading_Regs_Already_Ok),
.MAIN_STM_Ofmi_Reset(Main_Stm_Ofmi_Reset),
.MAIN_STM_Ofmi_Start_Loading_Weights(Main_Stm_Ofmi_Start_Loading_Weights),
.MAIN_STM_Ofmi_Start_Feeding_Datapath(Main_Stm_Ofmi_Start_Feeding_Datapath),
.MAIN_STM_Ofmi_Stop_Feeding_Datapath(Main_Stm_Ofmi_Stop_Feeding_Datapath),
.MAIN_STM_Ofmi_Feeding_Datapath_finished_OK(Main_Stm_Ofmi_Feeding_Datapath_finished_OK),
.MAIN_STM_Ofmi_Start_Writing_Data(Main_Stm_Ofmi_Start_Writing_Data),
.MAIN_STM_Ofmi_Writing_Data_Already_Ok(Main_Stm_Ofmi_Writing_Data_Already_Ok),
.MAIN_STM_Omdc_Reset(Main_Stm_Omdc_Reset),
.MAIN_STM_Omdc_Start_Routine(Main_Stm_Omdc_Start_Routine),
.MAIN_STM_Omdc_Stop_Routine(Main_Stm_Omdc_Stop_Routine),
.MAIN_STM_Omdc_Finish_Routine(Main_Stm_Omdc_Finish_Routine),
.MAIN_STM_Routine_Finished_Ok(Main_Stm_Routine_Finished_Ok),
.MAIN_STM_Wregs_Reset(Main_Stm_Wregs_Reset),
.MAIN_STM_Pedc_Start_Routine(Main_Stm_Pedc_Start_Routine),
.MAIN_STM_Pedc_Stop_Routine(Main_Stm_Pedc_Stop_Routine),
.MAIN_STM_Channel_Controller_Reset(Main_Stm_Channel_Controller_Reset),
.MAIN_STM_Channel_Controller_Start(Main_Stm_Channel_Controller_Start),
.MAIN_STM_Adder_Start_Routine(Main_Stm_Adder_Start_Routine),
.MAIN_STM_Adder_Routine_Finished_Already_Ok(Main_Stm_Adder_Routine_Finished_Already_Ok),
.MAIN_STM_Rbus_Reset(Main_Stm_Rbus_Reset),
.MAIN_STM_Rbus_Set_Conf(Main_Stm_Rbus_Set_Conf),
.MAIN_STM_Rbus_Set_Conf_Already_Ok(Main_Stm_Rbus_Set_Conf_Already_Ok),
.MAIN_STM_Muxdc_Reset(Main_Stm_Muxdc_Reset),
.MAIN_STM_Muxdc_Set_Conf(Main_Stm_Muxdc_Set_Conf),
.MAIN_STM_Muxdc_Set_Conf_Already_Ok(Main_Stm_Muxdc_Set_Conf_Already_Ok),
.MAIN_STM_Convolution_Routine_Finished(ACCELERATOR_FINISHED)
);


endmodule

