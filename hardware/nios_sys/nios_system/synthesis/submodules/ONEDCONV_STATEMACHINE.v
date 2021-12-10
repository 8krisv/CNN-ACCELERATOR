/*#########################################################################
//# One dimensional convolution module state machine
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

module ONEDCONV_STATEMACHINE(


/////////// INPUTS //////////
ONEDCONV_STATEMACHINE_Clk,
ONEDCONV_STATEMACHINE_Start,
ONEDCONV_STATEMACHINE_En,
ONEDCONV_STATEMACHINE_Reset,
//////////// OUTPUTS //////////
ONEDCONV_STATEMACHINE_Next_Row_Clr,
ONEDCONV_STATEMACHINE_SetEn_En,
ONEDCONV_STATEMACHINE_SetEn_clr,
ONEDCONV_STATEMACHINE_OEn_En,
ONEDCONV_STATEMACHINE_OEn_clr

);

//=======================================================
//  State declarations
//=======================================================

localparam State_reset = 0;
localparam State_Wait_Start = 1;
localparam State_Started = 2;

//=======================================================
//  PORT declarations
//=======================================================

input ONEDCONV_STATEMACHINE_Clk;
input ONEDCONV_STATEMACHINE_Start;
input ONEDCONV_STATEMACHINE_En;
input ONEDCONV_STATEMACHINE_Reset;
output reg ONEDCONV_STATEMACHINE_Next_Row_Clr;
output reg ONEDCONV_STATEMACHINE_SetEn_En;
output reg ONEDCONV_STATEMACHINE_SetEn_clr;
output reg ONEDCONV_STATEMACHINE_OEn_En;
output reg ONEDCONV_STATEMACHINE_OEn_clr;

//=======================================================
//  REG/WIRE DECLARATIONS
//=======================================================
reg [2:0] State_Register;
reg [2:0] State_Signal;


// Next state combinational logic
always @(*)
begin
	case (State_Register)
	
	State_reset: if(ONEDCONV_STATEMACHINE_En)
						State_Signal=State_Wait_Start;
					 else
						State_Signal=State_reset;
		
	State_Wait_Start: if(ONEDCONV_STATEMACHINE_Start)
								State_Signal=State_Started;
							else 
								State_Signal=State_Wait_Start;
			
								
	State_Started: if(!ONEDCONV_STATEMACHINE_Reset)
							State_Signal=State_reset;
						else
							State_Signal=State_Started;
							
	default : State_Signal = State_reset;
	
	endcase
	
end

// Sequential Logic

always @ (posedge ONEDCONV_STATEMACHINE_Clk , negedge ONEDCONV_STATEMACHINE_Reset)
begin
	if (!ONEDCONV_STATEMACHINE_Reset)
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
		ONEDCONV_STATEMACHINE_Next_Row_Clr=0;
		ONEDCONV_STATEMACHINE_SetEn_En=0;
		ONEDCONV_STATEMACHINE_OEn_En=0;
		ONEDCONV_STATEMACHINE_SetEn_clr=0;
		ONEDCONV_STATEMACHINE_OEn_clr=0;
		end
		
		State_Wait_Start:
		begin
			ONEDCONV_STATEMACHINE_Next_Row_Clr=1;
			ONEDCONV_STATEMACHINE_SetEn_En=0;
			ONEDCONV_STATEMACHINE_OEn_En=0;
			ONEDCONV_STATEMACHINE_SetEn_clr=1;
			ONEDCONV_STATEMACHINE_OEn_clr=1;
		end
		
		State_Started:
		begin
			ONEDCONV_STATEMACHINE_Next_Row_Clr=1;
			ONEDCONV_STATEMACHINE_SetEn_En=1;
			ONEDCONV_STATEMACHINE_OEn_En=1;
			ONEDCONV_STATEMACHINE_SetEn_clr=1;
			ONEDCONV_STATEMACHINE_OEn_clr=1;
		end
		
		default:
		begin
			ONEDCONV_STATEMACHINE_Next_Row_Clr=0;
			ONEDCONV_STATEMACHINE_SetEn_En=0;
			ONEDCONV_STATEMACHINE_OEn_En=0;
			ONEDCONV_STATEMACHINE_SetEn_clr=0;
			ONEDCONV_STATEMACHINE_OEn_clr=0;	
		end
		
	endcase

end

endmodule


