/*#########################################################################
//# Counter with offset and positive edge clock activation
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

module COUNTER_OFFSET_POS #(parameter BITWIDTH=10) (

/////////// INPUTS //////////
COUNTER_OFFSET_Clk,
COUNTER_OFFSET_Clr,
COUNTER_OFFSET_En,
COUNTER_OFFSET_Number,
COUNTER_OFFSET_offset,

//////////// OUTPUTS //////////
COUNTER_OFFSET_Out,
COUNTER_OFFSET_Eqn_Flag
);


//=======================================================
//  PORT declarations
//=======================================================

input COUNTER_OFFSET_Clk;
input COUNTER_OFFSET_Clr;
input COUNTER_OFFSET_En;
input [BITWIDTH-1:0] COUNTER_OFFSET_Number;
input [BITWIDTH-1:0] COUNTER_OFFSET_offset;
output [BITWIDTH-1:0] COUNTER_OFFSET_Out;
output COUNTER_OFFSET_Eqn_Flag;


//=======================================================
//  REG/WIRE DECLARATIONS
//=======================================================
reg [BITWIDTH-1:0] counter;

//============================================================
// SEQUENTIAL LOGIC
//============================================================

always@(posedge COUNTER_OFFSET_Clk or negedge COUNTER_OFFSET_Clr) // active low asynchronous reset 
begin
		if(!COUNTER_OFFSET_Clr)
			counter<=0;
		else if(COUNTER_OFFSET_En)
			counter<=counter +4'b1;
end


//============================================================
// COMBINATIONAL OUTPUT LOGIC
//============================================================

assign COUNTER_OFFSET_Out=counter+COUNTER_OFFSET_offset;
assign COUNTER_OFFSET_Eqn_Flag = counter== COUNTER_OFFSET_Number ? 1'b1 : 1'b0;


endmodule



