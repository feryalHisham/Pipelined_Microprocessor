vsim work.intcircuit


add wave -position end sim:/intcircuit/*

force -freeze sim:/intcircuit/clk 0 0, 1 {50 ps} -r 100

force -freeze sim:/intcircuit/pc 0000000000001000 0
force -freeze sim:/intcircuit/int 0 0
force -freeze sim:/intcircuit/stallLD 0 0
force -freeze sim:/intcircuit/rstHard 1 0
run
force -freeze sim:/intcircuit/rstHard 0 0
run

force -freeze sim:/intcircuit/int 1 0
run
force -freeze sim:/intcircuit/int 0 0
run
force -freeze sim:/intcircuit/stallLD 1 0