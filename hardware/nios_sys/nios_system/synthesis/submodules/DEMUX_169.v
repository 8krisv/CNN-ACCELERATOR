/*#########################################################################
//# General purpose demultiplexer
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

module DEMUX_169 #(parameter INPUT_DATA_WIDTH =8, BITWIDTH_SEL=9)(

/////////////// INPUTS ///////////////
input [INPUT_DATA_WIDTH-1:0] DEMUX_Data_in,
input [BITWIDTH_SEL-1:0] DEMUX_selector,
input DEMUX_En,

/////////////// OUTPUTS ///////////////
output [INPUT_DATA_WIDTH-1:0] DEMUX_out0,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out1,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out2,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out3,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out4,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out5,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out6,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out7,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out8,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out9,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out10,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out11,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out12,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out13,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out14,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out15,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out16,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out17,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out18,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out19,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out20,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out21,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out22,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out23,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out24,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out25,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out26,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out27,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out28,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out29,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out30,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out31,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out32,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out33,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out34,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out35
/*output [INPUT_DATA_WIDTH-1:0] DEMUX_out36,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out37,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out38,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out39,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out40,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out41,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out42,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out43,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out44,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out45,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out46,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out47,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out48,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out49,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out50,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out51,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out52,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out53,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out54,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out55,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out56,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out57,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out58,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out59,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out60,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out61,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out62,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out63,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out64,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out65,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out66,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out67,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out68,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out69,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out70,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out71,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out72,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out73,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out74,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out75,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out76,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out77,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out78,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out79, 
output [INPUT_DATA_WIDTH-1:0] DEMUX_out80,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out81,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out82,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out83,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out84,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out85,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out86,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out87,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out88,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out89,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out90,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out91,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out92,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out93,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out94,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out95,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out96,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out97,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out98,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out99,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out100,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out101,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out102,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out103,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out104,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out105,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out106,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out107,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out108,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out109,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out110,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out111,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out112,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out113,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out114,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out115,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out116,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out117,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out118,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out119,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out120,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out121,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out122,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out123,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out124,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out125,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out126,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out127,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out128,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out129,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out130,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out131,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out132,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out133,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out134,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out135,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out136,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out137,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out138,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out139,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out140,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out141,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out142,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out143,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out144,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out145,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out146,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out147,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out148,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out149,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out150,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out151,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out152,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out153,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out154,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out155,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out156,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out157,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out158,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out159,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out160,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out161,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out162,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out163,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out164,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out165,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out166,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out167,
output [INPUT_DATA_WIDTH-1:0] DEMUX_out168*/

);


//=======================================================
// Parameter declaration
//=======================================================

localparam [INPUT_DATA_WIDTH-1:0] DATA0 = 0;

//=======================================================
//  REG/WIRE declarations
//=======================================================

//reg [INPUT_DATA_WIDTH-1:0] Data;

//============================================================
// Combinational logic
//============================================================

/*always@(*) 
begin
	if(DEMUX_En)
	begin
		Data=DEMUX_Data_in;
	end
end*/


//============================================================
// Combinational logic ouput
//============================================================

