/*#########################################################################
//# procesing element dataflow controller state machine
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

module PEDC_STATEMACHINE(

//////////// INPUTS //////////
PEDC_STATEMACHINE_Clk,
PEDC_STATEMACHINE_Start_Routine,
PEDC_STATEMACHINE_Stop_Routine,

//////////// OUTPUT //////////
PEDC_STATEMACHINE_Reset,
PEDC_STATEMACHINE_Set_Signal_En
);

//=======================================================
//  State declarations
//=======================================================
localparam State_reset			= 0;
localparam State_started		= 1;

//=======================================================
//  PORT declarations
//=======================================================

input PEDC_STATEMACHINE_Clk;
input PEDC_STATEMACHINE_Start_Routine;
input PEDC_STATEMACHINE_Stop_Routine;
output reg PEDC_STATEMACHINE_Reset;
output reg PEDC_STATEMACHINE_Set_Signal_En;

//=======================================================
//  REG/WIRE declarations
//=======================================================

reg [1:0]State_Register;
reg [1:0]State_Signal;


// Next state combinational logic
always @(*)
begin
	case (State_Register)
		State_reset: if(PEDC_STATEMACHINE_Start_Routine)
							State_Signal=State_started;
						 else
							State_Signal=State_reset;
		
		State_started: if (PEDC_STATEMACHINE_Stop_Routine) 
								State_Signal=State_reset;
							else 
								State_Signal=State_started;
		
		default: State_Signal=State_reset;
	
	endcase
	
	
end


// Sequential Logic
always @ (negedge PEDC_STATEMACHINE_Clk )
begin
		State_Register <= State_Signal;
end

// COMBINATIONAL OUTPUT LOGIC
always @ (*)
begin
	
	case(State_Register)
		State_reset:
		begin
			PEDC_STATEMACHINE_Reset=0;
			PEDC_STATEMACHINE_Set_Signal_En=0;
		end
		
		State_started:
		begin
			PEDC_STATEMACHINE_Reset=1;
			PEDC_STATEMACHINE_Set_Signal_En=1;
		
		end
		
		default:
		begin	
			PEDC_STATEMACHINE_Reset=0;
			PEDC_STATEMACHINE_Set_Signal_En=0;
		end
	
	endcase
	
end


endmodule
