onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /ONEDCONV_tb/tb_clk
add wave -noupdate /ONEDCONV_tb/tb_enable
add wave -noupdate -radix decimal /ONEDCONV_tb/OneDConv/OneDConvOe/ONEDCONV_OEN_Clr
add wave -noupdate -radix binary /ONEDCONV_tb/OneDConv/OneDConvOe/ONEDCONV_OEN_SetEn_Clr
add wave -noupdate /ONEDCONV_tb/OneDConv/OneDConvOe/ONEDCONV_OEN_Flag_Out_Full
add wave -noupdate -radix binary /ONEDCONV_tb/OneDConv/OneDConvSetEn/ONEDCONV_SET_EN_Oen_clr
add wave -noupdate -radix decimal /ONEDCONV_tb/OneDConv/OneDConvSetEn/ONEDCONV_SET_EN_Flag_Om_Full
add wave -noupdate -radix decimal /ONEDCONV_tb/OneDConv/OneDConvSetEn/Set_counter
add wave -noupdate /ONEDCONV_tb/OneDConv/OneDConvOe/Inner_Str
add wave -noupdate -radix binary /ONEDCONV_tb/OneDConv/OneDConvSetEn/ONEDCONV_SET_EN_Clr
add wave -noupdate -radix decimal /ONEDCONV_tb/OneDConv/OneDConvOe/Oe_counter
add wave -noupdate -label OneDConv/State_Machine/State_Register -radix unsigned /ONEDCONV_tb/OneDConv/State_Machine/State_Register
add wave -noupdate -label OneDConv/State_Machine/State_Signal -radix unsigned /ONEDCONV_tb/OneDConv/State_Machine/State_Signal
add wave -noupdate -format Literal -radix decimal /ONEDCONV_tb/OneDConv/ONEDCONV_Set_En
add wave -noupdate -format Literal -radix binary /ONEDCONV_tb/OneDConv/ONEDCONV_O_En
add wave -noupdate -format Literal -radix decimal /ONEDCONV_tb/OneDConv/OneDConvOe/ONEDCONV_OEN_Wptclr
add wave -noupdate -format Literal -radix binary /ONEDCONV_tb/OneDConv/OneDConvSetEn/ONEDCONV_SET_EN_Rptclr
add wave -noupdate -radix binary /ONEDCONV_tb/tb_flag_Eqcw
add wave -noupdate -radix binary /ONEDCONV_tb/tb_flag_Eqst
add wave -noupdate -radix binary /ONEDCONV_tb/tb_flag_Eqcif
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {220 ps} 0}
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
WaveRestoreZoom {193 ps} {238 ps}
