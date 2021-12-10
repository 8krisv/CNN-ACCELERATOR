/*#########################################################################
//# Testbench for top module Avalon interface ACCELERATOR_AVALON_INTERFACE
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

`timescale 1 ns/1 ps

module ACC_AVALON_INTERFACE_tb();

//=======================================================
//  PARAMETER DECLARATIONS
//=======================================================
int file;
string line;
integer i;
integer j;
integer n;
integer status;
parameter [31:0]  Addr_Offset=9;
parameter OFFMEM_DATA_WIDTH = 32;
parameter OFFMEM_ADDR_WIDTH = 32;
parameter MAX_OFFMEM_SIZE =196716;

parameter string IFPATH [0:100] = {
"../../files/IF/memv/test-vin.txt",
"../../files/IF/memv/1-vin.txt",
"../../files/IF/memv/2-vin.txt",
"../../files/IF/memv/3-vin.txt",
"../../files/IF/memv/4-vin.txt",
"../../files/IF/memv/5-vin.txt",
"../../files/IF/memv/6-vin.txt",
"../../files/IF/memv/7-vin.txt",
"../../files/IF/memv/8-vin.txt",
"../../files/IF/memv/9-vin.txt",
"../../files/IF/memv/10-vin.txt",
"../../files/IF/memv/11-vin.txt",
"../../files/IF/memv/12-vin.txt",
"../../files/IF/memv/13-vin.txt",
"../../files/IF/memv/14-vin.txt",
"../../files/IF/memv/15-vin.txt",
"../../files/IF/memv/16-vin.txt",
"../../files/IF/memv/17-vin.txt",
"../../files/IF/memv/18-vin.txt",
"../../files/IF/memv/19-vin.txt",
"../../files/IF/memv/20-vin.txt",
"../../files/IF/memv/21-vin.txt",
"../../files/IF/memv/22-vin.txt",
"../../files/IF/memv/23-vin.txt",
"../../files/IF/memv/24-vin.txt",
"../../files/IF/memv/25-vin.txt",
"../../files/IF/memv/26-vin.txt",
"../../files/IF/memv/27-vin.txt",
"../../files/IF/memv/28-vin.txt",
"../../files/IF/memv/29-vin.txt",
"../../files/IF/memv/30-vin.txt",
"../../files/IF/memv/31-vin.txt",
"../../files/IF/memv/32-vin.txt",
"../../files/IF/memv/33-vin.txt",
"../../files/IF/memv/34-vin.txt",
"../../files/IF/memv/35-vin.txt",
"../../files/IF/memv/36-vin.txt",
"../../files/IF/memv/37-vin.txt",
"../../files/IF/memv/38-vin.txt",
"../../files/IF/memv/39-vin.txt",
"../../files/IF/memv/40-vin.txt",
"../../files/IF/memv/41-vin.txt",
"../../files/IF/memv/42-vin.txt",
"../../files/IF/memv/43-vin.txt",
"../../files/IF/memv/44-vin.txt",
"../../files/IF/memv/45-vin.txt",
"../../files/IF/memv/46-vin.txt",
"../../files/IF/memv/47-vin.txt",
"../../files/IF/memv/48-vin.txt",
"../../files/IF/memv/49-vin.txt",
"../../files/IF/memv/50-vin.txt",
"../../files/IF/memv/51-vin.txt",
"../../files/IF/memv/52-vin.txt",
"../../files/IF/memv/53-vin.txt",
"../../files/IF/memv/54-vin.txt",
"../../files/IF/memv/55-vin.txt",
"../../files/IF/memv/56-vin.txt",
"../../files/IF/memv/57-vin.txt",
"../../files/IF/memv/58-vin.txt",
"../../files/IF/memv/59-vin.txt",
"../../files/IF/memv/60-vin.txt",
"../../files/IF/memv/61-vin.txt",
"../../files/IF/memv/62-vin.txt",
"../../files/IF/memv/63-vin.txt",
"../../files/IF/memv/64-vin.txt",
"../../files/IF/memv/65-vin.txt",
"../../files/IF/memv/66-vin.txt",
"../../files/IF/memv/67-vin.txt",
"../../files/IF/memv/68-vin.txt",
"../../files/IF/memv/69-vin.txt",
"../../files/IF/memv/70-vin.txt",
"../../files/IF/memv/71-vin.txt",
"../../files/IF/memv/72-vin.txt",
"../../files/IF/memv/73-vin.txt",
"../../files/IF/memv/74-vin.txt",
"../../files/IF/memv/75-vin.txt",
"../../files/IF/memv/76-vin.txt",
"../../files/IF/memv/77-vin.txt",
"../../files/IF/memv/78-vin.txt",
"../../files/IF/memv/79-vin.txt",
"../../files/IF/memv/80-vin.txt",
"../../files/IF/memv/81-vin.txt",
"../../files/IF/memv/82-vin.txt",
"../../files/IF/memv/83-vin.txt",
"../../files/IF/memv/84-vin.txt",
"../../files/IF/memv/85-vin.txt",
"../../files/IF/memv/86-vin.txt",
"../../files/IF/memv/87-vin.txt",
"../../files/IF/memv/88-vin.txt",
"../../files/IF/memv/89-vin.txt",
"../../files/IF/memv/90-vin.txt",
"../../files/IF/memv/91-vin.txt",
"../../files/IF/memv/92-vin.txt",
"../../files/IF/memv/93-vin.txt",
"../../files/IF/memv/94-vin.txt",
"../../files/IF/memv/95-vin.txt",
"../../files/IF/memv/96-vin.txt",
"../../files/IF/memv/97-vin.txt",
"../../files/IF/memv/98-vin.txt",
"../../files/IF/memv/99-vin.txt",
"../../files/IF/memv/100-vin.txt"
};


parameter string OFPATH [0:100]= {
"../../files/OF/simout/test-out.txt",
"../../files/OF/simout/1-out.txt",
"../../files/OF/simout/2-out.txt",
"../../files/OF/simout/3-out.txt",
"../../files/OF/simout/4-out.txt",
"../../files/OF/simout/5-out.txt",
"../../files/OF/simout/6-out.txt",
"../../files/OF/simout/7-out.txt",
"../../files/OF/simout/8-out.txt",
"../../files/OF/simout/9-out.txt",
"../../files/OF/simout/10-out.txt",
"../../files/OF/simout/11-out.txt",
"../../files/OF/simout/12-out.txt",
"../../files/OF/simout/13-out.txt",
"../../files/OF/simout/14-out.txt",
"../../files/OF/simout/15-out.txt",
"../../files/OF/simout/16-out.txt",
"../../files/OF/simout/17-out.txt",
"../../files/OF/simout/18-out.txt",
"../../files/OF/simout/19-out.txt",
"../../files/OF/simout/20-out.txt",
"../../files/OF/simout/21-out.txt",
"../../files/OF/simout/22-out.txt",
"../../files/OF/simout/23-out.txt",
"../../files/OF/simout/24-out.txt",
"../../files/OF/simout/25-out.txt",
"../../files/OF/simout/26-out.txt",
"../../files/OF/simout/27-out.txt",
"../../files/OF/simout/28-out.txt",
"../../files/OF/simout/29-out.txt",
"../../files/OF/simout/30-out.txt",
"../../files/OF/simout/31-out.txt",
"../../files/OF/simout/32-out.txt",
"../../files/OF/simout/33-out.txt",
"../../files/OF/simout/34-out.txt",
"../../files/OF/simout/35-out.txt",
"../../files/OF/simout/36-out.txt",
"../../files/OF/simout/37-out.txt",
"../../files/OF/simout/38-out.txt",
"../../files/OF/simout/39-out.txt",
"../../files/OF/simout/40-out.txt",
"../../files/OF/simout/41-out.txt",
"../../files/OF/simout/42-out.txt",
"../../files/OF/simout/43-out.txt",
"../../files/OF/simout/44-out.txt",
"../../files/OF/simout/45-out.txt",
"../../files/OF/simout/46-out.txt",
"../../files/OF/simout/47-out.txt",
"../../files/OF/simout/48-out.txt",
"../../files/OF/simout/49-out.txt",
"../../files/OF/simout/50-out.txt",
"../../files/OF/simout/51-out.txt",
"../../files/OF/simout/52-out.txt",
"../../files/OF/simout/53-out.txt",
"../../files/OF/simout/54-out.txt",
"../../files/OF/simout/55-out.txt",
"../../files/OF/simout/56-out.txt",
"../../files/OF/simout/57-out.txt",
"../../files/OF/simout/58-out.txt",
"../../files/OF/simout/59-out.txt",
"../../files/OF/simout/60-out.txt",
"../../files/OF/simout/61-out.txt",
"../../files/OF/simout/62-out.txt",
"../../files/OF/simout/63-out.txt",
"../../files/OF/simout/64-out.txt",
"../../files/OF/simout/65-out.txt",
"../../files/OF/simout/66-out.txt",
"../../files/OF/simout/67-out.txt",
"../../files/OF/simout/68-out.txt",
"../../files/OF/simout/69-out.txt",
"../../files/OF/simout/70-out.txt",
"../../files/OF/simout/71-out.txt",
"../../files/OF/simout/72-out.txt",
"../../files/OF/simout/73-out.txt",
"../../files/OF/simout/74-out.txt",
"../../files/OF/simout/75-out.txt",
"../../files/OF/simout/76-out.txt",
"../../files/OF/simout/77-out.txt",
"../../files/OF/simout/78-out.txt",
"../../files/OF/simout/79-out.txt",
"../../files/OF/simout/80-out.txt",
"../../files/OF/simout/81-out.txt",
"../../files/OF/simout/82-out.txt",
"../../files/OF/simout/83-out.txt",
"../../files/OF/simout/84-out.txt",
"../../files/OF/simout/85-out.txt",
"../../files/OF/simout/86-out.txt",
"../../files/OF/simout/87-out.txt",
"../../files/OF/simout/88-out.txt",
"../../files/OF/simout/89-out.txt",
"../../files/OF/simout/90-out.txt",
"../../files/OF/simout/91-out.txt",
"../../files/OF/simout/92-out.txt",
"../../files/OF/simout/93-out.txt",
"../../files/OF/simout/94-out.txt",
"../../files/OF/simout/95-out.txt",
"../../files/OF/simout/96-out.txt",
"../../files/OF/simout/97-out.txt",
"../../files/OF/simout/98-out.txt",
"../../files/OF/simout/99-out.txt",
"../../files/OF/simout/100-out.txt"
};

//=======================================================
//  REG/WIRE Declarations
//=======================================================

//////////// ACCELERATOR INPUTS //////////
reg tb_clk_50;
reg tb_reset;
reg tb_m0_waitrequest;
reg [3:0] tb_s0_adress;
reg tb_s0_read;
reg tb_s0_write;
reg [31:0] tb_s0_writedata;
reg tb_s0_chipselect;
reg tb_Counduit_Same_W;
reg tb_Counduit_Start;
reg tb_Counduit_Finished_Ok;


//////////// RAM INPUTS //////////
reg tb_ram_save;
reg tb_ram_load;
reg [31:0] tb_final_addr;
reg [7:0]  tb_counter;
reg [OFFMEM_DATA_WIDTH-1:0] Conf_Regs [0:MAX_OFFMEM_SIZE];

//////////// ACCELERATOR OUTPUTS //////////
wire [31:0] tb_m0_adress;
wire [3:0] tb_m0_byteenable;
wire tb_m0_read;
wire [31:0] tb_s0_readdata;
wire tb_m0_write;
wire [31:0] tb_m0_writedata;
wire tb_Counduit_Finished;
wire [31:0] ram_data_out;



//////////// Device Under Test (DUT) instantiation //////////

RAM_SIM #(
.DATA_WIDTH(OFFMEM_DATA_WIDTH),
.MEM_SIZE(MAX_OFFMEM_SIZE),
.ADDR_WIDTH(OFFMEM_ADDR_WIDTH),
.IFPATH(IFPATH),
.OFPATH(OFPATH)) OffchipRam

(
//// INPUTS ////
.RAM_SIM_Clk(tb_clk_50),
.RAM_SIM_We(tb_m0_write),
.RAM_SIM_Oe(tb_m0_read),
.RAM_SIM_Save(tb_ram_save),
.RAM_SIM_Final_Addr(tb_final_addr),
.RAM_SIM_Load(tb_ram_load),
.RAM_SIM_Counter(tb_counter),
.RAM_SIM_Address(tb_m0_adress),
.RAM_SIM_Data_In(tb_m0_writedata),

//// OUTPUTS ////
.RAM_SIM_Data_Out(ram_data_out)
);


ACCELERATOR_AVALON_INTERFACE Av_is(

//////////// INPUTS //////////
.AVS_Clk(tb_clk_50),
.AVS_Reset(tb_reset),
.AVS_m0_readdata(ram_data_out),
.AVS_m0_waitrequest(tb_m0_waitrequest),
.AVS_s0_adress(tb_s0_adress),
.AVS_s0_read(tb_s0_read),
.AVS_s0_write(tb_s0_write),
.AVS_s0_writedata(tb_s0_writedata),
.AVS_s0_chipselect(tb_s0_chipselect),
.AVS_Counduit_Same_W(tb_Counduit_Same_W),
.AVS_Counduit_Start(tb_Counduit_Start),
.AVS_Counduit_Finished_Ok(tb_Counduit_Finished_Ok),

//////////// OUTPUTS //////////
.AVS_m0_adress(tb_m0_adress),
.AVS_m0_byteenable(tb_m0_byteenable),
.AVS_m0_read(tb_m0_read),
.AVS_s0_readdata(tb_s0_readdata),
.AVS_m0_write(tb_m0_write),
.AVS_m0_writedata(tb_m0_writedata),
.AVS_Counduit_Finished(tb_Counduit_Finished)
);



//////////// create a 50Mhz clock //////////
always
begin
		tb_clk_50=1'b1;
		#1;
		tb_clk_50=1'b0;
		#1;
end



initial

begin

	tb_counter<=8'd0;

	$display("Iniciando Test...");
	
	for (j=0; j<=100;j=j+1) 
	begin
	
		$display("Procesando archivo %s ...",IFPATH[j]);
		
		$readmemh(IFPATH[j],Conf_Regs);
				
		tb_m0_waitrequest<=1'b0;
		tb_s0_adress<=4'd0;
		tb_s0_read<=1'b0;
		tb_s0_write<=1'b0;
		tb_s0_writedata<=32'b0;
		tb_s0_chipselect<=1'b0;
		tb_Counduit_Same_W<=1'b0;
		tb_Counduit_Start<=1'b0;
		tb_Counduit_Finished_Ok<=1'b0;
		tb_reset<=1'b0;
		tb_ram_save<=1'b0;
		tb_ram_load<=1'b1;
		
		
		@(negedge tb_clk_50)
		tb_ram_load<=1'b0;
		@(posedge tb_clk_50)
		tb_reset<=1'b1;
		tb_final_addr<=(Conf_Regs[6]*Conf_Regs[7])-1+9;
	
		@(negedge tb_clk_50)
		tb_s0_chipselect<=1'b1;
		tb_s0_write<=1'b1;
		tb_s0_adress<=4'd0;
		tb_s0_writedata<=Addr_Offset; /// offset
		@(posedge tb_clk_50)
	
		@(negedge tb_clk_50)
		tb_s0_adress<=4'd1;
		tb_s0_writedata<=Conf_Regs[0]; /// if_rows
		@(posedge tb_clk_50)
	
		@(negedge tb_clk_50)
		tb_s0_adress<=4'd2;
		tb_s0_writedata<=Conf_Regs[1]; /// if_colums
		@(posedge tb_clk_50)
	
		@(negedge tb_clk_50)
		tb_s0_adress<=4'd3;
		tb_s0_writedata<=Conf_Regs[2]; /// if_channels
		@(posedge tb_clk_50);
	
		@(negedge tb_clk_50)
		tb_s0_adress<=4'd4;
		tb_s0_writedata<=Conf_Regs[3]; /// w_rows
		@(posedge tb_clk_50);

		@(negedge tb_clk_50)
		tb_s0_adress<=4'd5;
		tb_s0_writedata<=Conf_Regs[4]; /// w_colums
		@(posedge tb_clk_50);
	
		@(negedge tb_clk_50)
		tb_s0_adress<=4'd6;
		tb_s0_writedata<=Conf_Regs[5]; /// w_channels
		@(posedge tb_clk_50);
	
		@(negedge tb_clk_50)
		tb_s0_adress<=4'd7;
		tb_s0_writedata<=Conf_Regs[6]; /// of_rows
		@(posedge tb_clk_50);
	
		@(negedge tb_clk_50)
		tb_s0_adress<=4'd8;
		tb_s0_writedata<=Conf_Regs[7]; /// of_colums
		@(posedge tb_clk_50);
	
		@(negedge tb_clk_50)
		tb_s0_adress<=4'd9;
		tb_s0_writedata<=Conf_Regs[8]; /// stride
		@(posedge tb_clk_50);
	
		@(negedge tb_clk_50)
		@(posedge tb_clk_50)
		tb_s0_chipselect<=1'b0;
		tb_s0_write<=1'b0;
		
		@(negedge tb_clk_50)
		@(posedge tb_clk_50)
		tb_Counduit_Start<=1;
		@(negedge tb_clk_50)
		@(posedge tb_clk_50)
		tb_Counduit_Start<=0;
	
		for(i=0;tb_Counduit_Finished==1'b0;i=i+1)begin
			@(negedge tb_clk_50)
			@(posedge tb_clk_50);
		end
		tb_Counduit_Finished_Ok<=1;
		$display("Guardando archivo %s ...",OFPATH[j]);
		tb_ram_save<=1;
		$fclose(file);
		@(negedge tb_clk_50)
		@(posedge tb_clk_50);
		tb_ram_save<=0;
		tb_counter<=tb_counter+1'b1;
		
		
	end
	
		@(negedge tb_clk_50)
		$display("Total archivos procesados: %d",tb_counter);
		
		$stop;
	
end


endmodule

