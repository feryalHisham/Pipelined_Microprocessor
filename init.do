add wave -position end sim:/pipeline/*
force -freeze sim:/pipeline/Rst 0 0
mem load -i {/home/fatema/Desktop/College/Third year/Second Term/Arch/Pipelined_Microprocessor/FRam.mem} /pipeline/f/ramm/ram
mem load -i {/home/fatema/Desktop/College/Third year/Second Term/Arch/Pipelined_Microprocessor/Fmem.mem} /pipeline/M/mem/ram
force -freeze sim:/pipeline/Clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/pipeline/Rst 1 0
force -freeze sim:/pipeline/INTERUPT 0 0
run

force -freeze sim:/pipeline/Rst 0 0
run

