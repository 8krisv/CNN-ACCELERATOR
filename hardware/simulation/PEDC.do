onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /PEDC_tb/Pedc/PEDC_Clk
add wave -noupdate -label Pedc_Statemachine/State_Register -radix unsigned /PEDC_tb/Pedc/Pedc_Statemachine/State_Register
add wave -noupdate -label Pedc_Statemachine/State_Signal -radix unsigned /PEDC_tb/Pedc/Pedc_Statemachine/State_Signal
add wave -noupdate -radix binary /PEDC_tb/Pedc/PEDC_Start_Routine
add wave -noupdate -radix binary /PEDC_tb/Pedc/PEDC_Stop_Routine
add wave -noupdate -radix binary /PEDC_tb/Pedc/PEDC_Reset
add wave -noupdate -radix binary /PEDC_tb/Pedc/PEDC_OutReg_Set
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 354
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
WaveRestoreZoom {0 ps} {449 ps}
