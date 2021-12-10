/*#########################################################################
//# modulo Adder 
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

module ADDER #(parameter MEM_OUT_DATA_WIDTH = 16, BITWIDTH_MAX_IF_SIZE= 22, BITWIDTH_DATA_OUT= 32, BITWIDTH_IF_CHANNELS= 3)(

//////////// INPUTS //////////
ADDER_Clk,
ADDER_Start_Routine,
ADDER_Routine_Finished_Already_Ok,
ADDER_If_Channels,
ADDER_Of_Size, /*output feature size -1*/
ADDER_Out_Mem1,
ADDER_Out_Mem2,
ADDER_Out_Mem3,

//////////// OUTPUTS //////////

ADDER_Out,
ADDER_Routine_Finished_Already,
ADDER_Channel_Mems_Re

);

//=======================================================
//  PORT declarations
//=======================================================
input ADDER_Clk;
input ADDER_Start_Routine;
input ADDER_Routine_Finished_Already_Ok;
input [BITWIDTH_IF_CHANNELS-1:0] ADDER_If_Channels;
input [BITWIDTH_MAX_IF_SIZE-1:0] ADDER_Of_Size;
input [MEM_OUT_DATA_WIDTH-1:0] ADDER_Out_Mem1;
input [MEM_OUT_DATA_WIDTH-1:0] ADDER_Out_Mem2;
input [MEM_OUT_DATA_WIDTH-1:0] ADDER_Out_Mem3;

output signed[BITWIDTH_DATA_OUT-1:0] ADDER_Out;
output ADDER_Routine_Finished_Already;
output ADDER_Channel_Mems_Re;

//=======================================================
//  REG/WIRE declarations
//=======================================================

wire Simple_Counter_Eqn_Flag;
wire Adder_Statemachine_Counter_Clr;
wire Adder_Statemachine_Counter_En;
wire Adder_Statemachine_Counter_Load;

reg signed[BITWIDTH_DATA_OUT-1:0] Adder_out;
wire [BITWIDTH_MAX_IF_SIZE-1:0] Simple_Counter_Out;

//=======================================================
//  Structural coding 
//=======================================================

SIMPLE_COUNTER #(.BITWIDTH(BITWIDTH_MAX_IF_SIZE)) Simple_Counter (

//////////// INPUTS //////////
.COUNTER_Clk(ADDER_Clk),
.COUNTER_Clr(Adder_Statemachine_Counter_Clr),
.COUNTER_En(Adder_Statemachine_Counter_En),
.COUNTER_Number(ADDER_Of_Size),
//////////// OUTPUTS //////////

.COUNTER_Out(Simple_Counter_Out),
.COUNTER_Eqn_Flag(Simple_Counter_Eqn_Flag)
);




ADDER_STATEMACHINE Adder_Statemachine(

//////////// INPUTS //////////
.ADDER_STATEMACHINE_Clk(ADDER_Clk),
.ADDER_STATEMACHINE_Start_Routine(ADDER_Start_Routine),
.ADDER_STATEMACHINE_Counter_Flag(Simple_Counter_Eqn_Flag),
.ADDER_STATEMACHINE_Routine_Finished_Already_Ok(ADDER_Routine_Finished_Already_Ok),

//////////// OUTPUTS //////////
.ADDER_STATEMACHINE_Mems_Re(ADDER_Channel_Mems_Re),
.ADDER_STATEMACHINE_Counter_Clr(Adder_Statemachine_Counter_Clr),
.ADDER_STATEMACHINE_Counter_En(Adder_Statemachine_Counter_En),
.ADDER_STATEMACHINE_Routine_Finished_Already(ADDER_Routine_Finished_Already)

);


//============================================================
// SEQUENTIAL LOGIC 
//===========================================================

always@(posedge ADDER_Clk)
begin
	if(Adder_Statemachine_Counter_En)
	begin
		if(ADDER_If_Channels == 2'd1)
			Adder_out<= ADDER_Out_Mem1;
		else if (ADDER_If_Channels == 2'd2)
			Adder_out<= ADDER_Out_Mem1 + ADDER_Out_Mem2;
		else if (ADDER_If_Channels == 2'd3)
			Adder_out<= ADDER_Out_Mem1 + ADDER_Out_Mem2 + ADDER_Out_Mem3;
	end
	else
		Adder_out<=16'b0;
end


assign ADDER_Out= Adder_out;

endmodule
