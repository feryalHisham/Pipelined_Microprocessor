vsim -gui work.fetch
# vsim -gui work.fetch 
# Start time: 10:48:54 on Apr 05,2018
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading ieee.std_logic_arith(body)
# Loading ieee.std_logic_unsigned(body)
# Loading work.fetch(fetchh)
# Loading work.ram(syncrama)
# Loading work.my_ndff2(a_my_ndff2)
# Loading work.mux2_1(mux2_1_a)
# Loading work.my_ndff(a_my_ndff)
add wave -position insertpoint  \
sim:/fetch/Clk \
sim:/fetch/Reset \
sim:/fetch/Int_en \
sim:/fetch/select_offset \
sim:/fetch/delay_jmp \
sim:/fetch/RTI \
sim:/fetch/RET \
sim:/fetch/Int_pc_sel \
sim:/fetch/stall_ld \
sim:/fetch/jmp_cond \
sim:/fetch/imm_buf \
sim:/fetch/pc_mem \
sim:/fetch/Rdst_buf_ie_im \
sim:/fetch/Rdst \
sim:/fetch/counter \
sim:/fetch/counter_RT \
sim:/fetch/ir_fetch \
sim:/fetch/ir_buf \
sim:/fetch/pc_call \
sim:/fetch/pc_out \
sim:/fetch/pc_in \
sim:/fetch/pc_mux2_out \
sim:/fetch/pc_mux3_out \
sim:/fetch/ir \
sim:/fetch/pc_inc \
sim:/fetch/en_pc \
sim:/fetch/counter_0_1_2_3 \
sim:/fetch/counter_1_2_3 \
sim:/fetch/counter_rt_1_2 \
sim:/fetch/pc_mux1_s \
sim:/fetch/pc_mux2_s \
sim:/fetch/pc_mux3_s \
sim:/fetch/jmp_ir \
sim:/fetch/call_ir \
sim:/fetch/rst_ir_buf

force -freeze sim:/fetch/Clk 0 0, 1 {50 ps} -r 100
force -freeze sim:/fetch/Reset 1 0
force -freeze sim:/fetch/Int_pc_sel 0 0
force -freeze sim:/fetch/RET 0 0
force -freeze sim:/fetch/RTI 0 0
force -freeze sim:/fetch/pc_mem 0000000000000000 0
force -freeze sim:/fetch/counter 000 0
force -freeze sim:/fetch/counter_RT 000 0
force -freeze sim:/fetch/jmp_cond 0 0
force -freeze sim:/fetch/imm_buf 0 0
force -freeze sim:/fetch/Int_en 0 0
force -freeze sim:/fetch/stall_ld 0 0
force -freeze sim:/fetch/Rdst_buf_ie_im 0000000000000101 0
force -freeze sim:/fetch/Rdst 0000000000000101 0


run
force -freeze sim:/fetch/Reset 0 0
force -freeze sim:/fetch/delay_jmp 0 0
force -freeze sim:/fetch/select_offset 0 0

run
run
run

force -freeze sim:/fetch/select_offset 1 0

run
force -freeze sim:/fetch/select_offset 0 0
run