/*#########################################################################
//# Reconfigurable bus state machine
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

module RBUS_STATEMACHINE(

//////////// INPUTS //////////
RBUS_STATEMACHINE_Clk,
RBUS_STATEMACHINE_Reset,
RBUS_STATEMACHINE_Start_Conf,
RBUS_STATEMACHINE_Conf_Already_Ok,
RBUS_STATEMACHINE_Counter_Bus_Flag,
RBUS_STATEMACHINE_Counter_W_Size_Flag,

//////////// OUTPUTS //////////
RBUS_STATEMACHINE_Set_Conf_Already,
RBUS_STATEMACHINE_Counter_W_Size_En,
RBUS_STATEMACHINE_Counter_W_Size_Clr,
RBUS_STATEMACHINE_Counter_W_Col_En,
RBUS_STATEMACHINE_Counter_W_Col_Load,
RBUS_STATEMACHINE_Counter_W_Col_Clr,
RBUS_STATEMACHINE_Counter_Input_Clr,
RBUS_STATEMACHINE_Counter_Input_Load,
RBUS_STATEMACHINE_Counter_Bus_En,
RBUS_STATEMACHINE_Counter_Bus_Clr,
RBUS_STATEMACHINE_Conf_Rutine,
RBUS_STATEMACHINE_Bus_En

);


//=======================================================
//  State declarations
//=======================================================

localparam State_reset = 0;
localparam State_load = 1;
localparam State_Configuring0 = 2;
localparam State_Configuring1 = 3;
localparam State_Wait_Conf = 4;
localparam State_Configured = 5;

//=======================================================
//  PORT declarations
//=======================================================

input RBUS_STATEMACHINE_Clk;
input RBUS_STATEMACHINE_Reset;
input RBUS_STATEMACHINE_Start_Conf;
input RBUS_STATEMACHINE_Conf_Already_Ok;
input RBUS_STATEMACHINE_Counter_Bus_Flag;
input RBUS_STATEMACHINE_Counter_W_Size_Flag;
output reg RBUS_STATEMACHINE_Set_Conf_Already;
output reg RBUS_STATEMACHINE_Counter_W_Size_En;
output reg RBUS_STATEMACHINE_Counter_W_Size_Clr;
output reg RBUS_STATEMACHINE_Counter_W_Col_En;
output reg RBUS_STATEMACHINE_Counter_W_Col_Load;
output reg RBUS_STATEMACHINE_Counter_W_Col_Clr;
output reg RBUS_STATEMACHINE_Counter_Input_Clr;
output reg RBUS_STATEMACHINE_Counter_Input_Load;
output reg RBUS_STATEMACHINE_Counter_Bus_En;
output reg RBUS_STATEMACHINE_Counter_Bus_Clr;
output reg RBUS_STATEMACHINE_Conf_Rutine;
output reg RBUS_STATEMACHINE_Bus_En;

//=======================================================
//  REG/WIRE DECLARATIONS
//=======================================================
reg [2:0] State_Register;
reg [2:0] State_Signal;

// Next state combinational logic
always @(*)
begin
	case (State_Register)
		
		State_reset: if(RBUS_STATEMACHINE_Start_Conf)
							State_Signal=State_load;
						 else
							State_Signal=State_reset;
		
		State_load: State_Signal=State_Configuring0;
		
		
		
		State_Configuring0: if(RBUS_STATEMACHINE_Counter_Bus_Flag)
										State_Signal=State_Wait_Conf;
								  else if (RBUS_STATEMACHINE_Counter_W_Size_Flag)
										State_Signal =State_Configuring1;
								  else
									State_Signal=State_Configuring0;
		
		State_Configuring1: if(RBUS_STATEMACHINE_Counter_Bus_Flag)
										State_Signal=State_Wait_Conf;
								  else
										State_Signal=State_Configuring1;
										
		State_Wait_Conf: if(RBUS_STATEMACHINE_Conf_Already_Ok)	
									State_Signal=State_Configured;
							  else
									State_Signal=State_Wait_Conf;
											
		State_Configured: if(!RBUS_STATEMACHINE_Reset)
									State_Signal=State_reset;
								else
									State_Signal=State_Configured;		
									
		default: State_Signal = State_reset;
	endcase
	
end

// Sequential Logic

always @ (posedge RBUS_STATEMACHINE_Clk, negedge RBUS_STATEMACHINE_Reset)
begin
	if (!RBUS_STATEMACHINE_Reset)
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
			RBUS_STATEMACHINE_Set_Conf_Already = 1'b0;
			RBUS_STATEMACHINE_Counter_W_Size_En = 1'b0;
			RBUS_STATEMACHINE_Counter_W_Size_Clr = 1'b0;
			RBUS_STATEMACHINE_Counter_W_Col_En = 1'b0;
			RBUS_STATEMACHINE_Counter_W_Col_Load = 1'b0;
			RBUS_STATEMACHINE_Counter_W_Col_Clr = 1'b0;
			RBUS_STATEMACHINE_Counter_Input_Clr = 1'b0;
			RBUS_STATEMACHINE_Counter_Input_Load = 1'b0;
			RBUS_STATEMACHINE_Counter_Bus_En = 1'b0;
			RBUS_STATEMACHINE_Counter_Bus_Clr = 1'b0;
			RBUS_STATEMACHINE_Conf_Rutine = 1'b0;
			RBUS_STATEMACHINE_Bus_En = 1'b0;
		end
	
		State_load:
		begin
			RBUS_STATEMACHINE_Set_Conf_Already = 1'b0;
			RBUS_STATEMACHINE_Counter_W_Size_En = 1'b0;
			RBUS_STATEMACHINE_Counter_W_Size_Clr = 1'b1;
			RBUS_STATEMACHINE_Counter_W_Col_En = 1'b0;
			RBUS_STATEMACHINE_Counter_W_Col_Load = 1'b1;
			RBUS_STATEMACHINE_Counter_W_Col_Clr = 1'b1;
			RBUS_STATEMACHINE_Counter_Input_Clr = 1'b1;
			RBUS_STATEMACHINE_Counter_Input_Load = 1'b1;
			RBUS_STATEMACHINE_Counter_Bus_En = 1'b0;
			RBUS_STATEMACHINE_Counter_Bus_Clr = 1'b1;
			RBUS_STATEMACHINE_Conf_Rutine = 1'b0;
			RBUS_STATEMACHINE_Bus_En = 1'b0;
		end
	
		State_Configuring0:
		begin
			RBUS_STATEMACHINE_Set_Conf_Already = 1'b0;
			RBUS_STATEMACHINE_Counter_W_Size_En = 1'b1;
			RBUS_STATEMACHINE_Counter_W_Size_Clr = 1'b1;
			RBUS_STATEMACHINE_Counter_W_Col_En = 1'b1;
			RBUS_STATEMACHINE_Counter_W_Col_Load = 1'b0;
			RBUS_STATEMACHINE_Counter_W_Col_Clr = 1'b1;
			RBUS_STATEMACHINE_Counter_Input_Clr = 1'b1;
			RBUS_STATEMACHINE_Counter_Input_Load = 1'b0;
			RBUS_STATEMACHINE_Counter_Bus_En = 1'b1;
			RBUS_STATEMACHINE_Counter_Bus_Clr = 1'b1;
			RBUS_STATEMACHINE_Conf_Rutine = 1'b1;
			RBUS_STATEMACHINE_Bus_En = 1'b0;
		end
	
		State_Configuring1:
		begin
			RBUS_STATEMACHINE_Set_Conf_Already = 1'b0;
			RBUS_STATEMACHINE_Counter_W_Size_En = 1'b0;
			RBUS_STATEMACHINE_Counter_W_Size_Clr = 1'b0;
			RBUS_STATEMACHINE_Counter_W_Col_En = 1'b0;
			RBUS_STATEMACHINE_Counter_W_Col_Load = 1'b0;
			RBUS_STATEMACHINE_Counter_W_Col_Clr = 1'b0;
			RBUS_STATEMACHINE_Counter_Input_Clr = 1'b0;
			RBUS_STATEMACHINE_Counter_Input_Load = 1'b0;
			RBUS_STATEMACHINE_Counter_Bus_En = 1'b1;
			RBUS_STATEMACHINE_Counter_Bus_Clr = 1'b1;
			RBUS_STATEMACHINE_Conf_Rutine = 1'b1;
			RBUS_STATEMACHINE_Bus_En = 1'b0;
		end
	
		State_Wait_Conf:
		begin
			RBUS_STATEMACHINE_Set_Conf_Already = 1'b1;
			RBUS_STATEMACHINE_Counter_W_Size_En = 1'b0;
			RBUS_STATEMACHINE_Counter_W_Size_Clr = 1'b0;
			RBUS_STATEMACHINE_Counter_W_Col_En = 1'b0;
			RBUS_STATEMACHINE_Counter_W_Col_Load = 1'b0;
			RBUS_STATEMACHINE_Counter_W_Col_Clr = 1'b0;
			RBUS_STATEMACHINE_Counter_Input_Clr = 1'b0;
			RBUS_STATEMACHINE_Counter_Input_Load = 1'b0;
			RBUS_STATEMACHINE_Counter_Bus_En = 1'b0;
			RBUS_STATEMACHINE_Counter_Bus_Clr = 1'b0;
			RBUS_STATEMACHINE_Conf_Rutine = 1'b0;
			RBUS_STATEMACHINE_Bus_En = 1'b1;
		end
	
		State_Configured:
		begin
			RBUS_STATEMACHINE_Set_Conf_Already = 1'b0;
			RBUS_STATEMACHINE_Counter_W_Size_En = 1'b0;
			RBUS_STATEMACHINE_Counter_W_Size_Clr = 1'b0;
			RBUS_STATEMACHINE_Counter_W_Col_En = 1'b0;
			RBUS_STATEMACHINE_Counter_W_Col_Load = 1'b0;
			RBUS_STATEMACHINE_Counter_W_Col_Clr = 1'b0;
			RBUS_STATEMACHINE_Counter_Input_Clr = 1'b0;
			RBUS_STATEMACHINE_Counter_Input_Load = 1'b0;
			RBUS_STATEMACHINE_Counter_Bus_En = 1'b0;
			RBUS_STATEMACHINE_Counter_Bus_Clr = 1'b0;
			RBUS_STATEMACHINE_Conf_Rutine = 1'b0;
			RBUS_STATEMACHINE_Bus_En = 1'b1;
		end
	
	
		default:
		begin
			RBUS_STATEMACHINE_Set_Conf_Already = 1'b0;
			RBUS_STATEMACHINE_Counter_W_Size_En = 1'b0;
			RBUS_STATEMACHINE_Counter_W_Size_Clr = 1'b0;
			RBUS_STATEMACHINE_Counter_W_Col_En = 1'b0;
			RBUS_STATEMACHINE_Counter_W_Col_Load = 1'b0;
			RBUS_STATEMACHINE_Counter_W_Col_Clr = 1'b0;
			RBUS_STATEMACHINE_Counter_Input_Clr = 1'b0;
			RBUS_STATEMACHINE_Counter_Input_Load = 1'b0;
			RBUS_STATEMACHINE_Counter_Bus_En = 1'b0;
			RBUS_STATEMACHINE_Counter_Bus_Clr = 1'b0;
			RBUS_STATEMACHINE_Conf_Rutine = 1'b0;
			RBUS_STATEMACHINE_Bus_En = 1'b0;	
		end
	
	endcase
end


endmodule

