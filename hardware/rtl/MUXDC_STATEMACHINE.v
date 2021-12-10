/*#########################################################################
//# Multiplexers Dataflow Controller State Machine
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

module MUXDC_STATEMACHINE(

//////////// INPUTS //////////
MUXDC_STATEMACHINE_Clk,
MUXDC_STATEMACHINE_Reset,
MUXDC_STATEMACHINE_Start_Conf,
MUXDC_STATEMACHINE_Conf_Already_Ok,
MUXDC_STATEMACHINE_Counter_Bus_Flag,
MUXDC_STATEMACHINE_Counter_W_Size_Flag,

//////////// OUTPUTS //////////

MUXDC_STATEMACHINE_Set_Conf_Already,
MUXDC_STATEMACHINE_Counter_W_Size_En,
MUXDC_STATEMACHINEE_Counter_W_Size_Clr,
MUXDC_STATEMACHINE_Counter_W_Col_En,
MUXDC_STATEMACHINE_Counter_W_Col_Load,
MUXDC_STATEMACHINE_Counter_W_Col_Clr,
MUXDC_STATEMACHINE_Counter_Bus_En,
MUXDC_STATEMACHINE_Counter_Bus_Clr,
MUXDC_STATEMACHINE_Conf_Rutine

);

//=======================================================
//  State declarations
//=======================================================

localparam State_reset = 0;
localparam State_load = 1;
localparam State_Configuring0 = 2;
localparam State_Configuring1 = 3;
localparam State_Wait_Conf = 4;


//=======================================================
//  PORT declarations
//=======================================================
input MUXDC_STATEMACHINE_Clk;
input MUXDC_STATEMACHINE_Reset;
input MUXDC_STATEMACHINE_Start_Conf;
input MUXDC_STATEMACHINE_Conf_Already_Ok;
input MUXDC_STATEMACHINE_Counter_Bus_Flag;
input MUXDC_STATEMACHINE_Counter_W_Size_Flag;
output reg MUXDC_STATEMACHINE_Set_Conf_Already;
output reg MUXDC_STATEMACHINE_Counter_W_Size_En;
output reg MUXDC_STATEMACHINEE_Counter_W_Size_Clr;
output reg MUXDC_STATEMACHINE_Counter_W_Col_En;
output reg MUXDC_STATEMACHINE_Counter_W_Col_Load;
output reg MUXDC_STATEMACHINE_Counter_W_Col_Clr;
output reg MUXDC_STATEMACHINE_Counter_Bus_En;
output reg MUXDC_STATEMACHINE_Counter_Bus_Clr;
output reg MUXDC_STATEMACHINE_Conf_Rutine;

//=======================================================
//  REG/WIRE DECLARATIONS
//=======================================================
reg [2:0] State_Register;
reg [2:0] State_Signal;

// Next state combinational logic
always @(*)
begin
	case (State_Register)
	
		State_reset: if(MUXDC_STATEMACHINE_Start_Conf)
							State_Signal=State_load;
						 else
							State_Signal=State_reset;
		
		State_load: State_Signal=State_Configuring0;
		
		State_Configuring0:if(MUXDC_STATEMACHINE_Counter_Bus_Flag)
										State_Signal=State_Wait_Conf;
								 else if(MUXDC_STATEMACHINE_Counter_W_Size_Flag)
										State_Signal=State_Configuring1;
								 else
										State_Signal=State_Configuring0;
									
		State_Configuring1: if(MUXDC_STATEMACHINE_Counter_Bus_Flag)
										State_Signal=State_Wait_Conf;
								  else
										State_Signal=State_Configuring1;
		
		State_Wait_Conf: if(MUXDC_STATEMACHINE_Conf_Already_Ok)
									State_Signal=State_reset;
								else
									State_Signal=State_Wait_Conf;
									
		default: State_Signal = State_reset;
								
	endcase

end


// Sequential Logic
always @ (posedge MUXDC_STATEMACHINE_Clk, negedge MUXDC_STATEMACHINE_Reset)
begin
	if (!MUXDC_STATEMACHINE_Reset)
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
			MUXDC_STATEMACHINE_Set_Conf_Already = 1'b0;
			MUXDC_STATEMACHINE_Counter_W_Size_En = 1'b0;
			MUXDC_STATEMACHINEE_Counter_W_Size_Clr = 1'b0;
			MUXDC_STATEMACHINE_Counter_W_Col_En = 1'b0;
			MUXDC_STATEMACHINE_Counter_W_Col_Load = 1'b0;
			MUXDC_STATEMACHINE_Counter_W_Col_Clr = 1'b0;
			MUXDC_STATEMACHINE_Counter_Bus_En = 1'b0;
			MUXDC_STATEMACHINE_Counter_Bus_Clr = 1'b0;
			MUXDC_STATEMACHINE_Conf_Rutine = 1'b0;
		end
		
		State_load:
		begin
			MUXDC_STATEMACHINE_Set_Conf_Already = 1'b0;
			MUXDC_STATEMACHINE_Counter_W_Size_En = 1'b0;
			MUXDC_STATEMACHINEE_Counter_W_Size_Clr = 1'b1;
			MUXDC_STATEMACHINE_Counter_W_Col_En = 1'b0;
			MUXDC_STATEMACHINE_Counter_W_Col_Load = 1'b1;
			MUXDC_STATEMACHINE_Counter_W_Col_Clr = 1'b1;
			MUXDC_STATEMACHINE_Counter_Bus_En = 1'b0;
			MUXDC_STATEMACHINE_Counter_Bus_Clr = 1'b1;
			MUXDC_STATEMACHINE_Conf_Rutine = 1'b0;
		end
		
		State_Configuring0:
		begin
			MUXDC_STATEMACHINE_Set_Conf_Already = 1'b0;
			MUXDC_STATEMACHINE_Counter_W_Size_En = 1'b1;
			MUXDC_STATEMACHINEE_Counter_W_Size_Clr = 1'b1;
			MUXDC_STATEMACHINE_Counter_W_Col_En = 1'b1;
			MUXDC_STATEMACHINE_Counter_W_Col_Load = 1'b0;
			MUXDC_STATEMACHINE_Counter_W_Col_Clr = 1'b1;
			MUXDC_STATEMACHINE_Counter_Bus_En = 1'b1;
			MUXDC_STATEMACHINE_Counter_Bus_Clr = 1'b1;
			MUXDC_STATEMACHINE_Conf_Rutine = 1'b1;
		end
		
		State_Configuring1:
		begin
			MUXDC_STATEMACHINE_Set_Conf_Already = 1'b0;
			MUXDC_STATEMACHINE_Counter_W_Size_En = 1'b0;
			MUXDC_STATEMACHINEE_Counter_W_Size_Clr = 1'b0;
			MUXDC_STATEMACHINE_Counter_W_Col_En = 1'b0;
			MUXDC_STATEMACHINE_Counter_W_Col_Load = 1'b0;
			MUXDC_STATEMACHINE_Counter_W_Col_Clr = 1'b0;
			MUXDC_STATEMACHINE_Counter_Bus_En = 1'b1;
			MUXDC_STATEMACHINE_Counter_Bus_Clr = 1'b1;
			MUXDC_STATEMACHINE_Conf_Rutine = 1'b1;
		end
		
		
		State_Wait_Conf:
		begin
			MUXDC_STATEMACHINE_Set_Conf_Already = 1'b1;
			MUXDC_STATEMACHINE_Counter_W_Size_En = 1'b0;
			MUXDC_STATEMACHINEE_Counter_W_Size_Clr = 1'b0;
			MUXDC_STATEMACHINE_Counter_W_Col_En = 1'b0;
			MUXDC_STATEMACHINE_Counter_W_Col_Load = 1'b0;
			MUXDC_STATEMACHINE_Counter_W_Col_Clr = 1'b0;
			MUXDC_STATEMACHINE_Counter_Bus_En = 1'b0;
			MUXDC_STATEMACHINE_Counter_Bus_Clr = 1'b0;
			MUXDC_STATEMACHINE_Conf_Rutine = 1'b0;
		end
		
		
		default:
		begin
			MUXDC_STATEMACHINE_Set_Conf_Already = 1'b0;
			MUXDC_STATEMACHINE_Counter_W_Size_En = 1'b0;
			MUXDC_STATEMACHINEE_Counter_W_Size_Clr = 1'b0;
			MUXDC_STATEMACHINE_Counter_W_Col_En = 1'b0;
			MUXDC_STATEMACHINE_Counter_W_Col_Load = 1'b0;
			MUXDC_STATEMACHINE_Counter_W_Col_Clr = 1'b0;
			MUXDC_STATEMACHINE_Counter_Bus_En = 1'b0;
			MUXDC_STATEMACHINE_Counter_Bus_Clr = 1'b0;
			MUXDC_STATEMACHINE_Conf_Rutine = 1'b0;
		end
		
	endcase
	
end


endmodule

