/*#########################################################################
//# Reconfigurable bus test bench
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

module RBUS_tb ();


parameter BITWIDTH_W_COLUMS= 4;
parameter BITWIDTH_MAX_W_SIZE= 9;
parameter LENGTHBUS=9;
integer i;


//////////// INPUTS //////////
reg tb_clk_50;
reg tb_Reset;
reg tb_Set_Conf;
reg tb_Set_Conf_Already_Ok;
reg [BITWIDTH_W_COLUMS-1:0] tb_W_Colums;
reg [BITWIDTH_MAX_W_SIZE-1:0] tb_W_ROXCL; /*w size -1*/
reg tb_SetEn0;
reg tb_SetEn1;
reg tb_SetEn2;
reg tb_SetEn3;
reg tb_SetEn4;
reg tb_SetEn5;
reg tb_SetEn6;
reg tb_SetEn7;
reg tb_SetEn8;
reg tb_SetEn9;
reg tb_SetEn10;
reg tb_SetEn11;
reg tb_SetEn12;
reg tb_OEn0;
reg tb_OEn1;
reg tb_OEn2;
reg tb_OEn3;
reg tb_OEn4;
reg tb_OEn5;
reg tb_OEn6;
reg tb_OEn7;
reg tb_OEn8;
reg tb_OEn9;
reg tb_OEn10;
reg tb_OEn11;
reg tb_OEn12;
reg tb_Wptclr0;
reg tb_Wptclr1;
reg tb_Wptclr2;
reg tb_Wptclr3;
reg tb_Wptclr4;
reg tb_Wptclr5;
reg tb_Wptclr6;
reg tb_Wptclr7;
reg tb_Wptclr8;
reg tb_Wptclr9;
reg tb_Wptclr10;
reg tb_Wptclr11;
reg tb_Wptclr12;
reg tb_Rptclr0;
reg tb_Rptclr1;
reg tb_Rptclr2;
reg tb_Rptclr3;
reg tb_Rptclr4;
reg tb_Rptclr5;
reg tb_Rptclr6;
reg tb_Rptclr7;
reg tb_Rptclr8;
reg tb_Rptclr9;
reg tb_Rptclr10;
reg tb_Rptclr11;
reg tb_Rptclr12;

//////////// OUTPUTS //////////
wire [LENGTHBUS-1:0] tb_Om_SetEn;
wire [LENGTHBUS-1:0] tb_Om_OEn;
wire [LENGTHBUS-1:0] tb_Om_Wptclr;
wire [LENGTHBUS-1:0] tb_Om_Rptclr;
wire tb_Set_Conf_Already;

//////////// Device Under Test (DUT) instantiation //////////

