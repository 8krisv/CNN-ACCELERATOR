/*#########################################################################
//# 1 to 2 demuxtiplexer
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

module DEMUX_1_2 #(parameter INPUT_DATA_WIDTH =8)(

/////////////// INPUTS ///////////////
input [INPUT_DATA_WIDTH-1:0] DEMUX_Data_in,
input DEMUX_selector,
input DEMUX_En,

/////////////// OUTPUTS ///////////////
output [INPUT_DATA_WIDTH-1:0] DEMUX_out0,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out1
);


//============================================================
// Combinational output logic
//============================================================

assign DEMUX_out0 = DEMUX_En == 1'b1 ? DEMUX_selector == 1'b0 ? DEMUX_Data_in : 16'b0 : 16'b0;
assign DEMUX_out1 = DEMUX_En == 1'b1 ? DEMUX_selector == 1'b1 ? DEMUX_Data_in : 16'b0 : 16'b0;

endmodule

