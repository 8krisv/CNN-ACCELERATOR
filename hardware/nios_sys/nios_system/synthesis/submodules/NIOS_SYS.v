/*#########################################################################
//# Nios system with cnn accelerator
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

module NIOS_SYS(

input FPGA_CLK1_50,
input KEY0,
input [2:0] SW,
output LED0

);

//=======================================================
//  Structural coding
//=======================================================

nios_system u0 (

/////////// Inputs ///////////
.clk_clk                                              (FPGA_CLK1_50),                                                                               
.cnn_accelerator_avalon_0_control_signals_finished_ok (SW[2]),  
.cnn_accelerator_avalon_0_control_signals_same_w      (SW[1]),  
.cnn_accelerator_avalon_0_control_signals_start       (SW[0]),                              
.reset_reset_n(KEY0),

/////////// output ///////////
.cnn_accelerator_avalon_0_control_signals_finished    (LED0)                                                                     

);



endmodule
