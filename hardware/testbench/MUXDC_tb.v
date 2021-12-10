/*#########################################################################
//# Multiplexers dataflow controller testbench
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

module MUXDC_tb();


parameter LENGTHBUS=9;
parameter BITWIDTH_W_COLUMS=4; 
parameter BITWIDTH_MAX_W_SIZE=9;
integer i;


//////////// INPUTS //////////
reg tb_clk_50;
reg tb_Reset;
reg tb_Set_Conf;
reg tb_Set_Conf_Already_Ok;
reg [BITWIDTH_W_COLUMS-1:0] tb_W_Colums;
reg [BITWIDTH_MAX_W_SIZE-1:0] tb_W_ROXCL; /*w size -1*/

//////////// OUTPUTS //////////
wire [LENGTHBUS-2:0] tb_Muxes_Sel;
wire tb_Set_Conf_Already;

//////////// Device Under Test (DUT) instantiation //////////


MUXDC #(.LENGTHBUS(LENGTHBUS-1)) Muxdc(

//////////// INPUTS //////////
.MUXDC_Clk(tb_clk_50),
.MUXDC_Reset(tb_Reset),
.MUXDC_Set_Conf(tb_Set_Conf),
.MUXDC_Set_Conf_Already_Ok(tb_Set_Conf_Already_Ok),
.MUXDC_W_Colums(tb_W_Colums),
.MUXDC_W_ROXCL(tb_W_ROXCL), /*wrows x colums -1*/

//////////// OUTPUTS //////////
.MUXDC_Muxes_Sel(tb_Muxes_Sel),
.MUXDC_Set_Conf_Already(tb_Set_Conf_Already)

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

	tb_Reset<=0;
	tb_Set_Conf<=0;
	tb_Set_Conf_Already_Ok<=0;
	tb_W_Colums<=3;
	tb_W_ROXCL<=(9-1); /*w size -1*/
	 
	@(negedge tb_clk_50)
	@(posedge tb_clk_50)
	tb_Set_Conf<=1;
	tb_Reset<=1;
	@(negedge tb_clk_50)
	@(posedge tb_clk_50)
	tb_Set_Conf<=0;
	
	for(i=0;tb_Set_Conf_Already == 1'b0 ;i=i+1)begin
		@(negedge tb_clk_50)
		@(posedge tb_clk_50);
	end
	
	tb_Set_Conf_Already_Ok<=1'b1;
	@(negedge tb_clk_50)
	@(posedge tb_clk_50)
	tb_Set_Conf_Already_Ok<=1'b0;
	@(negedge tb_clk_50)
	@(posedge tb_clk_50)
	
	$stop;

end



endmodule

