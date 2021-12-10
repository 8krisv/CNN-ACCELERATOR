/*#########################################################################
//# Off-chip memory communication interface state machine 
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

module OFMI_STATEMACHINE(

//////////// INPUTS //////////
OFMI_STATEMACHINE_Clk,
OFMI_STATEMACHINE_Reset,
OFMI_STATEMACHINE_Mst_Start_Loading_Weights,
OFMI_STATEMACHINE_Mst_Loading_Weights_Already_Ok,
OFMI_STATEMACHINE_Owmc_Loading_Weights_Already,
OFMI_STATEMACHINE_Mst_Start_Feeding_Datapath,
OFMI_STATEMACHINE_Mst_Stop_Feeding_Datapath,
OFMI_STATEMACHINE_Mst_Feeding_Datapath_finished_OK,
OFMI_STATEMACHINE_Mst_Start_Writing_Data,
OFMI_STATEMACHINE_Mst_Writing_Data_Already_Ok,
OFMI_STATEMACHINE_Counter_Finish_Already,

//////////// OUTPUTS //////////
OFMI_STATEMACHINE_Mst_Loading_Weights_Already,
OFMI_STATEMACHINE_Mst_Feeding_Datapath_finished,
OFMI_STATEMACHINE_Mst_Writing_Data_Already,
OFMI_STATEMACHINE_Offmem_We,
OFMI_STATEMACHINE_Offmem_Re,
OFMI_STATEMACHINE_Counter_Sel_Offset,
OFMI_STATEMACHINE_Counter_Sel_UpperLim,
OFMI_STATEMACHINE_Counter_en,
OFMI_STATEMACHINE_Counter_Reset,
OFMI_STATEMACHINE_Mux_Sel,
OFMI_STATEMACHINE_Mux_En

);

//=======================================================
//  State declarations
//=======================================================

localparam State_reset						= 0;
localparam State_loading_weights			= 1;
localparam State_Wait_Conf0				= 2;
localparam State_Feeding_Datapath		= 3;
localparam State_Feeding_Last				= 4;
localparam State_Stop_Feeding				= 5;
localparam State_Wait_Conf1				= 6;
localparam State_Writing					= 7;
localparam State_Wait_Conf2				= 8;

//=======================================================
//  PORT declarations
//=======================================================

input OFMI_STATEMACHINE_Clk;
input OFMI_STATEMACHINE_Reset;
input OFMI_STATEMACHINE_Mst_Start_Loading_Weights;
input OFMI_STATEMACHINE_Mst_Loading_Weights_Already_Ok;
input OFMI_STATEMACHINE_Owmc_Loading_Weights_Already;
input OFMI_STATEMACHINE_Mst_Start_Feeding_Datapath;
input OFMI_STATEMACHINE_Mst_Stop_Feeding_Datapath;
input OFMI_STATEMACHINE_Mst_Feeding_Datapath_finished_OK;
input OFMI_STATEMACHINE_Mst_Start_Writing_Data;
input OFMI_STATEMACHINE_Mst_Writing_Data_Already_Ok;
input OFMI_STATEMACHINE_Counter_Finish_Already;

output reg OFMI_STATEMACHINE_Mst_Loading_Weights_Already;
output reg OFMI_STATEMACHINE_Mst_Feeding_Datapath_finished;
output reg OFMI_STATEMACHINE_Mst_Writing_Data_Already;
output reg OFMI_STATEMACHINE_Offmem_We;
output reg OFMI_STATEMACHINE_Offmem_Re;
output reg OFMI_STATEMACHINE_Counter_Sel_Offset;
output reg OFMI_STATEMACHINE_Counter_Sel_UpperLim;
output reg OFMI_STATEMACHINE_Counter_en;
output reg OFMI_STATEMACHINE_Counter_Reset;
output reg OFMI_STATEMACHINE_Mux_Sel;
output reg OFMI_STATEMACHINE_Mux_En;

//=======================================================
//  REG/WIRE declarations
//=======================================================

reg [3:0] State_Register;
reg [3:0] State_Signal;


// Next state combinational logic
always @(*)
begin
	case (State_Register)
		
		State_reset: if(OFMI_STATEMACHINE_Mst_Start_Loading_Weights)
							State_Signal=State_loading_weights;
						 else if(OFMI_STATEMACHINE_Mst_Start_Feeding_Datapath)
							State_Signal=State_Feeding_Datapath;
						 else if(OFMI_STATEMACHINE_Mst_Start_Writing_Data)
							State_Signal=State_Writing;
						 else
							State_Signal=State_reset;
		
		State_loading_weights: if(OFMI_STATEMACHINE_Owmc_Loading_Weights_Already)
										State_Signal=State_Wait_Conf0;
									  else
										State_Signal=State_loading_weights;
										
										
		State_Wait_Conf0: if(OFMI_STATEMACHINE_Mst_Loading_Weights_Already_Ok)	
									State_Signal=State_reset;
								else
									State_Signal=State_Wait_Conf0;
		
		
		State_Feeding_Datapath: if(OFMI_STATEMACHINE_Mst_Stop_Feeding_Datapath)
											State_Signal=State_Stop_Feeding;
										else if(OFMI_STATEMACHINE_Counter_Finish_Already)
											State_Signal=State_Feeding_Last;
										else
											State_Signal=State_Feeding_Datapath;
		
		State_Feeding_Last:State_Signal=State_Wait_Conf1;
										
		State_Stop_Feeding: if(OFMI_STATEMACHINE_Mst_Start_Feeding_Datapath)
									State_Signal=State_Feeding_Datapath;
								  else
									State_Signal=State_Stop_Feeding;
									
		State_Wait_Conf1: if(OFMI_STATEMACHINE_Mst_Feeding_Datapath_finished_OK)
									State_Signal=State_reset;
								else
									State_Signal=State_Wait_Conf1;
								
		State_Writing: if(OFMI_STATEMACHINE_Counter_Finish_Already)
								State_Signal=State_Wait_Conf2;
							else
								State_Signal=State_Writing;
								
		State_Wait_Conf2: if(OFMI_STATEMACHINE_Mst_Writing_Data_Already_Ok)
									State_Signal=State_reset;
								else
									State_Signal=State_Wait_Conf2;
		
		default : State_Signal = State_reset;
									
	endcase
		
end


// Sequential Logic
always @ (negedge OFMI_STATEMACHINE_Clk , negedge OFMI_STATEMACHINE_Reset)
begin
	if (!OFMI_STATEMACHINE_Reset)
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
		
			OFMI_STATEMACHINE_Mst_Loading_Weights_Already=0;
			OFMI_STATEMACHINE_Mst_Feeding_Datapath_finished=0;
			OFMI_STATEMACHINE_Mst_Writing_Data_Already=0;
			OFMI_STATEMACHINE_Offmem_We=0;
			OFMI_STATEMACHINE_Offmem_Re=0;
			OFMI_STATEMACHINE_Counter_Sel_Offset=0;
			OFMI_STATEMACHINE_Counter_Sel_UpperLim=0;
			OFMI_STATEMACHINE_Counter_en=0;
			OFMI_STATEMACHINE_Counter_Reset=0;
			OFMI_STATEMACHINE_Mux_Sel=0;
			OFMI_STATEMACHINE_Mux_En=0;
		
		end
		
		State_loading_weights:
		begin
			
			OFMI_STATEMACHINE_Mst_Loading_Weights_Already=0;
			OFMI_STATEMACHINE_Mst_Feeding_Datapath_finished=0;
			OFMI_STATEMACHINE_Mst_Writing_Data_Already=0;
			OFMI_STATEMACHINE_Offmem_We=0;
			OFMI_STATEMACHINE_Offmem_Re=1;
			OFMI_STATEMACHINE_Counter_Sel_Offset=0;
			OFMI_STATEMACHINE_Counter_Sel_UpperLim=0;
			OFMI_STATEMACHINE_Counter_en=1;
			OFMI_STATEMACHINE_Counter_Reset=1;
			OFMI_STATEMACHINE_Mux_Sel=0;
			OFMI_STATEMACHINE_Mux_En=1;
		end
		
		State_Wait_Conf0:
		begin
		
			OFMI_STATEMACHINE_Mst_Loading_Weights_Already=1;
			OFMI_STATEMACHINE_Mst_Feeding_Datapath_finished=0;
			OFMI_STATEMACHINE_Mst_Writing_Data_Already=0;
			OFMI_STATEMACHINE_Offmem_We=0;
			OFMI_STATEMACHINE_Offmem_Re=0;
			OFMI_STATEMACHINE_Counter_Sel_Offset=0;
			OFMI_STATEMACHINE_Counter_Sel_UpperLim=0;
			OFMI_STATEMACHINE_Counter_en=0;
			OFMI_STATEMACHINE_Counter_Reset=0;
			OFMI_STATEMACHINE_Mux_Sel=0;
			OFMI_STATEMACHINE_Mux_En=0;
		end
		
		State_Feeding_Datapath:
		begin
		
			OFMI_STATEMACHINE_Mst_Loading_Weights_Already=0;
			OFMI_STATEMACHINE_Mst_Feeding_Datapath_finished=0;
			OFMI_STATEMACHINE_Mst_Writing_Data_Already=0;
			OFMI_STATEMACHINE_Offmem_We=0;
			OFMI_STATEMACHINE_Offmem_Re=1;
			OFMI_STATEMACHINE_Counter_Sel_Offset=1;
			OFMI_STATEMACHINE_Counter_Sel_UpperLim=0;
			OFMI_STATEMACHINE_Counter_en=1;
			OFMI_STATEMACHINE_Counter_Reset=1;
			OFMI_STATEMACHINE_Mux_Sel=1;
			OFMI_STATEMACHINE_Mux_En=1;
		end
			
		State_Stop_Feeding:
		begin
		
			OFMI_STATEMACHINE_Mst_Loading_Weights_Already=0;
			OFMI_STATEMACHINE_Mst_Feeding_Datapath_finished=0;
			OFMI_STATEMACHINE_Mst_Writing_Data_Already=0;
			OFMI_STATEMACHINE_Offmem_We=0;
			OFMI_STATEMACHINE_Offmem_Re=1;
			OFMI_STATEMACHINE_Counter_Sel_Offset=1;
			OFMI_STATEMACHINE_Counter_Sel_UpperLim=0;
			OFMI_STATEMACHINE_Counter_en=0;
			OFMI_STATEMACHINE_Counter_Reset=1;
			OFMI_STATEMACHINE_Mux_Sel=1;
			OFMI_STATEMACHINE_Mux_En=0;
			
		end
		
		State_Feeding_Last:
		begin
			OFMI_STATEMACHINE_Mst_Loading_Weights_Already=0;
			OFMI_STATEMACHINE_Mst_Feeding_Datapath_finished=0;
			OFMI_STATEMACHINE_Mst_Writing_Data_Already=0;
			OFMI_STATEMACHINE_Offmem_We=0;
			OFMI_STATEMACHINE_Offmem_Re=1;
			OFMI_STATEMACHINE_Counter_Sel_Offset=1;
			OFMI_STATEMACHINE_Counter_Sel_UpperLim=0;
			OFMI_STATEMACHINE_Counter_en=1;
			OFMI_STATEMACHINE_Counter_Reset=1;
			OFMI_STATEMACHINE_Mux_Sel=1;
			OFMI_STATEMACHINE_Mux_En=1;
		end
		
		State_Wait_Conf1:
		begin
		
			OFMI_STATEMACHINE_Mst_Loading_Weights_Already=0;
			OFMI_STATEMACHINE_Mst_Feeding_Datapath_finished=1;
			OFMI_STATEMACHINE_Mst_Writing_Data_Already=0;
			OFMI_STATEMACHINE_Offmem_We=0;
			OFMI_STATEMACHINE_Offmem_Re=0;
			OFMI_STATEMACHINE_Counter_Sel_Offset=0;
			OFMI_STATEMACHINE_Counter_Sel_UpperLim=0;
			OFMI_STATEMACHINE_Counter_en=0;
			OFMI_STATEMACHINE_Counter_Reset=0;
			OFMI_STATEMACHINE_Mux_Sel=0;
			OFMI_STATEMACHINE_Mux_En=0;
		end
		
		State_Writing:
		begin
			OFMI_STATEMACHINE_Mst_Loading_Weights_Already=0;
			OFMI_STATEMACHINE_Mst_Feeding_Datapath_finished=0;
			OFMI_STATEMACHINE_Mst_Writing_Data_Already=0;
			OFMI_STATEMACHINE_Offmem_We=1;
			OFMI_STATEMACHINE_Offmem_Re=0;
			OFMI_STATEMACHINE_Counter_Sel_Offset=0;
			OFMI_STATEMACHINE_Counter_Sel_UpperLim=1;
			OFMI_STATEMACHINE_Counter_en=1;
			OFMI_STATEMACHINE_Counter_Reset=1;
			OFMI_STATEMACHINE_Mux_Sel=0;
			OFMI_STATEMACHINE_Mux_En=0;
		end
		
		State_Wait_Conf2:
		begin
			OFMI_STATEMACHINE_Mst_Loading_Weights_Already=0;
			OFMI_STATEMACHINE_Mst_Feeding_Datapath_finished=0;
			OFMI_STATEMACHINE_Mst_Writing_Data_Already=1;
			OFMI_STATEMACHINE_Offmem_We=0;
			OFMI_STATEMACHINE_Offmem_Re=0;
			OFMI_STATEMACHINE_Counter_Sel_Offset=0;
			OFMI_STATEMACHINE_Counter_Sel_UpperLim=0;
			OFMI_STATEMACHINE_Counter_en=0;
			OFMI_STATEMACHINE_Counter_Reset=0;
			OFMI_STATEMACHINE_Mux_Sel=0;
			OFMI_STATEMACHINE_Mux_En=0;
		end
		
		default:
		begin
			OFMI_STATEMACHINE_Mst_Loading_Weights_Already=0;
			OFMI_STATEMACHINE_Mst_Feeding_Datapath_finished=0;
			OFMI_STATEMACHINE_Mst_Writing_Data_Already=0;
			OFMI_STATEMACHINE_Offmem_We=0;
			OFMI_STATEMACHINE_Offmem_Re=0;
			OFMI_STATEMACHINE_Counter_Sel_Offset=0;
			OFMI_STATEMACHINE_Counter_Sel_UpperLim=0;
			OFMI_STATEMACHINE_Counter_en=0;
			OFMI_STATEMACHINE_Counter_Reset=0;
			OFMI_STATEMACHINE_Mux_Sel=0;
			OFMI_STATEMACHINE_Mux_En=0;
		end
		
	endcase
	
end



endmodule
