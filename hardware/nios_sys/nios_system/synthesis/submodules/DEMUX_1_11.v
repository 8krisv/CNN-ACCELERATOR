/*#########################################################################
//# 1 to 11 demuxtiplexer
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

module DEMUX_1_11 #(parameter INPUT_DATA_WIDTH =1)(

/////////////// INPUTS ///////////////
input [INPUT_DATA_WIDTH-1:0] DEMUX_Data_in,
input [3:0] DEMUX_selector,
input DEMUX_En,

/////////////// OUTPUTS ///////////////
output reg [INPUT_DATA_WIDTH-1:0] DEMUX_out0,
output reg [INPUT_DATA_WIDTH-1:0] DEMUX_out1,
output reg [INPUT_DATA_WIDTH-1:0] DEMUX_out2,
output reg [INPUT_DATA_WIDTH-1:0] DEMUX_out3,
output reg [INPUT_DATA_WIDTH-1:0] DEMUX_out4,
output reg [INPUT_DATA_WIDTH-1:0] DEMUX_out5,
output reg [INPUT_DATA_WIDTH-1:0] DEMUX_out6,
output reg [INPUT_DATA_WIDTH-1:0] DEMUX_out7,
output reg [INPUT_DATA_WIDTH-1:0] DEMUX_out8,
output reg [INPUT_DATA_WIDTH-1:0] DEMUX_out9,
output reg [INPUT_DATA_WIDTH-1:0] DEMUX_out10

);

//=======================================================
// Parameter declaration
//=======================================================

localparam [INPUT_DATA_WIDTH-1:0] DATA0 = 0;

//============================================================
// Combinational output logic
//============================================================

always@(*)
begin

	if(DEMUX_En)
	begin
		case(DEMUX_selector)
			
			4'b0000: 
				begin
					DEMUX_out0=DEMUX_Data_in;	
					DEMUX_out1=DATA0;
					DEMUX_out2=DATA0;
					DEMUX_out3=DATA0;
					DEMUX_out4=DATA0;
					DEMUX_out5=DATA0;
					DEMUX_out6=DATA0;
					DEMUX_out7=DATA0;
					DEMUX_out8=DATA0;
					DEMUX_out9=DATA0;
					DEMUX_out10=DATA0;
				end
				
				4'b0001: 
				begin
					DEMUX_out0=DATA0;	
					DEMUX_out1=DEMUX_Data_in;
					DEMUX_out2=DATA0;
					DEMUX_out3=DATA0;
					DEMUX_out4=DATA0;
					DEMUX_out5=DATA0;
					DEMUX_out6=DATA0;
					DEMUX_out7=DATA0;
					DEMUX_out8=DATA0;
					DEMUX_out9=DATA0;
					DEMUX_out10=DATA0;
				end
				
				
				4'b0010: 
				begin
					DEMUX_out0=DATA0;	
					DEMUX_out1=DATA0;
					DEMUX_out2=DEMUX_Data_in;
					DEMUX_out3=DATA0;
					DEMUX_out4=DATA0;
					DEMUX_out5=DATA0;
					DEMUX_out6=DATA0;
					DEMUX_out7=DATA0;
					DEMUX_out8=DATA0;
					DEMUX_out9=DATA0;
					DEMUX_out10=DATA0;
				end
				
				
				4'b0011: 
				begin
					DEMUX_out0=DATA0;	
					DEMUX_out1=DATA0;
					DEMUX_out2=DATA0;
					DEMUX_out3=DEMUX_Data_in;
					DEMUX_out4=DATA0;
					DEMUX_out5=DATA0;
					DEMUX_out6=DATA0;
					DEMUX_out7=DATA0;
					DEMUX_out8=DATA0;
					DEMUX_out9=DATA0;
					DEMUX_out10=DATA0;
				end
				
				
				4'b0100: 
				begin
					DEMUX_out0=DATA0;	
					DEMUX_out1=DATA0;
					DEMUX_out2=DATA0;
					DEMUX_out3=DATA0;
					DEMUX_out4=DEMUX_Data_in;
					DEMUX_out5=DATA0;
					DEMUX_out6=DATA0;
					DEMUX_out7=DATA0;
					DEMUX_out8=DATA0;
					DEMUX_out9=DATA0;
					DEMUX_out10=DATA0;
				end
				
				4'b0101: 
				begin
					DEMUX_out0=DATA0;	
					DEMUX_out1=DATA0;
					DEMUX_out2=DATA0;
					DEMUX_out3=DATA0;
					DEMUX_out4=DATA0;
					DEMUX_out5=DEMUX_Data_in;
					DEMUX_out6=DATA0;
					DEMUX_out7=DATA0;
					DEMUX_out8=DATA0;
					DEMUX_out9=DATA0;
					DEMUX_out10=DATA0;
				end
				
				4'b0110: 
				begin
					DEMUX_out0=DATA0;	
					DEMUX_out1=DATA0;
					DEMUX_out2=DATA0;
					DEMUX_out3=DATA0;
					DEMUX_out4=DATA0;
					DEMUX_out5=DATA0;
					DEMUX_out6=DEMUX_Data_in;
					DEMUX_out7=DATA0;
					DEMUX_out8=DATA0;
					DEMUX_out9=DATA0;
					DEMUX_out10=DATA0;
				end
				
				4'b0111: 
				begin
					DEMUX_out0=DATA0;	
					DEMUX_out1=DATA0;
					DEMUX_out2=DATA0;
					DEMUX_out3=DATA0;
					DEMUX_out4=DATA0;
					DEMUX_out5=DATA0;
					DEMUX_out6=DATA0;
					DEMUX_out7=DEMUX_Data_in;
					DEMUX_out8=DATA0;
					DEMUX_out9=DATA0;
					DEMUX_out10=DATA0;
				end
				
				4'b1000: 
				begin
					DEMUX_out0=DATA0;	
					DEMUX_out1=DATA0;
					DEMUX_out2=DATA0;
					DEMUX_out3=DATA0;
					DEMUX_out4=DATA0;
					DEMUX_out5=DATA0;
					DEMUX_out6=DATA0;
					DEMUX_out7=DATA0;
					DEMUX_out8=DEMUX_Data_in;
					DEMUX_out9=DATA0;
					DEMUX_out10=DATA0;
				end
				
				4'b1001: 
				begin
					DEMUX_out0=DATA0;	
					DEMUX_out1=DATA0;
					DEMUX_out2=DATA0;
					DEMUX_out3=DATA0;
					DEMUX_out4=DATA0;
					DEMUX_out5=DATA0;
					DEMUX_out6=DATA0;
					DEMUX_out7=DATA0;
					DEMUX_out8=DATA0;
					DEMUX_out9=DEMUX_Data_in;
					DEMUX_out10=DATA0;
				end
				

				default:
				begin
					DEMUX_out0=DATA0;	
					DEMUX_out1=DATA0;
					DEMUX_out2=DATA0;
					DEMUX_out3=DATA0;
					DEMUX_out4=DATA0;
					DEMUX_out5=DATA0;
					DEMUX_out6=DATA0;
					DEMUX_out7=DATA0;
					DEMUX_out8=DATA0;
					DEMUX_out9=DATA0;
					DEMUX_out10=DEMUX_Data_in;
				end
		
		endcase
		
	end
	
	else
		begin
			DEMUX_out0=DATA0;	
			DEMUX_out1=DATA0;
			DEMUX_out2=DATA0;
			DEMUX_out3=DATA0;
			DEMUX_out4=DATA0;
			DEMUX_out5=DATA0;
			DEMUX_out6=DATA0;
			DEMUX_out7=DATA0;
			DEMUX_out8=DATA0;
			DEMUX_out9=DATA0;
			DEMUX_out10=DATA0;
		end

end


endmodule

