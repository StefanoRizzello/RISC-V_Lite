read_verilog -netlist ../netlist/RV32I.v
read_saif -input ../saif/RV32I.saif -instance riscv_tb/ -unit ns -scale 1
create_clock -name MY_CLK clock
report_power > reports/power_report.txt
quit
