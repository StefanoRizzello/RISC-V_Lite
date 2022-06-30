project new . $1.mpf
project addfile ../hdl/src/ram.vhd
project addfile ../hdl/tb/RV32I_tb.vhd
project addfile ../netlist/RV32I.v
project compileall
vsim -L /software/dk/nangate45/verilog/msim6.2g -sdftyp /rv32i_tb/processor=../netlist/RV32I.sdf work.rv32i_tb
vcd file ../vcd/RV32I.vcd
vcd add /rv32i_tb/*
run 2 us
quit -sim
project close
quit
