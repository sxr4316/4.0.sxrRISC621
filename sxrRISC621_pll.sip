set_global_assignment -entity "sxrRISC621_pll" -library "lib_sxrRISC621_pll" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "sxrRISC621_pll" -library "lib_sxrRISC621_pll" -name IP_TOOL_VERSION "15.1"
set_global_assignment -entity "sxrRISC621_pll" -library "lib_sxrRISC621_pll" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_sxrRISC621_pll" -name SPD_FILE [file join $::quartus(sip_path) "sxrRISC621_pll.spd"]

set_global_assignment -library "lib_sxrRISC621_pll" -name MISC_FILE [file join $::quartus(sip_path) "sxrRISC621_pll_sim/sxrRISC621_pll.vo"]
