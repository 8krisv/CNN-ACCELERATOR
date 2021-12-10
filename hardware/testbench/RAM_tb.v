/*#########################################################################
//# Testbench for module Ram
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

module RAM_tb();

//////////// Parameter declarations //////////
parameter tb_data_width=32;
parameter tb_mem_size=1024;
parameter tb_addr_width=10;
parameter tb_clk_period=20; // clock period in ns
integer addr;
integer data;

//////////// Input signals declarations //////////
reg tb_clk;
reg tb_we;
reg tb_oe;
reg [tb_addr_width-1:0] tb_addr;
reg [tb_data_width-1:0] tb_data_in;

//////////// Output signals declarations //////////
wire [tb_data_width-1:0] tb_data_out;
reg  [tb_data_width-1:0] tb_expected_out;

//////////// Device Under Test (DUT) instantiation //////////

RAM #(.DATA_WIDTH(tb_data_width),.MEM_SIZE(tb_mem_size),.ADDR_WIDTH(tb_addr_width)) Ram (

.RAM_Clk(tb_clk),
.RAM_We(tb_we),
.RAM_Oe(tb_oe),
.RAM_Address(tb_addr),
.RAM_Data_In(tb_data_in),
.RAM_Data_Out(tb_data_out)
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
	tb_we<=0;
	tb_oe<=0;
	tb_addr<=0;
	tb_data_in<=0;
	data<=10;
	tb_expected_out<='hz;
	
	for (addr=0; addr<10;addr=addr+1)begin
		@(negedge tb_clk)
			tb_we<=1;
			tb_addr<=addr;
			tb_data_in<=data;
		@(posedge tb_clk)
			tb_we<=1;
			data<=data+10;
	end
	
	@(negedge tb_clk)
	tb_we<=0;
	tb_oe<=0;
	tb_addr<=0;
	tb_data_in<=0;
	data<=10;
	@(posedge tb_clk)
	tb_oe<=1;
	tb_expected_out<=data;
	data<=data+10;
	
	for (addr=1; addr<10;addr=addr+1)begin
		@(negedge tb_clk)
		tb_addr<=addr;
		@(posedge tb_clk)
		tb_expected_out<=data;
		data<=data+10;
		verify_output(tb_data_out,tb_expected_out);
	end
	
	@(negedge tb_clk)
	tb_oe<=0;
	tb_addr<=0;
	data<=10;
	
	$display($time," << Test passed >> ");
	
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

