set_global_assignment -entity "sxrRISC_pll" -library "lib_sxrRISC_pll" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "sxrRISC_pll" -library "lib_sxrRISC_pll" -name IP_TOOL_VERSION "15.1"
set_global_assignment -entity "sxrRISC_pll" -library "lib_sxrRISC_pll" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_sxrRISC_pll" -name SPD_FILE [file join $::quartus(sip_path) "sxrRISC_pll.spd"]

set_global_assignment -library "lib_sxrRISC_pll" -name MISC_FILE [file join $::quartus(sip_path) "sxrRISC_pll_sim/sxrRISC_pll.vo"]
