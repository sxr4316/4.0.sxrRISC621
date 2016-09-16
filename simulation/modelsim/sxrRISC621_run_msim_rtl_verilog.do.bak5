transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+D:/sxrRISC621 {D:/sxrRISC621/sxrRISC621.v}
vlog -vlog01compat -work work +incdir+D:/sxrRISC621 {D:/sxrRISC621/sxrRISC621_rom.v}
vlog -vlog01compat -work work +incdir+D:/sxrRISC621 {D:/sxrRISC621/sxrRISC621_ram.v}
vlog -vlog01compat -work work +incdir+D:/sxrRISC621 {D:/sxrRISC621/sxrRISC621_mult.v}
vlog -vlog01compat -work work +incdir+D:/sxrRISC621 {D:/sxrRISC621/sxrRISC621_div.v}
vlog -vlog01compat -work work +incdir+D:/sxrRISC621/db {D:/sxrRISC621/db/mult_01n.v}

vlog -vlog01compat -work work +incdir+D:/sxrRISC621 {D:/sxrRISC621/sxrRISC621_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  sxrRISC621_tb

add wave *
view structure
view signals
run -all
