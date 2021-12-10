/*#########################################################################
//# On-chip fifo memory dataflow controller testbench
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

module OMDC_tb();

//////////// Parameter declarations ////////////

parameter BITWIDTH_ROW=4; 
parameter BITWIDTH_IF_ROWS=10; 
parameter BITWIDTH_IF_COLUMS = 11; 
parameter BITWIDTH_OF_COLUMS=11;
parameter BITWIDTH_W_ROWS=4;
parameter BITWIDTH_W_COLUMS=4; 
parameter BITWIDTH_STRIDE=4;
parameter CLK_PERIOD=20;
integer i;


//////////// Input signals declarations ////////////
reg tb_clk;
reg tb_clkpll;
reg tb_reset;
reg [BITWIDTH_W_COLUMS-1:0] tb_w_colums=2-1;
reg [BITWIDTH_W_ROWS-1:0] tb_w_rows=2;
reg [BITWIDTH_STRIDE-1:0] tb_stride=1;
reg [BITWIDTH_OF_COLUMS-1:0] tb_of_colums=7;
reg [BITWIDTH_IF_COLUMS-1:0] tb_if_colums=8;
reg [BITWIDTH_IF_ROWS-1:0] tb_if_rows=8;
reg tb_start_routine;
reg tb_stop_routine;
reg tb_finish_routine;
reg tb_routine_finisehd_ok;

//////////// output signals declarations ////////////

wire tb_routine_finished_already;
wire tb_control_channel_select_en;
wire tb_new_channel_flag;

wire tb_SetEn0;
wire tb_OEn0;
wire tb_Wptclr0;
wire tb_Rptclr0;

wire tb_SetEn1;
wire tb_OEn1;
wire tb_Wptclr1;
wire tb_Rptclr1;

wire tb_SetEn2;
wire tb_OEn2;
wire tb_Wptclr2;
wire tb_Rptclr2;

wire tb_SetEn3;
wire tb_OEn3;
wire tb_Wptclr3;
wire tb_Rptclr3;

wire tb_SetEn4;
wire tb_OEn4;
wire tb_Wptclr4;
wire tb_Rptclr4;

wire tb_SetEn5;
wire tb_OEn5;
wire tb_Wptclr5;
wire tb_Rptclr5;

wire tb_SetEn6;
wire tb_OEn6;
wire tb_Wptclr6;
wire tb_Rptclr6;

wire tb_SetEn7;
wire tb_OEn7;
wire tb_Wptclr7;
wire tb_Rptclr7;

wire tb_SetEn8;
wire tb_OEn8;
wire tb_Wptclr8;
wire tb_Rptclr8;


//////////// Device Under Test (DUT) instantiation //////////


OMDC Omdc(

//////////// INPUTS //////////
.OMDC_Clk(tb_clk),
.OMDC_Reset(tb_reset),
.OMDC_W_Colums(tb_w_colums),
.OMDC_W_Rows(tb_w_rows),
.OMDC_Conv_Stride(tb_stride),
.OMDC_Of_Colums(tb_of_colums),
.OMDC_If_Colums(tb_if_colums),
.OMDC_If_Rows(tb_if_rows),
.OMDC_Start_Routine(tb_start_routine),
.OMDC_Stop_Routine(tb_stop_routine),
.OMDC_Finish_Routine(tb_finish_routine),
.OMDC_Routine_Finished_Ok(tb_routine_finisehd_ok),

//////////// OUTPUTS //////////

.OMDC_Routine_Finished_Already(tb_routine_finished_already),
.OMDC_control_channel_select_en(tb_control_channel_select_en),
.OMDC_new_channel_flag(tb_new_channel_flag),

.OMDC_SetEn0(tb_SetEn0),
.OMDC_OEn0(tb_OEn0),
.OMDC_Wptclr0(tb_Wptclr0),
.OMDC_Rptclr0(tb_Rptclr0),

.OMDC_SetEn1(tb_SetEn1),
.OMDC_OEn1(tb_OEn1),
.OMDC_Wptclr1(tb_Wptclr1),
.OMDC_Rptclr1(tb_Rptclr1),

.OMDC_SetEn2(tb_SetEn2),
.OMDC_OEn2(tb_OEn2),
.OMDC_Wptclr2(tb_Wptclr2),
.OMDC_Rptclr2(tb_Rptclr2),

.OMDC_SetEn3(tb_SetEn3),
.OMDC_OEn3(tb_OEn3),
.OMDC_Wptclr3(tb_Wptclr3),
.OMDC_Rptclr3(tb_Rptclr3),

.OMDC_SetEn4(tb_SetEn4),
.OMDC_OEn4(tb_OEn4),
.OMDC_Wptclr4(tb_Wptclr4),
.OMDC_Rptclr4(tb_Rptclr4),

.OMDC_SetEn5(tb_SetEn5),
.OMDC_OEn5(tb_OEn5),
.OMDC_Wptclr5(tb_Wptclr5),
.OMDC_Rptclr5(tb_Rptclr5),

.OMDC_SetEn6(tb_SetEn6),
.OMDC_OEn6(tb_OEn6),
.OMDC_Wptclr6(tb_Wptclr6),
.OMDC_Rptclr6(tb_Rptclr6),

.OMDC_SetEn7(tb_SetEn7),
.OMDC_OEn7(tb_OEn7),
.OMDC_Wptclr7(tb_Wptclr7),
.OMDC_Rptclr7(tb_Rptclr7),

.OMDC_SetEn8(tb_SetEn8),
.OMDC_OEn8(tb_OEn8),
.OMDC_Wptclr8(tb_Wptclr8),
.OMDC_Rptclr8(tb_Rptclr8)

);

//////////// create a 50Mhz clock //////////
always
begin
		tb_clk=1'b1;
		#(CLK_PERIOD/2);
		tb_clk=1'b0;
		#(CLK_PERIOD/2);
end



initial
begin
	
	tb_reset<=0;
	tb_start_routine<=0;
	tb_stop_routine<=0;
	tb_finish_routine<=0;
	tb_routine_finisehd_ok<=0;
	
	@(negedge tb_clk)
	@(posedge tb_clk)
	tb_reset<=1;
	@(negedge tb_clk)
	@(posedge tb_clk)
	tb_start_routine<=1;
	@(negedge tb_clk)
	@(posedge tb_clk)
	tb_start_routine<=0;
	@(negedge tb_clk)
	@(posedge tb_clk)
	
	for(i=0;tb_new_channel_flag==1'b0;i=i+1)
	begin
		@(negedge tb_clk)
		@(posedge tb_clk);
	end
	
	@(negedge tb_clk)
	@(posedge tb_clk)
	@(negedge tb_clk)
	@(posedge tb_clk)
	@(negedge tb_clk)
	@(posedge tb_clk)
	@(negedge tb_clk)
	@(posedge tb_clk);
	
	$stop;

end


endmodule

