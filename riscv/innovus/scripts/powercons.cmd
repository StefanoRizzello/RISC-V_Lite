set_global _enable_mmmc_by_default_flow      $CTE::mmmc_default
suppressMessage ENCEXT-2799
getDrawView
loadWorkspace -name Physical
win
encMessage warning 0
encMessage debug 0
encMessage info 0

set TopLevelDesign "RV32I"

restoreDesign $TopLevelDesign.enc.dat $TopLevelDesign
setDrawView fplan
encMessage warning 1
encMessage debug 0
encMessage info 1
reset_parasitics
extractRC
rcOut -setload $TopLevelDesign.setload -rc_corner my_rc
rcOut -setres $TopLevelDesign.setres -rc_corner my_rc
rcOut -spf $TopLevelDesign.spf -rc_corner my_rc
rcOut -spef $TopLevelDesign.spef -rc_corner my_rc
set_power_analysis_mode -reset
set_power_analysis_mode -method static -corner max -create_binary_db true -write_static_currents true -honor_negative_energy true -ignore_control_signals true
set_power_output_dir -reset
set_power_output_dir ./
set_default_switching_activity -reset
set_default_switching_activity -input_activity 0.2 -period 10.0
read_activity_file -reset
read_activity_file -format VCD -scope /rv321_tb/processor -start {} -end {} -block {} ../vcd/$TopLevelDesign\_postplace.vcd
set_power -reset
set_powerup_analysis -reset
set_dynamic_power_simulation -reset
report_power -rail_analysis_format VS -outfile .//$TopLevelDesign.rpt
report_power -outfile powerReport/power_report.txt -sort { total }
exit
