/*#########################################################################
//# On-chip fifo memory dataflow controller
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

module OMDC #(parameter BITWIDTH_ROW=4, BITWIDTH_IF_ROWS=10, BITWIDTH_IF_COLUMS = 11, BITWIDTH_OF_COLUMS=11, BITWIDTH_W_ROWS=4, BITWIDTH_W_COLUMS=4, BITWIDTH_STRIDE=4 )(

//////////// INPUTS //////////
input OMDC_Clk,
input OMDC_Reset,
input [BITWIDTH_W_COLUMS-1:0] OMDC_W_Colums,  /*Weight colums -1*/
input [BITWIDTH_W_ROWS-1:0] OMDC_W_Rows,
input [BITWIDTH_STRIDE-1:0] OMDC_Conv_Stride,
input [BITWIDTH_OF_COLUMS-1:0] OMDC_Of_Colums,
input [BITWIDTH_IF_COLUMS-1:0] OMDC_If_Colums,
input [BITWIDTH_IF_ROWS-1:0] OMDC_If_Rows,
input OMDC_Start_Routine,
input OMDC_Stop_Routine,
input OMDC_Finish_Routine,
input OMDC_Routine_Finished_Ok,

//////////// OUTPUTS //////////
output OMDC_Routine_Finished_Already,
output OMDC_control_channel_select_en,
output OMDC_new_channel_flag,
output OMDC_In_Output_Routine,
//
output OMDC_SetEn0,
output OMDC_OEn0,
output OMDC_Wptclr0,
output OMDC_Rptclr0,
//
output OMDC_SetEn1,
output OMDC_OEn1,
output OMDC_Wptclr1,
output OMDC_Rptclr1,
//
output OMDC_SetEn2,
output OMDC_OEn2,
output OMDC_Wptclr2,
output OMDC_Rptclr2,
//
output OMDC_SetEn3,
output OMDC_OEn3,
output OMDC_Wptclr3,
output OMDC_Rptclr3,
//
output OMDC_SetEn4,
output OMDC_OEn4,
output OMDC_Wptclr4,
output OMDC_Rptclr4,
//
output OMDC_SetEn5,
output OMDC_OEn5,
output OMDC_Wptclr5,
output OMDC_Rptclr5,
//
output OMDC_SetEn6,
output OMDC_OEn6,
output OMDC_Wptclr6,
output OMDC_Rptclr6,
//
output OMDC_SetEn7,
output OMDC_OEn7,
output OMDC_Wptclr7,
output OMDC_Rptclr7,
//
output OMDC_SetEn8,
output OMDC_OEn8,
output OMDC_Wptclr8,
output OMDC_Rptclr8,
//
output OMDC_SetEn9,
output OMDC_OEn9,
output OMDC_Wptclr9,
output OMDC_Rptclr9,
//
output OMDC_SetEn10,
output OMDC_OEn10,
output OMDC_Wptclr10,
output OMDC_Rptclr10,
//
output OMDC_SetEn11,
output OMDC_OEn11,
output OMDC_Wptclr11,
output OMDC_Rptclr11,
//
output OMDC_SetEn12,
output OMDC_OEn12,
output OMDC_Wptclr12,
output OMDC_Rptclr12

);

//=======================================================
//  Local parameters for row assignments 
//=======================================================

localparam [BITWIDTH_ROW-1:0] ROW1=1;
localparam [BITWIDTH_ROW-1:0] ROW2=2;
localparam [BITWIDTH_ROW-1:0] ROW3=3;
localparam [BITWIDTH_ROW-1:0] ROW4=4;
localparam [BITWIDTH_ROW-1:0] ROW5=5;
localparam [BITWIDTH_ROW-1:0] ROW6=6;
localparam [BITWIDTH_ROW-1:0] ROW7=7;
localparam [BITWIDTH_ROW-1:0] ROW8=8;
localparam [BITWIDTH_ROW-1:0] ROW9=9;
localparam [BITWIDTH_ROW-1:0] ROW10=10;
localparam [BITWIDTH_ROW-1:0] ROW11=11;
localparam [BITWIDTH_ROW-1:0] ROW12=12;
localparam [BITWIDTH_ROW-1:0] ROW13=13;
localparam [BITWIDTH_ROW-1:0] UNO= 1;

