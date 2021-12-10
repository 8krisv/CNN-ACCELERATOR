/*#########################################################################
//# On-chip weight memory controller testbench
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

module OWMC_tb();

//////////// Parameter declarations //////////
parameter tb_data_width=8;
parameter tb_mem_size=169;
parameter tb_addr_width=9;
parameter tb_clk_period=20; // clock period in ns
parameter w_size=12;
parameter w_coxrw=4;
parameter w_channels=3;
integer addr;
integer data;
integer ch;

//////////// Input signals declarations //////////
reg tb_clk;
reg tb_reset;
reg [tb_addr_width-1:0] tb_w_size;
reg [tb_addr_width-1:0] tb_w_coxrw;
reg [tb_data_width-1:0] tb_input_data;
reg tb_start_loading_weighs;
reg tb_start_loading_regs;
reg tb_loading_weights_already_ok;
reg tb_loading_regs_already_ok;

//////////// Output signals declarations //////////

wire tb_loading_weights_already;
wire tb_loading_regs_already;
wire [tb_data_width-1:0] tb_output_data;
wire tb_muxes_en;
wire [tb_addr_width-1:0] tb_muxes_sel;

//////////// Device Under Test (DUT) instantiation //////////

OWMC #(.W_DATA_WIDTH(tb_data_width),.W_MEM_SIZE(tb_mem_size),.W_ADDR_WIDTH(tb_addr_width)) Owmc
(
.OWMC_Clk(tb_clk),
.OWMC_Reset(tb_reset),
.OWMC_W_Size(tb_w_size),
.OWMC_W_COXRW(tb_w_coxrw),
.OWMC_Input_Data(tb_input_data),
.OWMC_Start_Loading_Weights(tb_start_loading_weighs),
.OWMC_Start_Loading_Regs(tb_start_loading_regs),
.OWMC_Loading_Weights_Already_Ok(tb_loading_weights_already_ok),
.OWMC_Loading_Regs_Already_Ok(tb_loading_regs_already_ok),
.OWMC_Loading_Weights_Already(tb_loading_weights_already),
.OWMC_Loading_Regs_Already(tb_loading_regs_already),
.OWMC_Output_Data(tb_output_data),
.OWMC_Muxes_En(tb_muxes_en),
.OWMC_Muxes_Sel(tb_muxes_sel)

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
	tb_w_size<=w_size-1;
	tb_w_coxrw<=w_coxrw-1;
	data<=0;
	tb_input_data<='hz;
	tb_start_loading_weighs<=0;
	tb_start_loading_regs<=0;
	tb_loading_weights_already_ok<=0;
	tb_loading_regs_already_ok<=0;
	
	
	$display(" << Cargando matriz de pesos >> ");
	//////////// Rutine to loads weigths //////////
	@(negedge tb_clk)
	data<=data+10;
	@(posedge tb_clk)
	tb_reset<=1;
	tb_start_loading_weighs<=1;
	tb_input_data<=data;
	
	for(addr=1; addr< w_size;addr=addr+1)begin
	@(negedge tb_clk)
	data<=data+10;
	@(posedge tb_clk)
	tb_input_data<=data;
	tb_start_loading_weighs<=0;
	end
	
	@(negedge tb_clk)
	@(posedge tb_clk)
	tb_input_data<='hz;
	@(negedge tb_clk)
	@(posedge tb_clk)
	tb_loading_weights_already_ok<=1;
	@(negedge tb_clk)
	@(posedge tb_clk)
	tb_loading_weights_already_ok<=0;
	@(negedge tb_clk)	
	/////////////////////////////////////////////
	
	
	
	$display(" << Cargando Registros >> ");
	//////////// Rutine to loads wregs //////////
	for (ch=0;ch<w_channels;ch=ch+1)begin
		@(posedge tb_clk)
		tb_start_loading_regs<=1;
	
		for(addr=0; addr< w_coxrw;addr=addr+1)begin
		@(negedge tb_clk)
		@(posedge tb_clk)
		tb_start_loading_regs<=0;
		end
	
		@(negedge tb_clk)
		@(posedge tb_clk)
		@(negedge tb_clk)
		@(posedge tb_clk)
		tb_loading_regs_already_ok<=1;
		@(negedge tb_clk)
		@(posedge tb_clk)
		tb_loading_regs_already_ok<=0;
		@(negedge tb_clk);
	end
	/////////////////////////////////////////////
	@(posedge tb_clk )
	tb_reset<=0;
	@(negedge tb_clk)
	@(posedge tb_clk )
	$stop;

end



endmodule
