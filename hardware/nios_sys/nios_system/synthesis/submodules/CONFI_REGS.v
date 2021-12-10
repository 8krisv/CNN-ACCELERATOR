/*#########################################################################
//# Configuration register for hardware accelerator
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

module CONFI_REGS(

/////// INPUTS ///////
CONFI_REGS_Clk,
CONFI_REGS_Reset,
CONFI_REGS_Addr,
CONFI_REGS_Writedata,
CONFI_REGS_We,
CONFI_REGS_Re,

/////// OUTPUTS ///////
CONFI_REGS_Readdata,
CONFI_REGS_Reg_Addr_Offset,
CONFI_REGS_Reg_If_Rows,
CONFI_REGS_Reg_If_Colums,
CONFI_REGS_Reg_If_Channels,
CONFI_REGS_Reg_W_Rows,
CONFI_REGS_Reg_W_Colums,
CONFI_REGS_Reg_W_Channels,
CONFI_REGS_Reg_Of_Rows,
CONFI_REGS_Reg_Of_Colums,
CONFI_REGS_Reg_Stride

);

//=======================================================
//  Parameter declarations
//=======================================================
localparam [31:0] DEF_VALUE = 32'b0;
localparam MUX_DATA_IN = 1'b1;

//=======================================================
//  PORT declarations
//=======================================================

input CONFI_REGS_Clk;
input CONFI_REGS_Reset;
input [3:0] CONFI_REGS_Addr;
input [31:0] CONFI_REGS_Writedata;
input CONFI_REGS_We;
input CONFI_REGS_Re;

output reg [31:0] CONFI_REGS_Readdata;
output [31:0] CONFI_REGS_Reg_Addr_Offset;
output [31:0] CONFI_REGS_Reg_If_Rows;
output [31:0] CONFI_REGS_Reg_If_Colums;
output [31:0] CONFI_REGS_Reg_If_Channels;
output [31:0] CONFI_REGS_Reg_W_Rows;
output [31:0] CONFI_REGS_Reg_W_Colums;
output [31:0] CONFI_REGS_Reg_W_Channels;
output [31:0] CONFI_REGS_Reg_Of_Rows;
output [31:0] CONFI_REGS_Reg_Of_Colums;
output [31:0] CONFI_REGS_Reg_Stride;

//=======================================================
//  REG/WIRE declarations
//=======================================================

wire Reg_Addr_Offset_Set;
wire Reg_If_Rows_Set;
wire Reg_If_Colums_Set;
wire Reg_If_Channels_Set;
wire Reg_W_Rows_Set;
wire Reg_W_Colums_Set;
wire Reg_W_Channels_Set;
wire Reg_Of_Rows_Set;
wire Reg_Of_Colums_Set;
wire Reg_Stride_Set;
wire Reg_Default_Set;
wire [31:0] Reg_Default_Out;

//=======================================================
//  STRUCTURAL Coding
//=======================================================

OUT_REG #(.REG_DATA_WIDTH(32)) Reg_Addr_Offset  (

//////////// INPUTS //////////
.OUT_REG_Clk(CONFI_REGS_Clk),
.OUT_REG_Reset(CONFI_REGS_Reset),
.OUT_REG_Set(Reg_Addr_Offset_Set),
.OUT_REG_Input_Data(CONFI_REGS_Writedata),
//////////// OUTPUTS //////////
.OUT_REG_Output_Data(CONFI_REGS_Reg_Addr_Offset)

);


OUT_REG #(.REG_DATA_WIDTH(32)) Reg_If_Rows (

//////////// INPUTS //////////
.OUT_REG_Clk(CONFI_REGS_Clk),
.OUT_REG_Reset(CONFI_REGS_Reset),
.OUT_REG_Set(Reg_If_Rows_Set),
.OUT_REG_Input_Data(CONFI_REGS_Writedata),
//////////// OUTPUTS //////////
.OUT_REG_Output_Data(CONFI_REGS_Reg_If_Rows)

);


OUT_REG #(.REG_DATA_WIDTH(32)) Reg_If_Colums (

//////////// INPUTS //////////
.OUT_REG_Clk(CONFI_REGS_Clk),
.OUT_REG_Reset(CONFI_REGS_Reset),
.OUT_REG_Set(Reg_If_Colums_Set),
.OUT_REG_Input_Data(CONFI_REGS_Writedata),
//////////// OUTPUTS //////////
.OUT_REG_Output_Data(CONFI_REGS_Reg_If_Colums)

);


OUT_REG #(.REG_DATA_WIDTH(32)) Reg_If_Channels (

//////////// INPUTS //////////
.OUT_REG_Clk(CONFI_REGS_Clk),
.OUT_REG_Reset(CONFI_REGS_Reset),
.OUT_REG_Set(Reg_If_Channels_Set),
.OUT_REG_Input_Data(CONFI_REGS_Writedata),
//////////// OUTPUTS //////////
.OUT_REG_Output_Data(CONFI_REGS_Reg_If_Channels)

);


OUT_REG #(.REG_DATA_WIDTH(32)) Reg_W_Rows (

//////////// INPUTS //////////
.OUT_REG_Clk(CONFI_REGS_Clk),
.OUT_REG_Reset(CONFI_REGS_Reset),
.OUT_REG_Set(Reg_W_Rows_Set),
.OUT_REG_Input_Data(CONFI_REGS_Writedata),
//////////// OUTPUTS //////////
.OUT_REG_Output_Data(CONFI_REGS_Reg_W_Rows)

);


OUT_REG #(.REG_DATA_WIDTH(32)) Reg_W_Colums (

//////////// INPUTS //////////
.OUT_REG_Clk(CONFI_REGS_Clk),
.OUT_REG_Reset(CONFI_REGS_Reset),
.OUT_REG_Set(Reg_W_Colums_Set),
.OUT_REG_Input_Data(CONFI_REGS_Writedata),
//////////// OUTPUTS //////////
.OUT_REG_Output_Data(CONFI_REGS_Reg_W_Colums)

);


OUT_REG #(.REG_DATA_WIDTH(32)) Reg_W_Channels (

//////////// INPUTS //////////
.OUT_REG_Clk(CONFI_REGS_Clk),
.OUT_REG_Reset(CONFI_REGS_Reset),
.OUT_REG_Set(Reg_W_Channels_Set),
.OUT_REG_Input_Data(CONFI_REGS_Writedata),
//////////// OUTPUTS //////////
.OUT_REG_Output_Data(CONFI_REGS_Reg_W_Channels)

);

OUT_REG #(.REG_DATA_WIDTH(32)) Reg_Of_Rows (

//////////// INPUTS //////////
.OUT_REG_Clk(CONFI_REGS_Clk),
.OUT_REG_Reset(CONFI_REGS_Reset),
.OUT_REG_Set(Reg_Of_Rows_Set),
.OUT_REG_Input_Data(CONFI_REGS_Writedata),
//////////// OUTPUTS //////////
.OUT_REG_Output_Data(CONFI_REGS_Reg_Of_Rows)

);

OUT_REG #(.REG_DATA_WIDTH(32)) Reg_Of_Colums (

//////////// INPUTS //////////
.OUT_REG_Clk(CONFI_REGS_Clk),
.OUT_REG_Reset(CONFI_REGS_Reset),
.OUT_REG_Set(Reg_Of_Colums_Set),
.OUT_REG_Input_Data(CONFI_REGS_Writedata),
//////////// OUTPUTS //////////
.OUT_REG_Output_Data(CONFI_REGS_Reg_Of_Colums)

);

OUT_REG #(.REG_DATA_WIDTH(32)) Reg_Stride (

//////////// INPUTS //////////
.OUT_REG_Clk(CONFI_REGS_Clk),
.OUT_REG_Reset(CONFI_REGS_Reset),
.OUT_REG_Set(Reg_Stride_Set),
.OUT_REG_Input_Data(CONFI_REGS_Writedata),
//////////// OUTPUTS //////////
.OUT_REG_Output_Data(CONFI_REGS_Reg_Stride)

);

OUT_REG #(.REG_DATA_WIDTH(32)) Reg_Default (

//////////// INPUTS //////////
.OUT_REG_Clk(CONFI_REGS_Clk),
.OUT_REG_Reset(CONFI_REGS_Reset),
.OUT_REG_Set(Reg_Default_Set),
.OUT_REG_Input_Data(CONFI_REGS_Writedata),
//////////// OUTPUTS //////////
.OUT_REG_Output_Data(Reg_Default_Out)

);


DEMUX_1_11 Demux_1_11(

/////////////// INPUTS ///////////////
.DEMUX_Data_in(MUX_DATA_IN),
.DEMUX_selector(CONFI_REGS_Addr),
.DEMUX_En(CONFI_REGS_We),

/////////////// OUTPUTS ///////////////
.DEMUX_out0(Reg_Addr_Offset_Set),
.DEMUX_out1(Reg_If_Rows_Set),
.DEMUX_out2(Reg_If_Colums_Set),
.DEMUX_out3(Reg_If_Channels_Set),
.DEMUX_out4(Reg_W_Rows_Set),
.DEMUX_out5(Reg_W_Colums_Set),
.DEMUX_out6(Reg_W_Channels_Set),
.DEMUX_out7(Reg_Of_Rows_Set),
.DEMUX_out8(Reg_Of_Colums_Set),
.DEMUX_out9(Reg_Stride_Set),
.DEMUX_out10(Reg_Default_Set)

);


//=======================================================
//  Sequential Logic
//=======================================================

always @(posedge CONFI_REGS_Clk)
begin	

	if(CONFI_REGS_Re) begin
		
		case(CONFI_REGS_Addr)
	 
			4'b0000:
				CONFI_REGS_Readdata<=CONFI_REGS_Reg_Addr_Offset;
			
			
			4'b0001:
				CONFI_REGS_Readdata<=CONFI_REGS_Reg_If_Rows;
			
	 
			4'b0010:
				CONFI_REGS_Readdata<=CONFI_REGS_Reg_If_Colums;
			
				
			4'b0011:
				CONFI_REGS_Readdata<=CONFI_REGS_Reg_If_Channels;
	
	 
			4'b0100:
				CONFI_REGS_Readdata<=CONFI_REGS_Reg_W_Rows;
		
	 
			4'b0101:
				CONFI_REGS_Readdata<=CONFI_REGS_Reg_W_Colums;
				
			
			4'b0110:
				CONFI_REGS_Readdata<=CONFI_REGS_Reg_W_Channels;
			
	 
			4'b0111:
				CONFI_REGS_Readdata<=CONFI_REGS_Reg_Of_Rows;
		
	 
			4'b1000:
				CONFI_REGS_Readdata<=CONFI_REGS_Reg_Of_Colums;
		
	 
			4'b1001:
				CONFI_REGS_Readdata<=CONFI_REGS_Reg_Stride;
		
				
			default:
				CONFI_REGS_Readdata<=DEF_VALUE;
		
		endcase
		
	end
	
end



endmodule


