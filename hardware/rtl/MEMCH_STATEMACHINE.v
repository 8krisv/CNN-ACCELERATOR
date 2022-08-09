/*#########################################################################
//# Memory channel controller
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

module MEMCH_STATEMACHINE  (

//////////// INPUTS //////////
MEMCH_STATEMACHINE_Clk,
MEMCH_STATEMACHINE_Reset,
MEMCH_STATEMACHINE_Start,
MEMCH_STATEMACHINE_New_Channel_Flag,
MEMCH_STATEMACHINE_In_Output_Routine,
//////////// OUTPUTS //////////
MEMCH_STATEMACHINE_Counter_Ch_Clr,
MEMCH_STATEMACHINE_Chmem1_Clr,
MEMCH_STATEMACHINE_Chmem2_Clr,
MEMCH_STATEMACHINE_Chmem3_Clr,
MEMCH_STATEMACHINE_Counter_En

);


//=======================================================
//  State declarations
//=======================================================

localparam State_reset 		= 0;
localparam State_started 	= 1;
localparam State_Wait		= 2;
localparam State_Newch		= 3;

//=======================================================
//  PORT declarations
//=======================================================

input MEMCH_STATEMACHINE_Clk;
input MEMCH_STATEMACHINE_Reset;
input MEMCH_STATEMACHINE_Start;
input MEMCH_STATEMACHINE_New_Channel_Flag;
input MEMCH_STATEMACHINE_In_Output_Routine;
output reg MEMCH_STATEMACHINE_Counter_Ch_Clr;
output reg MEMCH_STATEMACHINE_Chmem1_Clr;
output reg MEMCH_STATEMACHINE_Chmem2_Clr;
output reg MEMCH_STATEMACHINE_Chmem3_Clr;
output reg MEMCH_STATEMACHINE_Counter_En;
//=======================================================
//  REG/WIRE declarations
//=======================================================
reg [1:0] State_Register;
reg [1:0] State_Signal;

// Next state combinational logic
always @(*)
begin
	case (State_Register)
		
		State_reset: if(MEMCH_STATEMACHINE_Start)
							State_Signal=State_started;
						 else
							State_Signal=State_reset;
	   
		State_started: if(!MEMCH_STATEMACHINE_Reset)
								State_Signal=State_reset;
							else if (MEMCH_STATEMACHINE_New_Channel_Flag)
								State_Signal=State_Wait;
							else
								State_Signal=State_started;
								
		State_Wait: if(!MEMCH_STATEMACHINE_In_Output_Routine)	
							State_Signal=State_Newch;
						else
							State_Signal=State_Wait;
		
		State_Newch:State_Signal=State_started;
		
		default : State_Signal = State_reset;
		
	endcase
	
end


// Sequential Logic
always @ (negedge MEMCH_STATEMACHINE_Clk , negedge MEMCH_STATEMACHINE_Reset)
begin
	if (!MEMCH_STATEMACHINE_Reset)
		State_Register <= State_reset;
	else
		State_Register <= State_Signal;
end


// COMBINATIONAL OUTPUT LOGIC
always @ (*)
begin
	
	case(State_Register)
		
		State_reset:
		begin
			MEMCH_STATEMACHINE_Counter_Ch_Clr = 0;
			MEMCH_STATEMACHINE_Chmem1_Clr = 0;
			MEMCH_STATEMACHINE_Chmem2_Clr = 0;
			MEMCH_STATEMACHINE_Chmem3_Clr = 0;
			MEMCH_STATEMACHINE_Counter_En = 0;
		end
		
		State_started:
		begin
			MEMCH_STATEMACHINE_Counter_Ch_Clr = 1;
			MEMCH_STATEMACHINE_Chmem1_Clr = 1;
			MEMCH_STATEMACHINE_Chmem2_Clr = 1;
			MEMCH_STATEMACHINE_Chmem3_Clr = 1;
			MEMCH_STATEMACHINE_Counter_En = 0;
		end
		
		State_Wait:
		begin
			MEMCH_STATEMACHINE_Counter_Ch_Clr = 1;
			MEMCH_STATEMACHINE_Chmem1_Clr = 1;
			MEMCH_STATEMACHINE_Chmem2_Clr = 1;
			MEMCH_STATEMACHINE_Chmem3_Clr = 1;
			MEMCH_STATEMACHINE_Counter_En = 0;
		end
		
		State_Newch:
		begin
			MEMCH_STATEMACHINE_Counter_Ch_Clr = 1;
			MEMCH_STATEMACHINE_Chmem1_Clr = 1;
			MEMCH_STATEMACHINE_Chmem2_Clr = 1;
			MEMCH_STATEMACHINE_Chmem3_Clr = 1;
			MEMCH_STATEMACHINE_Counter_En = 1;
		end
		
		
		default:
		begin
			MEMCH_STATEMACHINE_Counter_Ch_Clr = 0;
			MEMCH_STATEMACHINE_Chmem1_Clr = 0;
			MEMCH_STATEMACHINE_Chmem2_Clr = 0;
			MEMCH_STATEMACHINE_Chmem3_Clr = 0;
			MEMCH_STATEMACHINE_Counter_En = 0;
		end
	
	endcase

end


endmodule
