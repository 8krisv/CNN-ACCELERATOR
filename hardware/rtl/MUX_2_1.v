/*#########################################################################
//# 2 to 1 muxtiplexer
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

module MUX_2_1 #(parameter INPUT_DATA_WIDTH =8)(

//////////// INPUTS //////////
input [INPUT_DATA_WIDTH-1:0] MUX_Input_0,
input [INPUT_DATA_WIDTH-1:0] MUX_Input_1,
input MUX_sel,

//////////// OUTPUT //////////

output[INPUT_DATA_WIDTH-1:0]  MUX_OUTPUT


);


reg [INPUT_DATA_WIDTH-1:0] Data;

always@(*)
begin
	case(MUX_sel)
		1'b0: Data=MUX_Input_0;
		1'b1: Data=MUX_Input_1;
	endcase
end


assign MUX_OUTPUT=Data;


endmodule

