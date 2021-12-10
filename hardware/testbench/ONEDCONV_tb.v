/*#########################################################################
//# One dimensional convolution module testbench
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

module ONEDCONV_tb();

//////////// Parameter declarations ////////////


parameter BITWIDTH_OF_COLUMS=11;
parameter BITWIDTH_IF_ROWS=10;
parameter BITWIDTH_W_ROWS=4;
parameter BITWIDTH_ROW=4;
parameter BITWIDTH_STRIDE=4;
parameter OF_COLUMS=5;
parameter IF_ROWS=6;
parameter W_ROWS=2;
parameter STRIDE=1;
parameter [BITWIDTH_ROW-1:0] ROW=1;
parameter CLK_PERIOD=20;
integer i;

//////////// General Input signals declarations ////////////
reg tb_clk;
reg tb_reset;
reg tb_flag_Eqcw;
reg tb_flag_Eqst;
reg tb_flag_Eqcif;
reg [BITWIDTH_IF_ROWS-1:0] tb_current_row;
reg [BITWIDTH_OF_COLUMS-1:0] tb_of_colums;
reg [BITWIDTH_IF_ROWS-1:0] tb_if_rows;
reg [BITWIDTH_W_ROWS-1:0] tb_w_rows;
reg [BITWIDTH_STRIDE-1:0] tb_stride;
reg tb_enable;
reg tb_start;

//////////// Outputs ////////////
wire tb_set_en;
wire tb_o_en;
wire tb_wptclr;
wire tb_rptclr;

//////////// Device Under Test (DUT) instantiation //////////

ONEDCONV OneDConv(

//// INPUTS ////
.ONEDCONV_Clk(tb_clk),
.ONEDCONV_Reset(tb_reset),
.ONEDCONV_Row(ROW),
.ONEDCONV_Flag_Eqcw(tb_flag_Eqcw),
.ONEDCONV_Flag_Eqst(tb_flag_Eqst),
.ONEDCONV_Flag_Eqcif(tb_flag_Eqcif),
.ONEDCONV_Current_Row(tb_current_row),
.ONEDCONV_Of_Colums(tb_of_colums),
.ONEDCONV_If_Rows(tb_if_rows),
.ONEDCONV_W_Rows(tb_w_rows),
.ONEDCONV_Conv_Stride(tb_stride),
.ONEDCONV_Enable(tb_enable),
.ONEDCONV_Start(tb_start),

//// OUTPUTS ////

.ONEDCONV_Set_En(tb_set_en),
.ONEDCONV_O_En(tb_o_en),
.ONEDCONV_Wptclr(tb_wptclr),
.ONEDCONV_Rptclr(tb_rptclr)


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
	tb_flag_Eqcw<=0;
	tb_flag_Eqst<=0;
	tb_flag_Eqcif<=0;
	tb_current_row<=1;
	tb_of_colums<=OF_COLUMS;
	tb_if_rows<=IF_ROWS;
	tb_w_rows<=W_ROWS;
	tb_stride<=STRIDE;
	tb_enable<=0;
	tb_start<=0;
	
	@(posedge tb_clk)
	tb_enable<=1;
	tb_reset<=1;
	@(posedge tb_clk)
	tb_enable<=0;
	@(posedge tb_clk);
	tb_start<=1;
	@(posedge tb_clk);
	tb_start<=0;
	
	
	for(i=0;i<3;i=i+1) begin
		
		@(posedge tb_clk);
		@(posedge tb_clk);
		tb_flag_Eqcw<=1;
		@(negedge tb_clk);
		tb_flag_Eqcw<=0;
	
		@(posedge tb_clk);
		tb_flag_Eqst<=1;
		@(negedge tb_clk);
		tb_flag_Eqst<=0;
	
		@(posedge tb_clk);
		tb_flag_Eqst<=1;
		@(negedge tb_clk);
		tb_flag_Eqst<=0;
	
		@(posedge tb_clk);
		tb_flag_Eqst<=1;
		@(negedge tb_clk);
		tb_flag_Eqst<=0;
	
		@(posedge tb_clk);
		tb_flag_Eqst<=1;
		@(negedge tb_clk);
		tb_flag_Eqst<=0;
	
	end


	$stop;

end


endmodule

