/*#########################################################################
//# Basic On-chip fifo memory testbench
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

module FIFO_tb();

//////////// Parameter declarations //////////
parameter tb_data_width=16;
parameter tb_fifo_size=720;
parameter tb_addr_width=10;
parameter tb_clk_period=20;
integer i;

//////////// Input signals declarations //////////
reg tb_clk;
reg tb_rdptclr;
reg tb_wrptclr;
reg tb_rdinc;
reg tb_wrdinc;
reg tb_wren;
reg tb_ren;
reg [tb_data_width-1:0] tb_data_in;


//////////// Output signals declarations //////////
wire [tb_data_width-1:0] tb_data_out;
reg [tb_data_width-1:0] tb_expected_output;


//////////// Device Under Test (DUT) instantiation //////////

FIFO #(.DATA_WIDTH(tb_data_width),.FIFO_SIZE(tb_fifo_size), .ADDR_WIDTH(tb_addr_width)) Fifo
(
.FIFO_Clk(tb_clk),
.FIFO_Rdptclr(tb_rdptclr),
.FIFO_Wrptclr(tb_wrptclr),
.FIFO_Rdinc(tb_rdinc),
.FIFO_Wrinc(tb_wrdinc),
.FIFO_Wen(tb_wren),
.FIFO_Ren(tb_ren),
.FIFO_Data_in(tb_data_in),
.FIFO_Data_out(tb_data_out)
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

	tb_rdptclr<=0;
	tb_wrptclr<=0;
	tb_rdinc<=1;
	tb_wrdinc<=1;
	tb_wren<=0;
	tb_ren<=0;
	tb_data_in<=0;
	tb_expected_output<=0;
	
	

	for (i=0;i<9;i=i+1)begin
		
		@(negedge tb_clk)
		tb_rdptclr<=1;
		tb_wrptclr<=1;
		tb_data_in<=i+1;
		tb_wren<=1;
		
		@(posedge tb_clk)
		tb_rdptclr<=1;
		tb_wrptclr<=1;
		tb_data_in<=i+1;
		tb_wren<=0;
		
	end
	
	@(negedge tb_clk)
	@(posedge tb_clk)
	tb_wren<=0;
	@(negedge tb_clk)
	@(posedge tb_clk)
	
	for (i=0;i<9;i=i+1)begin
		
		@(negedge tb_clk)
		tb_rdptclr<=1;
		tb_wrptclr<=1;
		tb_rdinc<=1;
		tb_wrdinc<=1;
		
		@(posedge tb_clk)
		
		tb_rdptclr<=1;
		tb_wrptclr<=1;
		tb_rdinc<=1;
		tb_wrdinc<=1;
		tb_wren<=0;
		tb_ren<=1;
		tb_expected_output<=i+1;
	end
	
	$stop;
	
	
	
end

task verify_output;
	input [tb_data_width-1:0] out;
	input [tb_data_width-1:0] expected_out;
	
	begin
		if(expected_out==out)
			begin
				$display($time," << Correct Output >> ");
			end
		else
			begin
				$error($time," << Error - incorrect output, expected %d, given %d >> ",expected_out,out);
				$stop;
			end
	end
endtask



endmodule



