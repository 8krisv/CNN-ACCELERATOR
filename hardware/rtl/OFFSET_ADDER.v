/*#########################################################################
//# This module update the upper limit and lower limit for Ram read
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

module OFFSET_ADDER #(parameter BITWIDTH=10)(

/////////// INPUTS //////////
OFFSET_ADDER_clk,
OFFSET_ADDER_Sum_En,
OFFSET_ADDER_Reset,
OFFSET_ADDER_offset,

//////////// OUTPUTS //////////
OFFSET_ADDER_Lower_Limit
);

//=======================================================
//  PORT declarations
//=======================================================
input OFFSET_ADDER_clk;
input OFFSET_ADDER_Sum_En;
input OFFSET_ADDER_Reset;
input [BITWIDTH-1:0] OFFSET_ADDER_offset;
output [BITWIDTH-1:0] OFFSET_ADDER_Lower_Limit;

//=======================================================
//  REG/WIRE DECLARATIONS
//=======================================================
reg [BITWIDTH-1:0] Reg_Lower_Limit;


always @(posedge OFFSET_ADDER_clk or negedge OFFSET_ADDER_Reset)
begin

	if(!OFFSET_ADDER_Reset)
		Reg_Lower_Limit<=0;
		
	else if(OFFSET_ADDER_Sum_En)
		Reg_Lower_Limit<=Reg_Lower_Limit+OFFSET_ADDER_offset+1'b1;//Reg_Lower_Limit+OFFSET_ADDER_offset;
end

//============================================================
// COMBINATIONAL OUTPUT LOGIC
//============================================================
assign OFFSET_ADDER_Lower_Limit=Reg_Lower_Limit;

endmodule
