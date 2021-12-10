onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /OMDC_tb/tb_clk
add wave -noupdate -label Omdc_Statemachine/State_Register -radix decimal /OMDC_tb/Omdc/Omdc_Statemachine/State_Register
add wave -noupdate -label Omdc_Statemachine/State_Signal -radix decimal /OMDC_tb/Omdc/Omdc_Statemachine/State_Signal
add wave -noupdate -radix binary /OMDC_tb/Omdc/Counter_Eqcw/COUNTER_Clr
add wave -noupdate -radix decimal /OMDC_tb/Omdc/Counter_Eqcw/counter
add wave -noupdate -radix binary /OMDC_tb/Omdc/Counter_Eqcw_Flag
add wave -noupdate -radix binary /OMDC_tb/Omdc/Counter_Eqst/COUNTER_Clr
add wave -noupdate -radix decimal /OMDC_tb/Omdc/Counter_Eqst/counter
add wave -noupdate -radix binary /OMDC_tb/Omdc/Counter_Eqst_Flag
add wave -noupdate /OMDC_tb/tb_start_routine
add wave -noupdate /OMDC_tb/tb_stop_routine
add wave -noupdate /OMDC_tb/tb_finish_routine
add wave -noupdate /OMDC_tb/tb_routine_finisehd_ok
add wave -noupdate -radix binary /OMDC_tb/tb_new_channel_flag
add wave -noupdate -radix binary /OMDC_tb/tb_OEn0
add wave -noupdate -radix binary /OMDC_tb/tb_OEn1
add wave -noupdate -radix binary /OMDC_tb/tb_OEn2
add wave -noupdate -radix binary /OMDC_tb/tb_SetEn0
add wave -noupdate -radix binary /OMDC_tb/tb_SetEn1
add wave -noupdate -radix binary /OMDC_tb/tb_SetEn2
add wave -noupdate -radix binary /OMDC_tb/tb_Rptclr0
add wave -noupdate -radix binary /OMDC_tb/tb_Rptclr1
add wave -noupdate -radix binary /OMDC_tb/tb_Rptclr2
add wave -noupdate -radix binary /OMDC_tb/tb_Wptclr0
add wave -noupdate -radix binary /OMDC_tb/tb_Wptclr1
add wave -noupdate -radix binary /OMDC_tb/tb_Wptclr2
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {110 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 332
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
WaveRestoreZoom {0 ps} {117 ps}
