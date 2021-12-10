onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /MUXDC_tb/tb_clk_50
add wave -noupdate -radix unsigned /MUXDC_tb/Muxdc/Muxdc_Statemachine/State_Register
add wave -noupdate -radix binary /MUXDC_tb/tb_Set_Conf
add wave -noupdate -radix unsigned /MUXDC_tb/Muxdc/Muxdc_Statemachine/State_Signal
add wave -noupdate -radix binary -childformat {{{/MUXDC_tb/Muxdc/MUXDC_Muxes_Sel[0]} -radix binary} {{/MUXDC_tb/Muxdc/MUXDC_Muxes_Sel[1]} -radix binary} {{/MUXDC_tb/Muxdc/MUXDC_Muxes_Sel[2]} -radix binary} {{/MUXDC_tb/Muxdc/MUXDC_Muxes_Sel[3]} -radix binary} {{/MUXDC_tb/Muxdc/MUXDC_Muxes_Sel[4]} -radix binary} {{/MUXDC_tb/Muxdc/MUXDC_Muxes_Sel[5]} -radix binary} {{/MUXDC_tb/Muxdc/MUXDC_Muxes_Sel[6]} -radix binary} {{/MUXDC_tb/Muxdc/MUXDC_Muxes_Sel[7]} -radix binary}} -subitemconfig {{/MUXDC_tb/Muxdc/MUXDC_Muxes_Sel[0]} {-height 17 -radix binary} {/MUXDC_tb/Muxdc/MUXDC_Muxes_Sel[1]} {-height 17 -radix binary} {/MUXDC_tb/Muxdc/MUXDC_Muxes_Sel[2]} {-height 17 -radix binary} {/MUXDC_tb/Muxdc/MUXDC_Muxes_Sel[3]} {-height 17 -radix binary} {/MUXDC_tb/Muxdc/MUXDC_Muxes_Sel[4]} {-height 17 -radix binary} {/MUXDC_tb/Muxdc/MUXDC_Muxes_Sel[5]} {-height 17 -radix binary} {/MUXDC_tb/Muxdc/MUXDC_Muxes_Sel[6]} {-height 17 -radix binary} {/MUXDC_tb/Muxdc/MUXDC_Muxes_Sel[7]} {-height 17 -radix binary}} /MUXDC_tb/Muxdc/MUXDC_Muxes_Sel
add wave -noupdate -radix unsigned /MUXDC_tb/Muxdc/Counter_Bus/COUNTER_Out
add wave -noupdate -radix binary /MUXDC_tb/Muxdc/Counter_Bus/COUNTER_Eqn_Flag
add wave -noupdate -radix unsigned /MUXDC_tb/Muxdc/Counter_W_Size/COUNTER_Out
add wave -noupdate -radix binary /MUXDC_tb/Muxdc/Counter_W_Size/COUNTER_Eqn_Flag
add wave -noupdate -radix unsigned /MUXDC_tb/Muxdc/Counter_W_Col/COUNTER_Out
add wave -noupdate -radix binary /MUXDC_tb/Muxdc/Counter_W_Col/COUNTER_Eqn_Flag
add wave -noupdate -radix binary /MUXDC_tb/Muxdc/MUXDC_Set_Conf_Already
add wave -noupdate -radix binary /MUXDC_tb/tb_Set_Conf_Already_Ok
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {279 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 305
configure wave -valuecolwidth 100
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
WaveRestoreZoom {224 ps} {283 ps}
