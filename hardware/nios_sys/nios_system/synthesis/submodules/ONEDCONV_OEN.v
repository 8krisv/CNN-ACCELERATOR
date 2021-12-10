/*#########################################################################
//# One dimensional convolution module output enable function
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

module ONEDCONV_OEN #(parameter BITWIDTH_OF_COLUMS=11, BITWIDTH_STRIDE=4 )(

/////////// INPUTS //////////
ONEDCONV_OEN_Clk,
ONEDCONV_OEN_Flag_Om_Full,
ONEDCONV_OEN_En,
ONEDCONV_OEN_Clr,
ONEDCONV_OEN_Of_Colums,
ONEDCONV_OEN_Stride,
//////////// OUTPUTS //////////
ONEDCONV_OEN_Wptclr,
ONEDCONV_OEN_Oen,
ONEDCONV_OEN_Flag_Out_Full,
ONEDCONV_OEN_In_Routine

);


//=======================================================
//  PORT declarations
//=======================================================

input ONEDCONV_OEN_Clk;
input ONEDCONV_OEN_Flag_Om_Full;
input ONEDCONV_OEN_En;
input ONEDCONV_OEN_Clr;
input [BITWIDTH_OF_COLUMS-1:0] ONEDCONV_OEN_Of_Colums;
input [BITWIDTH_STRIDE-1:0] ONEDCONV_OEN_Stride;
output ONEDCONV_OEN_Wptclr;
output ONEDCONV_OEN_Oen;
output ONEDCONV_OEN_Flag_Out_Full;
output ONEDCONV_OEN_In_Routine;

//=======================================================
//  REG/WIRE DECLARATIONS
//=======================================================

reg [BITWIDTH_OF_COLUMS-1:0] Oe_counter;
reg [BITWIDTH_STRIDE-1:0] Inner_Str;
reg Start_Rutine;
reg Wptclr;
reg Oe;
reg waitclk;


//============================================================
// COMBINATIONAL LOGIC
//============================================================
//always@(ONEDCONV_OEN_Flag_Om_Full,ONEDCONV_OEN_Clk,ONEDCONV_OEN_Clr)
//begin
// Signal_Reset= ((ONEDCONV_OEN_Flag_Om_Full) & (~ONEDCONV_OEN_Clk)) | ONEDCONV_OEN_Clr; // fundamental para el funcionamiento
//end

//============================================================
// SEQUENTIAL LOGIC 
//============================================================
always @(negedge ONEDCONV_OEN_Clk)
begin
	
	if(!ONEDCONV_OEN_Clr) begin
		Start_Rutine<=0;
		Oe_counter<=0;
		Inner_Str<=0;
		Oe<=0;
		Wptclr<=1;
	end
	
	else
		begin
			if(ONEDCONV_OEN_Flag_Om_Full) begin
				Wptclr<=0;
				Oe<=1;
				Oe_counter<=1;
				Start_Rutine<=1;
			end
			
			else
				begin
					Wptclr<=1;
				end
				
			if (Start_Rutine) begin
				if(Inner_Str==(ONEDCONV_OEN_Stride-1))begin
					Oe<=1;
					Oe_counter<=Oe_counter+1'b1;
					Inner_Str<=0;
				end
				else
					begin
						Inner_Str<=Inner_Str+1'b1;
						Oe<=0;
					end
			end
		end
end



//============================================================
// COMBINATIONAL OUTPUT LOGIC
//============================================================
assign ONEDCONV_OEN_Wptclr=Wptclr;
assign ONEDCONV_OEN_Oen= Oe;
assign ONEDCONV_OEN_Flag_Out_Full= (Oe_counter==ONEDCONV_OEN_Of_Colums) ? 1'b1 : 1'b0;
assign ONEDCONV_OEN_In_Routine=Start_Rutine;

endmodule

