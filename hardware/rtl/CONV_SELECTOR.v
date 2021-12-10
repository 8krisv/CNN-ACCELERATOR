/*#########################################################################
//# General purpose demultiplexer
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

module CONV_SELECTOR #( parameter BITWIDTH_W_ROWS=4)(


//////////// INPUTS //////////
CONV_SELECTOR_Wrows,

//////////// OUTPUTS //////////
CONV_SELECTOR_Sel

);

//=======================================================
//  PORT declarations
//=======================================================
input [BITWIDTH_W_ROWS-1:0] CONV_SELECTOR_Wrows;
output reg [12:0] CONV_SELECTOR_Sel;

//=======================================================
//  Local parameters
//======================================================
localparam [12:0] INVALID   = 13'b0000000000000;
localparam [12:0] CONV1  = 13'b0000000000001;
localparam [12:0] CONV2  = 13'b0000000000011;
localparam [12:0] CONV3  = 13'b0000000000111;
localparam [12:0] CONV4  = 13'b0000000001111;
localparam [12:0] CONV5  = 13'b0000000011111;
localparam [12:0] CONV6  = 13'b0000000111111;
localparam [12:0] CONV7  = 13'b0000001111111;
localparam [12:0] CONV8  = 13'b0000011111111;
localparam [12:0] CONV9  = 13'b0000111111111;
localparam [12:0] CONV10 = 13'b0001111111111;
localparam [12:0] CONV11 = 13'b0011111111111;
localparam [12:0] CONV12 = 13'b0111111111111;
localparam [12:0] CONV13 = 13'b1111111111111;


//=======================================================
//  Combinational lofgic
//=======================================================

always @(*)
begin
	
	case(CONV_SELECTOR_Wrows)
	
		4'd1:CONV_SELECTOR_Sel=CONV1;
		4'd2:CONV_SELECTOR_Sel=CONV2;
		4'd3:CONV_SELECTOR_Sel=CONV3;
		4'd4:CONV_SELECTOR_Sel=CONV4;
		4'd5:CONV_SELECTOR_Sel=CONV5;
		4'd6:CONV_SELECTOR_Sel=CONV6;
		4'd7:CONV_SELECTOR_Sel=CONV7;
		4'd8:CONV_SELECTOR_Sel=CONV8;
		4'd9:CONV_SELECTOR_Sel=CONV9;
		4'd10:CONV_SELECTOR_Sel=CONV10;
		4'd11:CONV_SELECTOR_Sel=CONV11;
		4'd12:CONV_SELECTOR_Sel=CONV12;
		4'd13:CONV_SELECTOR_Sel=CONV13;

		default:CONV_SELECTOR_Sel=INVALID;
	
	endcase

end




endmodule
