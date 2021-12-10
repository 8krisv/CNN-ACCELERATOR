/*#########################################################################
//# Testbench for module OUT_REG.v
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

`timescale 1 ns /1 ps // set timescale to ns, ps precision 

module OUT_REG_tb();


//////////// Parameter declarations //////////
parameter tb_data_width=16;
parameter tb_clk_period=20; // clock period in ns
integer i;

//////////// Input signals declarations //////////
reg tb_clk;
reg tb_reset;
reg tb_set;
reg [tb_data_width-1:0] tb_data_in;

//////////// Output signals declarations //////////
wire [tb_data_width-1:0] tb_data_out;


//////////// Device Under Test (DUT) instantiation //////////
OUT_REG #(.REG_DATA_WIDTH(tb_data_width)) Out_Reg(

.OUT_REG_Clk(tb_clk),
.OUT_REG_Reset(tb_reset),
.OUT_REG_Set(tb_set),
.OUT_REG_Input_Data(tb_data_in),
.OUT_REG_Output_Data(tb_data_out)
);

//////////// create a 50Mhz clock //////////
always
begin
		tb_clk=1'b1;
		#(tb_clk_period/2);
		tb_clk=1'b0;
		#(tb_clk_period/2);
end

//////////// Main simulation //////////
initial
begin
	////// At time 0 with the firt positive edge of the clk //////
	$display($time, " << Starting the Simulation >>");
	tb_reset<=1'b0; 
	tb_set<=1'b0;
	tb_data_in<=0;
	
	for (i=0; i<10;i=i+1)begin
		@(negedge tb_clk); // wait at the negative edge
		tb_reset<=1'b1; 
		tb_set<=1'b1;
		tb_data_in<=tb_data_in+1;
		verify_output(tb_data_out,tb_data_in);
		
		@(posedge tb_clk); // wait at the positive edge
		tb_set<=1'b0;
		verify_output(tb_data_out,tb_data_in-1);
	end
	
	$display($time," << Test passed >> ");
	$stop; // end simulation

end


initial 

begin
// print in the monitor whenever the signal change
$monitor($time, " tb_clk=%b, tb_reset=%b, tb_set=%b, Data in=%d, Data out=%d", 
tb_clk,tb_reset,tb_set,tb_data_in,tb_data_out);

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

