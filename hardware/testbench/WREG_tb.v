/*#########################################################################
//# Weight register testbench
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

module WREG_tb();


//////////// Parameter declarations //////////
parameter tb_data_width = 8;
parameter tb_clk_period=20;

//////////// Input signals declarations //////////

reg tb_clk;
reg tb_reset;
reg tb_set;
reg [tb_data_width-1:0] tb_input_data;

//////////// output signals declarations //////////
wire [tb_data_width-1:0] tb_output_data;

//////////// Device Under Test (DUT) instantiation //////////

WREG #(.WREG_DATA_WIDTH(tb_data_width)) Wreg(

//////////// INPUTS //////////
.WREG_Clk(tb_clk),
.WREG_Reset(tb_reset),
.WREG_Set(tb_set),
.WREG_Input_Data(tb_input_data),
//////////// OUTPUTS //////////
.WREG_Output_Data(tb_output_data)


);

//////////// create a 50Mhz clock //////////
always
begin
		tb_clk=1'b1;
		#(tb_clk_period/2);
		tb_clk=1'b0;
		#(tb_clk_period/2);
end


initial
begin
	
	tb_reset<=0;
	tb_set<=0;
	tb_input_data<=0;
	
	@(negedge tb_clk)
	@(posedge tb_clk)
	tb_reset<=1;
	@(negedge tb_clk)
	@(posedge tb_clk)
	tb_set<=1;
	tb_input_data<=4;
	@(negedge tb_clk)
	@(posedge tb_clk)
	tb_set<=0;
	tb_input_data<=0;
	@(negedge tb_clk)
	@(posedge tb_clk)
	@(negedge tb_clk)
	@(posedge tb_clk)
	
	$stop;

end

endmodule