localparam [BITWIDTH_W_COLUMS-1:0] Counter_Eqcw_Data_1 = 1;
localparam [BITWIDTH_IF_COLUMS-1:0] Counter_Eqcif_Data_1 = 1;
localparam [BITWIDTH_IF_ROWS-1:0] Counter_Crow_Data_1 = 1;


localparam [BITWIDTH_STRIDE-1:0] LOAD1= 1;

//=======================================================
//  REG/WIRE DECLARATIONS
//=======================================================

wire Counter_Eqcw_Flag;
wire Counter_Eqst_Flag;
wire Counter_Crow_NewCh_Flag;
wire Counter_Eqcif_Flag;
wire Counter_Eqcw_En;
wire Counter_Eqcw_Reset;
wire Counter_Eqcw_load1;
wire Counter_Eqst_En;
wire Omdc_Statemachine_Counter_Eqst_Reset;
//wire Counter_Eqst_Reset;
wire Counter_Eqst_load1;
wire Counter_Crow_En;
wire Counter_Crow_Reset;
wire Counter_Crow_load1;
wire Counter_Eqcif_En;
wire Counter_Eqcif_Reset;
wire Counter_Eqcif_load1;


wire State_Machine_OneDConv_Reset;
wire State_Machine_OneDConv_Reset_Counter_Row;
wire [BITWIDTH_W_COLUMS-1:0] Counter_Eqcw_Output;
wire [BITWIDTH_STRIDE-1:0] Counter_Eqst_Output;
wire [BITWIDTH_IF_ROWS-1:0] Counter_Crow_Output;
wire [BITWIDTH_IF_COLUMS-1:0] Counter_Eqcif_Output;

wire  Counter_Stride_Clear_Clr;

wire In_Output_Routine0;
wire In_Output_Routine1;
wire In_Output_Routine2;
wire In_Output_Routine3;
wire In_Output_Routine4;
wire In_Output_Routine5;
wire In_Output_Routine6;
wire In_Output_Routine7;
wire In_Output_Routine8;
wire In_Output_Routine9;
wire In_Output_Routine10;
wire In_Output_Routine11;
wire In_Output_Routine12;
wire [12:0] Conv_Selector_Sel;


/////////// FLAGS //////////

wire FLAG_In_Output_Routine;
wire [12:0] FLAG_Conv_Oe;

//=======================================================
//  Structural coding
//=======================================================

COUNTER_POS #(.BITWIDTH(BITWIDTH_W_COLUMS)) Counter_Eqcw (

/////////// INPUTS //////////
.COUNTER_Clk(OMDC_Clk),
.COUNTER_Clr(Counter_Eqcw_Reset),
.COUNTER_En(Counter_Eqcw_En),
.COUNTER_load(Counter_Eqcw_load1),
.COUNTER_Data(Counter_Eqcw_Data_1),
.COUNTER_Number(OMDC_W_Colums),

//////////// OUTPUTS //////////
.COUNTER_Out(Counter_Eqcw_Output),
.COUNTER_Eqn_Flag(Counter_Eqcw_Flag)

);


COUNTER_LOAD_NEG #(.BITWIDTH(BITWIDTH_STRIDE)) Counter_Eqst(

/////////// INPUTS //////////
.COUNTER_Clk(OMDC_Clk),
.COUNTER_Clr(Omdc_Statemachine_Counter_Eqst_Reset),
.COUNTER_En(Counter_Eqst_En),
.COUNTER_Load(Counter_Stride_Clear_Clr),
.COUNTER_Data(LOAD1),
.COUNTER_Number(OMDC_Conv_Stride),
//////////// OUTPUTS //////////
.COUNTER_Out(Counter_Eqst_Output),
.COUNTER_Eqn_Flag(Counter_Eqst_Flag)

);





STRIDE_CLEAR Counter_Stride_Clear (

/////////// INPUTS //////////
.STRIDE_CLEAR_Clk(OMDC_Clk),
.STRIDE_CLEAR_Eqst_Flag(Counter_Eqst_Flag),
//////////// OUTPUTS //////////
.STRIDE_CLEAR_Counter_Eqst_Clr(Counter_Stride_Clear_Clr)


);



