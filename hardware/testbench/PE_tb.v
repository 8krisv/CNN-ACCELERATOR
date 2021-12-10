/*#########################################################################
//# Testbench for the basic procesing elements PE
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

module PE_tb();


//////////// Parameter declarations //////////
parameter tb_px_width=9;
parameter tb_w_width=9;
parameter tb_data_out_width=9;
parameter tb_clk_period=20; // clock period in ns
integer i;

//////////// Input signals declarations //////////
reg tb_clk;
reg tb_reg_set;
reg tb_reset;
reg tb_fifo_set;
reg [tb_data_out_width-1:0] tb_is;
reg [tb_px_width-1:0]tb_if_px;
reg [tb_w_width-1:0] tb_w;

//////////// Output signals declarations //////////
wire [tb_data_out_width-1:0] tb_out;
reg  [tb_data_out_width-1:0] tb_expected_out;

//////////// Device Under Test (DUT) instantiation //////////

PE #(.PX_WIDTH(tb_px_width),.W_WIDTH(tb_w_width),.DATA_OUT_WIDTH(tb_data_out_width)) Pe(

.PE_Clk(tb_clk),
.PE_Out_Reg_Set(tb_reg_set),
.PE_Reset(tb_reset),
.PE_Fifo_Set(tb_fifo_set),
.PE_Is(tb_is),
.PE_If_Px(tb_if_px),
.PE_w(tb_w),
.PE_Out(tb_out)
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

	$display($time, " << Starting the Simulation >>");

	tb_reset<=0;
	tb_reg_set<=0;
	tb_fifo_set<=0;
	tb_is<=4;
	tb_if_px<=5;
	tb_w<=-2;
	tb_expected_out<=0;
	
	/// first half with fifo set signal set to 0 
	
	for (i=0; i<5;i=i+1)begin
	
		@(negedge tb_clk)
		tb_reset<=1;
		tb_reg_set<=1;
		tb_fifo_set<=0;
		verify_output(tb_out,tb_expected_out);
		
	
		@(posedge tb_clk)
		tb_reg_set<=0;
		tb_reset<=1;
		tb_fifo_set<=0;
		tb_expected_out<= (tb_if_px*tb_w) + tb_is;
		verify_output(tb_out,tb_expected_out);
		tb_if_px<=tb_if_px+1;
		tb_is<=tb_is+1;
		
	end
	
	
	/// second half with fifo set signal set to 1 in even iterations
	
	for (i=0; i<5;i=i+1)begin
	
		@(negedge tb_clk)
		tb_reset<=1;
		tb_reg_set<=1;
		
		if((i%2)==0)
			begin
				tb_fifo_set<=1;
				tb_expected_out<=(tb_if_px*tb_w) + tb_is;
				verify_output(tb_out,tb_expected_out);
			end
	
		else
			tb_fifo_set<=0;
	
		@(posedge tb_clk)
		tb_reg_set<=0;
		tb_reset<=1;
		tb_fifo_set<=0;
		tb_expected_out<= (tb_if_px*tb_w) + tb_is;
		verify_output(tb_out,tb_expected_out);
		tb_if_px<=tb_if_px+1;
		tb_is<=tb_is+1;
		
	end
	
	$display($time," << Test passed >> ");
	
	$stop;

end


task verify_output;
	input [tb_data_out_width-1:0] out;
	input [tb_data_out_width-1:0] expected_out;
	
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

