/*#########################################################################
//# Off-chip memory communication interface 
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

module OFMI #(parameter W_ADDR_WIDTH=9, IF_BITWIDTH_MAXSIZE=22, OFFMEN_ADDR_WIDTH=32)(

//////////// INPUTS //////////
OFMI_Clk,
OFMI_Reset,
OFMI_If_Size, /*(Ifrows x colums x channels) -1*/
OFMI_Of_Size, /*(Ofrows x colums x channels) -1*/
OFMI_W_Size, /*(Wrows x colums x channels) -1*/
OFMI_Addr_Offset,
OFMI_Mst_Start_Loading_Weights,
OFMI_Mst_Loading_Weights_Already_Ok,
OFMI_Owmc_Loading_Weights_Already,
OFMI_Mst_Start_Feeding_Datapath,
OFMI_Mst_Stop_Feeding_Datapath,
OFMI_Feeding_Datapath_finished_OK,
OFMI_Mst_Start_Writing_Data,
OFMI_Mst_Writing_Data_Already_Ok,

//////////// OUTPUTS //////////
OFMI_Mst_Loading_Weights_Already,
OFMI_Mst_Feeding_Datapath_finished,
OFMI_Mst_Writing_Data_Already,
OFMI_Offmem_We,
OFMI_Offmem_Re,
OFMI_Offmem_Addr,
OFMI_Mux_Sel,
OFMI_Mux_En

);

//=======================================================
//  PORT declarations
//=======================================================

input OFMI_Clk;
input OFMI_Reset;
input [IF_BITWIDTH_MAXSIZE-1:0] OFMI_If_Size;
input [IF_BITWIDTH_MAXSIZE-1:0] OFMI_Of_Size;
input	[W_ADDR_WIDTH-1:0] OFMI_W_Size;
input [OFFMEN_ADDR_WIDTH-1:0] OFMI_Addr_Offset;
input OFMI_Mst_Start_Loading_Weights;
input OFMI_Mst_Loading_Weights_Already_Ok;
input OFMI_Owmc_Loading_Weights_Already;
input OFMI_Mst_Start_Feeding_Datapath;
input OFMI_Mst_Stop_Feeding_Datapath;
input OFMI_Feeding_Datapath_finished_OK;
input OFMI_Mst_Start_Writing_Data;
input OFMI_Mst_Writing_Data_Already_Ok;
output OFMI_Mst_Loading_Weights_Already;
output OFMI_Mst_Feeding_Datapath_finished;
output OFMI_Mst_Writing_Data_Already;
output OFMI_Offmem_We;
output OFMI_Offmem_Re;
output [OFFMEN_ADDR_WIDTH-1:0] OFMI_Offmem_Addr;
output OFMI_Mux_Sel;
output OFMI_Mux_En;


//=======================================================
//  REG/WIRE DECLARATIONS
//=======================================================

//////////// COUNTER OUTPUT WIRES //////////
wire Counter_Eqn_Flag;

//////////// COUNTER INPUT WIRES //////////
wire[OFFMEN_ADDR_WIDTH-1:0]  Counter_Upper_Limit;
wire[OFFMEN_ADDR_WIDTH-1:0] Counter_Offset;

//////////// STATE MACHINE OUTPUT WIRES //////////
wire Ofmi_Statemachine_Counter_Sel_Offset;
wire Ofmi_Statemachine_Counter_Sel_UpperLim;
wire Ofmi_Statemachine_Counter_en;
wire Ofmi_Statemachine_Counter_Reset;


//=======================================================
//  Structural coding
//=======================================================

COUNTER_OFFSET_POS #(.BITWIDTH(OFFMEN_ADDR_WIDTH)) Counter(

//// INPUTS ////

.COUNTER_OFFSET_Clk(OFMI_Clk),
.COUNTER_OFFSET_Clr(Ofmi_Statemachine_Counter_Reset),
.COUNTER_OFFSET_En(Ofmi_Statemachine_Counter_en),
.COUNTER_OFFSET_Number(Counter_Upper_Limit),
.COUNTER_OFFSET_offset(Counter_Offset),

//// OUTPUTS ////

.COUNTER_OFFSET_Out(OFMI_Offmem_Addr),
.COUNTER_OFFSET_Eqn_Flag(Counter_Eqn_Flag)

);



OFMI_STATEMACHINE Ofmi_Statemachine(

//// INPUTS ////

.OFMI_STATEMACHINE_Clk(OFMI_Clk),
.OFMI_STATEMACHINE_Reset(OFMI_Reset),
.OFMI_STATEMACHINE_Mst_Start_Loading_Weights(OFMI_Mst_Start_Loading_Weights),
.OFMI_STATEMACHINE_Mst_Loading_Weights_Already_Ok(OFMI_Mst_Loading_Weights_Already_Ok),
.OFMI_STATEMACHINE_Owmc_Loading_Weights_Already(OFMI_Owmc_Loading_Weights_Already),
.OFMI_STATEMACHINE_Mst_Start_Feeding_Datapath(OFMI_Mst_Start_Feeding_Datapath),
.OFMI_STATEMACHINE_Mst_Stop_Feeding_Datapath(OFMI_Mst_Stop_Feeding_Datapath),
.OFMI_STATEMACHINE_Mst_Feeding_Datapath_finished_OK(OFMI_Feeding_Datapath_finished_OK),
.OFMI_STATEMACHINE_Mst_Start_Writing_Data(OFMI_Mst_Start_Writing_Data),
.OFMI_STATEMACHINE_Mst_Writing_Data_Already_Ok(OFMI_Mst_Writing_Data_Already_Ok),
.OFMI_STATEMACHINE_Counter_Finish_Already(Counter_Eqn_Flag),

//// OUTPUTS ////

.OFMI_STATEMACHINE_Mst_Loading_Weights_Already(OFMI_Mst_Loading_Weights_Already),
.OFMI_STATEMACHINE_Mst_Feeding_Datapath_finished(OFMI_Mst_Feeding_Datapath_finished),
.OFMI_STATEMACHINE_Mst_Writing_Data_Already(OFMI_Mst_Writing_Data_Already),
.OFMI_STATEMACHINE_Offmem_We(OFMI_Offmem_We),
.OFMI_STATEMACHINE_Offmem_Re(OFMI_Offmem_Re),
.OFMI_STATEMACHINE_Counter_Sel_Offset(Ofmi_Statemachine_Counter_Sel_Offset),
.OFMI_STATEMACHINE_Counter_Sel_UpperLim(Ofmi_Statemachine_Counter_Sel_UpperLim),
.OFMI_STATEMACHINE_Counter_en(Ofmi_Statemachine_Counter_en),
.OFMI_STATEMACHINE_Counter_Reset(Ofmi_Statemachine_Counter_Reset),
.OFMI_STATEMACHINE_Mux_Sel(OFMI_Mux_Sel),
.OFMI_STATEMACHINE_Mux_En(OFMI_Mux_En)

);

//============================================================
// COMBINATIONAL OUTPUT LOGIC
//============================================================

assign Counter_Upper_Limit = Ofmi_Statemachine_Counter_Sel_UpperLim == 1'b0 ? {10'b0,OFMI_If_Size} : {10'b0,(OFMI_Of_Size +1'b1)};
assign Counter_Offset = Ofmi_Statemachine_Counter_Sel_Offset == 1'b0 ? OFMI_Addr_Offset : OFMI_Addr_Offset + OFMI_W_Size +1'b1;



endmodule

