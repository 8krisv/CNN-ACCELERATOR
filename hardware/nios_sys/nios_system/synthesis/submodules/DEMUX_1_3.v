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

module DEMUX_1_3 #(parameter INPUT_DATA_WIDTH =8)(

/////////////// INPUTS ///////////////
input [INPUT_DATA_WIDTH-1:0] DEMUX_Data_in,
input [1:0] DEMUX_selector,
input DEMUX_En,

/////////////// OUTPUTS ///////////////
output [INPUT_DATA_WIDTH-1:0] DEMUX_out0,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out1,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out2
);

//=======================================================
// Parameter declaration
//=======================================================

localparam [INPUT_DATA_WIDTH-1:0] DATA0 = 0;

//============================================================
// Combinational output logic
//============================================================

assign DEMUX_out0 = DEMUX_En == 1'b1 ? DEMUX_selector == 2'b00 ? DEMUX_Data_in : DATA0 : DATA0;
assign DEMUX_out1 = DEMUX_En == 1'b1 ? DEMUX_selector == 2'b01 ? DEMUX_Data_in : DATA0 : DATA0;
assign DEMUX_out2 = DEMUX_En == 1'b1 ? DEMUX_selector == 2'b10 ? DEMUX_Data_in : DATA0 : DATA0;

endmodule
