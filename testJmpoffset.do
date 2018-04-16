vsim work.jmpoffset

add wave -position end sim:/jmpoffset/*

force -freeze sim:/jmpoffset/clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/jmpoffset/IRBuff 1100000000000000 0
force -freeze sim:/jmpoffset/flagReg 1100 0
force -freeze sim:/jmpoffset/delayJMP 0 0
force -freeze sim:/jmpoffset/delayJMPDE 0 0
force -freeze sim:/jmpoffset/rstHard 0 0
run
force -freeze sim:/jmpoffset/rstHard 0 0
run
run

force -freeze sim:/jmpoffset/delayJMP 1 0
run
#jz
force -freeze sim:/jmpoffset/IRBuff 0000000000000000 0
run