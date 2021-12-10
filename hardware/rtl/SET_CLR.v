/*#########################################################################
//# Module for control the clear signal of the set enable function
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

module SET_CLR(

input SET_CLR_Clk,
input SET_CLR_Flag_Om_Full,
output SET_CLR_Clr

);

//=======================================================
//  REG/WIRE DECLARATIONS
//=======================================================
reg SetEn_Clr;

//============================================================
// SEQUENTIAL LOGIC 
//============================================================
always @(negedge SET_CLR_Clk )
begin
	if(SET_CLR_Flag_Om_Full)
		SetEn_Clr<=1'b0;
	else
		SetEn_Clr<=1'b1;

end


//============================================================
// COMBINATIONAL OUTPUT LOGIC
//============================================================

assign SET_CLR_Clr=SetEn_Clr;

endmodule

