source /software/scripts/init_msim6.2g
cd sim/
vsim -c -do "do scripts/run_riscv_cmd.do RV32I"