COUNTER_POS  #(.BITWIDTH(BITWIDTH_IF_ROWS)) Counter_Crow(

/////////// INPUTS //////////
.COUNTER_Clk(OMDC_Clk),
.COUNTER_Clr(Counter_Crow_Reset),
.COUNTER_En(Counter_Crow_En),
.COUNTER_load(Counter_Crow_load1),
.COUNTER_Data(Counter_Crow_Data_1),
.COUNTER_Number(OMDC_If_Rows),

//////////// OUTPUTS //////////
.COUNTER_Out(Counter_Crow_Output),
.COUNTER_Eqn_Flag(Counter_Crow_NewCh_Flag)
);


COUNTER_POS  #(.BITWIDTH(BITWIDTH_IF_COLUMS)) Counter_Eqcif(

/////////// INPUTS //////////
.COUNTER_Clk(OMDC_Clk),
.COUNTER_Clr(Counter_Eqcif_Reset),
.COUNTER_En(Counter_Eqcif_En),
.COUNTER_load(Counter_Eqcif_load1),
.COUNTER_Data(Counter_Eqcif_Data_1),
.COUNTER_Number(OMDC_If_Colums),

//////////// OUTPUTS //////////
.COUNTER_Out(Counter_Eqcif_Output),
.COUNTER_Eqn_Flag(Counter_Eqcif_Flag)
);


OMDC_STATEMACHINE Omdc_Statemachine(

/////////// INPUTS //////////
.OMDC_STATEMACHINE_Clk(OMDC_Clk),
.OMDC_STATEMACHINE_Reset(OMDC_Reset),
.OMDC_STATEMACHINE_Start_Routine(OMDC_Start_Routine),
.OMDC_STATEMACHINE_Stop_Routine(OMDC_Stop_Routine),
.OMDC_STATEMACHINE_Finish_Routine(OMDC_Finish_Routine),
.OMDC_STATEMACHINE_Routine_Finished_Ok(OMDC_Routine_Finished_Ok),
.OMDC_STATEMACHINE_Flag_Eqcw(Counter_Eqcw_Flag),
.OMDC_STATEMACHINE_Flag_Eqst(Counter_Eqst_Flag),
.OMDC_STATEMACHINE_Flag_Eqcif(Counter_Eqcif_Flag),
.OMDC_STATEMACHINE_Flag_NewCh(Counter_Crow_NewCh_Flag),
.OMDC_STATEMACHINE_Flag_In_Output_Routine(FLAG_In_Output_Routine),

//////////// OUTPUTS //////////

.OMDC_STATEMACHINE_Routine_Finished_Already(OMDC_Routine_Finished_Already),
.OMDC_STATEMACHINE_OneDConv_Reset(State_Machine_OneDConv_Reset),
.OMDC_STATEMACHINE_OneDConv_Reset_Counter_Row(State_Machine_OneDConv_Reset_Counter_Row),
.OMDC_STATEMACHINE_Counter_Eqcw_En(Counter_Eqcw_En),
.OMDC_STATEMACHINE_Counter_Eqcw_Reset(Counter_Eqcw_Reset),
.OMDC_STATEMACHINE_Counter_Eqcw_load1(Counter_Eqcw_load1),
.OMDC_STATEMACHINE_Counter_Eqst_En(Counter_Eqst_En),
.OMDC_STATEMACHINE_Counter_Eqst_Reset(Omdc_Statemachine_Counter_Eqst_Reset),
.OMDC_STATEMACHINE_Counter_Eqst_load1(Counter_Eqst_load1),
.OMDC_STATEMACHINE_Counter_Crow_En(Counter_Crow_En),
.OMDC_STATEMACHINE_Counter_Crow_Reset(Counter_Crow_Reset),
.OMDC_STATEMACHINE_Counter_Crow_load1(Counter_Crow_load1),
.OMDC_STATEMACHINE_Counter_Eqcif_En(Counter_Eqcif_En),
.OMDC_STATEMACHINE_Counter_Eqcif_Reset(Counter_Eqcif_Reset),
.OMDC_STATEMACHINE_Counter_Eqcif_load1(Counter_Eqcif_load1)

);





