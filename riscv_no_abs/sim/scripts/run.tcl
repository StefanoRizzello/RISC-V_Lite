project open RV32I.mpf
project compileall
vsim work.RV32I_tb -t ns
do wave.do
run 500 ns
