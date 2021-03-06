/*######################################################################
//# Register triggered by positive edge clock and asynchronous reset
//######################################################################
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
//#####################################################################*/

module WREG #(parameter WREG_DATA_WIDTH=16)(
//////////// INPUTS //////////
WREG_Clk,
WREG_Reset,
WREG_Set,
WREG_Input_Data,
//////////// OUTPUTS //////////
WREG_Output_Data
);

//============================================================
//  PORT DECLARATIONS
//============================================================
input WREG_Clk;
input WREG_Reset;
input WREG_Set;
input signed [WREG_DATA_WIDTH-1:0] WREG_Input_Data; 
output signed [WREG_DATA_WIDTH-1:0] WREG_Output_Data;

//=======================================================
//  REG/WIRE DECLARATIONS
//=======================================================

reg signed[WREG_DATA_WIDTH-1:0] Internal_Register;

//============================================================
// SEQUENTIAL LOGIC
//============================================================
always @(negedge WREG_Clk or negedge WREG_Reset)
begin	
	if(!WREG_Reset)
		Internal_Register<=0;
	else if(WREG_Set)
		Internal_Register<=WREG_Input_Data;
end

//============================================================
// COMBINATIONAL OUTPUT LOGIC
//============================================================

assign WREG_Output_Data=Internal_Register;

endmodule
