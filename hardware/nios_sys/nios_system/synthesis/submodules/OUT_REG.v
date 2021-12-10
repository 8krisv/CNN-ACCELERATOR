/*#########################################################################
//# Output register triggered by positive edge clock and asynchronous reset
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

module OUT_REG #(parameter REG_DATA_WIDTH=16)(
//////////// INPUTS //////////
OUT_REG_Clk,
OUT_REG_Reset,
OUT_REG_Set,
OUT_REG_Input_Data,
//////////// OUTPUTS //////////
OUT_REG_Output_Data
);

//============================================================
//  PORT DECLARATIONS
//============================================================
input OUT_REG_Clk;
input OUT_REG_Reset;
input OUT_REG_Set;
input signed [REG_DATA_WIDTH-1:0] OUT_REG_Input_Data;
output signed [REG_DATA_WIDTH-1:0] OUT_REG_Output_Data;

//=======================================================
//  REG/WIRE DECLARATIONS
//=======================================================

reg signed [REG_DATA_WIDTH-1:0] Internal_Signal_Reg;
reg signed[REG_DATA_WIDTH-1:0] Internal_Data_Reg;

//============================================================
// COMBINATIONAL LOGIC
//============================================================
always@(*)
begin
	if(OUT_REG_Set)
		Internal_Signal_Reg=OUT_REG_Input_Data;
	else
		Internal_Signal_Reg=Internal_Data_Reg;
end

//============================================================
// SEQUENTIAL LOGIC
//============================================================

always@(posedge OUT_REG_Clk or negedge OUT_REG_Reset)
begin
	if(!OUT_REG_Reset)
		Internal_Data_Reg<=0;
	else
		Internal_Data_Reg<=Internal_Signal_Reg;
end

//============================================================
// COMBINATIONAL OUTPUT LOGIC
//============================================================
assign OUT_REG_Output_Data=Internal_Data_Reg;


endmodule