ONEDCONV OneDConv0 (

/////////// INPUTS //////////
.ONEDCONV_Clk(OMDC_Clk),
.ONEDCONV_Reset(OMDC_Reset),
.ONEDCONV_Reset_Counter_Row(State_Machine_OneDConv_Reset_Counter_Row),
.ONEDCONV_Row(ROW1),
.ONEDCONV_Flag_Eqcw(Counter_Eqcw_Flag),
.ONEDCONV_Flag_Eqst(Counter_Eqst_Flag),
.ONEDCONV_Flag_Eqcif(Counter_Eqcif_Flag),
.ONEDCONV_Current_Row(Counter_Crow_Output),
.ONEDCONV_Of_Colums(OMDC_Of_Colums),
.ONEDCONV_If_Rows(OMDC_If_Rows),
.ONEDCONV_W_Rows(OMDC_W_Rows),
.ONEDCONV_Conv_Stride(OMDC_Conv_Stride),
.ONEDCONV_Enable(Conv_Selector_Sel[0]),
.ONEDCONV_Start(OMDC_Start_Routine),
//////////// OUTPUTS //////////
.ONEDCONV_Set_En(OMDC_SetEn0),
.ONEDCONV_O_En(OMDC_OEn0),
.ONEDCONV_Wptclr(OMDC_Wptclr0),
.ONEDCONV_Rptclr(OMDC_Rptclr0),
.ONEDCONV_In_Output_Routine(In_Output_Routine0)


);


ONEDCONV OneDConv1 (

/////////// INPUTS //////////
.ONEDCONV_Clk(OMDC_Clk),
.ONEDCONV_Reset(OMDC_Reset),
.ONEDCONV_Reset_Counter_Row(State_Machine_OneDConv_Reset_Counter_Row),
.ONEDCONV_Row(ROW2),
.ONEDCONV_Flag_Eqcw(Counter_Eqcw_Flag),
.ONEDCONV_Flag_Eqst(Counter_Eqst_Flag),
.ONEDCONV_Flag_Eqcif(Counter_Eqcif_Flag),
.ONEDCONV_Current_Row(Counter_Crow_Output),
.ONEDCONV_Of_Colums(OMDC_Of_Colums),
.ONEDCONV_If_Rows(OMDC_If_Rows),
.ONEDCONV_W_Rows(OMDC_W_Rows),
.ONEDCONV_Conv_Stride(OMDC_Conv_Stride),
.ONEDCONV_Enable(Conv_Selector_Sel[1]),
.ONEDCONV_Start(OMDC_Start_Routine),
//////////// OUTPUTS //////////
.ONEDCONV_Set_En(OMDC_SetEn1),
.ONEDCONV_O_En(OMDC_OEn1),
.ONEDCONV_Wptclr(OMDC_Wptclr1),
.ONEDCONV_Rptclr(OMDC_Rptclr1),
.ONEDCONV_In_Output_Routine(In_Output_Routine1)


);


ONEDCONV OneDConv2 (

/////////// INPUTS //////////
.ONEDCONV_Clk(OMDC_Clk),
.ONEDCONV_Reset(OMDC_Reset),
.ONEDCONV_Reset_Counter_Row(State_Machine_OneDConv_Reset_Counter_Row),
.ONEDCONV_Row(ROW3),
.ONEDCONV_Flag_Eqcw(Counter_Eqcw_Flag),
.ONEDCONV_Flag_Eqst(Counter_Eqst_Flag),
.ONEDCONV_Flag_Eqcif(Counter_Eqcif_Flag),
.ONEDCONV_Current_Row(Counter_Crow_Output),
.ONEDCONV_Of_Colums(OMDC_Of_Colums),
.ONEDCONV_If_Rows(OMDC_If_Rows),
.ONEDCONV_W_Rows(OMDC_W_Rows),
.ONEDCONV_Conv_Stride(OMDC_Conv_Stride),
.ONEDCONV_Enable(Conv_Selector_Sel[2]),
.ONEDCONV_Start(OMDC_Start_Routine),
//////////// OUTPUTS //////////
.ONEDCONV_Set_En(OMDC_SetEn2),
.ONEDCONV_O_En(OMDC_OEn2),
.ONEDCONV_Wptclr(OMDC_Wptclr2),
.ONEDCONV_Rptclr(OMDC_Rptclr2),
.ONEDCONV_In_Output_Routine(In_Output_Routine2)


);


