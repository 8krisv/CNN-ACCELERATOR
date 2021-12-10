/*#########################################################################
//# General purpose multiplexer
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
module MUX_169 #(parameter INPUT_DATA_WIDTH =8, BITWIDTH_SEL=9)(

/////////////// INPUTS ///////////////

input [BITWIDTH_SEL-1:0] MUX_selector,


input [INPUT_DATA_WIDTH-1:0] MUX_In0,
input [INPUT_DATA_WIDTH-1:0] MUX_In1,
input [INPUT_DATA_WIDTH-1:0] MUX_In2,
input [INPUT_DATA_WIDTH-1:0] MUX_In3,
input [INPUT_DATA_WIDTH-1:0] MUX_In4,
input [INPUT_DATA_WIDTH-1:0] MUX_In5,
input [INPUT_DATA_WIDTH-1:0] MUX_In6,
input [INPUT_DATA_WIDTH-1:0] MUX_In7,
input [INPUT_DATA_WIDTH-1:0] MUX_In8,
input [INPUT_DATA_WIDTH-1:0] MUX_In9,
input [INPUT_DATA_WIDTH-1:0] MUX_In10,
input [INPUT_DATA_WIDTH-1:0] MUX_In11,
input [INPUT_DATA_WIDTH-1:0] MUX_In12,
input [INPUT_DATA_WIDTH-1:0] MUX_In13,
input [INPUT_DATA_WIDTH-1:0] MUX_In14,
input [INPUT_DATA_WIDTH-1:0] MUX_In15,
input [INPUT_DATA_WIDTH-1:0] MUX_In16,
input [INPUT_DATA_WIDTH-1:0] MUX_In17,
input [INPUT_DATA_WIDTH-1:0] MUX_In18,
input [INPUT_DATA_WIDTH-1:0] MUX_In19,
input [INPUT_DATA_WIDTH-1:0] MUX_In20,
input [INPUT_DATA_WIDTH-1:0] MUX_In21,
input [INPUT_DATA_WIDTH-1:0] MUX_In22,
input [INPUT_DATA_WIDTH-1:0] MUX_In23,
input [INPUT_DATA_WIDTH-1:0] MUX_In24,
input [INPUT_DATA_WIDTH-1:0] MUX_In25,
input [INPUT_DATA_WIDTH-1:0] MUX_In26,
input [INPUT_DATA_WIDTH-1:0] MUX_In27,
input [INPUT_DATA_WIDTH-1:0] MUX_In28,
input [INPUT_DATA_WIDTH-1:0] MUX_In29,
input [INPUT_DATA_WIDTH-1:0] MUX_In30,
input [INPUT_DATA_WIDTH-1:0] MUX_In31,
input [INPUT_DATA_WIDTH-1:0] MUX_In32,
input [INPUT_DATA_WIDTH-1:0] MUX_In33,
input [INPUT_DATA_WIDTH-1:0] MUX_In34,
input [INPUT_DATA_WIDTH-1:0] MUX_In35,
/*input [INPUT_DATA_WIDTH-1:0] MUX_In36,
input [INPUT_DATA_WIDTH-1:0] MUX_In37,
input [INPUT_DATA_WIDTH-1:0] MUX_In38,
input [INPUT_DATA_WIDTH-1:0] MUX_In39,
input [INPUT_DATA_WIDTH-1:0] MUX_In40,
input [INPUT_DATA_WIDTH-1:0] MUX_In41,
input [INPUT_DATA_WIDTH-1:0] MUX_In42,
input [INPUT_DATA_WIDTH-1:0] MUX_In43,
input [INPUT_DATA_WIDTH-1:0] MUX_In44,
input [INPUT_DATA_WIDTH-1:0] MUX_In45,
input [INPUT_DATA_WIDTH-1:0] MUX_In46,
input [INPUT_DATA_WIDTH-1:0] MUX_In47,
input [INPUT_DATA_WIDTH-1:0] MUX_In48,
input [INPUT_DATA_WIDTH-1:0] MUX_In49,
input [INPUT_DATA_WIDTH-1:0] MUX_In50,
input [INPUT_DATA_WIDTH-1:0] MUX_In51,
input [INPUT_DATA_WIDTH-1:0] MUX_In52,
input [INPUT_DATA_WIDTH-1:0] MUX_In53,
input [INPUT_DATA_WIDTH-1:0] MUX_In54,
input [INPUT_DATA_WIDTH-1:0] MUX_In55,
input [INPUT_DATA_WIDTH-1:0] MUX_In56,
input [INPUT_DATA_WIDTH-1:0] MUX_In57,
input [INPUT_DATA_WIDTH-1:0] MUX_In58,
input [INPUT_DATA_WIDTH-1:0] MUX_In59,
input [INPUT_DATA_WIDTH-1:0] MUX_In60,
input [INPUT_DATA_WIDTH-1:0] MUX_In61,
input [INPUT_DATA_WIDTH-1:0] MUX_In62,
input [INPUT_DATA_WIDTH-1:0] MUX_In63,
input [INPUT_DATA_WIDTH-1:0] MUX_In64,
input [INPUT_DATA_WIDTH-1:0] MUX_In65,
input [INPUT_DATA_WIDTH-1:0] MUX_In66,
input [INPUT_DATA_WIDTH-1:0] MUX_In67,
input [INPUT_DATA_WIDTH-1:0] MUX_In68,
input [INPUT_DATA_WIDTH-1:0] MUX_In69,
input [INPUT_DATA_WIDTH-1:0] MUX_In70,
input [INPUT_DATA_WIDTH-1:0] MUX_In71,
input [INPUT_DATA_WIDTH-1:0] MUX_In72,
input [INPUT_DATA_WIDTH-1:0] MUX_In73,
input [INPUT_DATA_WIDTH-1:0] MUX_In74,
input [INPUT_DATA_WIDTH-1:0] MUX_In75,
input [INPUT_DATA_WIDTH-1:0] MUX_In76,
input [INPUT_DATA_WIDTH-1:0] MUX_In77,
input [INPUT_DATA_WIDTH-1:0] MUX_In78,
input [INPUT_DATA_WIDTH-1:0] MUX_In79,
input [INPUT_DATA_WIDTH-1:0] MUX_In80,
input [INPUT_DATA_WIDTH-1:0] MUX_In81,
input [INPUT_DATA_WIDTH-1:0] MUX_In82,
input [INPUT_DATA_WIDTH-1:0] MUX_In83,
input [INPUT_DATA_WIDTH-1:0] MUX_In84,
input [INPUT_DATA_WIDTH-1:0] MUX_In85,
input [INPUT_DATA_WIDTH-1:0] MUX_In86,
input [INPUT_DATA_WIDTH-1:0] MUX_In87,
input [INPUT_DATA_WIDTH-1:0] MUX_In88,
input [INPUT_DATA_WIDTH-1:0] MUX_In89,
input [INPUT_DATA_WIDTH-1:0] MUX_In90,
input [INPUT_DATA_WIDTH-1:0] MUX_In91,
input [INPUT_DATA_WIDTH-1:0] MUX_In92,
input [INPUT_DATA_WIDTH-1:0] MUX_In93,
input [INPUT_DATA_WIDTH-1:0] MUX_In94,
input [INPUT_DATA_WIDTH-1:0] MUX_In95,
input [INPUT_DATA_WIDTH-1:0] MUX_In96,
input [INPUT_DATA_WIDTH-1:0] MUX_In97,
input [INPUT_DATA_WIDTH-1:0] MUX_In98,
input [INPUT_DATA_WIDTH-1:0] MUX_In99,
input [INPUT_DATA_WIDTH-1:0] MUX_In100,*/

