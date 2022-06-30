proc elab {} {
source .synopsys_dc.setup
#adding elemts
analyze -f vhdl -lib WORK ../hdl/src/absolute_value.vhd
analyze -f vhdl -lib WORK ../hdl/src/add_sub.vhd
analyze -f vhdl -lib WORK ../hdl/src/alu.vhd
analyze -f vhdl -lib WORK ../hdl/src/alu_control.vhd
analyze -f vhdl -lib WORK ../hdl/src/barrel_shifter.vhd
analyze -f vhdl -lib WORK ../hdl/src/branch_forwarding_unit.vhd
analyze -f vhdl -lib WORK ../hdl/src/control.vhd
analyze -f vhdl -lib WORK ../hdl/src/dec_5to32.vhd
analyze -f vhdl -lib WORK ../hdl/src/decode_stage.vhd
analyze -f vhdl -lib WORK ../hdl/src/decode_stage_control.vhd
analyze -f vhdl -lib WORK ../hdl/src/equality_checker.vhd
analyze -f vhdl -lib WORK ../hdl/src/execute_stage.vhd
analyze -f vhdl -lib WORK ../hdl/src/execute_stage_control.vhd
analyze -f vhdl -lib WORK ../hdl/src/fetch_stage.vhd
analyze -f vhdl -lib WORK ../hdl/src/forwarding_unit.vhd
analyze -f vhdl -lib WORK ../hdl/src/hazard_unit.vhd
analyze -f vhdl -lib WORK ../hdl/src/immediate_generator.vhd
analyze -f vhdl -lib WORK ../hdl/src/mem_stage.vhd
analyze -f vhdl -lib WORK ../hdl/src/mem_stage_control.vhd
analyze -f vhdl -lib WORK ../hdl/src/mux_2to1.vhd
analyze -f vhdl -lib WORK ../hdl/src/mux_2to1_bit.vhd
analyze -f vhdl -lib WORK ../hdl/src/mux_2to1_stall.vhd
analyze -f vhdl -lib WORK ../hdl/src/mux_4to1.vhd
analyze -f vhdl -lib WORK ../hdl/src/mux_32to1.vhd
analyze -f vhdl -lib WORK ../hdl/src/param_pkg.vhd
analyze -f vhdl -lib WORK ../hdl/src/reg.vhd
analyze -f vhdl -lib WORK ../hdl/src/reg_file.vhd
analyze -f vhdl -lib WORK ../hdl/src/RV32I_debug.vhd
analyze -f vhdl -lib WORK ../hdl/src/RV32I_control.vhd
analyze -f vhdl -lib WORK ../hdl/src/unary_AND.vhd
analyze -f vhdl -lib WORK ../hdl/src/wb_stage.vhd

set power_preserve_rtl_hier_names true
elaborate RV32I -arch str -lib WORK > ./reports/elaborate.txt
#filter contains multiple instances of reg, need to uniquify
uniquify 
link
ungroup -all -flatten
#set_implementation DW02_mult/csa [find cell *mult*]
}

proc synth {clk_var} {
#set clock @argv1+-0.07ns
create_clock -name MY_CLK -period $clk_var clock
set_dont_touch_network MY_CLK
set_clock_uncertainty 0.07 [get_clock MY_CLK]
set_input_delay 0.5 -max -clock MY_CLK [remove_from_collection [all_inputs] clock]
set_output_delay 0.5 -max -clock MY_CLK [all_outputs]
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]
compile
report_timing > reports/report_timing_${clk_var}_ns.txt
report_area > reports/report_area_clk_${clk_var}_ns.txt
report_resources > reports/report_resources_clk_${clk_var}_ns.txt

ungroup -all -flatten
change_names -hierarchy -rules verilog
write_sdf ../netlist/RV32I.sdf
write -f verilog -hierarchy -output ../netlist/RV32I.v
write_sdc ../netlist/RV32I.sdc

quit
}


elab
