/*#########################################################################
//# On-chip weight memory controller 
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

module OWMC #(parameter W_DATA_WIDTH = 8, W_MEM_SIZE=507  ,W_ADDR_WIDTH = 9)(

/////////// INPUTS //////////
OWMC_Clk,
OWMC_Reset,
OWMC_W_Size, /*(Wrows x colums x channels) -1*/
OWMC_W_COXRW, /*(Wcolums x rows) -1*/
OWMC_Input_Data,
OWMC_Start_Loading_Weights,
OWMC_Start_Loading_Regs,
OWMC_Loading_Weights_Already_Ok,
OWMC_Loading_Regs_Already_Ok,

//////////// OUTPUTS //////////
OWMC_Loading_Weights_Already,
OWMC_Loading_Regs_Already,
OWMC_Output_Data,
OWMC_Muxes_En,
OWMC_Muxes_Sel

);
//=======================================================
//  PORT declarations
//=======================================================
input OWMC_Clk;
input OWMC_Reset;
input [W_ADDR_WIDTH-1:0] OWMC_W_Size;
input [W_ADDR_WIDTH-1:0] OWMC_W_COXRW;
input [W_DATA_WIDTH-1:0] OWMC_Input_Data;
input OWMC_Start_Loading_Weights;
input OWMC_Start_Loading_Regs;
input OWMC_Loading_Weights_Already_Ok;
input OWMC_Loading_Regs_Already_Ok;

output OWMC_Loading_Weights_Already;
output OWMC_Loading_Regs_Already;
output [W_DATA_WIDTH-1:0] OWMC_Output_Data;
output OWMC_Muxes_En;
output [W_ADDR_WIDTH-1:0] OWMC_Muxes_Sel;


//=======================================================
//  REG/WIRE DECLARATIONS
//=======================================================


//////////// COUNTER DMUX OUTPUT WIRES //////////
wire Counter_Dmux_Eqn_Flag;

//////////// COUNTER RAM OUTPUT WIRES //////////
wire [W_ADDR_WIDTH-1:0] Counter_Ram_Output;
wire Counter_Ram_Eqn_Flag;

//////////// COUNTER RAM INPUT WIRES //////////
wire [W_ADDR_WIDTH-1:0] Counter_Ram_Number;
wire [W_ADDR_WIDTH-1:0] Counter_Ram_Lower_Limit;

//////////// OFFSET ADDER OUTPUT WIRES //////////
wire [W_ADDR_WIDTH-1:0] Offset_Adder_Lower_Limit;


//////////// STATE MACHINE OUTPUT WIRES //////////
wire Owmc_Statemachine_Counter_Dmux_En;
wire Owmc_Statemachine_Counter_Dmux_Reset;
wire Owmc_Statemachine_Counter_Ram_En;
wire Owmc_Statemachine_Counter_Ram_Reset;
wire Owmc_Statemachine_Counter_Ram_Input_Sel;
wire Owmc_Statemachine_Offset_Adder_Reset;
wire Owmc_Statemachine_Offset_Adder_Sum_En;
wire Owmc_Statemachine_Ram_Oe;
wire Owmc_Statemachine_Ram_We;


//=======================================================
//  Structural coding
//=======================================================

RAM #(.DATA_WIDTH(W_DATA_WIDTH),.MEM_SIZE(W_MEM_SIZE),.ADDR_WIDTH(W_ADDR_WIDTH)) OWM
(

//// INPUTS ////
.RAM_Clk(OWMC_Clk),
.RAM_We(Owmc_Statemachine_Ram_We),
.RAM_Oe(Owmc_Statemachine_Ram_Oe),
.RAM_Address(Counter_Ram_Output),
.RAM_Data_In(OWMC_Input_Data),

//// OUTPUTS ////
.RAM_Data_Out(OWMC_Output_Data)
);



COUNTER_NEG #(.BITWIDTH(W_ADDR_WIDTH)) Counter_Dmux (
//// INPUTS ////
.COUNTER_Clk(OWMC_Clk),
.COUNTER_Clr(Owmc_Statemachine_Counter_Dmux_Reset),
.COUNTER_En(Owmc_Statemachine_Counter_Dmux_En),
.COUNTER_Number(OWMC_W_COXRW),

//// OUTPUTS ////
.COUNTER_Out(OWMC_Muxes_Sel),
.COUNTER_Eqn_Flag(Counter_Dmux_Eqn_Flag)
);

