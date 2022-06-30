source /software/scripts/init_msim6.2g
cd sim/
vlib work
vsim -c -do "do scripts/create_project_cmd.do RV32I"
