vsim -gui work.memory
# vsim -gui work.memory 
# Start time: 18:13:33 on Apr 05,2018
# Loading std.standard
# Loading std.textio(body)
# Loading ieee.std_logic_1164(body)
# Loading ieee.numeric_std(body)
# Loading ieee.std_logic_arith(body)
# Loading ieee.std_logic_unsigned(body)
# Loading work.memory(memoryy)
# Loading work.ram(syncrama)
# Loading work.my_ndff_sp(a_my_ndff_sp)
# Loading work.mux2_1(mux2_1_a)
# Loading work.my_ndff(a_my_ndff)
add wave -position insertpoint  \
sim:/memory/Clk \
sim:/memory/Reset \
sim:/memory/int_en \
sim:/memory/std \
sim:/memory/push \
sim:/memory/exc_int \
sim:/memory/en_mem_wr \
sim:/memory/int_pc_sel \
sim:/memory/sp_address \
sim:/memory/inc_sp \
sim:/memory/en_sp \
sim:/memory/s1_wb_ie_im \
sim:/memory/so_wb_ie_im \
sim:/memory/out_en_reg_ie_im \
sim:/memory/pc_call \
sim:/memory/pc_int \
sim:/memory/Rdst_buf_ie_im \
sim:/memory/immediate_ie_m \
sim:/memory/Rsrc_add_ie_im \
sim:/memory/Rdst_add_ie_im \
sim:/memory/mem_result \
sim:/memory/pc_mem \
sim:/memory/immediate_im_iw \
sim:/memory/Rdst_buf_im_iw \
sim:/memory/Rsrc_add_im_iw \
sim:/memory/Rdst_add_im_iw \
sim:/memory/s1_wb \
sim:/memory/so_wb \
sim:/memory/out_en_reg_im_iw \
sim:/memory/sp_out \
sim:/memory/sp_mux_out \
sim:/memory/sp_inc \
sim:/memory/sp_dec \
sim:/memory/data_mem_in \
sim:/memory/data_mem_out \
sim:/memory/mem_address \
sim:/memory/mem_mux2_out \
sim:/memory/mem_mux3_out \
sim:/memory/mem_mux4_out \
sim:/memory/mem_in_mux2_out \
sim:/memory/en_mem \
sim:/memory/enable_sp \
sim:/memory/mem_mux1_s \
sim:/memory/mem_mux2_s \
sim:/memory/mem_in_mux1_s
force -freeze sim:/memory/push 0 0
force -freeze sim:/memory/exc_int 0 0
force -freeze sim:/memory/en_mem_wr 0 0
force -freeze sim:/memory/int_pc_sel 0 0
force -freeze sim:/memory/sp_address 0 0
force -freeze sim:/memory/inc_sp 0 0
force -freeze sim:/memory/en_sp 0 0
force -freeze sim:/memory/int_en 0 0
force -freeze sim:/memory/std 0 0
force -freeze sim:/memory/push 0 0
force -freeze sim:/memory/Reset 1 0
force -freeze sim:/memory/Clk 0 0, 1 {50 ps} -r 100
run
force -freeze sim:/memory/Reset 0 0
run
run
force -freeze sim:/memory/pc_int 0000000000000011 0
force -freeze sim:/memory/int_en 1 0
force -freeze sim:/memory/int_pc_sel 1 0
run
force -freeze sim:/memory/int_pc_sel 0 0
force -freeze sim:/memory/exc_int 1 0
run
force -freeze sim:/memory/exc_int 0 0
force -freeze sim:/memory/int_en 0 0
force -freeze sim:/memory/inc_sp 1 0
force -freeze sim:/memory/en_sp 1 0
run
force -freeze sim:/memory/en_sp 0 0
force -freeze sim:/memory/sp_address 0 0
force -freeze sim:/memory/immediate_ie_m 0000000000000100 0
run