ONEDCONV OneDConv3 (

/////////// INPUTS //////////
.ONEDCONV_Clk(OMDC_Clk),
.ONEDCONV_Reset(OMDC_Reset),
.ONEDCONV_Reset_Counter_Row(State_Machine_OneDConv_Reset_Counter_Row),
.ONEDCONV_Row(ROW4),
.ONEDCONV_Flag_Eqcw(Counter_Eqcw_Flag),
.ONEDCONV_Flag_Eqst(Counter_Eqst_Flag),
.ONEDCONV_Flag_Eqcif(Counter_Eqcif_Flag),
.ONEDCONV_Current_Row(Counter_Crow_Output),
.ONEDCONV_Of_Colums(OMDC_Of_Colums),
.ONEDCONV_If_Rows(OMDC_If_Rows),
.ONEDCONV_W_Rows(OMDC_W_Rows),
.ONEDCONV_Conv_Stride(OMDC_Conv_Stride),
.ONEDCONV_Enable(Conv_Selector_Sel[3]),
.ONEDCONV_Start(OMDC_Start_Routine),
//////////// OUTPUTS //////////
.ONEDCONV_Set_En(OMDC_SetEn3),
.ONEDCONV_O_En(OMDC_OEn3),
.ONEDCONV_Wptclr(OMDC_Wptclr3),
.ONEDCONV_Rptclr(OMDC_Rptclr3),
.ONEDCONV_In_Output_Routine(In_Output_Routine3)


);


ONEDCONV OneDConv4 (

/////////// INPUTS //////////
.ONEDCONV_Clk(OMDC_Clk),
.ONEDCONV_Reset(OMDC_Reset),
.ONEDCONV_Reset_Counter_Row(State_Machine_OneDConv_Reset_Counter_Row),
.ONEDCONV_Row(ROW5),
.ONEDCONV_Flag_Eqcw(Counter_Eqcw_Flag),
.ONEDCONV_Flag_Eqst(Counter_Eqst_Flag),
.ONEDCONV_Flag_Eqcif(Counter_Eqcif_Flag),
.ONEDCONV_Current_Row(Counter_Crow_Output),
.ONEDCONV_Of_Colums(OMDC_Of_Colums),
.ONEDCONV_If_Rows(OMDC_If_Rows),
.ONEDCONV_W_Rows(OMDC_W_Rows),
.ONEDCONV_Conv_Stride(OMDC_Conv_Stride),
.ONEDCONV_Enable(Conv_Selector_Sel[4]),
.ONEDCONV_Start(OMDC_Start_Routine),
//////////// OUTPUTS //////////
.ONEDCONV_Set_En(OMDC_SetEn4),
.ONEDCONV_O_En(OMDC_OEn4),
.ONEDCONV_Wptclr(OMDC_Wptclr4),
.ONEDCONV_Rptclr(OMDC_Rptclr4),
.ONEDCONV_In_Output_Routine(In_Output_Routine4)


);


ONEDCONV OneDConv5 (

/////////// INPUTS //////////
.ONEDCONV_Clk(OMDC_Clk),
.ONEDCONV_Reset(OMDC_Reset),
.ONEDCONV_Reset_Counter_Row(State_Machine_OneDConv_Reset_Counter_Row),
.ONEDCONV_Row(ROW6),
.ONEDCONV_Flag_Eqcw(Counter_Eqcw_Flag),
.ONEDCONV_Flag_Eqst(Counter_Eqst_Flag),
.ONEDCONV_Flag_Eqcif(Counter_Eqcif_Flag),
.ONEDCONV_Current_Row(Counter_Crow_Output),
.ONEDCONV_Of_Colums(OMDC_Of_Colums),
.ONEDCONV_If_Rows(OMDC_If_Rows),
.ONEDCONV_W_Rows(OMDC_W_Rows),
.ONEDCONV_Conv_Stride(OMDC_Conv_Stride),
.ONEDCONV_Enable(Conv_Selector_Sel[5]),
.ONEDCONV_Start(OMDC_Start_Routine),
//////////// OUTPUTS //////////
.ONEDCONV_Set_En(OMDC_SetEn5),
.ONEDCONV_O_En(OMDC_OEn5),
.ONEDCONV_Wptclr(OMDC_Wptclr5),
.ONEDCONV_Rptclr(OMDC_Rptclr5),
.ONEDCONV_In_Output_Routine(In_Output_Routine5)


);


