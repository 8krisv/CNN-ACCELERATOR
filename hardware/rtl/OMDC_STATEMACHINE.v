/*#########################################################################
//# On-chip fifo memory dataflow controller state machine 
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

module OMDC_STATEMACHINE(

/////////// INPUTS //////////
OMDC_STATEMACHINE_Clk,
OMDC_STATEMACHINE_Reset,
OMDC_STATEMACHINE_Start_Routine,
OMDC_STATEMACHINE_Stop_Routine,
OMDC_STATEMACHINE_Finish_Routine,
OMDC_STATEMACHINE_Routine_Finished_Ok,
OMDC_STATEMACHINE_Flag_Eqcw,
OMDC_STATEMACHINE_Flag_Eqst,
OMDC_STATEMACHINE_Flag_Eqcif,
OMDC_STATEMACHINE_Flag_NewCh,
OMDC_STATEMACHINE_Flag_In_Output_Routine,


//////////// OUTPUTS //////////
OMDC_STATEMACHINE_Routine_Finished_Already,
OMDC_STATEMACHINE_OneDConv_Reset,
OMDC_STATEMACHINE_OneDConv_Reset_Counter_Row,
OMDC_STATEMACHINE_Counter_Eqcw_En,
OMDC_STATEMACHINE_Counter_Eqcw_Reset,
OMDC_STATEMACHINE_Counter_Eqcw_load1,
OMDC_STATEMACHINE_Counter_Eqst_En,
OMDC_STATEMACHINE_Counter_Eqst_Reset,
OMDC_STATEMACHINE_Counter_Eqst_load1,
OMDC_STATEMACHINE_Counter_Crow_En,
OMDC_STATEMACHINE_Counter_Crow_Reset,
OMDC_STATEMACHINE_Counter_Crow_load1,
OMDC_STATEMACHINE_Counter_Eqcif_En,
OMDC_STATEMACHINE_Counter_Eqcif_Reset,
OMDC_STATEMACHINE_Counter_Eqcif_load1

);

//=======================================================
//  State declarations
//=======================================================

localparam State_reset = 0;
localparam State_count_w_colums = 1;
localparam State_count_stride = 2;
localparam State_Routine_Stoped = 3;
localparam State_count_row = 4;
localparam State_reset_count_row = 5;
localparam State_waiting_finish = 6;
localparam State_finish = 7;

//=======================================================
//  PORT declarations
//=======================================================

input OMDC_STATEMACHINE_Clk;
input OMDC_STATEMACHINE_Reset;
input OMDC_STATEMACHINE_Start_Routine;
input OMDC_STATEMACHINE_Stop_Routine;
input OMDC_STATEMACHINE_Finish_Routine;
input OMDC_STATEMACHINE_Routine_Finished_Ok;
input OMDC_STATEMACHINE_Flag_Eqcw;
input OMDC_STATEMACHINE_Flag_Eqst;
input OMDC_STATEMACHINE_Flag_Eqcif;
input OMDC_STATEMACHINE_Flag_NewCh;
input OMDC_STATEMACHINE_Flag_In_Output_Routine;
output reg OMDC_STATEMACHINE_Routine_Finished_Already;
output reg OMDC_STATEMACHINE_OneDConv_Reset;
output reg OMDC_STATEMACHINE_OneDConv_Reset_Counter_Row;
output reg OMDC_STATEMACHINE_Counter_Eqcw_En;
output reg OMDC_STATEMACHINE_Counter_Eqcw_Reset;
output reg OMDC_STATEMACHINE_Counter_Eqcw_load1;
output reg OMDC_STATEMACHINE_Counter_Eqst_En;
output reg OMDC_STATEMACHINE_Counter_Eqst_Reset;
output reg OMDC_STATEMACHINE_Counter_Eqst_load1;
output reg OMDC_STATEMACHINE_Counter_Crow_En;
output reg OMDC_STATEMACHINE_Counter_Crow_Reset;
output reg OMDC_STATEMACHINE_Counter_Crow_load1;
output reg OMDC_STATEMACHINE_Counter_Eqcif_En;
output reg OMDC_STATEMACHINE_Counter_Eqcif_Reset;
output reg OMDC_STATEMACHINE_Counter_Eqcif_load1;

//=======================================================
//  REG/WIRE DECLARATIONS
//=======================================================
reg [2:0] State_Register;
reg [2:0] State_Signal;



// Next state combinational logic
always @(*)
begin
	
	case(State_Register)
		
		State_reset: if(OMDC_STATEMACHINE_Start_Routine)
								State_Signal=State_count_w_colums;
						 else
								State_Signal=State_reset;
		
		State_count_w_colums: if(OMDC_STATEMACHINE_Flag_Eqcw)
										State_Signal=State_count_stride;
									 else if(OMDC_STATEMACHINE_Finish_Routine)
										State_Signal= State_waiting_finish;
									 else
										State_Signal=State_count_w_colums;
		
		State_count_stride: if(!OMDC_STATEMACHINE_Finish_Routine) begin
					
										if(!OMDC_STATEMACHINE_Stop_Routine) begin
											
											if(OMDC_STATEMACHINE_Flag_Eqcif) begin
													
													if(OMDC_STATEMACHINE_Flag_NewCh)
														State_Signal=State_reset_count_row;
													else
														State_Signal=State_count_row;
											end
											
											else
												State_Signal=State_count_stride;
										end
										
										else
											State_Signal=State_Routine_Stoped;
								  end
								  
									else
										State_Signal=State_waiting_finish;
		
		
		State_reset_count_row: if(OMDC_STATEMACHINE_Finish_Routine)
											State_Signal=State_waiting_finish;
									  else if(OMDC_STATEMACHINE_Flag_Eqcw)
											State_Signal=State_count_stride;
									  else
											State_Signal = State_count_w_colums;
		
		State_count_row: if(OMDC_STATEMACHINE_Flag_Eqcw)
									State_Signal=State_count_stride;
								else
									State_Signal = State_count_w_colums;
	
			
		State_Routine_Stoped: if(OMDC_STATEMACHINE_Start_Routine)
										State_Signal=State_count_w_colums;
									 else
										State_Signal=State_Routine_Stoped;
		
		
		State_waiting_finish: if(!OMDC_STATEMACHINE_Flag_In_Output_Routine)
										State_Signal=State_finish;
									 else
										State_Signal=State_waiting_finish;
										
			
		State_finish: if(OMDC_STATEMACHINE_Routine_Finished_Ok)	
							State_Signal=State_reset;
						  else
							State_Signal=State_finish;
			
			
		default : State_Signal = State_reset;
			
		
	endcase
	
	
end

// Sequential Logic
always @ (posedge OMDC_STATEMACHINE_Clk , negedge OMDC_STATEMACHINE_Reset)
begin
	if (!OMDC_STATEMACHINE_Reset)
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
			OMDC_STATEMACHINE_Routine_Finished_Already=0;
			OMDC_STATEMACHINE_OneDConv_Reset=0;
			OMDC_STATEMACHINE_OneDConv_Reset_Counter_Row=0;
			OMDC_STATEMACHINE_Counter_Eqcw_En=0;
			OMDC_STATEMACHINE_Counter_Eqcw_load1=0;
			OMDC_STATEMACHINE_Counter_Eqcw_Reset=0;
			OMDC_STATEMACHINE_Counter_Eqst_En=0;
			OMDC_STATEMACHINE_Counter_Eqst_load1=0;
			OMDC_STATEMACHINE_Counter_Eqst_Reset=0;
			OMDC_STATEMACHINE_Counter_Crow_En=0;
			OMDC_STATEMACHINE_Counter_Crow_load1=1;
			OMDC_STATEMACHINE_Counter_Crow_Reset=1;
			OMDC_STATEMACHINE_Counter_Eqcif_En=0;
			OMDC_STATEMACHINE_Counter_Eqcif_load1=0;
			OMDC_STATEMACHINE_Counter_Eqcif_Reset=0;
		end
			
		State_count_w_colums:
		
		begin
		
			OMDC_STATEMACHINE_Routine_Finished_Already=0;
			OMDC_STATEMACHINE_OneDConv_Reset=1;
			OMDC_STATEMACHINE_OneDConv_Reset_Counter_Row=1;
			OMDC_STATEMACHINE_Counter_Eqcw_En=1;
			OMDC_STATEMACHINE_Counter_Eqcw_load1=0;
			OMDC_STATEMACHINE_Counter_Eqcw_Reset=1;
			OMDC_STATEMACHINE_Counter_Eqst_En=0;
			OMDC_STATEMACHINE_Counter_Eqst_load1=0;
			OMDC_STATEMACHINE_Counter_Eqst_Reset=1;
			OMDC_STATEMACHINE_Counter_Crow_En=0;
			OMDC_STATEMACHINE_Counter_Crow_load1=0;
			OMDC_STATEMACHINE_Counter_Crow_Reset=1;
			OMDC_STATEMACHINE_Counter_Eqcif_En=1;
			OMDC_STATEMACHINE_Counter_Eqcif_load1=0;
			OMDC_STATEMACHINE_Counter_Eqcif_Reset=1;
	
		end
		
		State_count_stride:
		begin
		
			OMDC_STATEMACHINE_Routine_Finished_Already=0;
			OMDC_STATEMACHINE_OneDConv_Reset=1;
			OMDC_STATEMACHINE_OneDConv_Reset_Counter_Row=1;
			OMDC_STATEMACHINE_Counter_Eqcw_En=0;
			
			
			if(State_Signal == State_count_row || State_Signal==State_reset_count_row )
			begin
				OMDC_STATEMACHINE_Counter_Eqcw_Reset=1;
				OMDC_STATEMACHINE_Counter_Eqcw_load1=1;
				OMDC_STATEMACHINE_Counter_Eqcif_En=0;
				OMDC_STATEMACHINE_Counter_Eqcif_load1=1;
				OMDC_STATEMACHINE_Counter_Eqcif_Reset=1;
			end
			else
			begin
				OMDC_STATEMACHINE_Counter_Eqcw_Reset=0;
				OMDC_STATEMACHINE_Counter_Eqcw_load1=0;	
				OMDC_STATEMACHINE_Counter_Eqcif_En=1;
				OMDC_STATEMACHINE_Counter_Eqcif_load1=0;
				OMDC_STATEMACHINE_Counter_Eqcif_Reset=1;
			end
			
			OMDC_STATEMACHINE_Counter_Eqst_En=1;
			OMDC_STATEMACHINE_Counter_Eqst_load1=0;
			OMDC_STATEMACHINE_Counter_Eqst_Reset=1;
			
			
			if(State_Signal == State_count_row)
			begin
				OMDC_STATEMACHINE_Counter_Crow_En=1;
				OMDC_STATEMACHINE_Counter_Crow_load1=0;
				OMDC_STATEMACHINE_Counter_Crow_Reset=1;
			
			end
			
			else if(State_Signal==State_reset_count_row)
			begin
				OMDC_STATEMACHINE_Counter_Crow_En=0;
				OMDC_STATEMACHINE_Counter_Crow_load1=1;
				OMDC_STATEMACHINE_Counter_Crow_Reset=1;
			end
			
			else
			begin
				OMDC_STATEMACHINE_Counter_Crow_En=0;
				OMDC_STATEMACHINE_Counter_Crow_load1=0;
				OMDC_STATEMACHINE_Counter_Crow_Reset=1;
			end
	
		end
		
		State_count_row:	
		begin
			
			OMDC_STATEMACHINE_Routine_Finished_Already=0;
			OMDC_STATEMACHINE_OneDConv_Reset=1;
			OMDC_STATEMACHINE_OneDConv_Reset_Counter_Row=1;
			OMDC_STATEMACHINE_Counter_Eqcw_En=1;
			OMDC_STATEMACHINE_Counter_Eqcw_load1=0;
			OMDC_STATEMACHINE_Counter_Eqcw_Reset=1;
			OMDC_STATEMACHINE_Counter_Eqst_En=0;
			OMDC_STATEMACHINE_Counter_Eqst_load1=0;
			OMDC_STATEMACHINE_Counter_Eqst_Reset=0;
			OMDC_STATEMACHINE_Counter_Crow_En=0;
			OMDC_STATEMACHINE_Counter_Crow_load1=0;
			OMDC_STATEMACHINE_Counter_Crow_Reset=1;
			OMDC_STATEMACHINE_Counter_Eqcif_En=1;
			OMDC_STATEMACHINE_Counter_Eqcif_load1=0;
			OMDC_STATEMACHINE_Counter_Eqcif_Reset=1;	
		end
			
		State_reset_count_row:
		
		begin
			OMDC_STATEMACHINE_Routine_Finished_Already=0;
			OMDC_STATEMACHINE_OneDConv_Reset=1;
			OMDC_STATEMACHINE_OneDConv_Reset_Counter_Row=0;
			OMDC_STATEMACHINE_Counter_Eqcw_En=1;
			OMDC_STATEMACHINE_Counter_Eqcw_load1=0;
			OMDC_STATEMACHINE_Counter_Eqcw_Reset=1;
			OMDC_STATEMACHINE_Counter_Eqst_En=0;
			OMDC_STATEMACHINE_Counter_Eqst_load1=0;
			OMDC_STATEMACHINE_Counter_Eqst_Reset=0;
			OMDC_STATEMACHINE_Counter_Crow_En=0;
			OMDC_STATEMACHINE_Counter_Crow_load1=0;
			OMDC_STATEMACHINE_Counter_Crow_Reset=1;
			OMDC_STATEMACHINE_Counter_Eqcif_En=1;
			OMDC_STATEMACHINE_Counter_Eqcif_load1=0;
			OMDC_STATEMACHINE_Counter_Eqcif_Reset=1;	
		end
	
		State_Routine_Stoped:	
		begin
			OMDC_STATEMACHINE_Routine_Finished_Already=0;
			OMDC_STATEMACHINE_OneDConv_Reset=1;
			OMDC_STATEMACHINE_OneDConv_Reset_Counter_Row=0;
			OMDC_STATEMACHINE_Counter_Eqcw_En=0;
			OMDC_STATEMACHINE_Counter_Eqcw_load1=0;
			OMDC_STATEMACHINE_Counter_Eqcw_Reset=0;
			OMDC_STATEMACHINE_Counter_Eqst_En=0;
			OMDC_STATEMACHINE_Counter_Eqst_load1=0;
			OMDC_STATEMACHINE_Counter_Eqst_Reset=0;
			OMDC_STATEMACHINE_Counter_Crow_En=0;
			OMDC_STATEMACHINE_Counter_Crow_load1=1;
			OMDC_STATEMACHINE_Counter_Crow_Reset=1;
			OMDC_STATEMACHINE_Counter_Eqcif_En=0;
			OMDC_STATEMACHINE_Counter_Eqcif_load1=0;
			OMDC_STATEMACHINE_Counter_Eqcif_Reset=0;
		end
		
		
		State_waiting_finish:
		begin
		
			OMDC_STATEMACHINE_Routine_Finished_Already=0;
			OMDC_STATEMACHINE_OneDConv_Reset=1;
			OMDC_STATEMACHINE_OneDConv_Reset_Counter_Row=0;
			OMDC_STATEMACHINE_Counter_Eqcw_En=0;
			OMDC_STATEMACHINE_Counter_Eqcw_load1=0;
			OMDC_STATEMACHINE_Counter_Eqcw_Reset=0;
			OMDC_STATEMACHINE_Counter_Eqst_En=0;
			OMDC_STATEMACHINE_Counter_Eqst_load1=0;
			OMDC_STATEMACHINE_Counter_Eqst_Reset=0;
			OMDC_STATEMACHINE_Counter_Crow_En=0;
			OMDC_STATEMACHINE_Counter_Crow_load1=0;
			OMDC_STATEMACHINE_Counter_Crow_Reset=0;
			OMDC_STATEMACHINE_Counter_Eqcif_En=0;
			OMDC_STATEMACHINE_Counter_Eqcif_load1=0;
			OMDC_STATEMACHINE_Counter_Eqcif_Reset=0;
		end
		
		
		State_finish:
		begin
			
			OMDC_STATEMACHINE_Routine_Finished_Already=1;
			OMDC_STATEMACHINE_OneDConv_Reset=0;
			OMDC_STATEMACHINE_OneDConv_Reset_Counter_Row=0;
			OMDC_STATEMACHINE_Counter_Eqcw_En=0;
			OMDC_STATEMACHINE_Counter_Eqcw_load1=0;
			OMDC_STATEMACHINE_Counter_Eqcw_Reset=0;
			OMDC_STATEMACHINE_Counter_Eqst_En=0;
			OMDC_STATEMACHINE_Counter_Eqst_load1=0;
			OMDC_STATEMACHINE_Counter_Eqst_Reset=0;
			OMDC_STATEMACHINE_Counter_Crow_En=0;
			OMDC_STATEMACHINE_Counter_Crow_load1=1;
			OMDC_STATEMACHINE_Counter_Crow_Reset=0;
			OMDC_STATEMACHINE_Counter_Eqcif_En=0;
			OMDC_STATEMACHINE_Counter_Eqcif_load1=0;
			OMDC_STATEMACHINE_Counter_Eqcif_Reset=0;
		
		end
		
		
	default:
	begin
			OMDC_STATEMACHINE_Routine_Finished_Already=0;
			OMDC_STATEMACHINE_OneDConv_Reset=0;
			OMDC_STATEMACHINE_OneDConv_Reset_Counter_Row=0;
			OMDC_STATEMACHINE_Counter_Eqcw_En=0;
			OMDC_STATEMACHINE_Counter_Eqcw_load1=0;
			OMDC_STATEMACHINE_Counter_Eqcw_Reset=0;
			OMDC_STATEMACHINE_Counter_Eqst_En=0;
			OMDC_STATEMACHINE_Counter_Eqst_load1=0;
			OMDC_STATEMACHINE_Counter_Eqst_Reset=0;
			OMDC_STATEMACHINE_Counter_Crow_En=0;
			OMDC_STATEMACHINE_Counter_Crow_load1=1;
			OMDC_STATEMACHINE_Counter_Crow_Reset=1;
			OMDC_STATEMACHINE_Counter_Eqcif_En=0;
			OMDC_STATEMACHINE_Counter_Eqcif_load1=0;
			OMDC_STATEMACHINE_Counter_Eqcif_Reset=0;
	end
	
	endcase
	
end

endmodule
