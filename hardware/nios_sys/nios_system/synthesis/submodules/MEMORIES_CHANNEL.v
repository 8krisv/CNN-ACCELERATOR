/*#########################################################################
//# Memories channel
//#########################################################################
//#
//# Copyright (C) 2021 Jose Maria Jaramillo Hoyos ACCELERATOR_DATA_OUT
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

module MEMORIES_CHANNEL #(parameter DATA_WIDTH = 16, MEMORIES_SIZE=16384 ,ADDR_WIDTH = 14) (

//////////// INPUTS //////////
MEMORIES_CHANNEL_Clk,
MEMORIES_CHANNEL_Start,
MEMORIES_CHANNEL_Reset,
MEMORIES_CHANNEL_Select_En,
MEMORIES_CHANNEL_In_Output_Rutine,
MEMORIES_CHANNEL_New_Channel_Flag,
MEMORIES_CHANNEL_Re,
MEMORIES_CHANNEL_Input_Data,

//////////// OUTPUTS //////////
MEMORIES_CHANNEL_Out_Mem1,
MEMORIES_CHANNEL_Out_Mem2,
MEMORIES_CHANNEL_Out_Mem3

);


//=======================================================
//  PORT declarations
//=======================================================
input MEMORIES_CHANNEL_Clk;
input MEMORIES_CHANNEL_Start;
input MEMORIES_CHANNEL_Reset;
input MEMORIES_CHANNEL_Select_En;
input MEMORIES_CHANNEL_In_Output_Rutine;
input MEMORIES_CHANNEL_New_Channel_Flag;
input MEMORIES_CHANNEL_Re;
input [DATA_WIDTH-1:0] MEMORIES_CHANNEL_Input_Data;

output [DATA_WIDTH-1:0] MEMORIES_CHANNEL_Out_Mem1;
output [DATA_WIDTH-1:0] MEMORIES_CHANNEL_Out_Mem2;
output [DATA_WIDTH-1:0] MEMORIES_CHANNEL_Out_Mem3;

//=======================================================
//  Parameter declarations
//=======================================================
localparam CHMEM_Rdinc=1'b1;
localparam CHMEM_Wrinc=1'b1;

//=======================================================
//  REG/WIRE declarations
//=======================================================

wire[DATA_WIDTH-1:0] Demux_Data_Out0;
wire[DATA_WIDTH-1:0] Demux_Data_Out1;
wire[DATA_WIDTH-1:0] Demux_Data_Out2;

wire Demux_We_Out0;
wire Demux_We_Out1;
wire Demux_We_Out2;

wire [1:0] Counter_Ch_Out;

wire Memch_Statemachine_Counter_Ch_Clr;
wire Memch_Statemachine_Chmem1_Clr;
wire Memch_Statemachine_Chmem2_Clr;
wire Memch_Statemachine_Chmem3_Clr;
wire Memch_Statemachine_Counter_En;

//=======================================================
//  Structural coding
//=======================================================


//////////// 1 to 3 Demultiplexer instantiation //////////

DEMUX_1_3 #(.INPUT_DATA_WIDTH(DATA_WIDTH)) Demux_Data (

/////////////// INPUTS ///////////////
.DEMUX_Data_in(MEMORIES_CHANNEL_Input_Data),
.DEMUX_selector(Counter_Ch_Out),
.DEMUX_En(MEMORIES_CHANNEL_Select_En),
/////////////// OUTPUTS ///////////////
.DEMUX_out0(Demux_Data_Out0),
.DEMUX_out1(Demux_Data_Out1),
.DEMUX_out2(Demux_Data_Out2)

);


DEMUX_1_3 #(.INPUT_DATA_WIDTH(1'b1)) Demux_We (

/////////////// INPUTS ///////////////
.DEMUX_Data_in(1'b1),
.DEMUX_selector(Counter_Ch_Out),
.DEMUX_En(MEMORIES_CHANNEL_Select_En),
/////////////// OUTPUTS ///////////////
.DEMUX_out0(Demux_We_Out0),
.DEMUX_out1(Demux_We_Out1),
.DEMUX_out2(Demux_We_Out2)

);


//////////// Counter channel instantiation //////////

COUNTER_CH Counter_Ch(

/////////// INPUTS //////////MEMCH_STATEMACHINE_Mux169_En
.COUNTER_Clk(MEMORIES_CHANNEL_Clk),
.COUNTER_Clr(Memch_Statemachine_Counter_Ch_Clr),
.COUNTER_En(Memch_Statemachine_Counter_En),

//////////// OUTPUTS //////////
.COUNTER_Out(Counter_Ch_Out)

);


//////////// Channel memory 1 instantiation //////////
CHANNEL_MEM #(
.DATA_WIDTH(DATA_WIDTH), 
.MEM_SIZE(MEMORIES_SIZE),
.ADDR_WIDTH(ADDR_WIDTH)) Chmem1
(
//////////// INPUTS //////////
.CHANNEL_MEM_Clk(MEMORIES_CHANNEL_Clk),
.CHANNEL_MEM_We(Demux_We_Out0),
.CHANNEL_MEM_Oe(MEMORIES_CHANNEL_Re),
.CHANNEL_MEM_Rdinc(CHMEM_Rdinc),
.CHANNEL_MEM_Wrinc(CHMEM_Wrinc),
.CHANNEL_MEM_Wptclr(Memch_Statemachine_Chmem1_Clr),
.CHANNEL_MEM_Rptclr(Memch_Statemachine_Chmem1_Clr),
.CHANNEL_MEM_Data_In(Demux_Data_Out0),
//////////// OUTPUT //////////
.CHANNEL_MEM_Data_Out(MEMORIES_CHANNEL_Out_Mem1)
);

//////////// Channel memory 2 instantiation //////////

CHANNEL_MEM #(
.DATA_WIDTH(DATA_WIDTH), 
.MEM_SIZE(MEMORIES_SIZE),
.ADDR_WIDTH(ADDR_WIDTH)) Chmem2
(
//////////// INPUTS //////////
.CHANNEL_MEM_Clk(MEMORIES_CHANNEL_Clk),
.CHANNEL_MEM_We(Demux_We_Out1),
.CHANNEL_MEM_Oe(MEMORIES_CHANNEL_Re),
.CHANNEL_MEM_Rdinc(CHMEM_Rdinc),
.CHANNEL_MEM_Wrinc(CHMEM_Wrinc),
.CHANNEL_MEM_Wptclr(Memch_Statemachine_Chmem2_Clr),
.CHANNEL_MEM_Rptclr(Memch_Statemachine_Chmem2_Clr),
.CHANNEL_MEM_Data_In(Demux_Data_Out1),
//////////// OUTPUT //////////
.CHANNEL_MEM_Data_Out(MEMORIES_CHANNEL_Out_Mem2)
);


//////////// Channel memory 3 instantiation //////////

CHANNEL_MEM #(
.DATA_WIDTH(DATA_WIDTH), 
.MEM_SIZE(MEMORIES_SIZE),
.ADDR_WIDTH(ADDR_WIDTH)) Chmem3
(
//////////// INPUTS //////////
.CHANNEL_MEM_Clk(MEMORIES_CHANNEL_Clk),
.CHANNEL_MEM_We(Demux_We_Out2),
.CHANNEL_MEM_Oe(MEMORIES_CHANNEL_Re),
.CHANNEL_MEM_Rdinc(CHMEM_Rdinc),
.CHANNEL_MEM_Wrinc(CHMEM_Wrinc),
.CHANNEL_MEM_Wptclr(Memch_Statemachine_Chmem3_Clr),
.CHANNEL_MEM_Rptclr(Memch_Statemachine_Chmem3_Clr),
.CHANNEL_MEM_Data_In(Demux_Data_Out2),
//////////// OUTPUT //////////
.CHANNEL_MEM_Data_Out(MEMORIES_CHANNEL_Out_Mem3)
);


//////////// State machine instantiation //////////

MEMCH_STATEMACHINE Memch_Statemachine(

//////////// INPUTS //////////
.MEMCH_STATEMACHINE_Clk(MEMORIES_CHANNEL_Clk),
.MEMCH_STATEMACHINE_Reset(MEMORIES_CHANNEL_Reset),
.MEMCH_STATEMACHINE_Start(MEMORIES_CHANNEL_Start),
.MEMCH_STATEMACHINE_New_Channel_Flag(MEMORIES_CHANNEL_New_Channel_Flag),
.MEMCH_STATEMACHINE_In_Output_Routine(MEMORIES_CHANNEL_In_Output_Rutine),

//////////// OUTPUTS //////////
.MEMCH_STATEMACHINE_Counter_Ch_Clr(Memch_Statemachine_Counter_Ch_Clr),
.MEMCH_STATEMACHINE_Chmem1_Clr(Memch_Statemachine_Chmem1_Clr),
.MEMCH_STATEMACHINE_Chmem2_Clr(Memch_Statemachine_Chmem2_Clr),
.MEMCH_STATEMACHINE_Chmem3_Clr(Memch_Statemachine_Chmem3_Clr),
.MEMCH_STATEMACHINE_Counter_En(Memch_Statemachine_Counter_En)

);





endmodule
