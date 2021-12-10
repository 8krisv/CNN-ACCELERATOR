/*#########################################################################
//# procesing element dataflow controller 
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

module PEDC(

//////////// INPUTS //////////
PEDC_Clk,
PEDC_Start_Routine,
PEDC_Stop_Routine,

//////////// OUTPUT //////////
PEDC_OutReg_Set,
PEDC_Reset

);



//=======================================================
//  PORT declarations
//=======================================================

input PEDC_Clk;
input PEDC_Start_Routine;
input PEDC_Stop_Routine;
output PEDC_OutReg_Set;
output PEDC_Reset;


//=======================================================
//  REG/WIRE DECLARATIONS
//=======================================================
wire Pedc_Statemachine_Set_Signal_En;
reg Set;


//============================================================
// COMBINATIONAL LOGIC 
//============================================================

always@(PEDC_Clk)
begin
		if(Pedc_Statemachine_Set_Signal_En)
			Set=~PEDC_Clk;
		else
			Set=1'b0;
end


//=======================================================
//  Structural coding
//=======================================================

PEDC_STATEMACHINE Pedc_Statemachine(

.PEDC_STATEMACHINE_Clk(PEDC_Clk),
.PEDC_STATEMACHINE_Start_Routine(PEDC_Start_Routine),
.PEDC_STATEMACHINE_Stop_Routine(PEDC_Stop_Routine),

//////////// OUTPUT //////////
.PEDC_STATEMACHINE_Reset(PEDC_Reset),
.PEDC_STATEMACHINE_Set_Signal_En(Pedc_Statemachine_Set_Signal_En)

);

//=======================================================
//  Combinational logic output
//=======================================================

assign PEDC_OutReg_Set=Set;


endmodule




