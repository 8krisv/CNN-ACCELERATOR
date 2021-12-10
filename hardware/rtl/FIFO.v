/*#########################################################################
//# Basic dual clock On-chip fifo memory, read occurs during positive edge of the FIFO_Clk_1
//# and write during positive edge of the FIFO_Clk_2,FIFO_Rdptclr and FIFO_Wrptclr
//# are both active low asynchronous signals
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

module FIFO #(parameter DATA_WIDTH=16, parameter FIFO_SIZE= 720, parameter ADDR_WIDTH=10)(

//////////// INPUTS //////////
FIFO_Clk_1,
FIFO_Clk_2,
FIFO_Rdptclr,
FIFO_Wrptclr,
FIFO_Rdinc,
FIFO_Wrinc,
FIFO_Wen,
FIFO_Ren,
FIFO_Data_in,
//////////// OUTPUT //////////
FIFO_Data_out
);

//============================================================
//  PORT DECLARATIONS
//============================================================
input FIFO_Clk_1;
input FIFO_Clk_2;
input FIFO_Rdptclr; 
input FIFO_Wrptclr; 
input FIFO_Rdinc;
input FIFO_Wrinc;
input FIFO_Wen;
input FIFO_Ren;
input [DATA_WIDTH-1:0] FIFO_Data_in;
output [DATA_WIDTH-1:0] FIFO_Data_out;
 
//=======================================================
//  REG/WIRE DECLARATIONS
//=======================================================
reg [DATA_WIDTH-1:0] Fifo_Array[0:FIFO_SIZE-1];
reg [ADDR_WIDTH-1:0] Wrptr;
reg [ADDR_WIDTH-1:0] Rdptr;
reg [DATA_WIDTH-1:0] Qtemp;

reg reg_we;
reg reg_re;


//============================================================
// SEQUENTIAL LOGIC
//============================================================

always@(*)
begin
	reg_we=FIFO_Wen;
	reg_re=FIFO_Ren;

end

always@(posedge FIFO_Clk_1 or negedge FIFO_Rdptclr)
begin
	
	if(!FIFO_Rdptclr)
		begin
			Rdptr<=0;
		end
	
	else if(reg_re)
		begin
			Qtemp<=Fifo_Array[Rdptr];
			Rdptr<=Rdptr+FIFO_Rdinc;
		end		
	else
		Qtemp<=0;
	
end


always@(posedge FIFO_Clk_2 or negedge FIFO_Wrptclr)
begin
	
	if(!FIFO_Wrptclr)
		begin
			Wrptr<=1'b0;
		end
	
	else if(reg_we)
		begin
			Fifo_Array[Wrptr]<=FIFO_Data_in;
			Wrptr<=Wrptr+1'b1;
		end
end


//============================================================
// COMBINATIONAL OUTPUT LOGIC
//============================================================
assign FIFO_Data_out=Qtemp;


endmodule