ONEDCONV OneDConv6 (

/////////// INPUTS //////////
.ONEDCONV_Clk(OMDC_Clk),
.ONEDCONV_Reset(OMDC_Reset),
.ONEDCONV_Reset_Counter_Row(State_Machine_OneDConv_Reset_Counter_Row),
.ONEDCONV_Row(ROW7),
.ONEDCONV_Flag_Eqcw(Counter_Eqcw_Flag),
.ONEDCONV_Flag_Eqst(Counter_Eqst_Flag),
.ONEDCONV_Flag_Eqcif(Counter_Eqcif_Flag),
.ONEDCONV_Current_Row(Counter_Crow_Output),
.ONEDCONV_Of_Colums(OMDC_Of_Colums),
.ONEDCONV_If_Rows(OMDC_If_Rows),
.ONEDCONV_W_Rows(OMDC_W_Rows),
.ONEDCONV_Conv_Stride(OMDC_Conv_Stride),
.ONEDCONV_Enable(Conv_Selector_Sel[6]),
.ONEDCONV_Start(OMDC_Start_Routine),
//////////// OUTPUTS //////////
.ONEDCONV_Set_En(OMDC_SetEn6),
.ONEDCONV_O_En(OMDC_OEn6),
.ONEDCONV_Wptclr(OMDC_Wptclr6),
.ONEDCONV_Rptclr(OMDC_Rptclr6),
.ONEDCONV_In_Output_Routine(In_Output_Routine6)


);


ONEDCONV OneDConv7 (

/////////// INPUTS //////////
.ONEDCONV_Clk(OMDC_Clk),
.ONEDCONV_Reset(OMDC_Reset),
.ONEDCONV_Reset_Counter_Row(State_Machine_OneDConv_Reset_Counter_Row),
.ONEDCONV_Row(ROW8),
.ONEDCONV_Flag_Eqcw(Counter_Eqcw_Flag),
.ONEDCONV_Flag_Eqst(Counter_Eqst_Flag),
.ONEDCONV_Flag_Eqcif(Counter_Eqcif_Flag),
.ONEDCONV_Current_Row(Counter_Crow_Output),
.ONEDCONV_Of_Colums(OMDC_Of_Colums),
.ONEDCONV_If_Rows(OMDC_If_Rows),
.ONEDCONV_W_Rows(OMDC_W_Rows),
.ONEDCONV_Conv_Stride(OMDC_Conv_Stride),
.ONEDCONV_Enable(Conv_Selector_Sel[7]),
.ONEDCONV_Start(OMDC_Start_Routine),
//////////// OUTPUTS //////////
.ONEDCONV_Set_En(OMDC_SetEn7),
.ONEDCONV_O_En(OMDC_OEn7),
.ONEDCONV_Wptclr(OMDC_Wptclr7),
.ONEDCONV_Rptclr(OMDC_Rptclr7),
.ONEDCONV_In_Output_Routine(In_Output_Routine7)


);