/////////////// OUTPUTS ///////////////
output[INPUT_DATA_WIDTH-1:0]  MUX_OUTPUT

);



reg [INPUT_DATA_WIDTH-1:0] Data;

always@(*)
begin
	case(MUX_selector)
		9'd0: Data=MUX_In0;
		9'd1: Data=MUX_In1;
		9'd2: Data=MUX_In2;
		9'd3: Data=MUX_In3;
		9'd4: Data=MUX_In4;
		9'd5: Data=MUX_In5;
		9'd6: Data=MUX_In6;
		9'd7: Data=MUX_In7;
		9'd8: Data=MUX_In8;
		9'd9: Data=MUX_In9;
		9'd10: Data=MUX_In10;
		9'd11: Data=MUX_In11;
		9'd12: Data=MUX_In12;
		9'd13: Data=MUX_In13;
		9'd14: Data=MUX_In14;
		9'd15: Data=MUX_In15;
		9'd16: Data=MUX_In16;
		9'd17: Data=MUX_In17;
		9'd18: Data=MUX_In18;
		9'd19: Data=MUX_In19;
		9'd20: Data=MUX_In20;
		9'd21: Data=MUX_In21;
		9'd22: Data=MUX_In22;
		9'd23: Data=MUX_In23;
		9'd24: Data=MUX_In24;
		9'd25: Data=MUX_In25;
		9'd26: Data=MUX_In26;
		9'd27: Data=MUX_In27;
		9'd28: Data=MUX_In28;
		9'd29: Data=MUX_In29;
		9'd30: Data=MUX_In30;
		9'd31: Data=MUX_In31;
		9'd32: Data=MUX_In32;
		9'd33: Data=MUX_In33;
		9'd34: Data=MUX_In34;
		9'd35: Data=MUX_In35;
			
	default:
		Data=16'b0;
		
	endcase
end


assign MUX_OUTPUT=Data;



endmodule

