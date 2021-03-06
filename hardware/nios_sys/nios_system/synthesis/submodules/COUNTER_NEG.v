/*#########################################################################
//# Counter triggered by negative edge clk
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

module COUNTER_NEG #(parameter BITWIDTH=10)(

/////////// INPUTS //////////
COUNTER_Clk,
COUNTER_Clr,
COUNTER_En,
COUNTER_Number,

//////////// OUTPUTS //////////
COUNTER_Out,
COUNTER_Eqn_Flag

);

//=======================================================
//  PORT declarations
//=======================================================

input COUNTER_Clk;
input COUNTER_Clr;
input COUNTER_En;
input [BITWIDTH-1:0] COUNTER_Number;
output [BITWIDTH-1:0] COUNTER_Out;
output COUNTER_Eqn_Flag;

//=======================================================
//  REG/WIRE DECLARATIONS
//=======================================================
reg [BITWIDTH-1:0] counter;

//============================================================
// SEQUENTIAL LOGIC
//============================================================

always@(negedge COUNTER_Clk or negedge COUNTER_Clr) // active low asynchronous reset 
begin
		if(!COUNTER_Clr)
			counter<=0;
		else if(COUNTER_En)
			counter<=counter +1'b1;
end


assign COUNTER_Out=counter;
assign COUNTER_Eqn_Flag = counter== COUNTER_Number ? 1'b1 : 1'b0;

endmodule

