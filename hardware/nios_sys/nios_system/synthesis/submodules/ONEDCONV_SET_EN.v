/*#########################################################################
//# One dimensional convolution module set enable function
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

module ONEDCONV_SET_EN #(parameter BITWIDTH_OF_COLUMS=11)(

/////////// INPUTS //////////
ONEDCONV_SET_EN_clk,
ONEDCONV_SET_EN_Eqcw,
ONEDCONV_SET_EN_Eqst,
ONEDCONV_SET_EN_En,
ONEDCONV_SET_EN_Clr, 
ONEDCONV_SET_Flag_Out_Full, 
ONEDCONV_SET_EN_Of_Colums,

//////////// OUTPUTS //////////
ONEDCONV_SET_EN_Rptclr,
ONEDCONV_SET_EN_Oen_clr,
ONEDCONV_SET_EN_set_en,
ONEDCONV_SET_EN_Flag_Om_Full

);

//=======================================================
//  PORT declarations
//=======================================================
input ONEDCONV_SET_EN_clk;
input ONEDCONV_SET_EN_Eqcw;
input ONEDCONV_SET_EN_Eqst;
input ONEDCONV_SET_EN_En;
input ONEDCONV_SET_EN_Clr;
input ONEDCONV_SET_Flag_Out_Full;
input [BITWIDTH_OF_COLUMS-1:0] ONEDCONV_SET_EN_Of_Colums;

output ONEDCONV_SET_EN_Rptclr;
output ONEDCONV_SET_EN_Oen_clr;
output ONEDCONV_SET_EN_set_en;
output ONEDCONV_SET_EN_Flag_Om_Full;

//=======================================================
//  REG/WIRE DECLARATIONS
//=======================================================

reg [BITWIDTH_OF_COLUMS-1:0] Set_counter;

reg Set_en;
reg Oe_Clr;
reg Rptclr;

always@(posedge ONEDCONV_SET_EN_clk)
begin

	if(!ONEDCONV_SET_EN_Clr)begin	
		Set_counter<=1'b0;
		Set_en<=1'b0;
		Rptclr<=1'b1;
		Oe_Clr<=1'b1;
	end
	
	else 
		begin
			
			if(ONEDCONV_SET_EN_En)begin
				
				if(ONEDCONV_SET_EN_Eqcw || ONEDCONV_SET_EN_Eqst)begin
					Set_en<=1'b1;
					Set_counter<=Set_counter+1'b1;
				end
				
				else 
					Set_en<=1'b0;
			end

			else
				Set_en<=1'b0;
			
			
			if(ONEDCONV_SET_Flag_Out_Full)begin
				Rptclr<=1'b0;
				Oe_Clr<=1'b0;
			end
			
			else
				begin
					Oe_Clr<=1'b1;
					Rptclr<=1'b1;
				end
				
		end
end



//============================================================
// COMBINATIONAL OUTPUT LOGIC
//============================================================

assign ONEDCONV_SET_EN_Rptclr=Rptclr;
assign ONEDCONV_SET_EN_Oen_clr=Oe_Clr; 
assign ONEDCONV_SET_EN_set_en=Set_en;
assign ONEDCONV_SET_EN_Flag_Om_Full = (Set_counter== ONEDCONV_SET_EN_Of_Colums) ? 1'b1 : 1'b0;



endmodule