ONEDCONV OneDConv8 (

/////////// INPUTS //////////
.ONEDCONV_Clk(OMDC_Clk),
.ONEDCONV_Reset(OMDC_Reset),
.ONEDCONV_Reset_Counter_Row(State_Machine_OneDConv_Reset_Counter_Row),
.ONEDCONV_Row(ROW9),
.ONEDCONV_Flag_Eqcw(Counter_Eqcw_Flag),
.ONEDCONV_Flag_Eqst(Counter_Eqst_Flag),
.ONEDCONV_Flag_Eqcif(Counter_Eqcif_Flag),
.ONEDCONV_Current_Row(Counter_Crow_Output),
.ONEDCONV_Of_Colums(OMDC_Of_Colums),
.ONEDCONV_If_Rows(OMDC_If_Rows),
.ONEDCONV_W_Rows(OMDC_W_Rows),
.ONEDCONV_Conv_Stride(OMDC_Conv_Stride),
.ONEDCONV_Enable(Conv_Selector_Sel[8]),
.ONEDCONV_Start(OMDC_Start_Routine),
//////////// OUTPUTS //////////
.ONEDCONV_Set_En(OMDC_SetEn8),
.ONEDCONV_O_En(OMDC_OEn8),
.ONEDCONV_Wptclr(OMDC_Wptclr8),
.ONEDCONV_Rptclr(OMDC_Rptclr8),
.ONEDCONV_In_Output_Routine(In_Output_Routine8)


);



ONEDCONV OneDConv9 (

/////////// INPUTS //////////
.ONEDCONV_Clk(OMDC_Clk),
.ONEDCONV_Reset(OMDC_Reset),
.ONEDCONV_Reset_Counter_Row(State_Machine_OneDConv_Reset_Counter_Row),
.ONEDCONV_Row(ROW10),
.ONEDCONV_Flag_Eqcw(Counter_Eqcw_Flag),
.ONEDCONV_Flag_Eqst(Counter_Eqst_Flag),
.ONEDCONV_Flag_Eqcif(Counter_Eqcif_Flag),
.ONEDCONV_Current_Row(Counter_Crow_Output),
.ONEDCONV_Of_Colums(OMDC_Of_Colums),
.ONEDCONV_If_Rows(OMDC_If_Rows),
.ONEDCONV_W_Rows(OMDC_W_Rows),
.ONEDCONV_Conv_Stride(OMDC_Conv_Stride),
.ONEDCONV_Enable(Conv_Selector_Sel[9]),
.ONEDCONV_Start(OMDC_Start_Routine),
//////////// OUTPUTS //////////
.ONEDCONV_Set_En(OMDC_SetEn9),
.ONEDCONV_O_En(OMDC_OEn9),
.ONEDCONV_Wptclr(OMDC_Wptclr9),
.ONEDCONV_Rptclr(OMDC_Rptclr9),
.ONEDCONV_In_Output_Routine(In_Output_Routine9)


);



ONEDCONV OneDConv10 (

/////////// INPUTS //////////
.ONEDCONV_Clk(OMDC_Clk),
.ONEDCONV_Reset(OMDC_Reset),
.ONEDCONV_Reset_Counter_Row(State_Machine_OneDConv_Reset_Counter_Row),
.ONEDCONV_Row(ROW11),
.ONEDCONV_Flag_Eqcw(Counter_Eqcw_Flag),
.ONEDCONV_Flag_Eqst(Counter_Eqst_Flag),
.ONEDCONV_Flag_Eqcif(Counter_Eqcif_Flag),
.ONEDCONV_Current_Row(Counter_Crow_Output),
.ONEDCONV_Of_Colums(OMDC_Of_Colums),
.ONEDCONV_If_Rows(OMDC_If_Rows),
.ONEDCONV_W_Rows(OMDC_W_Rows),
.ONEDCONV_Conv_Stride(OMDC_Conv_Stride),
.ONEDCONV_Enable(Conv_Selector_Sel[10]),
.ONEDCONV_Start(OMDC_Start_Routine),
//////////// OUTPUTS //////////
.ONEDCONV_Set_En(OMDC_SetEn10),
.ONEDCONV_O_En(OMDC_OEn10),
.ONEDCONV_Wptclr(OMDC_Wptclr10),
.ONEDCONV_Rptclr(OMDC_Rptclr10),
.ONEDCONV_In_Output_Routine(In_Output_Routine10)


);


