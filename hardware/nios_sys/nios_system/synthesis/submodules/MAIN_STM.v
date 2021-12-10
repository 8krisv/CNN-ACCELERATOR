/*#########################################################################
//# Main state machine for hardware accelerator
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

module MAIN_STM(

//////////// INPUTS //////////
MAIN_STM_Clk,
MAIN_STM_Reset,
MAIN_STM_Same_W,
MAIN_STM_Start_Convolution_Routine,
MAIN_STM_Owmc_Loading_Weights_Already,
MAIN_STM_Owmc_Loading_Regs_Already,
MAIN_STM_Ofmi_Loading_Weights_Already,
MAIN_STM_Ofmi_Feeding_Datapath_finished,
MAIN_STM_Ofmi_Writing_Data_Already,
MAIN_STM_Omdc_Routine_Finished_Already,
MAIN_STM_Omdc_New_Channel_Flag,
MAIN_STM_Adder_Routine_Finished_Already,
MAIN_STM_Rbus_Set_Conf_Already,
MAIN_STM_Muxdc_Set_Conf_Already,
MAIN_STM_Usr_Convolution_Routine_Finished_Ok,

//////////// OUTPUTS //////////
MAIN_STM_Owmc_Reset,
MAIN_STM_Owmc_Start_Loading_Weights,
MAIN_STM_Owmc_Start_Loading_Regs,
MAIN_STM_Loading_Weights_Already_Ok,
MAIN_STM_Owmc_Loading_Regs_Already_Ok,
MAIN_STM_Ofmi_Reset,
MAIN_STM_Ofmi_Start_Loading_Weights,
MAIN_STM_Ofmi_Start_Feeding_Datapath,
MAIN_STM_Ofmi_Stop_Feeding_Datapath,
MAIN_STM_Ofmi_Feeding_Datapath_finished_OK,
MAIN_STM_Ofmi_Start_Writing_Data,
MAIN_STM_Ofmi_Writing_Data_Already_Ok,
MAIN_STM_Omdc_Reset,
MAIN_STM_Omdc_Start_Routine,
MAIN_STM_Omdc_Stop_Routine,
MAIN_STM_Omdc_Finish_Routine,
MAIN_STM_Routine_Finished_Ok,
MAIN_STM_Wregs_Reset,
MAIN_STM_Pedc_Start_Routine,
MAIN_STM_Pedc_Stop_Routine,
MAIN_STM_Channel_Controller_Reset,
MAIN_STM_Channel_Controller_Start,
MAIN_STM_Adder_Start_Routine,
MAIN_STM_Adder_Routine_Finished_Already_Ok,
MAIN_STM_Rbus_Reset,
MAIN_STM_Rbus_Set_Conf,
MAIN_STM_Rbus_Set_Conf_Already_Ok,
MAIN_STM_Muxdc_Reset,
MAIN_STM_Muxdc_Set_Conf,
MAIN_STM_Muxdc_Set_Conf_Already_Ok,
MAIN_STM_Convolution_Routine_Finished

);

//=======================================================
//  State declarations
//=======================================================

localparam State_reset			= 0;
localparam State_Start0			= 1;
localparam State_Start1			= 2;
localparam State_Loading0		= 3;
localparam State_Conf0			= 4;
localparam State_Loading1		= 5;
localparam State_Conf1			= 6;
localparam State_Feeding0		= 7;
localparam State_Feeding1		= 8;
localparam State_Stop			= 9;
localparam State_Wait			= 10;
localparam State_Conf2			= 11;
localparam State_Writing0		= 12;
localparam State_Writing1		= 13;
localparam State_Writing2		= 14;
localparam State_Conf3			= 15;
localparam State_Wait_Conf		= 16;

//=======================================================
//  PORT declarations
//=======================================================

input MAIN_STM_Clk;
input MAIN_STM_Reset;
input MAIN_STM_Same_W;
input MAIN_STM_Usr_Convolution_Routine_Finished_Ok;
input MAIN_STM_Start_Convolution_Routine;
input MAIN_STM_Owmc_Loading_Weights_Already;
input MAIN_STM_Owmc_Loading_Regs_Already;
input MAIN_STM_Ofmi_Loading_Weights_Already;
input MAIN_STM_Ofmi_Feeding_Datapath_finished;
input MAIN_STM_Ofmi_Writing_Data_Already;
input MAIN_STM_Omdc_Routine_Finished_Already;
input MAIN_STM_Omdc_New_Channel_Flag;
input MAIN_STM_Adder_Routine_Finished_Already;
input MAIN_STM_Rbus_Set_Conf_Already;
input MAIN_STM_Muxdc_Set_Conf_Already;
output reg MAIN_STM_Owmc_Reset;
output reg MAIN_STM_Owmc_Start_Loading_Weights;
output reg MAIN_STM_Owmc_Start_Loading_Regs;
output reg MAIN_STM_Loading_Weights_Already_Ok;
output reg MAIN_STM_Owmc_Loading_Regs_Already_Ok;
output reg MAIN_STM_Ofmi_Reset;
output reg MAIN_STM_Ofmi_Start_Loading_Weights;
output reg MAIN_STM_Ofmi_Start_Feeding_Datapath;
output reg MAIN_STM_Ofmi_Stop_Feeding_Datapath;
output reg MAIN_STM_Ofmi_Feeding_Datapath_finished_OK;
output reg MAIN_STM_Ofmi_Start_Writing_Data;
output reg MAIN_STM_Ofmi_Writing_Data_Already_Ok;
output reg MAIN_STM_Omdc_Reset;
output reg MAIN_STM_Omdc_Start_Routine;
output reg MAIN_STM_Omdc_Stop_Routine;
output reg MAIN_STM_Omdc_Finish_Routine;
output reg MAIN_STM_Routine_Finished_Ok;
output reg MAIN_STM_Wregs_Reset;
output reg MAIN_STM_Pedc_Start_Routine;
output reg MAIN_STM_Pedc_Stop_Routine;
output reg MAIN_STM_Channel_Controller_Reset;
output reg MAIN_STM_Channel_Controller_Start;
output reg MAIN_STM_Adder_Start_Routine;
output reg MAIN_STM_Adder_Routine_Finished_Already_Ok;
output reg MAIN_STM_Rbus_Reset;
output reg MAIN_STM_Rbus_Set_Conf;
output reg MAIN_STM_Rbus_Set_Conf_Already_Ok;
output reg MAIN_STM_Muxdc_Reset;
output reg MAIN_STM_Muxdc_Set_Conf;
output reg MAIN_STM_Muxdc_Set_Conf_Already_Ok;
output reg MAIN_STM_Convolution_Routine_Finished;

//=======================================================
//  REG/WIRE DECLARATIONS
//=======================================================
reg [5:0] State_Register;
reg [5:0] State_Signal;


// Next state combinational logic
always @(*)
begin
	
	case(State_Register)
		
		State_reset: if(MAIN_STM_Start_Convolution_Routine)
							State_Signal=State_Start0;
						 else
							State_Signal=State_reset;
		
		State_Start0: State_Signal= State_Start1;
		
		State_Start1: State_Signal= State_Loading0;
		
		State_Loading0: if(MAIN_STM_Owmc_Loading_Weights_Already && MAIN_STM_Ofmi_Loading_Weights_Already)
								State_Signal=State_Conf0;
							 else
								State_Signal=State_Loading0;
							
		State_Conf0: State_Signal = State_Loading1;	
			
		State_Loading1: if(MAIN_STM_Owmc_Loading_Regs_Already && MAIN_STM_Rbus_Set_Conf_Already && MAIN_STM_Muxdc_Set_Conf_Already)
								State_Signal=State_Conf1;
							 else
								State_Signal=State_Loading1;
						
		State_Conf1: State_Signal= State_Feeding0;
		
		State_Feeding0: State_Signal= State_Feeding1;
		
		State_Feeding1: if(MAIN_STM_Ofmi_Feeding_Datapath_finished)
								State_Signal = State_Wait;
								
							 else if(MAIN_STM_Omdc_New_Channel_Flag) 
								begin
									if(!MAIN_STM_Same_W)
										State_Signal= State_Stop;
									else
										State_Signal=State_Feeding1;
								end
							
							 else
								State_Signal=State_Feeding1;
								
		State_Stop: if(MAIN_STM_Owmc_Loading_Regs_Already)
							State_Signal=State_Feeding0;
						else		
							State_Signal=State_Stop;
								
		State_Wait: if(MAIN_STM_Omdc_Routine_Finished_Already)
							State_Signal=State_Conf2;
						else
							State_Signal=State_Wait;
				
		State_Conf2: State_Signal= State_Writing0;
		
		
		State_Writing0: State_Signal= State_Writing1;
		
		State_Writing1: State_Signal= State_Writing2;
		
		State_Writing2: if(MAIN_STM_Adder_Routine_Finished_Already)
								State_Signal= State_Conf3;
						    else
								State_Signal=State_Writing2;
		
		
		State_Conf3: State_Signal = State_Wait_Conf;
		
		
		State_Wait_Conf: if(MAIN_STM_Usr_Convolution_Routine_Finished_Ok)
								 State_Signal = State_reset;
								else
									State_Signal=State_Wait_Conf;
		
		default : State_Signal = State_reset;
			
			
	endcase

end


// Sequential Logic
always @ (posedge MAIN_STM_Clk, negedge MAIN_STM_Reset)
begin
		if(!MAIN_STM_Reset)
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
			MAIN_STM_Owmc_Reset =0;
			MAIN_STM_Owmc_Start_Loading_Weights =0;
			MAIN_STM_Owmc_Start_Loading_Regs =0;
			MAIN_STM_Loading_Weights_Already_Ok =0;
			MAIN_STM_Owmc_Loading_Regs_Already_Ok =0;
			MAIN_STM_Ofmi_Reset =0;
			MAIN_STM_Ofmi_Start_Loading_Weights =0;
			MAIN_STM_Ofmi_Start_Feeding_Datapath =0;
			MAIN_STM_Ofmi_Stop_Feeding_Datapath =0;
			MAIN_STM_Ofmi_Feeding_Datapath_finished_OK =0;
			MAIN_STM_Ofmi_Start_Writing_Data =0;
			MAIN_STM_Ofmi_Writing_Data_Already_Ok =0;
			MAIN_STM_Omdc_Reset =0;
			MAIN_STM_Omdc_Start_Routine =0;
			MAIN_STM_Omdc_Stop_Routine =0;
			MAIN_STM_Omdc_Finish_Routine =0;
			MAIN_STM_Routine_Finished_Ok =0;
			MAIN_STM_Wregs_Reset =1;
			MAIN_STM_Pedc_Start_Routine =0;
			MAIN_STM_Pedc_Stop_Routine =0;
			MAIN_STM_Channel_Controller_Reset = 0;
			MAIN_STM_Channel_Controller_Start = 0;
			MAIN_STM_Adder_Start_Routine = 0;
			MAIN_STM_Adder_Routine_Finished_Already_Ok = 0;
			MAIN_STM_Rbus_Reset=0;
			MAIN_STM_Rbus_Set_Conf=0;
			MAIN_STM_Rbus_Set_Conf_Already_Ok=0;
			MAIN_STM_Muxdc_Reset=0;
			MAIN_STM_Muxdc_Set_Conf=0;
			MAIN_STM_Muxdc_Set_Conf_Already_Ok=0;
			MAIN_STM_Convolution_Routine_Finished = 0;

		end
		
		
		State_Start0:
		begin
			MAIN_STM_Owmc_Reset =1;
			MAIN_STM_Owmc_Start_Loading_Weights =0;
			MAIN_STM_Owmc_Start_Loading_Regs =0;
			MAIN_STM_Loading_Weights_Already_Ok =0;
			MAIN_STM_Owmc_Loading_Regs_Already_Ok =0;
			MAIN_STM_Ofmi_Reset =1;
			MAIN_STM_Ofmi_Start_Loading_Weights =1;
			MAIN_STM_Ofmi_Start_Feeding_Datapath =0;
			MAIN_STM_Ofmi_Stop_Feeding_Datapath =0;
			MAIN_STM_Ofmi_Feeding_Datapath_finished_OK =0;
			MAIN_STM_Ofmi_Start_Writing_Data =0;
			MAIN_STM_Ofmi_Writing_Data_Already_Ok =0;
			MAIN_STM_Omdc_Reset =1;
			MAIN_STM_Omdc_Start_Routine =0;
			MAIN_STM_Omdc_Stop_Routine =0;
			MAIN_STM_Omdc_Finish_Routine =0;
			MAIN_STM_Routine_Finished_Ok =0;
			MAIN_STM_Wregs_Reset =1;
			MAIN_STM_Pedc_Start_Routine =0;
			MAIN_STM_Pedc_Stop_Routine =0;
			MAIN_STM_Channel_Controller_Reset=1;
			MAIN_STM_Channel_Controller_Start=1;
			MAIN_STM_Adder_Start_Routine = 0;
			MAIN_STM_Adder_Routine_Finished_Already_Ok = 0;
			MAIN_STM_Rbus_Reset=1;
			MAIN_STM_Rbus_Set_Conf=1;
			MAIN_STM_Rbus_Set_Conf_Already_Ok=0;
			MAIN_STM_Muxdc_Reset=1;
			MAIN_STM_Muxdc_Set_Conf=1;
			MAIN_STM_Muxdc_Set_Conf_Already_Ok=0;
			MAIN_STM_Convolution_Routine_Finished = 0;

		end
		
		
		State_Start1:
		begin
			MAIN_STM_Owmc_Reset =1;
			MAIN_STM_Owmc_Start_Loading_Weights =1;
			MAIN_STM_Owmc_Start_Loading_Regs =0;
			MAIN_STM_Loading_Weights_Already_Ok =0;
			MAIN_STM_Owmc_Loading_Regs_Already_Ok =0;
			MAIN_STM_Ofmi_Reset =1;
			MAIN_STM_Ofmi_Start_Loading_Weights =0;
			MAIN_STM_Ofmi_Start_Feeding_Datapath =0;
			MAIN_STM_Ofmi_Stop_Feeding_Datapath =0;
			MAIN_STM_Ofmi_Feeding_Datapath_finished_OK =0;
			MAIN_STM_Ofmi_Start_Writing_Data =0;
			MAIN_STM_Ofmi_Writing_Data_Already_Ok =0;
			MAIN_STM_Omdc_Reset =1;
			MAIN_STM_Omdc_Start_Routine =0;
			MAIN_STM_Omdc_Stop_Routine =0;
			MAIN_STM_Omdc_Finish_Routine =0;
			MAIN_STM_Routine_Finished_Ok =0;
			MAIN_STM_Wregs_Reset =1;	
			MAIN_STM_Pedc_Start_Routine =0;
			MAIN_STM_Pedc_Stop_Routine =0;
			MAIN_STM_Channel_Controller_Reset=1;
			MAIN_STM_Channel_Controller_Start=0;
			MAIN_STM_Adder_Start_Routine = 0;
			MAIN_STM_Adder_Routine_Finished_Already_Ok = 0;
			MAIN_STM_Rbus_Reset=1;
			MAIN_STM_Rbus_Set_Conf=0;
			MAIN_STM_Rbus_Set_Conf_Already_Ok=0;
			MAIN_STM_Muxdc_Reset=1;
			MAIN_STM_Muxdc_Set_Conf=0;
			MAIN_STM_Muxdc_Set_Conf_Already_Ok=0;
			MAIN_STM_Convolution_Routine_Finished = 0;

		end
		
		State_Loading0:
		begin
			MAIN_STM_Owmc_Reset =1;
			MAIN_STM_Owmc_Start_Loading_Weights =0;
			MAIN_STM_Owmc_Start_Loading_Regs =0;
			MAIN_STM_Loading_Weights_Already_Ok =0;
			MAIN_STM_Owmc_Loading_Regs_Already_Ok =0;
			MAIN_STM_Ofmi_Reset =1;
			MAIN_STM_Ofmi_Start_Loading_Weights =0;
			MAIN_STM_Ofmi_Start_Feeding_Datapath =0;
			MAIN_STM_Ofmi_Stop_Feeding_Datapath =0;
			MAIN_STM_Ofmi_Feeding_Datapath_finished_OK =0;
			MAIN_STM_Ofmi_Start_Writing_Data =0;
			MAIN_STM_Ofmi_Writing_Data_Already_Ok =0;
			MAIN_STM_Omdc_Reset =1;
			MAIN_STM_Omdc_Start_Routine =0;
			MAIN_STM_Omdc_Stop_Routine =0;
			MAIN_STM_Omdc_Finish_Routine =0;
			MAIN_STM_Routine_Finished_Ok =0;
			MAIN_STM_Wregs_Reset =1;	
			MAIN_STM_Pedc_Start_Routine =0;
			MAIN_STM_Pedc_Stop_Routine =0;
			MAIN_STM_Channel_Controller_Reset=1;
			MAIN_STM_Channel_Controller_Start=0;
			MAIN_STM_Adder_Start_Routine = 0;
			MAIN_STM_Adder_Routine_Finished_Already_Ok = 0;
			MAIN_STM_Rbus_Reset=1;
			MAIN_STM_Rbus_Set_Conf=0;
			MAIN_STM_Rbus_Set_Conf_Already_Ok=0;
			MAIN_STM_Muxdc_Reset=1;
			MAIN_STM_Muxdc_Set_Conf=0;
			MAIN_STM_Muxdc_Set_Conf_Already_Ok=0;
			MAIN_STM_Convolution_Routine_Finished = 0;
		
		end
		
		State_Conf0:
		begin
			MAIN_STM_Owmc_Reset =1;
			MAIN_STM_Owmc_Start_Loading_Weights =0;
			MAIN_STM_Owmc_Start_Loading_Regs =0;
			MAIN_STM_Loading_Weights_Already_Ok =1;
			MAIN_STM_Owmc_Loading_Regs_Already_Ok =0;
			MAIN_STM_Ofmi_Reset =1;
			MAIN_STM_Ofmi_Start_Loading_Weights =0;
			MAIN_STM_Ofmi_Start_Feeding_Datapath =0;
			MAIN_STM_Ofmi_Stop_Feeding_Datapath =0;
			MAIN_STM_Ofmi_Feeding_Datapath_finished_OK =0;
			MAIN_STM_Ofmi_Start_Writing_Data =0;
			MAIN_STM_Ofmi_Writing_Data_Already_Ok =0;
			MAIN_STM_Omdc_Reset =1;
			MAIN_STM_Omdc_Start_Routine =0;
			MAIN_STM_Omdc_Stop_Routine =0;
			MAIN_STM_Omdc_Finish_Routine =0;
			MAIN_STM_Routine_Finished_Ok =0;
			MAIN_STM_Wregs_Reset =1;	
			MAIN_STM_Pedc_Start_Routine =0;
			MAIN_STM_Pedc_Stop_Routine =0;
			MAIN_STM_Channel_Controller_Reset=1;
			MAIN_STM_Channel_Controller_Start=0;
			MAIN_STM_Adder_Start_Routine = 0;
			MAIN_STM_Adder_Routine_Finished_Already_Ok = 0;
			MAIN_STM_Rbus_Reset=1;
			MAIN_STM_Rbus_Set_Conf=0;
			MAIN_STM_Rbus_Set_Conf_Already_Ok=0;
			MAIN_STM_Muxdc_Reset=1;
			MAIN_STM_Muxdc_Set_Conf=0;
			MAIN_STM_Muxdc_Set_Conf_Already_Ok=0;
			MAIN_STM_Convolution_Routine_Finished = 0;
		
		end
		
		State_Loading1:
		begin
			MAIN_STM_Owmc_Reset =1;
			MAIN_STM_Owmc_Start_Loading_Weights =0;
			MAIN_STM_Owmc_Start_Loading_Regs =1;
			MAIN_STM_Loading_Weights_Already_Ok =0;
			MAIN_STM_Owmc_Loading_Regs_Already_Ok =0;
			MAIN_STM_Ofmi_Reset =1;
			MAIN_STM_Ofmi_Start_Loading_Weights =0;
			MAIN_STM_Ofmi_Start_Feeding_Datapath =0;
			MAIN_STM_Ofmi_Stop_Feeding_Datapath =0;
			MAIN_STM_Ofmi_Feeding_Datapath_finished_OK =0;
			MAIN_STM_Ofmi_Start_Writing_Data =0;
			MAIN_STM_Ofmi_Writing_Data_Already_Ok =0;
			MAIN_STM_Omdc_Reset =1;
			MAIN_STM_Omdc_Start_Routine =0;
			MAIN_STM_Omdc_Stop_Routine =0;
			MAIN_STM_Omdc_Finish_Routine =0;
			MAIN_STM_Routine_Finished_Ok =0;
			MAIN_STM_Wregs_Reset =1;	
			MAIN_STM_Pedc_Start_Routine =0;
			MAIN_STM_Pedc_Stop_Routine =0;
			MAIN_STM_Channel_Controller_Reset=1;
			MAIN_STM_Channel_Controller_Start=0;
			MAIN_STM_Adder_Start_Routine = 0;
			MAIN_STM_Adder_Routine_Finished_Already_Ok = 0;
			MAIN_STM_Rbus_Reset=1;
			MAIN_STM_Rbus_Set_Conf=0;
			MAIN_STM_Rbus_Set_Conf_Already_Ok=0;
			MAIN_STM_Muxdc_Reset=1;
			MAIN_STM_Muxdc_Set_Conf=0;
			MAIN_STM_Muxdc_Set_Conf_Already_Ok=0;
			MAIN_STM_Convolution_Routine_Finished = 0;
		
		end
		
		
		State_Conf1:
		begin
			MAIN_STM_Owmc_Reset =1;
			MAIN_STM_Owmc_Start_Loading_Weights =0;
			MAIN_STM_Owmc_Start_Loading_Regs =0;
			MAIN_STM_Loading_Weights_Already_Ok =0;
			MAIN_STM_Owmc_Loading_Regs_Already_Ok =1;
			MAIN_STM_Ofmi_Reset =1;
			MAIN_STM_Ofmi_Start_Loading_Weights =0;
			MAIN_STM_Ofmi_Start_Feeding_Datapath =0;
			MAIN_STM_Ofmi_Stop_Feeding_Datapath =0;
			MAIN_STM_Ofmi_Feeding_Datapath_finished_OK =0;
			MAIN_STM_Ofmi_Start_Writing_Data =0;
			MAIN_STM_Ofmi_Writing_Data_Already_Ok =0;
			MAIN_STM_Omdc_Reset =1;
			MAIN_STM_Omdc_Start_Routine =0;
			MAIN_STM_Omdc_Stop_Routine =0;
			MAIN_STM_Omdc_Finish_Routine =0;
			MAIN_STM_Routine_Finished_Ok =0;
			MAIN_STM_Wregs_Reset =1;	
			MAIN_STM_Pedc_Start_Routine =0;
			MAIN_STM_Pedc_Stop_Routine =0;
			MAIN_STM_Channel_Controller_Reset=1;
			MAIN_STM_Channel_Controller_Start=0;
			MAIN_STM_Adder_Start_Routine = 0;
			MAIN_STM_Adder_Routine_Finished_Already_Ok = 0;
			MAIN_STM_Rbus_Reset=1;
			MAIN_STM_Rbus_Set_Conf=0;
			MAIN_STM_Rbus_Set_Conf_Already_Ok=1;
			MAIN_STM_Muxdc_Reset=1;
			MAIN_STM_Muxdc_Set_Conf=0;
			MAIN_STM_Muxdc_Set_Conf_Already_Ok=1;
			MAIN_STM_Convolution_Routine_Finished = 0;
		
		end
		
		State_Feeding0:
		begin
			MAIN_STM_Owmc_Reset =1;
			MAIN_STM_Owmc_Start_Loading_Weights =0;
			MAIN_STM_Owmc_Start_Loading_Regs =0;
			MAIN_STM_Loading_Weights_Already_Ok =0;
			MAIN_STM_Owmc_Loading_Regs_Already_Ok =1;
			MAIN_STM_Ofmi_Reset =1;
			MAIN_STM_Ofmi_Start_Loading_Weights =0;
			MAIN_STM_Ofmi_Start_Feeding_Datapath =0;
			MAIN_STM_Ofmi_Stop_Feeding_Datapath =0;
			MAIN_STM_Ofmi_Feeding_Datapath_finished_OK =0;
			MAIN_STM_Ofmi_Start_Writing_Data =0;
			MAIN_STM_Ofmi_Writing_Data_Already_Ok =0;
			MAIN_STM_Omdc_Reset =1;
			MAIN_STM_Omdc_Start_Routine =1;
			MAIN_STM_Omdc_Stop_Routine =0;
			MAIN_STM_Omdc_Finish_Routine =0;
			MAIN_STM_Routine_Finished_Ok =0;
			MAIN_STM_Wregs_Reset =1;	
			MAIN_STM_Pedc_Start_Routine =0;
			MAIN_STM_Pedc_Stop_Routine =0;
			MAIN_STM_Channel_Controller_Reset=1;
			MAIN_STM_Channel_Controller_Start=0;
			MAIN_STM_Adder_Start_Routine = 0;
			MAIN_STM_Adder_Routine_Finished_Already_Ok = 0;
			MAIN_STM_Rbus_Reset=1;
			MAIN_STM_Rbus_Set_Conf=0;
			MAIN_STM_Rbus_Set_Conf_Already_Ok=0;
			MAIN_STM_Muxdc_Reset=1;
			MAIN_STM_Muxdc_Set_Conf=0;
			MAIN_STM_Muxdc_Set_Conf_Already_Ok=0;
			MAIN_STM_Convolution_Routine_Finished = 0;
		
		end
		
		
		State_Feeding1:
		begin
			MAIN_STM_Owmc_Reset =1;
			MAIN_STM_Owmc_Start_Loading_Weights =0;
			MAIN_STM_Owmc_Start_Loading_Regs =0;
			MAIN_STM_Loading_Weights_Already_Ok =0;
			MAIN_STM_Owmc_Loading_Regs_Already_Ok =0;
			MAIN_STM_Ofmi_Reset =1;
			MAIN_STM_Ofmi_Start_Loading_Weights =0;
			
			if(State_Signal==State_Stop)
				begin
					MAIN_STM_Ofmi_Start_Feeding_Datapath =0;
					MAIN_STM_Ofmi_Stop_Feeding_Datapath =1;
					MAIN_STM_Omdc_Stop_Routine =1;
					MAIN_STM_Pedc_Start_Routine =0;
					MAIN_STM_Pedc_Stop_Routine =1;
				end
			else
				begin
					MAIN_STM_Ofmi_Start_Feeding_Datapath =1;
					MAIN_STM_Ofmi_Stop_Feeding_Datapath =0;
					MAIN_STM_Omdc_Stop_Routine =0;
					MAIN_STM_Pedc_Start_Routine =1;
					MAIN_STM_Pedc_Stop_Routine =0;
				end
			
			MAIN_STM_Ofmi_Feeding_Datapath_finished_OK =0;
			MAIN_STM_Ofmi_Start_Writing_Data =0;
			MAIN_STM_Ofmi_Writing_Data_Already_Ok =0;
			MAIN_STM_Omdc_Reset =1;
			MAIN_STM_Omdc_Start_Routine =0;
			MAIN_STM_Omdc_Finish_Routine =0;
			MAIN_STM_Routine_Finished_Ok =0;
			MAIN_STM_Wregs_Reset =1;	
			MAIN_STM_Channel_Controller_Reset=1;
			MAIN_STM_Channel_Controller_Start=0;
			MAIN_STM_Adder_Start_Routine = 0;
			MAIN_STM_Adder_Routine_Finished_Already_Ok = 0;
			MAIN_STM_Rbus_Reset=1;
			MAIN_STM_Rbus_Set_Conf=0;
			MAIN_STM_Rbus_Set_Conf_Already_Ok=0;
			MAIN_STM_Muxdc_Reset=1;
			MAIN_STM_Muxdc_Set_Conf=0;
			MAIN_STM_Muxdc_Set_Conf_Already_Ok=0;
			MAIN_STM_Convolution_Routine_Finished = 0;
	
		end
		
		State_Stop:
		begin
			MAIN_STM_Owmc_Reset =1;
			MAIN_STM_Owmc_Start_Loading_Weights =0;
			MAIN_STM_Owmc_Start_Loading_Regs =1;
			MAIN_STM_Loading_Weights_Already_Ok =0;
			MAIN_STM_Owmc_Loading_Regs_Already_Ok =0;
			MAIN_STM_Ofmi_Reset =1;
			MAIN_STM_Ofmi_Start_Loading_Weights =0;
			MAIN_STM_Ofmi_Start_Feeding_Datapath =0;
			MAIN_STM_Ofmi_Stop_Feeding_Datapath =1;
			MAIN_STM_Ofmi_Feeding_Datapath_finished_OK =0;
			MAIN_STM_Ofmi_Start_Writing_Data =0;
			MAIN_STM_Ofmi_Writing_Data_Already_Ok =0;
			MAIN_STM_Omdc_Reset =1;
			MAIN_STM_Omdc_Start_Routine =0;
			MAIN_STM_Omdc_Stop_Routine =1;
			MAIN_STM_Omdc_Finish_Routine =0;
			MAIN_STM_Routine_Finished_Ok =0;
			MAIN_STM_Wregs_Reset =1;	
			MAIN_STM_Pedc_Start_Routine =0;
			MAIN_STM_Pedc_Stop_Routine =1;
			MAIN_STM_Channel_Controller_Reset=1;
			MAIN_STM_Channel_Controller_Start=0;
			MAIN_STM_Adder_Start_Routine = 0;
			MAIN_STM_Adder_Routine_Finished_Already_Ok = 0;
			MAIN_STM_Rbus_Reset=1;
			MAIN_STM_Rbus_Set_Conf=0;
			MAIN_STM_Rbus_Set_Conf_Already_Ok=0;
			MAIN_STM_Muxdc_Reset=1;
			MAIN_STM_Muxdc_Set_Conf=0;
			MAIN_STM_Muxdc_Set_Conf_Already_Ok=0;
			MAIN_STM_Convolution_Routine_Finished = 0;
		
		end
		
		
		State_Wait:
		begin
			MAIN_STM_Owmc_Reset =1;
			MAIN_STM_Owmc_Start_Loading_Weights =0;
			MAIN_STM_Owmc_Start_Loading_Regs =0;
			MAIN_STM_Loading_Weights_Already_Ok =0;
			MAIN_STM_Owmc_Loading_Regs_Already_Ok =0;
			MAIN_STM_Ofmi_Reset =1;
			MAIN_STM_Ofmi_Start_Loading_Weights =0;
			MAIN_STM_Ofmi_Start_Feeding_Datapath =0;
			MAIN_STM_Ofmi_Stop_Feeding_Datapath =0;
			MAIN_STM_Ofmi_Feeding_Datapath_finished_OK =0;
			MAIN_STM_Ofmi_Start_Writing_Data =0;
			MAIN_STM_Ofmi_Writing_Data_Already_Ok =0;
			MAIN_STM_Omdc_Reset =1;
			MAIN_STM_Omdc_Start_Routine =0;
			MAIN_STM_Omdc_Stop_Routine =0;
			MAIN_STM_Omdc_Finish_Routine =1;
			MAIN_STM_Routine_Finished_Ok =0;
			MAIN_STM_Wregs_Reset =1;	
			MAIN_STM_Pedc_Start_Routine =0;
			MAIN_STM_Pedc_Stop_Routine =1;
			MAIN_STM_Channel_Controller_Reset=1;
			MAIN_STM_Channel_Controller_Start=0;
			MAIN_STM_Adder_Start_Routine = 0;
			MAIN_STM_Adder_Routine_Finished_Already_Ok = 0;
			MAIN_STM_Rbus_Reset=1;
			MAIN_STM_Rbus_Set_Conf=0;
			MAIN_STM_Rbus_Set_Conf_Already_Ok=0;
			MAIN_STM_Muxdc_Reset=1;
			MAIN_STM_Muxdc_Set_Conf=0;
			MAIN_STM_Muxdc_Set_Conf_Already_Ok=0;
			MAIN_STM_Convolution_Routine_Finished = 0;
		
		end
		
		
		State_Conf2:
		begin
			MAIN_STM_Owmc_Reset =1;
			MAIN_STM_Owmc_Start_Loading_Weights =0;
			MAIN_STM_Owmc_Start_Loading_Regs =0;
			MAIN_STM_Loading_Weights_Already_Ok =0;
			MAIN_STM_Owmc_Loading_Regs_Already_Ok =0;
			MAIN_STM_Ofmi_Reset =1;
			MAIN_STM_Ofmi_Start_Loading_Weights =0;
			MAIN_STM_Ofmi_Start_Feeding_Datapath =0;
			MAIN_STM_Ofmi_Stop_Feeding_Datapath =0;
			MAIN_STM_Ofmi_Feeding_Datapath_finished_OK =1;
			MAIN_STM_Ofmi_Start_Writing_Data =0;
			MAIN_STM_Ofmi_Writing_Data_Already_Ok =0;
			MAIN_STM_Omdc_Reset =1;
			MAIN_STM_Omdc_Start_Routine =0;
			MAIN_STM_Omdc_Stop_Routine =0;
			MAIN_STM_Omdc_Finish_Routine =0;
			MAIN_STM_Routine_Finished_Ok =1;
			MAIN_STM_Wregs_Reset =1;	
			MAIN_STM_Pedc_Start_Routine =0;
			MAIN_STM_Pedc_Stop_Routine =0;
			MAIN_STM_Channel_Controller_Reset=1;
			MAIN_STM_Channel_Controller_Start=0;
			MAIN_STM_Adder_Start_Routine = 0;
			MAIN_STM_Adder_Routine_Finished_Already_Ok = 0;
			MAIN_STM_Rbus_Reset=1;
			MAIN_STM_Rbus_Set_Conf=0;
			MAIN_STM_Rbus_Set_Conf_Already_Ok=0;
			MAIN_STM_Muxdc_Reset=1;
			MAIN_STM_Muxdc_Set_Conf=0;
			MAIN_STM_Muxdc_Set_Conf_Already_Ok=0;
			MAIN_STM_Convolution_Routine_Finished = 0;
			
		end
		
		State_Writing0:
		begin
			MAIN_STM_Owmc_Reset =1;
			MAIN_STM_Owmc_Start_Loading_Weights =0;
			MAIN_STM_Owmc_Start_Loading_Regs =0;
			MAIN_STM_Loading_Weights_Already_Ok =0;
			MAIN_STM_Owmc_Loading_Regs_Already_Ok =0;
			MAIN_STM_Ofmi_Reset =1;
			MAIN_STM_Ofmi_Start_Loading_Weights =0;
			MAIN_STM_Ofmi_Start_Feeding_Datapath =0;
			MAIN_STM_Ofmi_Stop_Feeding_Datapath =0;
			MAIN_STM_Ofmi_Feeding_Datapath_finished_OK =0;
			MAIN_STM_Ofmi_Start_Writing_Data =0;
			MAIN_STM_Ofmi_Writing_Data_Already_Ok =0;
			MAIN_STM_Omdc_Reset =1;
			MAIN_STM_Omdc_Start_Routine =0;
			MAIN_STM_Omdc_Stop_Routine =0;
			MAIN_STM_Omdc_Finish_Routine =0;
			MAIN_STM_Routine_Finished_Ok =0;
			MAIN_STM_Wregs_Reset =1;	
			MAIN_STM_Pedc_Start_Routine =0;
			MAIN_STM_Pedc_Stop_Routine =0;
			MAIN_STM_Channel_Controller_Reset=1;
			MAIN_STM_Channel_Controller_Start=0;
			MAIN_STM_Adder_Start_Routine = 1;
			MAIN_STM_Adder_Routine_Finished_Already_Ok = 0;
			MAIN_STM_Rbus_Reset=1;
			MAIN_STM_Rbus_Set_Conf=0;
			MAIN_STM_Rbus_Set_Conf_Already_Ok=0;
			MAIN_STM_Muxdc_Reset=1;
			MAIN_STM_Muxdc_Set_Conf=0;
			MAIN_STM_Muxdc_Set_Conf_Already_Ok=0;
			MAIN_STM_Convolution_Routine_Finished = 0;
		
		end
		
		State_Writing1:
		begin
			MAIN_STM_Owmc_Reset =1;
			MAIN_STM_Owmc_Start_Loading_Weights =0;
			MAIN_STM_Owmc_Start_Loading_Regs =0;
			MAIN_STM_Loading_Weights_Already_Ok =0;
			MAIN_STM_Owmc_Loading_Regs_Already_Ok =0;
			MAIN_STM_Ofmi_Reset =1;
			MAIN_STM_Ofmi_Start_Loading_Weights =0;
			MAIN_STM_Ofmi_Start_Feeding_Datapath =0;
			MAIN_STM_Ofmi_Stop_Feeding_Datapath =0;
			MAIN_STM_Ofmi_Feeding_Datapath_finished_OK =0;
			MAIN_STM_Ofmi_Start_Writing_Data =0;
			MAIN_STM_Ofmi_Writing_Data_Already_Ok =0;
			MAIN_STM_Omdc_Reset =1;
			MAIN_STM_Omdc_Start_Routine =0;
			MAIN_STM_Omdc_Stop_Routine =0;
			MAIN_STM_Omdc_Finish_Routine =0;
			MAIN_STM_Routine_Finished_Ok =0;
			MAIN_STM_Wregs_Reset =1;	
			MAIN_STM_Pedc_Start_Routine =0;
			MAIN_STM_Pedc_Stop_Routine =0;
			MAIN_STM_Channel_Controller_Reset=1;
			MAIN_STM_Channel_Controller_Start=0;
			MAIN_STM_Adder_Start_Routine = 1;
			MAIN_STM_Adder_Routine_Finished_Already_Ok = 0;
			MAIN_STM_Rbus_Reset=1;
			MAIN_STM_Rbus_Set_Conf=0;
			MAIN_STM_Rbus_Set_Conf_Already_Ok=0;
			MAIN_STM_Muxdc_Reset=1;
			MAIN_STM_Muxdc_Set_Conf=0;
			MAIN_STM_Muxdc_Set_Conf_Already_Ok=0;
			MAIN_STM_Convolution_Routine_Finished = 0;
			
		end
		
		State_Writing2:
		begin
			MAIN_STM_Owmc_Reset =1;
			MAIN_STM_Owmc_Start_Loading_Weights =0;
			MAIN_STM_Owmc_Start_Loading_Regs =0;
			MAIN_STM_Loading_Weights_Already_Ok =0;
			MAIN_STM_Owmc_Loading_Regs_Already_Ok =0;
			MAIN_STM_Ofmi_Reset =1;
			MAIN_STM_Ofmi_Start_Loading_Weights =0;
			MAIN_STM_Ofmi_Start_Feeding_Datapath =0;
			MAIN_STM_Ofmi_Stop_Feeding_Datapath =0;
			MAIN_STM_Ofmi_Feeding_Datapath_finished_OK =0;
			MAIN_STM_Ofmi_Start_Writing_Data =1;
			MAIN_STM_Ofmi_Writing_Data_Already_Ok =0;
			MAIN_STM_Omdc_Reset =1;
			MAIN_STM_Omdc_Start_Routine =0;
			MAIN_STM_Omdc_Stop_Routine =0;
			MAIN_STM_Omdc_Finish_Routine =0;
			MAIN_STM_Routine_Finished_Ok =0;
			MAIN_STM_Wregs_Reset =1;	
			MAIN_STM_Pedc_Start_Routine =0;
			MAIN_STM_Pedc_Stop_Routine =0;
			MAIN_STM_Channel_Controller_Reset=1;
			MAIN_STM_Channel_Controller_Start=0;
			MAIN_STM_Adder_Start_Routine = 1;
			MAIN_STM_Adder_Routine_Finished_Already_Ok = 0;
			MAIN_STM_Rbus_Reset=1;
			MAIN_STM_Rbus_Set_Conf=0;
			MAIN_STM_Rbus_Set_Conf_Already_Ok=0;
			MAIN_STM_Muxdc_Reset=1;
			MAIN_STM_Muxdc_Set_Conf=0;
			MAIN_STM_Muxdc_Set_Conf_Already_Ok=0;
			MAIN_STM_Convolution_Routine_Finished = 0;
			
		end
	
		State_Conf3:
		begin
			MAIN_STM_Owmc_Reset =1;
			MAIN_STM_Owmc_Start_Loading_Weights =0;
			MAIN_STM_Owmc_Start_Loading_Regs =0;
			MAIN_STM_Loading_Weights_Already_Ok =0;
			MAIN_STM_Owmc_Loading_Regs_Already_Ok =0;
			MAIN_STM_Ofmi_Reset =1;
			MAIN_STM_Ofmi_Start_Loading_Weights =0;
			MAIN_STM_Ofmi_Start_Feeding_Datapath =0;
			MAIN_STM_Ofmi_Stop_Feeding_Datapath =0;
			MAIN_STM_Ofmi_Feeding_Datapath_finished_OK =0;
			MAIN_STM_Ofmi_Start_Writing_Data =0;
			MAIN_STM_Ofmi_Writing_Data_Already_Ok =0;
			MAIN_STM_Omdc_Reset =1;
			MAIN_STM_Omdc_Start_Routine =0;
			MAIN_STM_Omdc_Stop_Routine  =0;
			MAIN_STM_Omdc_Finish_Routine =0;
			MAIN_STM_Routine_Finished_Ok =0;
			MAIN_STM_Wregs_Reset =1;	
			MAIN_STM_Pedc_Start_Routine =0;
			MAIN_STM_Pedc_Stop_Routine =0;
			MAIN_STM_Channel_Controller_Reset=1;
			MAIN_STM_Channel_Controller_Start=0;
			MAIN_STM_Adder_Start_Routine = 0;
			MAIN_STM_Adder_Routine_Finished_Already_Ok = 1;
			MAIN_STM_Rbus_Reset=1;
			MAIN_STM_Rbus_Set_Conf=0;
			MAIN_STM_Rbus_Set_Conf_Already_Ok=0;
			MAIN_STM_Muxdc_Reset=1;
			MAIN_STM_Muxdc_Set_Conf=0;
			MAIN_STM_Muxdc_Set_Conf_Already_Ok=0;
			MAIN_STM_Convolution_Routine_Finished = 0;
		
		end
		
		State_Wait_Conf:
		begin
			MAIN_STM_Owmc_Reset =0;
			MAIN_STM_Owmc_Start_Loading_Weights =0;
			MAIN_STM_Owmc_Start_Loading_Regs =0;
			MAIN_STM_Loading_Weights_Already_Ok =0;
			MAIN_STM_Owmc_Loading_Regs_Already_Ok =0;
			MAIN_STM_Ofmi_Reset =0;
			MAIN_STM_Ofmi_Start_Loading_Weights =0;
			MAIN_STM_Ofmi_Start_Feeding_Datapath =0;
			MAIN_STM_Ofmi_Stop_Feeding_Datapath =0;
			MAIN_STM_Ofmi_Feeding_Datapath_finished_OK =0;
			MAIN_STM_Ofmi_Start_Writing_Data =0;
			MAIN_STM_Ofmi_Writing_Data_Already_Ok =0;
			MAIN_STM_Omdc_Reset =0;
			MAIN_STM_Omdc_Start_Routine =0;
			MAIN_STM_Omdc_Stop_Routine =0;
			MAIN_STM_Omdc_Finish_Routine =0;
			MAIN_STM_Routine_Finished_Ok =0;
			MAIN_STM_Wregs_Reset =1;
			MAIN_STM_Pedc_Start_Routine =0;
			MAIN_STM_Pedc_Stop_Routine =0;
			MAIN_STM_Channel_Controller_Reset = 0;
			MAIN_STM_Channel_Controller_Start = 0;
			MAIN_STM_Adder_Start_Routine = 0;
			MAIN_STM_Adder_Routine_Finished_Already_Ok = 0;
			MAIN_STM_Rbus_Reset=1;
			MAIN_STM_Rbus_Set_Conf=0;
			MAIN_STM_Rbus_Set_Conf_Already_Ok=0;
			MAIN_STM_Muxdc_Reset=1;
			MAIN_STM_Muxdc_Set_Conf=0;
			MAIN_STM_Muxdc_Set_Conf_Already_Ok=0;
			MAIN_STM_Convolution_Routine_Finished = 1;
			
		end
		
		default:
		begin
			MAIN_STM_Owmc_Reset =0;
			MAIN_STM_Owmc_Start_Loading_Weights =0;
			MAIN_STM_Owmc_Start_Loading_Regs =0;
			MAIN_STM_Loading_Weights_Already_Ok =0;
			MAIN_STM_Owmc_Loading_Regs_Already_Ok =0;
			MAIN_STM_Ofmi_Reset =0;
			MAIN_STM_Ofmi_Start_Loading_Weights =0;
			MAIN_STM_Ofmi_Start_Feeding_Datapath =0;
			MAIN_STM_Ofmi_Stop_Feeding_Datapath =0;
			MAIN_STM_Ofmi_Feeding_Datapath_finished_OK =0;
			MAIN_STM_Ofmi_Start_Writing_Data =0;
			MAIN_STM_Ofmi_Writing_Data_Already_Ok =0;
			MAIN_STM_Omdc_Reset =0;
			MAIN_STM_Omdc_Start_Routine =0;
			MAIN_STM_Omdc_Stop_Routine =0;
			MAIN_STM_Omdc_Finish_Routine =0;
			MAIN_STM_Routine_Finished_Ok =0;
			MAIN_STM_Wregs_Reset =0;
			MAIN_STM_Pedc_Start_Routine =0;
			MAIN_STM_Pedc_Stop_Routine =0;
			MAIN_STM_Channel_Controller_Reset=0;
			MAIN_STM_Channel_Controller_Start=0;
			MAIN_STM_Adder_Start_Routine = 0;
			MAIN_STM_Adder_Routine_Finished_Already_Ok = 0;
			MAIN_STM_Rbus_Reset=0;
			MAIN_STM_Rbus_Set_Conf=0;
			MAIN_STM_Rbus_Set_Conf_Already_Ok=0;
			MAIN_STM_Muxdc_Reset=0;
			MAIN_STM_Muxdc_Set_Conf=0;
			MAIN_STM_Muxdc_Set_Conf_Already_Ok=0;
			MAIN_STM_Convolution_Routine_Finished = 0;
			
		end
		
	endcase
	
end


endmodule
