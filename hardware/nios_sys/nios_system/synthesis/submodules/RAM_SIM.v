/*#########################################################################
//# Ram module for modelsim simulations
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


module RAM_SIM #(parameter DATA_WIDTH = 8, MEM_SIZE=1024  ,ADDR_WIDTH = 10, IFPATH="")
(
//////////// INPUTS //////////
RAM_SIM_Clk,
RAM_SIM_We,
RAM_SIM_Oe,
RAM_SIM_Address, 
RAM_SIM_Data_In,

//////////// OUTPUT //////////
RAM_SIM_Data_Out
);

//============================================================
//  PORT DECLARATIONS
//============================================================

input RAM_SIM_Clk;
input RAM_SIM_We;
input RAM_SIM_Oe;
input [ADDR_WIDTH-1:0] RAM_SIM_Address;
input [DATA_WIDTH-1:0] RAM_SIM_Data_In;
output [DATA_WIDTH-1:0] RAM_SIM_Data_Out;

//=======================================================
//  REG/WIRE DECLARATIONS
//=======================================================

reg [DATA_WIDTH-1:0] Ram_Array[0:MEM_SIZE-1];
reg [DATA_WIDTH-1:0] Q_temp;

//============================================================
// LOADING RAM FOR SIMULATION
//============================================================

initial 
begin
	$display("Loading Ram...");
	$readmemh(IFPATH,Ram_Array);
	$display("Ram successfully loaded.");
end

//============================================================
// SEQUENTIAL LOGIC
//============================================================

always@(posedge RAM_SIM_Clk)
begin
	
	if(RAM_SIM_We) begin
		Ram_Array[RAM_SIM_Address]<=RAM_SIM_Data_In;
	end
	
	Q_temp<=Ram_Array[RAM_SIM_Address];
	
end

//============================================================
// COMBINATIONAL OUTPUT LOGIC
//============================================================

assign RAM_SIM_Data_Out = RAM_SIM_Oe == 1'b1 ? Q_temp : 'hz;



endmodule
