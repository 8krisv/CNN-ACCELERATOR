/*#########################################################################
//# Reconfigurable bus
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

module RBUS #( parameter LENGTHBUS=169,BITWIDTH_W_COLUMS=4, BITWIDTH_MAX_W_SIZE=9)(

//////////// INPUTS //////////
input RBUS_Clk,
input RBUS_Reset,
input RBUS_Set_Conf,
input RBUS_Set_Conf_Already_Ok,
input [BITWIDTH_W_COLUMS-1:0] RBUS_W_Colums,
input [BITWIDTH_MAX_W_SIZE-1:0] RBUS_W_ROXCL, /*wrows x colums -1*/

input RBUS_SetEn0,
input RBUS_SetEn1,
input RBUS_SetEn2,
input RBUS_SetEn3,
input RBUS_SetEn4,
input RBUS_SetEn5,
input RBUS_SetEn6,
input RBUS_SetEn7,
input RBUS_SetEn8,
input RBUS_SetEn9,
input RBUS_SetEn10,
input RBUS_SetEn11,
input RBUS_SetEn12,
input RBUS_OEn0,
input RBUS_OEn1,
input RBUS_OEn2,
input RBUS_OEn3,
input RBUS_OEn4,
input RBUS_OEn5,
input RBUS_OEn6,
input RBUS_OEn7,
input RBUS_OEn8,
input RBUS_OEn9,
input RBUS_OEn10,
input RBUS_OEn11,
input RBUS_OEn12,
input RBUS_Wptclr0,
input RBUS_Wptclr1,
input RBUS_Wptclr2,
input RBUS_Wptclr3,
input RBUS_Wptclr4,
input RBUS_Wptclr5,
input RBUS_Wptclr6,
input RBUS_Wptclr7,
input RBUS_Wptclr8,
input RBUS_Wptclr9,
input RBUS_Wptclr10,
input RBUS_Wptclr11,
input RBUS_Wptclr12,
input RBUS_Rptclr0,
input RBUS_Rptclr1,
input RBUS_Rptclr2,
input RBUS_Rptclr3,
input RBUS_Rptclr4,
input RBUS_Rptclr5,
input RBUS_Rptclr6,
input RBUS_Rptclr7,
input RBUS_Rptclr8,
input RBUS_Rptclr9,
input RBUS_Rptclr10,
input RBUS_Rptclr11,
input RBUS_Rptclr12,

//////////// OUTPUTS //////////
output [0:LENGTHBUS-1] RBUS_Om_SetEn,
output [0:LENGTHBUS-1] RBUS_Om_OEn,
output [0:LENGTHBUS-1] RBUS_Om_Wptclr,
output [0:LENGTHBUS-1] RBUS_Om_Rptclr,
output RBUS_Set_Conf_Already
);


//=======================================================
//  LOCAL PARAMETER
//=======================================================
localparam [BITWIDTH_W_COLUMS-1:0] data1_4= 4'd1;
localparam [7:0] Counter_Bus_Number = LENGTHBUS[7:0] -8'b1;
localparam [3:0] maxInput=4'd13;


//=======================================================
//  REG/WIRE DECLARATIONS
//=======================================================

wire Counter_W_Size_Eqn_Flag;
wire [BITWIDTH_MAX_W_SIZE-1:0] Counter_W_Size_Out;
wire Counter_Input_Eqn_Flag;
wire [3:0] Counter_Input_Out;

wire [BITWIDTH_W_COLUMS-1:0] Counter_W_Col_Out;
wire Counter_W_Col_Eqn_Flag;
wire Counter_W_Col_Load;

wire Rbus_Statemachine_Counter_W_Size_En;
wire Rbus_Statemachine_Counter_W_Size_Clr;
wire Rbus_Statemachine_Counter_W_Col_En;
wire Rbus_Statemachine_Counter_W_Col_Load;
wire Rbus_Statemachine_Counter_W_Col_Clr;
wire Rbus_Statemachine_Counter_Input_Clr;
wire Rbus_Statemachine_Counter_Input_Load;
wire Rbus_Statemachine_Bus_En;
wire Rbus_Statemachine_Conf_Rutine;
wire Rbus_Statemachine_Counter_Bus_En;
wire Rbus_Statemachine_Counter_Bus_Clr;
wire [7:0] Counter_Bus_Out;
wire Counter_Bus_Eqn_Flag;

reg Counter_W_Col_Load_1;
reg [3:0] Select[0:LENGTHBUS-1]; // Selector for mux configuration


//============================================================
// SEQUENTIAL LOGIC
//============================================================

always@(negedge RBUS_Clk)
begin

 if(Rbus_Statemachine_Conf_Rutine)
	begin
		
		if(Counter_W_Col_Eqn_Flag) begin
			Select[Counter_Bus_Out]<=Counter_Input_Out;
			Counter_W_Col_Load_1<=1'b1;	
		end
	
		else
		begin
			Select[Counter_Bus_Out]<=4'b0;
			Counter_W_Col_Load_1<=1'b0;
		end
		
	end
