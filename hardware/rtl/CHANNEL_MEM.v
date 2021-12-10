/*#########################################################################
//# Channel memory
//#########################################################################
//#
//# Copyright (C) 2021 Jose Maria Jaramillo Hoyos ACCELERATOR_DATA_OUT
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

module CHANNEL_MEM #(parameter DATA_WIDTH = 16, MEM_SIZE=1024  ,ADDR_WIDTH = 10)
(
//////////// INPUTS //////////
CHANNEL_MEM_Clk,
CHANNEL_MEM_We,
CHANNEL_MEM_Oe,
CHANNEL_MEM_Rdinc,
CHANNEL_MEM_Wrinc,
CHANNEL_MEM_Wptclr,
CHANNEL_MEM_Rptclr,
CHANNEL_MEM_Data_In,
//////////// OUTPUT //////////
CHANNEL_MEM_Data_Out
);

//============================================================
//  PORT DECLARATIONS
//============================================================

input CHANNEL_MEM_Clk;
input CHANNEL_MEM_We;
input CHANNEL_MEM_Oe;
input CHANNEL_MEM_Rdinc;
input CHANNEL_MEM_Wrinc;
input CHANNEL_MEM_Wptclr;
input CHANNEL_MEM_Rptclr;
input [DATA_WIDTH-1:0] CHANNEL_MEM_Data_In;
output [DATA_WIDTH-1:0] CHANNEL_MEM_Data_Out;

//=======================================================
//  REG/WIRE DECLARATIONS
//=======================================================

reg [DATA_WIDTH-1:0] Ram_Array[0:MEM_SIZE-1];
reg [ADDR_WIDTH-1:0] Wrptr;
reg [ADDR_WIDTH-1:0] Rdptr;
reg [DATA_WIDTH-1:0] Q_temp;



always@(negedge CHANNEL_MEM_Clk)
begin
	
	if(!CHANNEL_MEM_Wptclr)
	begin
		Wrptr<=0;
	end	
	
	else if(CHANNEL_MEM_We)
	begin
		Ram_Array[Wrptr]<=CHANNEL_MEM_Data_In;
		Wrptr<=Wrptr+CHANNEL_MEM_Wrinc;
	end
	
	
	if(!CHANNEL_MEM_Rptclr)
	begin
		Rdptr<=0;
	end	
	else if(CHANNEL_MEM_Oe)
	begin
		Q_temp<=Ram_Array[Rdptr];
		Rdptr<=Rdptr+CHANNEL_MEM_Rdinc;
	end
	else
		Q_temp<=16'b0;
	
	
end


assign CHANNEL_MEM_Data_Out= CHANNEL_MEM_Oe==1'b1 ? Q_temp:16'b0;


endmodule

