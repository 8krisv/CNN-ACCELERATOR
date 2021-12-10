/*#########################################################################
//# Off-chip memory communication interface test bench
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

module OFMI_tb();

//////////// Parameter declarations ////////////

parameter IFPATH = "../files/IF/vin/test-vin.txt";
parameter IF_SIZE=192;
parameter W_SIZE=27;
parameter W_COXRW=9;
parameter OF_SIZE=108;
parameter ADDR_OFFSET=0;
parameter MAXIMSIZE=10800;
parameter MAXWSIZE=507;
parameter W_ADDR_WIDTH=9;
parameter IF_ADDR_WIDTH=22;
parameter MEM_ADDR_WIDTH=22;
parameter W_DATA_WIDTH=8;
parameter IF_DATA_WIDTH=9;
parameter MEM_DATA_WIDTH=32;
localparam MAXMEMSIZE=MAXIMSIZE+MAXWSIZE;
parameter CLK_PERIOD=20;
integer i;

//////////// General Input signals declarations ////////////
reg tb_clk;
reg [IF_ADDR_WIDTH-1:0] tb_if_Size;
reg [IF_ADDR_WIDTH-1:0] tb_of_size;
reg [W_ADDR_WIDTH-1:0] tb_w_size;
reg [W_ADDR_WIDTH-1:0] tb_w_coxrw;
reg tb_loading_weights_already_ok;

//////////// Ofmi input signals ////////////
reg tb_reset_Ofmi;
reg [MEM_ADDR_WIDTH-1:0] tb_Ofmi_addr_offset;
reg tb_Ofmi_start_loading_weights;
reg tb_Ofmi_start_feeding_datapath;
reg tb_Ofmi_stop_feeding_datapath;
reg tb_Ofmi_feeding_datapath_finished_ok;
reg tb_Ofmi_start_writing_data;
reg tb_Ofmi_writing_data_already_ok;

//////////// Owmc input signals ////////////
reg tb_reset_Owmc;
reg tb_Owmc_start_loading_weights;
reg tb_Owmc_start_loading_regs;
reg tb_Owmc_loading_regs_already_ok;


//////////// OffchipRam input signals ////////////
reg [MEM_DATA_WIDTH-1:0] tb_OffchipRam_data_in;


//////////// Ofmi output wires //////////
wire tb_Ofmi_loading_weights_already;
wire tb_Ofmi_feeding_datapath_finished;
wire tb_Ofmi_writing_data_already;
wire tb_Ofmi_Offmem_We;
wire tb_Ofmi_Offmem_Re;
wire [MEM_ADDR_WIDTH-1:0]  tb_Ofmi_Offmem_Addr;
wire tb_Ofmi_Mux_Sel;
wire tb_Ofmi_Mux_En;


//////////// Owmc output wires ////////////
wire tb_Owmc_loading_weights_already;
wire tb_Owmc_loading_regs_already;
wire [W_DATA_WIDTH-1:0] tb_Owmc_output_data;
wire tb_Owmc_muxes_en;
wire [W_ADDR_WIDTH-1:0] tb_Owmc_muxes_sel;


//////////// OffchipRam output wires //////////
wire [MEM_DATA_WIDTH-1:0] tb_OffchipRam_Data_Out;

//////////// Demux output wires //////////
wire [MEM_DATA_WIDTH-1:0] Demux_out0;
wire [MEM_DATA_WIDTH-1:0] Demux_out1;



//////////// Device Under Test (DUT) instantiation //////////
OFMI #(.W_ADDR_WIDTH(W_ADDR_WIDTH),.IF_BITWIDTH_MAXSIZE(IF_ADDR_WIDTH),.OFFMEN_ADDR_WIDTH(MEM_ADDR_WIDTH)) Ofmi
(

//// INPUTS ////
.OFMI_Clk(tb_clk),
.OFMI_Reset(tb_reset_Ofmi),
.OFMI_If_Size(tb_if_Size),
.OFMI_Of_Size(tb_of_size),
.OFMI_W_Size(tb_w_size), 
.OFMI_Addr_Offset(tb_Ofmi_addr_offset),
.OFMI_Mst_Start_Loading_Weights(tb_Ofmi_start_loading_weights),
.OFMI_Mst_Loading_Weights_Already_Ok(tb_loading_weights_already_ok),
.OFMI_Owmc_Loading_Weights_Already(tb_Owmc_loading_weights_already),
.OFMI_Mst_Start_Feeding_Datapath(tb_Ofmi_start_feeding_datapath),
.OFMI_Mst_Stop_Feeding_Datapath(tb_Ofmi_stop_feeding_datapath),
.OFMI_Feeding_Datapath_finished_OK(tb_Ofmi_feeding_datapath_finished_ok),
.OFMI_Mst_Start_Writing_Data(tb_Ofmi_start_writing_data),
.OFMI_Mst_Writing_Data_Already_Ok(tb_Ofmi_writing_data_already_ok),

//// OUTPUTS ////

.OFMI_Mst_Loading_Weights_Already(tb_Ofmi_loading_weights_already),
.OFMI_Mst_Feeding_Datapath_finished(tb_Ofmi_feeding_datapath_finished),
.OFMI_Mst_Writing_Data_Already(tb_Ofmi_writing_data_already),
.OFMI_Offmem_We(tb_Ofmi_Offmem_We),
.OFMI_Offmem_Re(tb_Ofmi_Offmem_Re),
.OFMI_Offmem_Addr(tb_Ofmi_Offmem_Addr),
.OFMI_Mux_Sel(tb_Ofmi_Mux_Sel),
.OFMI_Mux_En(tb_Ofmi_Mux_En)

);

RAM_SIM #(
.DATA_WIDTH(MEM_DATA_WIDTH),
.MEM_SIZE(MAXMEMSIZE),
.ADDR_WIDTH(MEM_ADDR_WIDTH),
.IFPATH(IFPATH)) OffchipRam

(

//// INPUTS ////
.RAM_SIM_Clk(tb_clk),
.RAM_SIM_We(tb_Ofmi_Offmem_We),
.RAM_SIM_Oe(tb_Ofmi_Offmem_Re),
.RAM_SIM_Address(tb_Ofmi_Offmem_Addr),
.RAM_SIM_Data_In(tb_OffchipRam_data_in),

//// OUTPUTS ////
.RAM_SIM_Data_Out(tb_OffchipRam_Data_Out)

);


OWMC #(.W_DATA_WIDTH(W_DATA_WIDTH),.W_MEM_SIZE(MAXWSIZE),.W_ADDR_WIDTH(W_ADDR_WIDTH)) Owmc
(

//// INPUTS ////
.OWMC_Clk(tb_clk),
.OWMC_Reset(tb_reset_Owmc),
.OWMC_W_Size(tb_w_size),
.OWMC_W_COXRW(tb_w_coxrw),
.OWMC_Input_Data(Demux_out0),
.OWMC_Start_Loading_Weights(tb_Owmc_start_loading_weights),
.OWMC_Start_Loading_Regs(tb_Owmc_start_loading_regs),
.OWMC_Loading_Weights_Already_Ok(tb_loading_weights_already_ok),
.OWMC_Loading_Regs_Already_Ok(tb_Owmc_loading_regs_already_ok),

//// OUTPUTS ////
.OWMC_Loading_Weights_Already(tb_Owmc_loading_weights_already),
.OWMC_Loading_Regs_Already(tb_Owmc_loading_regs_already),
.OWMC_Output_Data(tb_Owmc_output_data),
.OWMC_Muxes_En(tb_Owmc_muxes_en),
.OWMC_Muxes_Sel(tb_Owmc_muxes_sel)

);


DEMUX_1_2 #(.INPUT_DATA_WIDTH(MEM_DATA_WIDTH)) Demux
(

//// INPUTS ////
.DEMUX_Data_in(tb_OffchipRam_Data_Out),
.DEMUX_selector(tb_Ofmi_Mux_Sel),
.DEMUX_En(tb_Ofmi_Mux_En),
//// OUTPUTS ////
.DEMUX_out0(Demux_out0),
.DEMUX_out1(Demux_out1)

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
	
	tb_if_Size<=IF_SIZE-1;
	tb_of_size<=OF_SIZE-1;
	tb_w_size<=W_SIZE-1;
	tb_w_coxrw<=W_COXRW-1;
	tb_loading_weights_already_ok<=0;
	tb_reset_Ofmi<=0;
	tb_Ofmi_addr_offset<=ADDR_OFFSET;
	tb_Ofmi_start_loading_weights<=0;
	tb_Ofmi_start_feeding_datapath<=0;
	tb_Ofmi_stop_feeding_datapath<=0;
	tb_Ofmi_feeding_datapath_finished_ok<=0;
	tb_Ofmi_start_writing_data<=0;
	tb_Ofmi_writing_data_already_ok<=0;
	tb_reset_Owmc<=0;
	tb_Owmc_start_loading_weights<=0;
	tb_Owmc_start_loading_regs<=0;
	tb_Owmc_loading_regs_already_ok<=0;
	tb_OffchipRam_data_in<=0;

	
	@(negedge tb_clk)
	@(posedge tb_clk)
	tb_Ofmi_start_loading_weights<=1;
	tb_Owmc_start_loading_weights<=0;
	tb_reset_Ofmi<=1;
	tb_reset_Owmc<=1;
	@(negedge tb_clk)
	@(posedge tb_clk)
	tb_Ofmi_start_loading_weights<=0;
	tb_Owmc_start_loading_weights<=1;
	
	
	for(i=0;tb_Owmc_loading_weights_already==1'b0;i=i+1)begin
		
		@(negedge tb_clk)
		@(posedge tb_clk);
		tb_Owmc_start_loading_weights<=0;
		
	end
	
	@(negedge tb_clk)
	@(posedge tb_clk)
	tb_loading_weights_already_ok<=1;
	@(negedge tb_clk)
	@(posedge tb_clk)
	tb_loading_weights_already_ok<=0;
	@(negedge tb_clk)
	@(posedge tb_clk)
	tb_Ofmi_start_feeding_datapath<=1;
	@(negedge tb_clk)
	@(posedge tb_clk)
	tb_Ofmi_start_feeding_datapath<=0;
	
	for(i=0;tb_Ofmi_feeding_datapath_finished==1'b0;i=i+1)begin
		@(negedge tb_clk)
		@(posedge tb_clk);
		
	end
	
	tb_Ofmi_feeding_datapath_finished_ok<=1;
	@(negedge tb_clk)
	@(posedge tb_clk)
	tb_Ofmi_feeding_datapath_finished_ok<=0;
	
	
	//// Rutine for test stop feeding feature ////
	@(negedge tb_clk)
	@(posedge tb_clk)
	tb_Ofmi_start_feeding_datapath<=1;
	@(negedge tb_clk)
	@(posedge tb_clk)
	tb_Ofmi_start_feeding_datapath<=0;
	
	for(i=0;i<20;i=i+1)begin
		@(negedge tb_clk)
		@(posedge tb_clk);
		
	end
	tb_Ofmi_stop_feeding_datapath<=1;
	
	for(i=0;i<3;i=i+1)begin
		@(negedge tb_clk)
		@(posedge tb_clk)
		tb_Ofmi_stop_feeding_datapath<=0;
	end
	
	tb_Ofmi_start_feeding_datapath<=1;
	@(negedge tb_clk)
	@(posedge tb_clk)
	tb_Ofmi_start_feeding_datapath<=0;

	
	for(i=0;tb_Ofmi_feeding_datapath_finished==1'b0;i=i+1)begin
		@(negedge tb_clk)
		@(posedge tb_clk);
	end
	
	tb_Ofmi_feeding_datapath_finished_ok<=1;
	@(negedge tb_clk)
	@(posedge tb_clk);
	tb_Ofmi_feeding_datapath_finished_ok<=0;
	
	$stop;
	
end
	
	
endmodule

