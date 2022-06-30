proc elab {} {
source .synopsys_dc.setup
#adding elemts
analyze -f vhdl -lib WORK ../hdl/src/absolute_value.vhd
analyze -f vhdl -lib WORK ../hdl/src/add_sub.vhd
analyze -f vhdl -lib WORK ../hdl/src/alu.vhd
analyze -f vhdl -lib WORK ../hdl/src/alu_control.vhd
analyze -f vhdl -lib WORK ../hdl/src/barrel_shifter.vhd
analyze -f vhdl -lib WORK ../hdl/src/control.vhd
analyze -f vhdl -lib WORK ../hdl/src/dec_5to32.vhd                   
analyze -f vhdl -lib WORK ../hdl/src/decode_stage.vhd
analyze -f vhdl -lib WORK ../hdl/src/decode_stage_control.vhd  
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
analyze -f vhdl -lib WORK ../hdl/src/ram.vhd
analyze -f vhdl -lib WORK ../hdl/src/reg.vhd
analyze -f vhdl -lib WORK ../hdl/src/reg_file.vhd
analyze -f vhdl -lib WORK ../hdl/src/RV32I.vhd
analyze -f vhdl -lib WORK ../hdl/src/RV32I_control.vhd
analyze -f vhdl -lib WORK ../hdl/src/unary_AND.vhd
analyze -f vhdl -lib WORK ../hdl/src/wb_stage.vhd

set power_preserve_rtl_hier_names true
elaborate RV32I -arch str -lib WORK > reports_riscv/elaborate.txt
#filter contains multiple instances of reg, need to uniquify
uniquify 
link
ungroup -all -flatten
#set_implementation DW02_mult/csa [find cell I2/mult_134]
}
elab