assign DEMUX_out0 = DEMUX_En == 1'b1 ? DEMUX_selector == 9'd0 ? DEMUX_Data_in : DATA0 : DATA0;
assign DEMUX_out1 = DEMUX_En == 1'b1 ? DEMUX_selector == 9'd1 ? DEMUX_Data_in : DATA0 : DATA0;
assign DEMUX_out2 = DEMUX_En == 1'b1 ? DEMUX_selector == 9'd2 ? DEMUX_Data_in : DATA0 : DATA0;
assign DEMUX_out3 = DEMUX_En == 1'b1 ? DEMUX_selector == 9'd3 ? DEMUX_Data_in : DATA0 : DATA0;
assign DEMUX_out4 = DEMUX_En == 1'b1 ? DEMUX_selector == 9'd4 ? DEMUX_Data_in : DATA0 : DATA0;
assign DEMUX_out5 = DEMUX_En == 1'b1 ? DEMUX_selector == 9'd5 ? DEMUX_Data_in : DATA0 : DATA0;
assign DEMUX_out6 = DEMUX_En == 1'b1 ? DEMUX_selector == 9'd6 ? DEMUX_Data_in : DATA0 : DATA0;
assign DEMUX_out7 = DEMUX_En == 1'b1 ? DEMUX_selector == 9'd7 ? DEMUX_Data_in : DATA0 : DATA0;
assign DEMUX_out8 = DEMUX_En == 1'b1 ? DEMUX_selector == 9'd8 ? DEMUX_Data_in : DATA0 : DATA0;
assign DEMUX_out9 = DEMUX_En == 1'b1 ? DEMUX_selector == 9'd9 ? DEMUX_Data_in : DATA0 : DATA0;
assign DEMUX_out10 = DEMUX_En == 1'b1 ? DEMUX_selector == 9'd10 ? DEMUX_Data_in : DATA0 : DATA0;
assign DEMUX_out11 = DEMUX_En == 1'b1 ? DEMUX_selector == 9'd11 ? DEMUX_Data_in : DATA0 : DATA0;
assign DEMUX_out12 = DEMUX_En == 1'b1 ? DEMUX_selector == 9'd12 ? DEMUX_Data_in : DATA0 : DATA0;
assign DEMUX_out13 = DEMUX_En == 1'b1 ? DEMUX_selector == 9'd13 ? DEMUX_Data_in : DATA0 : DATA0;
assign DEMUX_out14 = DEMUX_En == 1'b1 ? DEMUX_selector == 9'd14 ? DEMUX_Data_in : DATA0 : DATA0;
assign DEMUX_out15 = DEMUX_En == 1'b1 ? DEMUX_selector == 9'd15 ? DEMUX_Data_in : DATA0 : DATA0;
assign DEMUX_out16 = DEMUX_En == 1'b1 ? DEMUX_selector == 9'd16 ? DEMUX_Data_in : DATA0 : DATA0;
assign DEMUX_out17 = DEMUX_En == 1'b1 ? DEMUX_selector == 9'd17 ? DEMUX_Data_in : DATA0 : DATA0;
assign DEMUX_out18 = DEMUX_En == 1'b1 ? DEMUX_selector == 9'd18 ? DEMUX_Data_in : DATA0 : DATA0;
assign DEMUX_out19 = DEMUX_En == 1'b1 ? DEMUX_selector == 9'd19 ? DEMUX_Data_in : DATA0 : DATA0;
assign DEMUX_out20 = DEMUX_En == 1'b1 ? DEMUX_selector == 9'd20 ? DEMUX_Data_in : DATA0 : DATA0;
assign DEMUX_out21 = DEMUX_En == 1'b1 ? DEMUX_selector == 9'd21 ? DEMUX_Data_in : DATA0 : DATA0;
assign DEMUX_out22 = DEMUX_En == 1'b1 ? DEMUX_selector == 9'd22 ? DEMUX_Data_in : DATA0 : DATA0;
assign DEMUX_out23 = DEMUX_En == 1'b1 ? DEMUX_selector == 9'd23 ? DEMUX_Data_in : DATA0 : DATA0;
assign DEMUX_out24 = DEMUX_En == 1'b1 ? DEMUX_selector == 9'd24 ? DEMUX_Data_in : DATA0 : DATA0;
assign DEMUX_out25 = DEMUX_En == 1'b1 ? DEMUX_selector == 9'd25 ? DEMUX_Data_in : DATA0 : DATA0;
assign DEMUX_out26 = DEMUX_En == 1'b1 ? DEMUX_selector == 9'd26 ? DEMUX_Data_in : DATA0 : DATA0;
assign DEMUX_out27 = DEMUX_En == 1'b1 ? DEMUX_selector == 9'd27 ? DEMUX_Data_in : DATA0 : DATA0;
assign DEMUX_out28 = DEMUX_En == 1'b1 ? DEMUX_selector == 9'd28 ? DEMUX_Data_in : DATA0 : DATA0;
assign DEMUX_out29 = DEMUX_En == 1'b1 ? DEMUX_selector == 9'd29 ? DEMUX_Data_in : DATA0 : DATA0;
assign DEMUX_out30 = DEMUX_En == 1'b1 ? DEMUX_selector == 9'd30 ? DEMUX_Data_in : DATA0 : DATA0;
assign DEMUX_out31 = DEMUX_En == 1'b1 ? DEMUX_selector == 9'd31 ? DEMUX_Data_in : DATA0 : DATA0;
assign DEMUX_out32 = DEMUX_En == 1'b1 ? DEMUX_selector == 9'd32 ? DEMUX_Data_in : DATA0 : DATA0;
assign DEMUX_out33 = DEMUX_En == 1'b1 ? DEMUX_selector == 9'd33 ? DEMUX_Data_in : DATA0 : DATA0;
assign DEMUX_out34 = DEMUX_En == 1'b1 ? DEMUX_selector == 9'd34 ? DEMUX_Data_in : DATA0 : DATA0;
assign DEMUX_out35 = DEMUX_En == 1'b1 ? DEMUX_selector == 9'd35 ? DEMUX_Data_in : DATA0 : DATA0;
/*assign DEMUX_out36 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd36 ? Data : 0 : 0;
assign DEMUX_out37 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd37 ? Data : 0 : 0;
assign DEMUX_out38 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd38 ? Data : 0 : 0;
assign DEMUX_out39 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd39 ? Data : 0 : 0; 
assign DEMUX_out40 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd40 ? Data : 0 : 0; 
assign DEMUX_out41 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd41 ? Data : 0 : 0; 
assign DEMUX_out42 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd42 ? Data : 0 : 0; 
assign DEMUX_out43 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd43 ? Data : 0 : 0; 
assign DEMUX_out44 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd44 ? Data : 0 : 0; 
assign DEMUX_out45 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd45 ? Data : 0 : 0; 
assign DEMUX_out46 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd46 ? Data : 0 : 0; 
assign DEMUX_out47 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd47 ? Data : 0 : 0; 
assign DEMUX_out48 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd48 ? Data : 0 : 0; 
assign DEMUX_out49 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd49 ? Data : 0 : 0; 
assign DEMUX_out50 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd50 ? Data : 0 : 0; 
assign DEMUX_out51 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd51 ? Data : 0 : 0; 
assign DEMUX_out52 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd52 ? Data : 0 : 0; 
assign DEMUX_out53 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd53 ? Data : 0 : 0; 
assign DEMUX_out54 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd54 ? Data : 0 : 0; 
assign DEMUX_out55 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd55 ? Data : 0 : 0; 
assign DEMUX_out56 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd56 ? Data : 0 : 0; 
assign DEMUX_out57 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd57 ? Data : 0 : 0; 
assign DEMUX_out58 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd58 ? Data : 0 : 0; 
assign DEMUX_out59 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd59 ? Data : 0 : 0; 
assign DEMUX_out60 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd60 ? Data : 0 : 0; 
assign DEMUX_out61 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd61 ? Data : 0 : 0; 
assign DEMUX_out62 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd62 ? Data : 0 : 0; 
assign DEMUX_out63 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd63 ? Data : 0 : 0;
assign DEMUX_out64 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd64 ? Data : 0 : 0;
assign DEMUX_out65 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd65 ? Data : 0 : 0;
assign DEMUX_out66 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd66 ? Data : 0 : 0;
assign DEMUX_out67 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd67 ? Data : 0 : 0;
assign DEMUX_out68 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd68 ? Data : 0 : 0;
assign DEMUX_out69 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd69 ? Data : 0 : 0;
assign DEMUX_out70 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd70 ? Data : 0 : 0;
assign DEMUX_out71 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd71 ? Data : 0 : 0;
assign DEMUX_out72 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd72 ? Data : 0 : 0;
assign DEMUX_out73 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd73 ? Data : 0 : 0;
assign DEMUX_out74 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd74 ? Data : 0 : 0;
assign DEMUX_out75 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd75 ? Data : 0 : 0;
assign DEMUX_out76 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd76 ? Data : 0 : 0;
assign DEMUX_out77 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd77 ? Data : 0 : 0;
assign DEMUX_out78 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd78 ? Data : 0 : 0;
assign DEMUX_out79 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd79 ? Data : 0 : 0;
assign DEMUX_out80 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd80 ? Data : 0 : 0;
assign DEMUX_out81 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd81 ? Data : 0 : 0;
assign DEMUX_out82 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd82 ? Data : 0 : 0;
assign DEMUX_out83 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd83 ? Data : 0 : 0;
assign DEMUX_out84 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd84 ? Data : 0 : 0;
assign DEMUX_out85 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd85 ? Data : 0 : 0;
assign DEMUX_out86 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd86 ? Data : 0 : 0;
assign DEMUX_out87 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd87 ? Data : 0 : 0;
assign DEMUX_out88 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd88 ? Data : 0 : 0;
assign DEMUX_out89 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd89 ? Data : 0 : 0;
assign DEMUX_out90 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd90 ? Data : 0 : 0;
assign DEMUX_out91 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd91 ? Data : 0 : 0;
assign DEMUX_out92 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd92 ? Data : 0 : 0;
assign DEMUX_out93 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd93 ? Data : 0 : 0;
assign DEMUX_out94 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd94 ? Data : 0 : 0;
assign DEMUX_out95 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd95 ? Data : 0 : 0;
assign DEMUX_out96 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd96 ? Data : 0 : 0;
assign DEMUX_out97 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd97 ? Data : 0 : 0;
assign DEMUX_out98 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd98 ? Data : 0 : 0;
assign DEMUX_out99 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd99 ? Data : 0 : 0;
assign DEMUX_out100 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd100 ? Data :0 : 0;
assign DEMUX_out101 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd101 ? Data : 0 : 0;
assign DEMUX_out102 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd102 ? Data : 0 : 0;
assign DEMUX_out103 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd103 ? Data : 0 : 0;
assign DEMUX_out104 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd104 ? Data : 0 : 0;
assign DEMUX_out105 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd105 ? Data : 0 : 0;
assign DEMUX_out106 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd106 ? Data : 0 : 0;
assign DEMUX_out107 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd107 ? Data : 0 : 0;
assign DEMUX_out108 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd108 ? Data : 0 : 0;
assign DEMUX_out109 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd109 ? Data : 0 : 0;
assign DEMUX_out110 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd110 ? Data : 0 : 0;
assign DEMUX_out111 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd111 ? Data : 0 : 0;
assign DEMUX_out112 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd112 ? Data : 0 : 0;
assign DEMUX_out113 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd113 ? Data : 0 : 0;
assign DEMUX_out114 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd114 ? Data : 0 : 0;
assign DEMUX_out115 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd115 ? Data : 0 : 0;
assign DEMUX_out116 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd116 ? Data : 0 : 0;
assign DEMUX_out117 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd117 ? Data : 0 : 0;
assign DEMUX_out118 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd118 ? Data : 0 : 0;
assign DEMUX_out119 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd119 ? Data : 0 : 0;
assign DEMUX_out120 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd120 ? Data : 0 : 0;
assign DEMUX_out121 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd121 ? Data : 0 : 0;
assign DEMUX_out122 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd122 ? Data : 0 : 0;
assign DEMUX_out123 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd123 ? Data : 0 : 0;
assign DEMUX_out124 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd124 ? Data : 0 : 0;
assign DEMUX_out125 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd125 ? Data : 0 : 0;
assign DEMUX_out126 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd126 ? Data : 0 : 0;
assign DEMUX_out127 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd127 ? Data : 0 : 0;
assign DEMUX_out128 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd128 ? Data : 0 : 0;
assign DEMUX_out129 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd129 ? Data : 0 : 0;
assign DEMUX_out130 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd130 ? Data : 0 : 0;
assign DEMUX_out131 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd131 ? Data : 0 : 0;
assign DEMUX_out132 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd132 ? Data : 0 : 0;
assign DEMUX_out133 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd133 ? Data : 0 : 0;
assign DEMUX_out134 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd134 ? Data : 0 : 0;
assign DEMUX_out135 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd135 ? Data : 0 : 0;
assign DEMUX_out136 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd136 ? Data : 0 : 0;
assign DEMUX_out137 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd137 ? Data : 0 : 0;
assign DEMUX_out138 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd138 ? Data : 0 : 0;
assign DEMUX_out139 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd139 ? Data : 0 : 0;
assign DEMUX_out140 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd140 ? Data : 0 : 0;
assign DEMUX_out141 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd141 ? Data : 0 : 0;
assign DEMUX_out142 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd142 ? Data : 0 : 0;
assign DEMUX_out143 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd143 ? Data : 0 : 0;
assign DEMUX_out144 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd144 ? Data : 0 : 0;
assign DEMUX_out145 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd145 ? Data : 0 : 0;
assign DEMUX_out146 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd146 ? Data : 0 : 0;
assign DEMUX_out147 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd147 ? Data : 0 : 0;
assign DEMUX_out148 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd148 ? Data : 0 : 0;
assign DEMUX_out149 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd149 ? Data : 0 : 0;
assign DEMUX_out150 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd150 ? Data : 0 : 0;
assign DEMUX_out151 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd151 ? Data : 0 : 0;
assign DEMUX_out152 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd152 ? Data : 0 : 0;
assign DEMUX_out153 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd153 ? Data : 0 : 0;
assign DEMUX_out154 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd154 ? Data : 0 : 0;
assign DEMUX_out155 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd144 ? Data : 0 : 0;
assign DEMUX_out156 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd156 ? Data : 0 : 0;
assign DEMUX_out157 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd157 ? Data : 0 : 0;
assign DEMUX_out158 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd158 ? Data : 0 : 0;
assign DEMUX_out159 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd159 ? Data : 0 : 0;
assign DEMUX_out160 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd160 ? Data : 0 : 0;
assign DEMUX_out161 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd161 ? Data : 0 : 0;
assign DEMUX_out162 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd162 ? Data : 0 : 0;
assign DEMUX_out163 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd163 ? Data : 0 : 0;
assign DEMUX_out164 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd164 ? Data : 0 : 0;
assign DEMUX_out165 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd165 ? Data : 0 : 0;
assign DEMUX_out166 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd166 ? Data : 0 : 0;
assign DEMUX_out167 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd167 ? Data : 0 : 0;
assign DEMUX_out168 = DEMUX_En == 1'b1 ? DEMUX_selector == 8'd168 ? Data : 0 : 0;*/

endmodule



