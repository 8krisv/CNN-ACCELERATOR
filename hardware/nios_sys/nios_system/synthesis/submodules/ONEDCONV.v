/*#########################################################################
//# One dimensional convolution module 
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

module ONEDCONV #(parameter BITWIDTH_ROW=4, BITWIDTH_IF_ROWS=10, BITWIDTH_OF_COLUMS=11, BITWIDTH_W_ROWS=4, BITWIDTH_STRIDE=4)(

/////////// INPUTS //////////
ONEDCONV_Clk,
ONEDCONV_Reset,
ONEDCONV_Reset_Counter_Row,
ONEDCONV_Row,
ONEDCONV_Flag_Eqcw,
ONEDCONV_Flag_Eqst,
ONEDCONV_Flag_Eqcif,
ONEDCONV_Current_Row,
ONEDCONV_Of_Colums,
ONEDCONV_If_Rows,
ONEDCONV_W_Rows,
ONEDCONV_Conv_Stride,
ONEDCONV_Enable,
ONEDCONV_Start,
//////////// OUTPUTS //////////
ONEDCONV_Set_En,
ONEDCONV_O_En,
ONEDCONV_Wptclr,
ONEDCONV_Rptclr,
ONEDCONV_In_Output_Routine
);


//=======================================================
//  PORT declarations
//=======================================================

input ONEDCONV_Clk;
input ONEDCONV_Reset;
input ONEDCONV_Reset_Counter_Row;
input [BITWIDTH_ROW-1:0] ONEDCONV_Row;
input ONEDCONV_Flag_Eqcw;
input ONEDCONV_Flag_Eqst;
input ONEDCONV_Flag_Eqcif;
input [BITWIDTH_IF_ROWS-1:0] ONEDCONV_Current_Row;
input [BITWIDTH_OF_COLUMS-1:0] ONEDCONV_Of_Colums;
input [BITWIDTH_IF_ROWS-1:0] ONEDCONV_If_Rows;
input [BITWIDTH_W_ROWS-1:0] ONEDCONV_W_Rows;
input [BITWIDTH_STRIDE-1:0] ONEDCONV_Conv_Stride;
input ONEDCONV_Enable;
input ONEDCONV_Start;

output ONEDCONV_Set_En;
output ONEDCONV_O_En;
output ONEDCONV_Wptclr;
output ONEDCONV_Rptclr;
output ONEDCONV_In_Output_Routine;

//=======================================================
//  REG/WIRE DECLARATIONS
//=======================================================
reg [BITWIDTH_IF_ROWS-1:0] FinalRow;


//////////// State machine output wires //////////
wire State_Machine_next_row_clr;
wire State_Machine_setEn_en;
wire State_Machine_OEn_en;
wire State_Machine_setEn_clr;
wire State_Machine_OEn_clr;


//////////// CounterNextRow input wires //////////
wire CounterNextRow_Clr;

//////////// CounterNextRow output wires //////////
wire[BITWIDTH_IF_ROWS-1:0] CounterNextRow_next_row;

//////////// OneDConvSetEn input wires //////////
wire OneDConvSetEn_En;
wire OneDConvSetEn_Clr;

//////////// OneDConvSetEn output wires //////////
wire OneDConvSetEn_Flag_Om_Full;
wire OneDConvSetEn_Oen_clr;

//////////// OneDConvOe input wires //////////
wire OneDConvOe_Clr;

//////////// OneDConvOe output wires //////////
wire OneDConvOe_SetEn_Clr;
wire OneDConvOe_Flag_Out_Full;

//////////// Set_Clr output wires //////////
wire Set_Clr_Clr;

//////////// Module flags //////////
reg Flag_Inside_Range;
reg Flag_CurrentRow_Eq_Nxt;

wire  CounterNextRow_En;


//============================================================
// COMBINATIONAL LOGIC 
//============================================================

always@(ONEDCONV_If_Rows,ONEDCONV_W_Rows,ONEDCONV_Row)
begin

	FinalRow= ONEDCONV_If_Rows - ONEDCONV_W_Rows + ONEDCONV_Row;

end

always@(ONEDCONV_Current_Row,ONEDCONV_Row,FinalRow)
begin
	if(ONEDCONV_Current_Row>=ONEDCONV_Row && ONEDCONV_Current_Row<=FinalRow)
		Flag_Inside_Range=1;
	else
		Flag_Inside_Range=0;
end


always@(CounterNextRow_next_row,ONEDCONV_Current_Row)
begin
	if(ONEDCONV_Current_Row==CounterNextRow_next_row)
		Flag_CurrentRow_Eq_Nxt=1;
	else
		Flag_CurrentRow_Eq_Nxt=0;
end

//=======================================================
//  Structural coding
//=======================================================

ONEDCONV_STATEMACHINE State_Machine(

//////////// INPUTS //////////
.ONEDCONV_STATEMACHINE_Clk(ONEDCONV_Clk),
.ONEDCONV_STATEMACHINE_Start(ONEDCONV_Start),
.ONEDCONV_STATEMACHINE_En(ONEDCONV_Enable),
.ONEDCONV_STATEMACHINE_Reset(ONEDCONV_Reset),

//////////// OUTPUTS //////////
.ONEDCONV_STATEMACHINE_Next_Row_Clr(State_Machine_next_row_clr),
.ONEDCONV_STATEMACHINE_SetEn_En(State_Machine_setEn_en),
.ONEDCONV_STATEMACHINE_OEn_En(State_Machine_OEn_en),
.ONEDCONV_STATEMACHINE_SetEn_clr(State_Machine_setEn_clr),
.ONEDCONV_STATEMACHINE_OEn_clr(State_Machine_OEn_clr)

);


COUNTER_NEXT_ROW #(.BITWIDTH_ROW(BITWIDTH_ROW),.BITWIDTH_IF_ROWS(BITWIDTH_IF_ROWS),.BITWIDTH_STRIDE(BITWIDTH_STRIDE)) CounterNextRow
(
//////////// INPUTS //////////
.COUNTER_NEXT_ROW_clk(ONEDCONV_Clk),
.COUNTER_NEXT_ROW_Stride(ONEDCONV_Conv_Stride),
.COUNTER_NEXT_ROW_Offset(ONEDCONV_Row),
.COUNTER_NEXT_ROW_En(CounterNextRow_En),
.COUNTER_NEXT_ROW_Clr(CounterNextRow_Clr),

//////////// OUTPUTS //////////
.COUNTER_NEXT_ROW_Next_Row(CounterNextRow_next_row)
);


ONEDCONV_SET_EN #(.BITWIDTH_OF_COLUMS(BITWIDTH_OF_COLUMS)) OneDConvSetEn(

//////////// INPUTS //////////
.ONEDCONV_SET_EN_clk(ONEDCONV_Clk),
.ONEDCONV_SET_EN_Eqcw(ONEDCONV_Flag_Eqcw),
.ONEDCONV_SET_EN_Eqst(ONEDCONV_Flag_Eqst),
.ONEDCONV_SET_EN_En(OneDConvSetEn_En),
.ONEDCONV_SET_EN_Clr(OneDConvSetEn_Clr), 
.ONEDCONV_SET_Flag_Out_Full(OneDConvOe_Flag_Out_Full), 
.ONEDCONV_SET_EN_Of_Colums(ONEDCONV_Of_Colums),

//////////// OUTPUTS //////////

.ONEDCONV_SET_EN_Rptclr(ONEDCONV_Rptclr),
.ONEDCONV_SET_EN_Oen_clr(OneDConvSetEn_Oen_clr),
.ONEDCONV_SET_EN_set_en(ONEDCONV_Set_En),
.ONEDCONV_SET_EN_Flag_Om_Full(OneDConvSetEn_Flag_Om_Full)

);



SET_CLR Set_Clr(
.SET_CLR_Clk(ONEDCONV_Clk),
.SET_CLR_Flag_Om_Full(OneDConvSetEn_Flag_Om_Full),
.SET_CLR_Clr(Set_Clr_Clr)
);


ONEDCONV_OEN #(.BITWIDTH_OF_COLUMS(BITWIDTH_OF_COLUMS),.BITWIDTH_STRIDE(BITWIDTH_STRIDE)) OneDConvOe (

//////////// INPUTS //////////
.ONEDCONV_OEN_Clk(ONEDCONV_Clk),
.ONEDCONV_OEN_Flag_Om_Full(OneDConvSetEn_Flag_Om_Full),
.ONEDCONV_OEN_En(State_Machine_OEn_en),
.ONEDCONV_OEN_Clr(OneDConvOe_Clr),
.ONEDCONV_OEN_Of_Colums(ONEDCONV_Of_Colums),
.ONEDCONV_OEN_Stride(ONEDCONV_Conv_Stride),

//////////// OUTPUTS //////////
.ONEDCONV_OEN_Wptclr(ONEDCONV_Wptclr),
.ONEDCONV_OEN_Oen(ONEDCONV_O_En),
.ONEDCONV_OEN_Flag_Out_Full(OneDConvOe_Flag_Out_Full),
.ONEDCONV_OEN_In_Routine(ONEDCONV_In_Output_Routine)

);

//============================================================
// COMBINATIONAL OUTPUT LOGIC
//============================================================

assign OneDConvSetEn_En = (Flag_Inside_Range & Flag_CurrentRow_Eq_Nxt & State_Machine_setEn_en);
assign OneDConvSetEn_Clr = (State_Machine_setEn_clr & Set_Clr_Clr);
assign OneDConvOe_Clr = (State_Machine_OEn_clr & OneDConvSetEn_Oen_clr);
assign CounterNextRow_Clr= (State_Machine_next_row_clr & ONEDCONV_Reset_Counter_Row);
assign CounterNextRow_En = (ONEDCONV_Flag_Eqcif & Flag_CurrentRow_Eq_Nxt);

endmodule

