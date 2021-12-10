/*#########################################################################
//# procesing element dataflow controller testbench
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

module PEDC_tb();

//////////// Parameter declarations //////////

parameter clk_period = 20;
integer i;

//////////// Input signals declarations //////////
reg tb_clk;
reg tb_start_routine;
reg tb_stop_routine;

//////////// Output signals declarations //////////
wire tb_OuReg_set;
wire tb_pe_reset;

//////////// Device Under Test (DUT) instantiation //////////

PEDC Pedc(

//////////// INPUTS //////////
.PEDC_Clk(tb_clk),
.PEDC_Start_Routine(tb_start_routine),
.PEDC_Stop_Routine(tb_stop_routine),

//////////// OUTPUT //////////
.PEDC_OutReg_Set(tb_OuReg_set),
.PEDC_Reset(tb_pe_reset)

);


//////////// create a 50Mhz clock //////////
always
begin
		tb_clk=1'b1;
		#(clk_period/2);
		tb_clk=1'b0;
		#(clk_period/2);
end


initial
begin
	tb_start_routine<=0;
	tb_stop_routine<=0;
	
	@(negedge tb_clk)
	@(posedge tb_clk)
	tb_start_routine<=1;
	@(negedge tb_clk)
	@(posedge tb_clk)
	tb_start_routine<=0;
	
	for(i=0;i<5;i=i+1)begin
		@(negedge tb_clk)
		@(posedge tb_clk);
	end
	
	tb_stop_routine<=1;
	@(negedge tb_clk)
	@(posedge tb_clk)
	tb_stop_routine<=0;
	@(negedge tb_clk)
	@(posedge tb_clk)
	@(negedge tb_clk)
	@(posedge tb_clk)
	
	
	$stop;
	
	
end




endmodule

