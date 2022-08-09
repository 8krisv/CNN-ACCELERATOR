/*#########################################################################
//# Main testbench for top mododule ACCELERATOR.V
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

`timescale 1 ns/10 ps

module ACCELERATOR_tb();

//////////// Parameter declarations ////////////

parameter IFPATH = "../../files/IF/memv/69-vin.txt";



parameter BITWIDTH_W_ROWS=4;
parameter BITWIDTH_W_COLUMS=4; 
parameter BITWIDTH_IF_CHANNELS=2; 
parameter BITWIDTH_IF_ROWS=10; 
parameter BITWIDTH_IF_COLUMS = 11; 
parameter OFFMEM_ADDR_WIDTH = 32;
parameter OFFMEM_DATA_WIDTH = 16;
parameter MAX_OFFMEM_SIZE =196608;
parameter BITWIDTH_STRIDE=4; 
integer i;

//////////// Input signals declarations ////////////
reg [OFFMEM_ADDR_WIDTH-1:0] tb_addr_offset;
reg [BITWIDTH_IF_ROWS-1:0] tb_if_rows = 256;
reg [BITWIDTH_IF_COLUMS-1:0] tb_if_colums = 256;
reg [BITWIDTH_IF_CHANNELS-1:0] tb_if_channels=3;
reg [BITWIDTH_W_ROWS-1:0] tb_w_rows=5;
reg [BITWIDTH_W_COLUMS-1:0] tb_w_colums=2;
reg [BITWIDTH_IF_CHANNELS-1:0] tb_w_channels=3;
reg [BITWIDTH_IF_ROWS-1:0] tb_of_rows = 252;
reg [BITWIDTH_IF_COLUMS-1:0] tb_of_colums=255;
reg [BITWIDTH_STRIDE-1:0] tb_conv_stride=1;
reg tb_conv_start;
reg tb_conv_finished_ok;
reg tb_same_w;
reg tb_clk_50;
reg tb_reset;

//////////// Output signals declarations ////////////

wire [OFFMEM_DATA_WIDTH-1:0] OffchipRam_Data_Out;
wire [OFFMEM_ADDR_WIDTH-1:0] Aceletator_Offmem_Addr;

wire Acelerator_Offmem_We;
wire Acelerator_Offmem_Re;
wire Acelerator_Finished;
wire [OFFMEM_DATA_WIDTH-1:0] Accelerator_Data_Out;

//////////// Device Under Test (DUT) instantiation //////////



RAM_SIMUL #(
.DATA_WIDTH(OFFMEM_DATA_WIDTH),
.MEM_SIZE(MAX_OFFMEM_SIZE),
.ADDR_WIDTH(OFFMEM_ADDR_WIDTH),
.IFPATH(IFPATH)) OffchipRam

(

//// INPUTS ////
.RAM_SIM_Clk(tb_clk_50),
.RAM_SIM_We(Acelerator_Offmem_We),
.RAM_SIM_Oe(Acelerator_Offmem_Re),
.RAM_SIM_Address(Aceletator_Offmem_Addr),
.RAM_SIM_Data_In(Accelerator_Data_Out),

//// OUTPUTS ////
.RAM_SIM_Data_Out(OffchipRam_Data_Out)

);




ACCELERATOR Accelerator(


//////////// INPUTS //////////
.ACCELERATOR_Clk_50(tb_clk_50),
.ACCELERATOR_Reset(tb_reset),
.ACCELERATOR_DATA_IN(OffchipRam_Data_Out),
.ACCELERATOR_ADDR_OFFSET(tb_addr_offset),
.ACCELERATOR_IF_ROWS(tb_if_rows),
.ACCELERATOR_IF_COLUMS(tb_if_colums),
.ACCELERATOR_IF_CHANNELS(tb_if_channels),
.ACCELERATOR_OF_ROWS(tb_of_rows),
.ACCELERATOR_OF_COLUMS(tb_of_colums),
.ACCELERATOR_W_ROWS(tb_w_rows),
.ACCELERATOR_W_COLUMS(tb_w_colums),
.ACCELERATOR_W_CHANNELS(tb_w_channels),
.ACCELERATOR_SAME_W(tb_same_w),
.ACCELERATOR_CONV_STRIDE(tb_conv_stride),
.ACCELERATOR_START(tb_conv_start),
.ACCELERATOR_FINISHED_OK(tb_conv_finished_ok),

//////////// OUTPUTS //////////

.ACCELERATOR_DATA_OUT(Accelerator_Data_Out),
.ACCELERATOR_MEM_ADDR(Aceletator_Offmem_Addr),
.ACCELERATOR_MEM_WE(Acelerator_Offmem_We),
.ACCELERATOR_MEM_RE(Acelerator_Offmem_Re),
.ACCELERATOR_FINISHED(Acelerator_Finished)

);


//////////// create a 50Mhz clock //////////
always
begin
		tb_clk_50=1'b1;
		#10;
		tb_clk_50=1'b0;
		#10;
end


initial
begin

	tb_conv_start<=0;
	tb_conv_finished_ok<=0;
	tb_addr_offset<=9;
	tb_reset<=1;
	tb_same_w<=0;
	
	@(negedge tb_clk_50)
	@(posedge tb_clk_50)
	@(negedge tb_clk_50)
	@(posedge tb_clk_50)
	tb_conv_start<=1;
	@(negedge tb_clk_50)
	@(posedge tb_clk_50)
	tb_conv_start<=0;
	
	for(i=0;Acelerator_Finished==1'b0;i=i+1)begin
		@(negedge tb_clk_50)
		@(posedge tb_clk_50);
	end
	tb_conv_finished_ok<=1;
	@(negedge tb_clk_50)
	@(posedge tb_clk_50);
	
	$stop;
	
end




endmodule