end


//=======================================================
//  Structural coding
//=======================================================

SIMPLE_COUNTER  #(.BITWIDTH(8)) Counter_Bus(
/////////// INPUTS //////////
.COUNTER_Clk(RBUS_Clk),
.COUNTER_Clr(Rbus_Statemachine_Counter_Bus_Clr),
.COUNTER_En(Rbus_Statemachine_Counter_Bus_En),
.COUNTER_Number(Counter_Bus_Number),

//////////// OUTPUTS //////////
.COUNTER_Out(Counter_Bus_Out),
.COUNTER_Eqn_Flag(Counter_Bus_Eqn_Flag)

);


SIMPLE_COUNTER #(.BITWIDTH(BITWIDTH_MAX_W_SIZE)) Counter_W_Size(
/////////// INPUTS //////////
.COUNTER_Clk(RBUS_Clk),
.COUNTER_Clr(Rbus_Statemachine_Counter_W_Size_Clr),
.COUNTER_En(Rbus_Statemachine_Counter_W_Size_En),
.COUNTER_Number(RBUS_W_ROXCL),

//////////// OUTPUTS //////////
.COUNTER_Out(Counter_W_Size_Out),
.COUNTER_Eqn_Flag(Counter_W_Size_Eqn_Flag)

);



COUNTER_POS #(.BITWIDTH(BITWIDTH_W_COLUMS)) Counter_W_Col(
/////////// INPUTS //////////
.COUNTER_Clk(RBUS_Clk),
.COUNTER_Clr(Rbus_Statemachine_Counter_W_Col_Clr),
.COUNTER_En(Rbus_Statemachine_Counter_W_Col_En),
.COUNTER_load(Counter_W_Col_Load),
.COUNTER_Data(data1_4),
.COUNTER_Number(RBUS_W_Colums),

//////////// OUTPUTS //////////
.COUNTER_Out(Counter_W_Col_Out),
.COUNTER_Eqn_Flag(Counter_W_Col_Eqn_Flag)
);


COUNTER_POS #(.BITWIDTH(4)) Counter_Input(
/////////// INPUTS //////////
.COUNTER_Clk(RBUS_Clk),
.COUNTER_Clr(Rbus_Statemachine_Counter_Input_Clr),
.COUNTER_En(Counter_W_Col_Eqn_Flag),
.COUNTER_load(Rbus_Statemachine_Counter_Input_Load),
.COUNTER_Data(data1_4),
.COUNTER_Number(maxInput),

//////////// OUTPUTS //////////
.COUNTER_Out(Counter_Input_Out),
.COUNTER_Eqn_Flag(Counter_Input_Eqn_Flag)

);


RBUS_STATEMACHINE Rbus_Statemachine
(
//////////// INPUTS //////////
.RBUS_STATEMACHINE_Clk(RBUS_Clk),
.RBUS_STATEMACHINE_Reset(RBUS_Reset),
.RBUS_STATEMACHINE_Start_Conf(RBUS_Set_Conf),
.RBUS_STATEMACHINE_Conf_Already_Ok(RBUS_Set_Conf_Already_Ok),
.RBUS_STATEMACHINE_Counter_Bus_Flag(Counter_Bus_Eqn_Flag),
.RBUS_STATEMACHINE_Counter_W_Size_Flag(Counter_W_Size_Eqn_Flag),
//////////// OUTPUTS //////////
.RBUS_STATEMACHINE_Set_Conf_Already(RBUS_Set_Conf_Already),
.RBUS_STATEMACHINE_Counter_W_Size_En(Rbus_Statemachine_Counter_W_Size_En),
.RBUS_STATEMACHINE_Counter_W_Size_Clr(Rbus_Statemachine_Counter_W_Size_Clr),
.RBUS_STATEMACHINE_Counter_W_Col_En(Rbus_Statemachine_Counter_W_Col_En),
.RBUS_STATEMACHINE_Counter_W_Col_Load(Rbus_Statemachine_Counter_W_Col_Load),
.RBUS_STATEMACHINE_Counter_W_Col_Clr(Rbus_Statemachine_Counter_W_Col_Clr),
.RBUS_STATEMACHINE_Counter_Input_Clr(Rbus_Statemachine_Counter_Input_Clr),
.RBUS_STATEMACHINE_Counter_Input_Load(Rbus_Statemachine_Counter_Input_Load),
.RBUS_STATEMACHINE_Counter_Bus_En(Rbus_Statemachine_Counter_Bus_En),
.RBUS_STATEMACHINE_Counter_Bus_Clr(Rbus_Statemachine_Counter_Bus_Clr),
.RBUS_STATEMACHINE_Conf_Rutine(Rbus_Statemachine_Conf_Rutine),
.RBUS_STATEMACHINE_Bus_En(Rbus_Statemachine_Bus_En)
);



