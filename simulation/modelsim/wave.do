onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix hexadecimal /sxrRISC621_tb/RISC621/Resetn_pin
add wave -noupdate -radix hexadecimal /sxrRISC621_tb/RISC621/Clock_pin
add wave -noupdate -radix hexadecimal -childformat {{{/sxrRISC621_tb/RISC621/R[15]} -radix hexadecimal} {{/sxrRISC621_tb/RISC621/R[14]} -radix hexadecimal} {{/sxrRISC621_tb/RISC621/R[13]} -radix hexadecimal} {{/sxrRISC621_tb/RISC621/R[12]} -radix hexadecimal} {{/sxrRISC621_tb/RISC621/R[11]} -radix hexadecimal} {{/sxrRISC621_tb/RISC621/R[10]} -radix hexadecimal} {{/sxrRISC621_tb/RISC621/R[9]} -radix hexadecimal} {{/sxrRISC621_tb/RISC621/R[8]} -radix hexadecimal} {{/sxrRISC621_tb/RISC621/R[7]} -radix hexadecimal} {{/sxrRISC621_tb/RISC621/R[6]} -radix hexadecimal} {{/sxrRISC621_tb/RISC621/R[5]} -radix hexadecimal} {{/sxrRISC621_tb/RISC621/R[4]} -radix hexadecimal} {{/sxrRISC621_tb/RISC621/R[3]} -radix hexadecimal} {{/sxrRISC621_tb/RISC621/R[2]} -radix hexadecimal} {{/sxrRISC621_tb/RISC621/R[1]} -radix hexadecimal} {{/sxrRISC621_tb/RISC621/R[0]} -radix hexadecimal}} -expand -subitemconfig {{/sxrRISC621_tb/RISC621/R[15]} {-height 15 -radix hexadecimal} {/sxrRISC621_tb/RISC621/R[14]} {-height 15 -radix hexadecimal} {/sxrRISC621_tb/RISC621/R[13]} {-height 15 -radix hexadecimal} {/sxrRISC621_tb/RISC621/R[12]} {-height 15 -radix hexadecimal} {/sxrRISC621_tb/RISC621/R[11]} {-height 15 -radix hexadecimal} {/sxrRISC621_tb/RISC621/R[10]} {-height 15 -radix hexadecimal} {/sxrRISC621_tb/RISC621/R[9]} {-height 15 -radix hexadecimal} {/sxrRISC621_tb/RISC621/R[8]} {-height 15 -radix hexadecimal} {/sxrRISC621_tb/RISC621/R[7]} {-height 15 -radix hexadecimal} {/sxrRISC621_tb/RISC621/R[6]} {-height 15 -radix hexadecimal} {/sxrRISC621_tb/RISC621/R[5]} {-height 15 -radix hexadecimal} {/sxrRISC621_tb/RISC621/R[4]} {-height 15 -radix hexadecimal} {/sxrRISC621_tb/RISC621/R[3]} {-height 15 -radix hexadecimal} {/sxrRISC621_tb/RISC621/R[2]} {-height 15 -radix hexadecimal} {/sxrRISC621_tb/RISC621/R[1]} {-height 15 -radix hexadecimal} {/sxrRISC621_tb/RISC621/R[0]} {-height 15 -radix hexadecimal}} /sxrRISC621_tb/RISC621/R
add wave -noupdate -radix decimal /sxrRISC621_tb/RISC621/PC
add wave -noupdate -radix hexadecimal /sxrRISC621_tb/RISC621/IR
add wave -noupdate -radix hexadecimal /sxrRISC621_tb/RISC621/DM_in
add wave -noupdate -radix hexadecimal /sxrRISC621_tb/RISC621/TSR
add wave -noupdate -radix hexadecimal /sxrRISC621_tb/RISC621/SR
add wave -noupdate -radix hexadecimal /sxrRISC621_tb/RISC621/PM_out
add wave -noupdate -radix hexadecimal /sxrRISC621_tb/RISC621/DM_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2638548949 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 314
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
WaveRestoreZoom {1578937500 ps} {3684187500 ps}
