onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /PE_tb/Pe/PE_Clk
add wave -noupdate /PE_tb/Pe/PE_If_Px
add wave -noupdate -radix decimal /PE_tb/Pe/PE_w
add wave -noupdate -radix decimal /PE_tb/Pe/PE_Is
add wave -noupdate -radix binary /PE_tb/Pe/PE_Out_Reg_Set
add wave -noupdate -radix binary /PE_tb/Pe/PE_Fifo_Set
add wave -noupdate -radix decimal /PE_tb/Pe/PE_Out
add wave -noupdate -radix binary /PE_tb/tb_reset
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 416
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
WaveRestoreZoom {0 ps} {48 ps}
