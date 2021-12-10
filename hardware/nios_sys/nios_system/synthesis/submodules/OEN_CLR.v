/*#########################################################################
//# Module for control the clear signal of the output enable function
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

module OEN_CLR(
/////////// INPUTS //////////
OEN_CLR_Clk,
OEN_CLR_Flag_Out_Full,
//////////// OUTPUTS //////////
OEN_CLR_Clr,
OEN_CLR_Rptclr
);

//=======================================================
//  PORT declarations
//=======================================================
input OEN_CLR_Clk;
input OEN_CLR_Flag_Out_Full;
output OEN_CLR_Clr;
output OEN_CLR_Rptclr;
//=======================================================
//  REG/WIRE DECLARATIONS
//=======================================================
reg Oe_Clr;
reg WaitClk;
reg Rptclr;

//============================================================
// SEQUENTIAL LOGIC 
//============================================================

always@(posedge OEN_CLR_Clk )
begin
	if(OEN_CLR_Flag_Out_Full)begin
			WaitClk<=1;
			Rptclr<=0;
	end
			
	else
		begin
			Oe_Clr<=1;
			Rptclr<=1;
			WaitClk<=0;
		end
				
	if(WaitClk)
			Oe_Clr<=0;
end

//============================================================
// COMBINATIONAL OUTPUT LOGIC
//============================================================
//assign OEN_CLR_Clr = OEN_CLR_Clk == 1'b0 ? (OEN_CLR_Flag_Om_Full | OEN_CLR_SetEn_Oen_Clr) : OEN_CLR_SetEn_Oen_Clr ;

assign OEN_CLR_Clr = Oe_Clr;
assign OEN_CLR_Rptclr = Rptclr;

endmodule
