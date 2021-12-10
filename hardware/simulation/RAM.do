vsim work.RAM_tb

onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix binary /RAM_tb/Ram/RAM_Clk
add wave -noupdate -radix binary /RAM_tb/Ram/RAM_Oe
add wave -noupdate -radix binary /RAM_tb/Ram/RAM_We
add wave -noupdate -radix decimal /RAM_tb/Ram/RAM_Data_In
add wave -noupdate -radix decimal /RAM_tb/Ram/RAM_Address
add wave -noupdate -radix decimal /RAM_tb/Ram/RAM_Data_Out
add wave -noupdate -radix decimal /RAM_tb/tb_expected_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 204
configure wave -valuecolwidth 38
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
WaveRestoreZoom {0 ps} {105 ps}

run -all
