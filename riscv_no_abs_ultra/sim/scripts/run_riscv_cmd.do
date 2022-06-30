project open $1.mpf
project compileall
vsim work.rv32i_tb -t ns
run 2700 ns
quit -sim
project close
quit