COUNTER_OFFSET_NEG #(.BITWIDTH(W_ADDR_WIDTH)) Counter_Ram(

//// INPUTS ////
.COUNTER_OFFSET_Clk(OWMC_Clk),
.COUNTER_OFFSET_Clr(Owmc_Statemachine_Counter_Ram_Reset),
.COUNTER_OFFSET_En(Owmc_Statemachine_Counter_Ram_En),
.COUNTER_OFFSET_Number(Counter_Ram_Number),
.COUNTER_OFFSET_offset(Counter_Ram_Lower_Limit),

//// OUTPUTS ////
.COUNTER_OFFSET_Out(Counter_Ram_Output),
.COUNTER_OFFSET_Eqn_Flag(Counter_Ram_Eqn_Flag)

);


OFFSET_ADDER #(.BITWIDTH(W_ADDR_WIDTH)) Offset_Adder(

//// INPUTS ////
.OFFSET_ADDER_clk(OWMC_Clk),
.OFFSET_ADDER_Sum_En(Owmc_Statemachine_Offset_Adder_Sum_En),
.OFFSET_ADDER_Reset(Owmc_Statemachine_Offset_Adder_Reset),
.OFFSET_ADDER_offset(OWMC_W_COXRW),

//// OUTPUTS ////
.OFFSET_ADDER_Lower_Limit(Offset_Adder_Lower_Limit)

);


OWMC_STATEMACHINE Owmc_Statemachine (

//// INPUTS ////
.OWMC_STATEMACHINE_Clk(OWMC_Clk),
.OWMC_STATEMACHINE_Reset(OWMC_Reset),
.OWMC_STATEMACHINE_Start_Loading_Weights(OWMC_Start_Loading_Weights),
.OWMC_STATEMACHINE_Start_Loading_Regs(OWMC_Start_Loading_Regs),
.OWMC_STATEMACHINE_Loading_Weights_Already_Ok(OWMC_Loading_Weights_Already_Ok),
.OWMC_STATEMACHINE_Loading_Regs_Already_Ok(OWMC_Loading_Regs_Already_Ok),
.OWMC_STATEMACHINE_Counter_Ram_Finish_Already(Counter_Ram_Eqn_Flag),
.OWMC_STATEMACHINE_Counter_Dmux_Finish_Already(Counter_Dmux_Eqn_Flag),

//// OUTPUTS ////
.OWMC_STATEMACHINE_Loading_Weights_Already(OWMC_Loading_Weights_Already),
.OWMC_STATEMACHINE_Loading_Regs_Already(OWMC_Loading_Regs_Already),
.OWMC_STATEMACHINE_Counter_Dmux_En(Owmc_Statemachine_Counter_Dmux_En),
.OWMC_STATEMACHINE_Counter_Dmux_Reset(Owmc_Statemachine_Counter_Dmux_Reset),
.OWMC_STATEMACHINE_Counter_Ram_En(Owmc_Statemachine_Counter_Ram_En),
.OWMC_STATEMACHINE_Counter_Ram_Reset(Owmc_Statemachine_Counter_Ram_Reset),
.OWMC_STATEMACHINE_Counter_Ram_Input_Sel(Owmc_Statemachine_Counter_Ram_Input_Sel),
.OWMC_STATEMACHINE_Offset_Adder_Reset(Owmc_Statemachine_Offset_Adder_Reset),
.OWMC_STATEMACHINE_Offset_Adder_Sum_En(Owmc_Statemachine_Offset_Adder_Sum_En),
.OWMC_STATEMACHINE_Muxes_en(OWMC_Muxes_En),
.OWMC_STATEMACHINE_Ram_Oe(Owmc_Statemachine_Ram_Oe),
.OWMC_STATEMACHINE_Ram_We(Owmc_Statemachine_Ram_We)
);


//============================================================
// COMBINATIONAL OUTPUT LOGIC
//============================================================
assign Counter_Ram_Lower_Limit = Owmc_Statemachine_Counter_Ram_Input_Sel == 1'b1 ? Offset_Adder_Lower_Limit : 9'b0;
assign Counter_Ram_Number = Owmc_Statemachine_Counter_Ram_Input_Sel == 1'b1 ? OWMC_W_COXRW : OWMC_W_Size;


endmodule
