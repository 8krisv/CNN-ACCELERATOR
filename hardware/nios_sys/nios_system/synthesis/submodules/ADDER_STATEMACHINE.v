/*#########################################################################
//# modulo Adder Statemachine
//#########################################################################
//#
//# Copyright (C) 2021 Jose Maria Jaramillo Hoyos ACCELERATOR_DATA_OUT
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

module ADDER_STATEMACHINE (

//////////// INPUTS //////////
ADDER_STATEMACHINE_Clk,
ADDER_STATEMACHINE_Start_Routine,
ADDER_STATEMACHINE_Counter_Flag,
ADDER_STATEMACHINE_Routine_Finished_Already_Ok,

//////////// OUTPUTS //////////
ADDER_STATEMACHINE_Mems_Re,
ADDER_STATEMACHINE_Counter_Clr,
ADDER_STATEMACHINE_Counter_En,
ADDER_STATEMACHINE_Routine_Finished_Already
);

//=======================================================
//  State declarations
//=======================================================

localparam State_reset = 0;
localparam State_started = 1;
localparam State_wait_conf = 2;

//=======================================================
//  PORT declarations
//=======================================================

input ADDER_STATEMACHINE_Clk;
input ADDER_STATEMACHINE_Start_Routine;
input ADDER_STATEMACHINE_Counter_Flag;
input ADDER_STATEMACHINE_Routine_Finished_Already_Ok;
output reg ADDER_STATEMACHINE_Mems_Re;
output reg ADDER_STATEMACHINE_Counter_Clr;
output reg ADDER_STATEMACHINE_Counter_En;
output reg ADDER_STATEMACHINE_Routine_Finished_Already;

//=======================================================
//  REG/WIRE DECLARATIONS
//=======================================================
reg [2:0] State_Register;
reg [2:0] State_Signal;

// Next state combinational logic
always @(*)
begin
	case (State_Register)
	
	State_reset: if (ADDER_STATEMACHINE_Start_Routine)
							State_Signal=State_started;
					 else
							State_Signal=State_reset;
	
	State_started: if (ADDER_STATEMACHINE_Counter_Flag)
							State_Signal=State_wait_conf;
						else
							State_Signal=State_started;
	
	State_wait_conf: if(ADDER_STATEMACHINE_Routine_Finished_Already_Ok)
								State_Signal=State_reset;
						  else
								State_Signal=State_wait_conf;
								
								
	
	default: State_Signal = State_reset;
	
	endcase

end


// Sequential Logic

always @ (posedge ADDER_STATEMACHINE_Clk )
begin
		State_Register <= State_Signal;
end


// COMBINATIONAL OUTPUT LOGIC
always @ (*)
begin
	
	case(State_Register)
		
		State_reset:
		begin
			ADDER_STATEMACHINE_Mems_Re =0;
			ADDER_STATEMACHINE_Counter_Clr =0;
			ADDER_STATEMACHINE_Counter_En = 0;
			ADDER_STATEMACHINE_Routine_Finished_Already = 0;
		end
		
		State_started:
		begin
			ADDER_STATEMACHINE_Mems_Re =1;
			ADDER_STATEMACHINE_Counter_Clr =1;
			ADDER_STATEMACHINE_Counter_En = 1;
			ADDER_STATEMACHINE_Routine_Finished_Already = 0;
		end
		
		State_wait_conf:
		begin
			ADDER_STATEMACHINE_Mems_Re =0;
			ADDER_STATEMACHINE_Counter_Clr =0;
			ADDER_STATEMACHINE_Counter_En = 0;
			ADDER_STATEMACHINE_Routine_Finished_Already = 1;
		end
		
	endcase

end



endmodule

