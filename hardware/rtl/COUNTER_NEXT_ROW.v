/*#########################################################################
//# Next row counter for module ONEDCONV
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

module COUNTER_NEXT_ROW #(parameter BITWIDTH_ROW=4, parameter BITWIDTH_IF_ROWS=10, parameter BITWIDTH_STRIDE=4)(


/////////// INPUTS //////////
COUNTER_NEXT_ROW_clk,
COUNTER_NEXT_ROW_Stride,
COUNTER_NEXT_ROW_Offset,
COUNTER_NEXT_ROW_En,
COUNTER_NEXT_ROW_Clr,

//////////// OUTPUTS //////////
COUNTER_NEXT_ROW_Next_Row
);
//=======================================================
//  PORT declarations
//=======================================================
input COUNTER_NEXT_ROW_clk;
input [BITWIDTH_STRIDE-1:0] COUNTER_NEXT_ROW_Stride;
input [BITWIDTH_ROW-1:0] COUNTER_NEXT_ROW_Offset;
input COUNTER_NEXT_ROW_En;
input COUNTER_NEXT_ROW_Clr;
output [BITWIDTH_IF_ROWS-1:0] COUNTER_NEXT_ROW_Next_Row;

//=======================================================
//  REG/WIRE DECLARATIONS
//=======================================================
reg [BITWIDTH_IF_ROWS-1:0] counter;

//============================================================
// SEQUENTIAL LOGIC
//============================================================

always@(posedge COUNTER_NEXT_ROW_clk or negedge COUNTER_NEXT_ROW_Clr) // active low asynchronous reset 
begin
		if(!COUNTER_NEXT_ROW_Clr)
			counter<=0;
		else if(COUNTER_NEXT_ROW_En)
			counter<=counter +COUNTER_NEXT_ROW_Stride;
end

//============================================================
// COMBINATIONAL OUTPUT LOGIC
//============================================================
assign COUNTER_NEXT_ROW_Next_Row=counter+COUNTER_NEXT_ROW_Offset;

endmodule
