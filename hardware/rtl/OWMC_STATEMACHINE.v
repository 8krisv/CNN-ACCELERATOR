/*#########################################################################
//# On-chip weight memory controller state machine
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

module OWMC_STATEMACHINE(

//////////// INPUTS //////////
OWMC_STATEMACHINE_Clk,
OWMC_STATEMACHINE_Reset,
OWMC_STATEMACHINE_Start_Loading_Weights,
OWMC_STATEMACHINE_Start_Loading_Regs,
OWMC_STATEMACHINE_Loading_Weights_Already_Ok,
OWMC_STATEMACHINE_Loading_Regs_Already_Ok,
OWMC_STATEMACHINE_Counter_Ram_Finish_Already,
OWMC_STATEMACHINE_Counter_Dmux_Finish_Already,
//////////// OUTPUTS //////////
OWMC_STATEMACHINE_Loading_Weights_Already,
OWMC_STATEMACHINE_Loading_Regs_Already,
OWMC_STATEMACHINE_Counter_Dmux_En,
OWMC_STATEMACHINE_Counter_Dmux_Reset,
OWMC_STATEMACHINE_Counter_Ram_En,
OWMC_STATEMACHINE_Counter_Ram_Reset,
OWMC_STATEMACHINE_Counter_Ram_Input_Sel,
OWMC_STATEMACHINE_Offset_Adder_Reset,
OWMC_STATEMACHINE_Offset_Adder_Sum_En,
OWMC_STATEMACHINE_Muxes_en,
OWMC_STATEMACHINE_Ram_Oe,
OWMC_STATEMACHINE_Ram_We

);


//=======================================================
//  State declarations
//=======================================================
localparam State_reset							=0;
localparam State_loading_weights				=1;
localparam State_wait_confirmation0       =2;
localparam State_loading_weights_regs		=3;
localparam State_adder_en						=4;
localparam State_wait_confirmation1			=5;
localparam State_Started						=6;

//=======================================================
//  PORT declarations
//=======================================================
input OWMC_STATEMACHINE_Clk;
input OWMC_STATEMACHINE_Reset;
input OWMC_STATEMACHINE_Start_Loading_Weights;
input OWMC_STATEMACHINE_Start_Loading_Regs;
input OWMC_STATEMACHINE_Loading_Weights_Already_Ok;
input OWMC_STATEMACHINE_Loading_Regs_Already_Ok;
input OWMC_STATEMACHINE_Counter_Ram_Finish_Already;
input OWMC_STATEMACHINE_Counter_Dmux_Finish_Already;
output reg OWMC_STATEMACHINE_Loading_Weights_Already;
output reg OWMC_STATEMACHINE_Loading_Regs_Already;
output reg OWMC_STATEMACHINE_Counter_Dmux_En;
output reg OWMC_STATEMACHINE_Counter_Dmux_Reset;
output reg OWMC_STATEMACHINE_Counter_Ram_En;
output reg OWMC_STATEMACHINE_Counter_Ram_Reset;
output reg OWMC_STATEMACHINE_Counter_Ram_Input_Sel;
output reg OWMC_STATEMACHINE_Offset_Adder_Reset;
output reg OWMC_STATEMACHINE_Offset_Adder_Sum_En;
output reg OWMC_STATEMACHINE_Muxes_en;
output reg OWMC_STATEMACHINE_Ram_Oe;
output reg OWMC_STATEMACHINE_Ram_We;

//=======================================================
//  REG/WIRE declarations
//=======================================================
reg [2:0] State_Register;
reg [2:0] State_Signal;

// Next state combinational logic
always @(*)
begin
	case (State_Register)
		
		State_reset: if(OWMC_STATEMACHINE_Start_Loading_Weights)
								State_Signal=State_loading_weights;
						 else if(OWMC_STATEMACHINE_Start_Loading_Regs)
								State_Signal=State_loading_weights_regs;
						 else
								State_Signal=State_reset;
		
		State_loading_weights: if(OWMC_STATEMACHINE_Counter_Ram_Finish_Already)
											State_Signal=State_wait_confirmation0;
									  else
											State_Signal=State_loading_weights;
											
										
		State_wait_confirmation0: if(OWMC_STATEMACHINE_Loading_Weights_Already_Ok)
												State_Signal=State_Started;
										  else
												State_Signal=State_wait_confirmation0;
												
		
		State_loading_weights_regs: if(OWMC_STATEMACHINE_Counter_Ram_Finish_Already)
													State_Signal=State_adder_en;
											 else	
													State_Signal=State_loading_weights_regs;
													
		State_adder_en:State_Signal=State_wait_confirmation1;
		
		
		State_wait_confirmation1: if(OWMC_STATEMACHINE_Loading_Regs_Already_Ok)
												State_Signal=State_Started;
										  else
												State_Signal=State_wait_confirmation1;
		
		State_Started: if(OWMC_STATEMACHINE_Start_Loading_Regs)
								State_Signal=State_loading_weights_regs;
							else if(!OWMC_STATEMACHINE_Reset)
								State_Signal=State_reset;
							else
								State_Signal=State_Started;
								
		default : State_Signal = State_reset;
	endcase
end

// Sequential Logic
always @ (negedge OWMC_STATEMACHINE_Clk , negedge OWMC_STATEMACHINE_Reset)
begin
	if (!OWMC_STATEMACHINE_Reset)
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
			OWMC_STATEMACHINE_Loading_Weights_Already = 0;
			OWMC_STATEMACHINE_Loading_Regs_Already = 0;
			OWMC_STATEMACHINE_Counter_Dmux_En=0;
			OWMC_STATEMACHINE_Counter_Dmux_Reset=0;
			OWMC_STATEMACHINE_Counter_Ram_En=0;
			OWMC_STATEMACHINE_Counter_Ram_Reset=0;
			OWMC_STATEMACHINE_Counter_Ram_Input_Sel=0;
			OWMC_STATEMACHINE_Offset_Adder_Reset=0;
			OWMC_STATEMACHINE_Offset_Adder_Sum_En=0;
			OWMC_STATEMACHINE_Muxes_en=0;
			OWMC_STATEMACHINE_Ram_Oe = 0;
			OWMC_STATEMACHINE_Ram_We = 0;
		end
		
		State_loading_weights:
		begin
			OWMC_STATEMACHINE_Loading_Weights_Already = 0;
			OWMC_STATEMACHINE_Loading_Regs_Already = 0;		
			OWMC_STATEMACHINE_Counter_Dmux_En=0;
			OWMC_STATEMACHINE_Counter_Dmux_Reset=0;
			OWMC_STATEMACHINE_Counter_Ram_En=1;
			OWMC_STATEMACHINE_Counter_Ram_Reset=1;
			OWMC_STATEMACHINE_Counter_Ram_Input_Sel=0;
			OWMC_STATEMACHINE_Offset_Adder_Reset=0;
			OWMC_STATEMACHINE_Offset_Adder_Sum_En=0;
			OWMC_STATEMACHINE_Muxes_en=0;
			OWMC_STATEMACHINE_Ram_Oe = 0;
			OWMC_STATEMACHINE_Ram_We = 1;
		end
			
		State_wait_confirmation0:
		begin
			OWMC_STATEMACHINE_Loading_Weights_Already = 1;
			OWMC_STATEMACHINE_Loading_Regs_Already = 0;
			OWMC_STATEMACHINE_Counter_Dmux_En=0;
			OWMC_STATEMACHINE_Counter_Dmux_Reset=0;
			OWMC_STATEMACHINE_Counter_Ram_En=0;
			OWMC_STATEMACHINE_Counter_Ram_Reset=0;
			OWMC_STATEMACHINE_Counter_Ram_Input_Sel=0;
			OWMC_STATEMACHINE_Offset_Adder_Reset=0;
			OWMC_STATEMACHINE_Offset_Adder_Sum_En=0;
			OWMC_STATEMACHINE_Muxes_en=0;
			OWMC_STATEMACHINE_Ram_Oe = 0;
			OWMC_STATEMACHINE_Ram_We = 0;
		end
			
		State_loading_weights_regs:
		begin
			OWMC_STATEMACHINE_Loading_Weights_Already = 0;
			OWMC_STATEMACHINE_Loading_Regs_Already = 0;
			OWMC_STATEMACHINE_Counter_Dmux_En=1;
			OWMC_STATEMACHINE_Counter_Dmux_Reset=1;
			OWMC_STATEMACHINE_Counter_Ram_En=1;
			OWMC_STATEMACHINE_Counter_Ram_Reset=1;
			OWMC_STATEMACHINE_Counter_Ram_Input_Sel=1;
			OWMC_STATEMACHINE_Offset_Adder_Reset=1;
			OWMC_STATEMACHINE_Offset_Adder_Sum_En=0;
			OWMC_STATEMACHINE_Muxes_en=1;
			OWMC_STATEMACHINE_Ram_Oe = 1;
			OWMC_STATEMACHINE_Ram_We = 0;
		end
		
		
		State_adder_en:
		begin
			OWMC_STATEMACHINE_Loading_Weights_Already = 0;
			OWMC_STATEMACHINE_Loading_Regs_Already = 0;
			OWMC_STATEMACHINE_Counter_Dmux_En=0;
			OWMC_STATEMACHINE_Counter_Dmux_Reset=0;
			OWMC_STATEMACHINE_Counter_Ram_En=0;
			OWMC_STATEMACHINE_Counter_Ram_Reset=0;
			OWMC_STATEMACHINE_Counter_Ram_Input_Sel=1;
			OWMC_STATEMACHINE_Offset_Adder_Reset=1;
			OWMC_STATEMACHINE_Offset_Adder_Sum_En=1;
			OWMC_STATEMACHINE_Muxes_en=0;
			OWMC_STATEMACHINE_Ram_Oe = 0;
			OWMC_STATEMACHINE_Ram_We = 0;
		end
		
		
		State_wait_confirmation1:
		begin
			OWMC_STATEMACHINE_Loading_Weights_Already = 0;
			OWMC_STATEMACHINE_Loading_Regs_Already = 1;
			OWMC_STATEMACHINE_Counter_Dmux_En=0;
			OWMC_STATEMACHINE_Counter_Dmux_Reset=0;
			OWMC_STATEMACHINE_Counter_Ram_En=0;
			OWMC_STATEMACHINE_Counter_Ram_Reset=0;
			OWMC_STATEMACHINE_Counter_Ram_Input_Sel=1;
			OWMC_STATEMACHINE_Offset_Adder_Reset=1;
			OWMC_STATEMACHINE_Offset_Adder_Sum_En=0;
			OWMC_STATEMACHINE_Muxes_en=0;
			OWMC_STATEMACHINE_Ram_Oe = 0;
			OWMC_STATEMACHINE_Ram_We = 0;
		end
		
		
		State_Started:
		begin
			OWMC_STATEMACHINE_Loading_Weights_Already = 0;
			OWMC_STATEMACHINE_Loading_Regs_Already = 0;
			OWMC_STATEMACHINE_Counter_Dmux_En=0;
			OWMC_STATEMACHINE_Counter_Dmux_Reset=0;
			OWMC_STATEMACHINE_Counter_Ram_En=0;
			OWMC_STATEMACHINE_Counter_Ram_Reset=0;
			OWMC_STATEMACHINE_Counter_Ram_Input_Sel=1;
			OWMC_STATEMACHINE_Offset_Adder_Reset=1;
			OWMC_STATEMACHINE_Offset_Adder_Sum_En=0;
			OWMC_STATEMACHINE_Muxes_en=0;
			OWMC_STATEMACHINE_Ram_Oe = 0;
			OWMC_STATEMACHINE_Ram_We = 0;
		end
		
		default:
		begin
			OWMC_STATEMACHINE_Loading_Weights_Already = 0;
			OWMC_STATEMACHINE_Loading_Regs_Already = 0;
			OWMC_STATEMACHINE_Counter_Dmux_En=0;
			OWMC_STATEMACHINE_Counter_Dmux_Reset=0;
			OWMC_STATEMACHINE_Counter_Ram_En=0;
			OWMC_STATEMACHINE_Counter_Ram_Reset=0;
			OWMC_STATEMACHINE_Counter_Ram_Input_Sel=0;
			OWMC_STATEMACHINE_Offset_Adder_Reset=0;
			OWMC_STATEMACHINE_Offset_Adder_Sum_En=0;
			OWMC_STATEMACHINE_Muxes_en=0;
			OWMC_STATEMACHINE_Ram_Oe = 0;
			OWMC_STATEMACHINE_Ram_We = 0;
		end
	
	endcase

end


endmodule
