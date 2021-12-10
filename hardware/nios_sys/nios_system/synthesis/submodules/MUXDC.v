/*#########################################################################
//# Multiplexers dataflow controller
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

module MUXDC #(parameter LENGTHBUS=168, BITWIDTH_W_COLUMS=4, BITWIDTH_MAX_W_SIZE=9)(

//////////// INPUTS //////////
input MUXDC_Clk,
input MUXDC_Reset,
input MUXDC_Set_Conf,
input MUXDC_Set_Conf_Already_Ok,
input [BITWIDTH_W_COLUMS-1:0] MUXDC_W_Colums,
input [BITWIDTH_MAX_W_SIZE-1:0] MUXDC_W_ROXCL, /*wrows x colums -1*/

//////////// OUTPUTS //////////
output reg [0:LENGTHBUS-1] MUXDC_Muxes_Sel,
output MUXDC_Set_Conf_Already

);


//=======================================================
//  LOCAL PARAMETER
//=======================================================
localparam [7:0] Counter_Bus_Number = LENGTHBUS[7:0] -8'b1;
localparam [BITWIDTH_W_COLUMS-1:0] data1_4= 4'd1;

//=======================================================
//  REG/WIRE DECLARATIONS
//=======================================================

wire Counter_Bus_Eqn_Flag;
wire [7:0] Counter_Bus_Out;
wire [BITWIDTH_MAX_W_SIZE-1:0] Counter_W_Size_Out;
wire Counter_W_Size_Eqn_Flag;
wire [BITWIDTH_W_COLUMS-1:0] Counter_W_Col_Out;
wire Counter_W_Col_Eqn_Flag;
wire Counter_W_Col_Load;

wire Muxdc_Statemachine_Counter_W_Size_En;
wire Muxdc_Statemachine_Counter_W_Size_Clr;
wire Muxdc_Statemachine_Counter_W_Col_En;
wire Muxdc_Statemachine_Counter_W_Col_Load;
wire Muxdc_Statemachine_Counter_W_Col_Clr;
wire Muxdc_Statemachine_Counter_Bus_En;
wire Muxdc_Statemachine_Counter_Bus_Clr;
wire Muxdc_Statemachine_Conf_Rutine;


reg Counter_W_Col_Load_1;
//============================================================
// SEQUENTIAL LOGIC
//============================================================

always@(negedge MUXDC_Clk)
begin

 if(Muxdc_Statemachine_Conf_Rutine)
	begin
		
		if(Counter_W_Col_Eqn_Flag) begin
			MUXDC_Muxes_Sel[Counter_Bus_Out]<=1'b1;
			Counter_W_Col_Load_1<=1'b1;	
		end
	
		else
		begin
			MUXDC_Muxes_Sel[Counter_Bus_Out]<=1'b0;
			Counter_W_Col_Load_1<=1'b0;
		end
		
	end
end

//=======================================================
//  Structural coding
//=======================================================

SIMPLE_COUNTER  #(.BITWIDTH(8)) Counter_Bus(
/////////// INPUTS //////////
.COUNTER_Clk(MUXDC_Clk),
.COUNTER_Clr(Muxdc_Statemachine_Counter_Bus_Clr),
.COUNTER_En(Muxdc_Statemachine_Counter_Bus_En),
.COUNTER_Number(Counter_Bus_Number),

//////////// OUTPUTS //////////
.COUNTER_Out(Counter_Bus_Out),
.COUNTER_Eqn_Flag(Counter_Bus_Eqn_Flag)

);


SIMPLE_COUNTER #(.BITWIDTH(BITWIDTH_MAX_W_SIZE)) Counter_W_Size(
/////////// INPUTS //////////
.COUNTER_Clk(MUXDC_Clk),
.COUNTER_Clr(Muxdc_Statemachine_Counter_W_Size_Clr),
.COUNTER_En(Muxdc_Statemachine_Counter_W_Size_En),
.COUNTER_Number(MUXDC_W_ROXCL),

//////////// OUTPUTS //////////
.COUNTER_Out(Counter_W_Size_Out),
.COUNTER_Eqn_Flag(Counter_W_Size_Eqn_Flag)

);



COUNTER_POS #(.BITWIDTH(BITWIDTH_W_COLUMS)) Counter_W_Col(
/////////// INPUTS //////////
.COUNTER_Clk(MUXDC_Clk),
.COUNTER_Clr(Muxdc_Statemachine_Counter_W_Col_Clr),
.COUNTER_En(Muxdc_Statemachine_Counter_W_Col_En),
.COUNTER_load(Counter_W_Col_Load),
.COUNTER_Data(data1_4),
.COUNTER_Number(MUXDC_W_Colums),

//////////// OUTPUTS //////////
.COUNTER_Out(Counter_W_Col_Out),
.COUNTER_Eqn_Flag(Counter_W_Col_Eqn_Flag)
);


MUXDC_STATEMACHINE Muxdc_Statemachine(

//////////// INPUTS //////////
.MUXDC_STATEMACHINE_Clk(MUXDC_Clk),
.MUXDC_STATEMACHINE_Reset(MUXDC_Reset),
.MUXDC_STATEMACHINE_Start_Conf(MUXDC_Set_Conf),
.MUXDC_STATEMACHINE_Conf_Already_Ok(MUXDC_Set_Conf_Already_Ok),
.MUXDC_STATEMACHINE_Counter_Bus_Flag(Counter_Bus_Eqn_Flag),
.MUXDC_STATEMACHINE_Counter_W_Size_Flag(Counter_W_Size_Eqn_Flag),

//////////// OUTPUTS //////////

.MUXDC_STATEMACHINE_Set_Conf_Already(MUXDC_Set_Conf_Already),
.MUXDC_STATEMACHINE_Counter_W_Size_En(Muxdc_Statemachine_Counter_W_Size_En),
.MUXDC_STATEMACHINEE_Counter_W_Size_Clr(Muxdc_Statemachine_Counter_W_Size_Clr),
.MUXDC_STATEMACHINE_Counter_W_Col_En(Muxdc_Statemachine_Counter_W_Col_En),
.MUXDC_STATEMACHINE_Counter_W_Col_Load(Muxdc_Statemachine_Counter_W_Col_Load),
.MUXDC_STATEMACHINE_Counter_W_Col_Clr(Muxdc_Statemachine_Counter_W_Col_Clr),
.MUXDC_STATEMACHINE_Counter_Bus_En(Muxdc_Statemachine_Counter_Bus_En),
.MUXDC_STATEMACHINE_Counter_Bus_Clr(Muxdc_Statemachine_Counter_Bus_Clr),
.MUXDC_STATEMACHINE_Conf_Rutine(Muxdc_Statemachine_Conf_Rutine)

);


assign Counter_W_Col_Load= (Counter_W_Col_Load_1 | Muxdc_Statemachine_Counter_W_Col_Load);

endmodule

