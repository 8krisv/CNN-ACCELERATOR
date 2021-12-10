/*#########################################################################
//# Counter stride clear
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

module STRIDE_CLEAR(

/////////// INPUTS //////////
STRIDE_CLEAR_Clk,
STRIDE_CLEAR_Eqst_Flag,
//////////// OUTPUTS //////////
STRIDE_CLEAR_Counter_Eqst_Clr
);


//=======================================================
//  PORT declarations
//=======================================================
input STRIDE_CLEAR_Clk;
input STRIDE_CLEAR_Eqst_Flag;
output  STRIDE_CLEAR_Counter_Eqst_Clr;


//=======================================================
//  REG/WIRE DECLARATIONS
//=======================================================
reg clear;


always@(STRIDE_CLEAR_Clk)
begin

	if(STRIDE_CLEAR_Clk)
	begin
		if(STRIDE_CLEAR_Eqst_Flag)
			clear=1;
		else
			clear=0;
	end
	
	else
	begin
		clear=0;
	end
end




assign STRIDE_CLEAR_Counter_Eqst_Clr=clear;


endmodule
