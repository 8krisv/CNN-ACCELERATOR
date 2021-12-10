onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /OWMC_tb/Owmc/OWMC_Clk
add wave -noupdate -radix decimal /OWMC_tb/Owmc/Owmc_Statemachine/State_Register
add wave -noupdate -radix decimal /OWMC_tb/Owmc/Owmc_Statemachine/State_Signal
add wave -noupdate /OWMC_tb/tb_start_loading_regs
add wave -noupdate -radix binary /OWMC_tb/Owmc/OWM/RAM_Oe
add wave -noupdate -radix binary /OWMC_tb/Owmc/OWM/RAM_We
add wave -noupdate -label OWMC_STATEMACHINE_Loading_Regs_Already /OWMC_tb/Owmc/Owmc_Statemachine/OWMC_STATEMACHINE_Loading_Regs_Already
add wave -noupdate /OWMC_tb/tb_loading_regs_already_ok
add wave -noupdate -label COUNTER_OFFSET_Eqn_Flag /OWMC_tb/Owmc/Counter_Ram/COUNTER_OFFSET_Eqn_Flag
add wave -noupdate -format Literal -radix binary /OWMC_tb/Owmc/OWMC_Muxes_En
add wave -noupdate /OWMC_tb/Owmc/Offset_Adder/OFFSET_ADDER_Sum_En
add wave -noupdate -radix decimal /OWMC_tb/Owmc/Counter_Ram_Lower_Limit
add wave -noupdate -radix decimal /OWMC_tb/Owmc/OWM/RAM_Address
add wave -noupdate -radix decimal /OWMC_tb/Owmc/OWMC_Muxes_Sel
add wave -noupdate -radix decimal /OWMC_tb/Owmc/OWMC_Output_Data
add wave -noupdate -childformat {{{/OWMC_tb/Owmc/OWM/Ram_Array[8]} -radix decimal} {{/OWMC_tb/Owmc/OWM/Ram_Array[7]} -radix decimal} {{/OWMC_tb/Owmc/OWM/Ram_Array[6]} -radix decimal} {{/OWMC_tb/Owmc/OWM/Ram_Array[5]} -radix decimal} {{/OWMC_tb/Owmc/OWM/Ram_Array[4]} -radix decimal} {{/OWMC_tb/Owmc/OWM/Ram_Array[3]} -radix decimal} {{/OWMC_tb/Owmc/OWM/Ram_Array[2]} -radix decimal} {{/OWMC_tb/Owmc/OWM/Ram_Array[1]} -radix decimal} {{/OWMC_tb/Owmc/OWM/Ram_Array[0]} -radix decimal}} -subitemconfig {{/OWMC_tb/Owmc/OWM/Ram_Array[8]} {-height 17 -radix decimal} {/OWMC_tb/Owmc/OWM/Ram_Array[7]} {-height 17 -radix decimal} {/OWMC_tb/Owmc/OWM/Ram_Array[6]} {-height 17 -radix decimal} {/OWMC_tb/Owmc/OWM/Ram_Array[5]} {-height 17 -radix decimal} {/OWMC_tb/Owmc/OWM/Ram_Array[4]} {-height 17 -radix decimal} {/OWMC_tb/Owmc/OWM/Ram_Array[3]} {-height 17 -radix decimal} {/OWMC_tb/Owmc/OWM/Ram_Array[2]} {-height 17 -radix decimal} {/OWMC_tb/Owmc/OWM/Ram_Array[1]} {-height 17 -radix decimal} {/OWMC_tb/Owmc/OWM/Ram_Array[0]} {-height 17 -radix decimal}} /OWMC_tb/Owmc/OWM/Ram_Array
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {811 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 321
configure wave -valuecolwidth 40
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {703 ps} {826 ps}
