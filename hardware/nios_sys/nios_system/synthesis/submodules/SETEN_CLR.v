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

module SETEN_CLR(

SETEN_CLR_Clk,
SETEN_CLR_Flag_Om_Full,
SETEN_CLR_Clr,
SETEN_CLR_Wptclr
);

//=======================================================
//  PORT declarations
//=======================================================

input SETEN_CLR_Clk;
input SETEN_CLR_Flag_Om_Full;
output SETEN_CLR_Clr;
output SETEN_CLR_Wptclr;

//=======================================================
//  REG/WIRE DECLARATIONS
//=======================================================
reg Wptclr;
reg SetEn_Clr;

//============================================================
// SEQUENTIAL LOGIC 
//============================================================

always @(negedge SETEN_CLR_Clk)
begin

	if(SETEN_CLR_Flag_Om_Full)
		begin
			SetEn_Clr<=0;
			Wptclr<=0;
		end
	
	else
		begin
			Wptclr<=1;
			SetEn_Clr<=1;
		end
end

//============================================================
// COMBINATIONAL OUTPUT LOGIC
//============================================================
assign SETEN_CLR_Wptclr=Wptclr;
assign SETEN_CLR_Clr=SetEn_Clr;

endmodule



