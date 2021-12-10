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

module COUNTER_CH #(parameter BITWIDTH=2)(

/////////// INPUTS //////////
COUNTER_Clk,
COUNTER_Clr,
COUNTER_En,

//////////// OUTPUTS //////////
COUNTER_Out


);


//=======================================================
//  PORT declarations
//=======================================================
input COUNTER_Clk;
input COUNTER_Clr;
input COUNTER_En;
output [BITWIDTH-1:0] COUNTER_Out;

//=======================================================
//  REG/WIRE DECLARATIONS
//=======================================================
reg [BITWIDTH-1:0] counter;


//============================================================
// SEQUENTIAL LOGIC
//============================================================

always@(posedge COUNTER_Clk or negedge COUNTER_Clr) // active low asynchronous reset 
begin
		if(!COUNTER_Clr)
			counter<=0;
		else if(COUNTER_En)
			counter<=counter +1'b1;
end

assign COUNTER_Out=counter;


endmodule

