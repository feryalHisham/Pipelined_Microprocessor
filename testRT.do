vsim work.rtcircuit

add wave -position end sim:/rtcircuit/*
force -freeze sim:/rtcircuit/IR 0000000000000000 0
force -freeze sim:/rtcircuit/stallLD 0 0
force -freeze sim:/rtcircuit/clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/rtcircuit/rstHard 1 0
run
run
run
force -freeze sim:/rtcircuit/rstHard 0 0
run

force -freeze sim:/rtcircuit/IR 0100000000000000 0
run

force -freeze sim:/rtcircuit/IR 0110000000000000 0
run
run
run
force -freeze sim:/rtcircuit/IR 0110000000000000 0
run
run
run

force -freeze sim:/rtcircuit/IR 0100000000000000 0
run
force -freeze sim:/rtcircuit/stallLD 1 0
run
run
force -freeze sim:/rtcircuit/stallLD 0 0
run
run