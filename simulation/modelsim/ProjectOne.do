onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix decimal /sxrRISC621_tb/Clock_tb
add wave -noupdate -radix decimal /sxrRISC621_tb/Resetn_tb
add wave -noupdate -radix decimal /sxrRISC621_tb/RISC621/PC
add wave -noupdate -radix decimal /sxrRISC621_tb/RISC621/IR
add wave -noupdate -radix decimal /sxrRISC621_tb/RISC621/Ri
add wave -noupdate -radix decimal /sxrRISC621_tb/RISC621/Rj
add wave -noupdate -radix decimal /sxrRISC621_tb/RISC621/TA
add wave -noupdate -radix decimal /sxrRISC621_tb/RISC621/TB
add wave -noupdate -radix decimal /sxrRISC621_tb/RISC621/TALUH
add wave -noupdate -radix decimal /sxrRISC621_tb/RISC621/TALUL
add wave -noupdate -radix decimal /sxrRISC621_tb/RISC621/TALUout
add wave -noupdate -radix decimal /sxrRISC621_tb/RISC621/TSR
add wave -noupdate -radix decimal /sxrRISC621_tb/RISC621/SR
add wave -noupdate -radix decimal /sxrRISC621_tb/RISC621/R
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 256
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
WaveRestoreZoom {0 ps} {6284 ps}