//============================================================
// Combinational logic ouput
//============================================================

genvar i;  // variable for code generation    
generate

	for (i = 0; i < LENGTHBUS ; i=i+1)   
	begin:bus
	
		assign RBUS_Om_SetEn[i]= (Rbus_Statemachine_Bus_En == 1'b1) ?  
										 (Select[i] == 4'd1) ? RBUS_SetEn0 :
								       (Select[i] == 4'd2) ? RBUS_SetEn1 :
								       (Select[i] == 4'd3) ? RBUS_SetEn2 :
								       (Select[i] == 4'd4) ? RBUS_SetEn3 :
								       (Select[i] == 4'd5) ? RBUS_SetEn4 :
								       (Select[i] == 4'd6) ? RBUS_SetEn5 :
								       (Select[i] == 4'd7) ? RBUS_SetEn6 :
								       (Select[i] == 4'd8) ? RBUS_SetEn7 :
								       (Select[i] == 4'd9) ? RBUS_SetEn8 :
								       (Select[i] == 4'd10) ? RBUS_SetEn9 :
								       (Select[i] == 4'd11) ? RBUS_SetEn10 :
								       (Select[i] == 4'd12) ? RBUS_SetEn11 :
								       (Select[i] == 4'd13) ? RBUS_SetEn12 : 1'b0 :1'b0;
							
		assign RBUS_Om_OEn[i]= (Rbus_Statemachine_Bus_En == 1'b1) ?  
									  (Select[i] == 4'd1) ? RBUS_OEn0 :
									  (Select[i] == 4'd2) ? RBUS_OEn1 :
								     (Select[i] == 4'd3) ? RBUS_OEn2 :
								     (Select[i] == 4'd4) ? RBUS_OEn3 :
								     (Select[i] == 4'd5) ? RBUS_OEn4 :
								     (Select[i] == 4'd6) ? RBUS_OEn5 :
								     (Select[i] == 4'd7) ? RBUS_OEn6 :
								     (Select[i] == 4'd8) ? RBUS_OEn7 :
								     (Select[i] == 4'd9) ? RBUS_OEn8 :
								     (Select[i] == 4'd10) ? RBUS_OEn9 :
								     (Select[i] == 4'd11) ? RBUS_OEn10 :
								     (Select[i] == 4'd12) ? RBUS_OEn11 :
								     (Select[i] == 4'd13) ? RBUS_OEn12 : 1'b0 :1'b0;
								 
      assign RBUS_Om_Wptclr[i]= (Rbus_Statemachine_Bus_En == 1'b1) ?  
								        (Select[i] == 4'd1) ? RBUS_Wptclr0 :
								        (Select[i] == 4'd2) ? RBUS_Wptclr1 :
								        (Select[i] == 4'd3) ? RBUS_Wptclr2 :
								        (Select[i] == 4'd4) ? RBUS_Wptclr3 :
								        (Select[i] == 4'd5) ? RBUS_Wptclr4 :
								        (Select[i] == 4'd6) ? RBUS_Wptclr5 :
								        (Select[i] == 4'd7) ? RBUS_Wptclr6 :
								        (Select[i] == 4'd8) ? RBUS_Wptclr7 :
								        (Select[i] == 4'd9) ? RBUS_Wptclr8 :
								        (Select[i] == 4'd10) ? RBUS_Wptclr9 :
								        (Select[i] == 4'd11) ? RBUS_Wptclr10 :
								        (Select[i] == 4'd12) ? RBUS_Wptclr11 :
								        (Select[i] == 4'd13) ? RBUS_Wptclr12 : 1'b0 :1'b0;
								 
								 
		assign RBUS_Om_Rptclr[i]= (Rbus_Statemachine_Bus_En == 1'b1) ?  
								        (Select[i] == 4'd1) ? RBUS_Rptclr0 :
								        (Select[i] == 4'd2) ? RBUS_Rptclr1 :
								        (Select[i] == 4'd3) ? RBUS_Rptclr2 :
								        (Select[i] == 4'd4) ? RBUS_Rptclr3 :
							           (Select[i] == 4'd5) ? RBUS_Rptclr4 :
								        (Select[i] == 4'd6) ? RBUS_Rptclr5 :
								        (Select[i] == 4'd7) ? RBUS_Rptclr6 :
								        (Select[i] == 4'd8) ? RBUS_Rptclr7 :
								        (Select[i] == 4'd9) ? RBUS_Rptclr8 :
								        (Select[i] == 4'd10) ? RBUS_Rptclr9 :
								        (Select[i] == 4'd11) ? RBUS_Rptclr10 :
								        (Select[i] == 4'd12) ? RBUS_Rptclr11 :
								        (Select[i] == 4'd13) ? RBUS_Rptclr12 : 1'b0 :1'b0;				 
	end
	
endgenerate 


assign Counter_W_Col_Load =(Counter_W_Col_Load_1 | Rbus_Statemachine_Counter_W_Col_Load);


endmodule