ONEDCONV OneDConv11 (

/////////// INPUTS //////////
.ONEDCONV_Clk(OMDC_Clk),
.ONEDCONV_Reset(OMDC_Reset),
.ONEDCONV_Reset_Counter_Row(State_Machine_OneDConv_Reset_Counter_Row),
.ONEDCONV_Row(ROW12),
.ONEDCONV_Flag_Eqcw(Counter_Eqcw_Flag),
.ONEDCONV_Flag_Eqst(Counter_Eqst_Flag),
.ONEDCONV_Flag_Eqcif(Counter_Eqcif_Flag),
.ONEDCONV_Current_Row(Counter_Crow_Output),
.ONEDCONV_Of_Colums(OMDC_Of_Colums),
.ONEDCONV_If_Rows(OMDC_If_Rows),
.ONEDCONV_W_Rows(OMDC_W_Rows),
.ONEDCONV_Conv_Stride(OMDC_Conv_Stride),
.ONEDCONV_Enable(Conv_Selector_Sel[11]),
.ONEDCONV_Start(OMDC_Start_Routine),
//////////// OUTPUTS //////////
.ONEDCONV_Set_En(OMDC_SetEn11),
.ONEDCONV_O_En(OMDC_OEn11),
.ONEDCONV_Wptclr(OMDC_Wptclr11),
.ONEDCONV_Rptclr(OMDC_Rptclr11),
.ONEDCONV_In_Output_Routine(In_Output_Routine11)


);



ONEDCONV OneDConv12 (

/////////// INPUTS //////////
.ONEDCONV_Clk(OMDC_Clk),
.ONEDCONV_Reset(OMDC_Reset),
.ONEDCONV_Reset_Counter_Row(State_Machine_OneDConv_Reset_Counter_Row),
.ONEDCONV_Row(ROW13),
.ONEDCONV_Flag_Eqcw(Counter_Eqcw_Flag),
.ONEDCONV_Flag_Eqst(Counter_Eqst_Flag),
.ONEDCONV_Flag_Eqcif(Counter_Eqcif_Flag),
.ONEDCONV_Current_Row(Counter_Crow_Output),
.ONEDCONV_Of_Colums(OMDC_Of_Colums),
.ONEDCONV_If_Rows(OMDC_If_Rows),
.ONEDCONV_W_Rows(OMDC_W_Rows),
.ONEDCONV_Conv_Stride(OMDC_Conv_Stride),
.ONEDCONV_Enable(Conv_Selector_Sel[12]),
.ONEDCONV_Start(OMDC_Start_Routine),
//////////// OUTPUTS //////////
.ONEDCONV_Set_En(OMDC_SetEn12),
.ONEDCONV_O_En(OMDC_OEn12),
.ONEDCONV_Wptclr(OMDC_Wptclr12),
.ONEDCONV_Rptclr(OMDC_Rptclr12),
.ONEDCONV_In_Output_Routine(In_Output_Routine12)

);

CONV_SELECTOR #(.BITWIDTH_W_ROWS(BITWIDTH_W_ROWS)) Conv_Selector(
//////////// INPUTS //////////
.CONV_SELECTOR_Wrows(OMDC_W_Rows),

//////////// OUTPUTS //////////
.CONV_SELECTOR_Sel(Conv_Selector_Sel)

);




//============================================================
// COMBINATIONAL OUTPUT LOGIC
//============================================================
assign FLAG_In_Output_Routine = (In_Output_Routine0 | In_Output_Routine1 | In_Output_Routine2 | In_Output_Routine3 | In_Output_Routine4 | In_Output_Routine5 | In_Output_Routine6 | In_Output_Routine7 | In_Output_Routine8 | In_Output_Routine9 | In_Output_Routine10 | In_Output_Routine11 | In_Output_Routine12);
assign FLAG_Conv_Oe= {OMDC_OEn12,OMDC_OEn11,OMDC_OEn10,OMDC_OEn9,OMDC_OEn8,OMDC_OEn7,OMDC_OEn6,OMDC_OEn5,OMDC_OEn4,OMDC_OEn3,OMDC_OEn2,OMDC_OEn1,OMDC_OEn0};
assign OMDC_new_channel_flag = (Counter_Crow_NewCh_Flag & Counter_Eqcif_Flag);
assign OMDC_control_channel_select_en =  FLAG_Conv_Oe[OMDC_W_Rows-UNO];   
//assign Counter_Eqst_Reset = (Omdc_Statemachine_Counter_Eqst_Reset & Counter_Stride_Clear_Clr );
assign OMDC_In_Output_Routine =FLAG_In_Output_Routine;

endmodule