RBUS #(.LENGTHBUS(LENGTHBUS)) Rbus
(
//////////// INPUTS //////////
.RBUS_Clk(tb_clk_50),
.RBUS_Reset(tb_Reset),
.RBUS_Set_Conf(tb_Set_Conf),
.RBUS_Set_Conf_Already_Ok(tb_Set_Conf_Already_Ok),
.RBUS_W_Colums(tb_W_Colums),
.RBUS_W_ROXCL(tb_W_ROXCL), /*wrows x colums -1*/

.RBUS_SetEn0(tb_SetEn0),
.RBUS_SetEn1(tb_SetEn1),
.RBUS_SetEn2(tb_SetEn2),
.RBUS_SetEn3(tb_SetEn3),
.RBUS_SetEn4(tb_SetEn4),
.RBUS_SetEn5(tb_SetEn5),
.RBUS_SetEn6(tb_SetEn6),
.RBUS_SetEn7(tb_SetEn7),
.RBUS_SetEn8(tb_SetEn8),
.RBUS_SetEn9(tb_SetEn9),
.RBUS_SetEn10(tb_SetEn10),
.RBUS_SetEn11(tb_SetEn11),
.RBUS_SetEn12(tb_SetEn12),
.RBUS_OEn0(tb_OEn0),
.RBUS_OEn1(tb_OEn1),
.RBUS_OEn2(tb_OEn2),
.RBUS_OEn3(tb_OEn3),
.RBUS_OEn4(tb_OEn4),
.RBUS_OEn5(tb_OEn5),
.RBUS_OEn6(tb_OEn6),
.RBUS_OEn7(tb_OEn7),
.RBUS_OEn8(tb_OEn8),
.RBUS_OEn9(tb_OEn9),
.RBUS_OEn10(tb_OEn10),
.RBUS_OEn11(tb_OEn11),
.RBUS_OEn12(tb_OEn12),
.RBUS_Wptclr0(tb_Wptclr0),
.RBUS_Wptclr1(tb_Wptclr1),
.RBUS_Wptclr2(tb_Wptclr2),
.RBUS_Wptclr3(tb_Wptclr3),
.RBUS_Wptclr4(tb_Wptclr4),
.RBUS_Wptclr5(tb_Wptclr5),
.RBUS_Wptclr6(tb_Wptclr6),
.RBUS_Wptclr7(tb_Wptclr7),
.RBUS_Wptclr8(tb_Wptclr8),
.RBUS_Wptclr9(tb_Wptclr9),
.RBUS_Wptclr10(tb_Wptclr10),
.RBUS_Wptclr11(tb_Wptclr11),
.RBUS_Wptclr12(tb_Wptclr12),
.RBUS_Rptclr0(tb_Rptclr0),
.RBUS_Rptclr1(tb_Rptclr1),
.RBUS_Rptclr2(tb_Rptclr2),
.RBUS_Rptclr3(tb_Rptclr3),
.RBUS_Rptclr4(tb_Rptclr4),
.RBUS_Rptclr5(tb_Rptclr5),
.RBUS_Rptclr6(tb_Rptclr6),
.RBUS_Rptclr7(tb_Rptclr7),
.RBUS_Rptclr8(tb_Rptclr8),
.RBUS_Rptclr9(tb_Rptclr9),
.RBUS_Rptclr10(tb_Rptclr10),
.RBUS_Rptclr11(tb_Rptclr11),
.RBUS_Rptclr12(tb_Rptclr12),

//////////// OUTPUTS //////////
.RBUS_Om_SetEn(tb_Om_SetEn),
.RBUS_Om_OEn(tb_Om_OEn),
.RBUS_Om_Wptclr(tb_Om_Wptclr),
.RBUS_Om_Rptclr(tb_Om_Rptclr),
.RBUS_Set_Conf_Already(tb_Set_Conf_Already)

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
	tb_SetEn0<=1;
	tb_SetEn1<=1;
	tb_SetEn2<=1;
	tb_SetEn3<=0;
	tb_SetEn4<=0;
	tb_SetEn5<=0;
	tb_SetEn6<=0;
	tb_SetEn7<=0;
	tb_SetEn8<=0;
	tb_SetEn9<=0;
	tb_SetEn10<=0;
	tb_SetEn11<=0;
	tb_SetEn12<=0;	
	tb_OEn0<=1;
	tb_OEn1<=1;
	tb_OEn2<=1;
	tb_OEn3<=0;
	tb_OEn4<=0;
	tb_OEn5<=0;
	tb_OEn6<=0;
	tb_OEn7<=0;
	tb_OEn8<=0;
	tb_OEn9<=0;
	tb_OEn10<=0;
	tb_OEn11<=0;
	tb_OEn12<=0;
	tb_Wptclr0<=1;
	tb_Wptclr1<=1;
	tb_Wptclr2<=1;
	tb_Wptclr3<=0;
	tb_Wptclr4<=0;
	tb_Wptclr5<=0;
	tb_Wptclr6<=0;
	tb_Wptclr7<=0;
	tb_Wptclr8<=0;
	tb_Wptclr9<=0;
	tb_Wptclr10<=0;
	tb_Wptclr11<=0;
	tb_Wptclr12<=0;
	tb_Rptclr0<=1;
	tb_Rptclr1<=1;
	tb_Rptclr2<=1;
	tb_Rptclr3<=0;
	tb_Rptclr4<=0;
	tb_Rptclr5<=0;
	tb_Rptclr6<=0;
	tb_Rptclr7<=0;
	tb_Rptclr8<=0;
	tb_Rptclr9<=0;
	tb_Rptclr10<=0;
	tb_Rptclr11<=0;
	tb_Rptclr12<=0;

	
	@(negedge tb_clk_50)
	@(posedge tb_clk_50)
	tb_Set_Conf<=1;
	tb_Reset<=1;

	
	for(i=0;tb_Set_Conf_Already == 1'b0;i=i+1)begin
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

