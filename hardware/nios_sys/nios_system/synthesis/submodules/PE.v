/*#########################################################################
//# Basic procesing element for multiply ans sum operations
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

module PE #( parameter PX_WIDTH=16, parameter W_WIDTH=16, parameter DATA_OUT_WIDTH=16)
(
//////////// INPUTS //////////
PE_Clk,
PE_Out_Reg_Set,
PE_Reset,
PE_Fifo_Set,
PE_Is,
PE_If_Px,
PE_w,
//////////// OUTPUT //////////
PE_Out
);

//============================================================
//  PORT DECLARATIONS
//============================================================
input PE_Clk;
input PE_Out_Reg_Set;
input PE_Reset;
input PE_Fifo_Set;
input [DATA_OUT_WIDTH-1:0] PE_Is;
input signed [PX_WIDTH-1:0] PE_If_Px;
input signed [W_WIDTH-1:0] PE_w;
output signed [DATA_OUT_WIDTH-1:0] PE_Out;

//=======================================================
//  REG/WIRE DECLARATIONS
//=======================================================
reg signed [DATA_OUT_WIDTH-1:0] Sum_Reg;
wire signed [DATA_OUT_WIDTH-1:0] Sum_Reg_Output_Wire;
wire signed [DATA_OUT_WIDTH-1:0] Out_Reg_Output_Wire;

//=======================================================
//  Structural coding
//=======================================================

OUT_REG #(.REG_DATA_WIDTH(DATA_OUT_WIDTH)) Out_Reg(

.OUT_REG_Clk(PE_Clk),
.OUT_REG_Reset(PE_Reset),
.OUT_REG_Set(PE_Out_Reg_Set),
.OUT_REG_Input_Data(Sum_Reg_Output_Wire),
.OUT_REG_Output_Data(Out_Reg_Output_Wire)
);

//============================================================
// COMBINATIONAL LOGIC 
//============================================================
always@(PE_If_Px,PE_w,PE_Is)
begin
	Sum_Reg= (PE_If_Px*PE_w) + PE_Is;
end

//============================================================
// COMBINATIONAL OUTPUT LOGIC
//============================================================
assign Sum_Reg_Output_Wire=Sum_Reg;
assign PE_Out= PE_Fifo_Set==1'b0 ? Out_Reg_Output_Wire : Sum_Reg_Output_Wire;


endmodule
