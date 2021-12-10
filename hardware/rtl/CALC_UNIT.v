/*#########################################################################
//# Calc unit
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

module CALC_UNIT #(parameter BITWIDTH_MAX_IF_SIZE= 22, BITWIDTH_MAX_W_SIZE=9, BITWIDTH_IF_ROWS=10, BITWIDTH_IF_COLUMS=11, BITWIDTH_IF_CHANNELS=2, BITWIDTH_W_ROWS=4, BITWIDTH_W_COLUMS=4, BITWIDTH_STRIDE=4 )(

//////////// INPUTS //////////
CALC_UNIT_If_Rows,
CALC_UNIT_If_Colums,
CALC_UNIT_If_Channels,
CALC_UNIT_Of_Rows,
CALC_UNIT_Of_Colums,
CALC_UNIT_W_Rows,
CALC_UNIT_W_Colums,
CALC_UNIT_W_Channels,

//////////// OUTPUTS //////////
CALC_UNIT_W_Size_1,
CALC_UNIT_If_Size_1,
CALC_UNIT_Of_Size_1,
CALC_UNIT_W_ROXCL_1,
CALC_UNIT_W_Colums_1

);


//=======================================================
//  Parameter declarations
//=======================================================

input [BITWIDTH_IF_ROWS-1:0] CALC_UNIT_If_Rows;
input [BITWIDTH_IF_COLUMS-1:0] CALC_UNIT_If_Colums;
input [BITWIDTH_IF_CHANNELS-1:0] CALC_UNIT_If_Channels;
input [BITWIDTH_IF_ROWS-1:0] CALC_UNIT_Of_Rows;
input [BITWIDTH_IF_COLUMS-1:0] CALC_UNIT_Of_Colums;
input [BITWIDTH_W_ROWS-1:0] CALC_UNIT_W_Rows;
input [BITWIDTH_W_COLUMS-1:0] CALC_UNIT_W_Colums;
input	[BITWIDTH_IF_CHANNELS-1:0] CALC_UNIT_W_Channels;

output [BITWIDTH_MAX_IF_SIZE-1:0] CALC_UNIT_If_Size_1;
output [BITWIDTH_MAX_W_SIZE-1:0] CALC_UNIT_W_Size_1;
output [BITWIDTH_MAX_IF_SIZE-1:0] CALC_UNIT_Of_Size_1;
output [BITWIDTH_MAX_W_SIZE-1:0] CALC_UNIT_W_ROXCL_1;
output [BITWIDTH_W_COLUMS-1:0] CALC_UNIT_W_Colums_1;

//=======================================================
//  REG/WIRE DECLARATIONS
//=======================================================

reg [BITWIDTH_MAX_IF_SIZE-1:0] If_Size_1; 
reg [BITWIDTH_MAX_W_SIZE-1:0] W_size_1;
reg [BITWIDTH_MAX_IF_SIZE-1:0] Of_Size_1;
reg [BITWIDTH_MAX_W_SIZE-1:0] W_ROXCL_1;
reg [BITWIDTH_W_ROWS-1:0] W_Colums_1;


//=======================================================
//  COMBINATIONAL LOGIC
//=======================================================

always@(*)
begin
	If_Size_1= (CALC_UNIT_If_Rows*CALC_UNIT_If_Colums*CALC_UNIT_If_Channels) -1'b1;
	W_size_1= (CALC_UNIT_W_Rows*CALC_UNIT_W_Colums*CALC_UNIT_W_Channels) -1'b1;
	W_ROXCL_1= (CALC_UNIT_W_Rows*CALC_UNIT_W_Colums) -1'b1;
	W_Colums_1=CALC_UNIT_W_Colums-1'b1;
	Of_Size_1= (CALC_UNIT_Of_Rows*CALC_UNIT_Of_Colums) -1'b1;
end

//=======================================================
// COMBINATIONAL OUTPUT LOGIC
//=======================================================

assign CALC_UNIT_If_Size_1=If_Size_1;
assign CALC_UNIT_W_Size_1=W_size_1;
assign CALC_UNIT_W_ROXCL_1=W_ROXCL_1;
assign CALC_UNIT_W_Colums_1=W_Colums_1;
assign CALC_UNIT_Of_Size_1=Of_Size_1;

endmodule





