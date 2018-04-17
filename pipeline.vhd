LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY pipeline IS
GENERIC ( n : integer := 16);
PORT( Clk,Rst,INTERUPT : IN std_logic;
		  in_port : IN std_logic_vector(n-1 DOWNTO 0);
		  out_port: OUT std_logic_vector(n-1 DOWNTO 0));
END pipeline;

ARCHITECTURE a_pipeline OF pipeline IS

component fetch IS
	
	port (Clk : IN std_logic;
              Reset,Int_en,select_offset,delay_jmp,RTI,RET,Int_pc_sel,stall_ld,jmp_cond,imm_buf: in std_logic;
           pc_mem,Rdst_buf_ie_im,Rdst : IN std_logic_vector(15 DOWNTO 0);
          counter: IN std_logic_vector(2 DOWNTO 0);
counter_RT: IN std_logic_vector(1 DOWNTO 0);
            ir_fetch,ir_buf,pc_call,pc_to_int: out std_logic_vector(15 DOWNTO 0)
           ); 
		
END component;


component Decode IS
	Generic (m : integer :=16);
	port (	clk,rst: in std_logic ;
		IR_Buff , write_data_Rdst, Exec_Result_H , IR,PC_Call:in std_logic_vector (m-1 downto 0);
		Rdst_add_IM_IW, Rsrc_add_IM_IW: in std_logic_vector(2 downto 0);
		write_en_Rsrc_IM_IW,write_en_Rdst_IM_IW ,Imm_control_signal , JMP_cond , Stall_LD : in std_logic;
		
		 Rsrc_Buff_in,Rdst_Buff_in   : in std_logic_vector(m-1 downto 0 );

		-- from CU 
		RTI_sig,SETC_sig,CLRC_sig,SETC_or_CLRC_sig,en_exec_result_sig : in std_logic;
		ALU_op_ctrl : in std_logic_vector (3 downto 0);
		write_en_Rsrc,write_en_Rdst,inc_SP,en_SP,en_mem_write,out_en_reg,S1_WB,S0_WB: in std_logic;

	
		write_en_Rsrc_ID_IE,write_en_Rdst_ID_IE,inc_SP_ID_IE,en_SP_ID_IE,en_mem_write_ID_IE,out_en_reg_ID_IE,S1_WB_ID_IE,S0_WB_ID_IE: out std_logic;
		RTI_sig_ID_IE,SETC_sig_ID_IE,CLRC_sig_ID_IE,SETC_or_CLRC_sig_ID_IE,en_exec_result_sig_ID_IE : out std_logic;
		ALU_op_ctrl_ID_IE : out std_logic_vector (3 downto 0);
		-- end out CU signals 
		Rsrc_out_RegFile,Rdst_out_RegFile	: out std_logic_vector(m-1 downto 0 );
		Rsrc_buff_ID_IE , Rdst_buff_ID_IE , IR_Immediate_ID_IE ,PC_Call_ID_IE,ReadinFetch_dataBus: out std_logic_vector(m-1 downto 0 );
		Rsrc_add_ID_IE,Rdst_add_ID_IE: out std_logic_vector (2 downto 0);
		Imm_buff_ID_IE: out std_logic
		);
end component;

component  execute is
generic ( n : integer := 16);  

PORT ( Clk,RESET,RTI_sig,SETC_sig,CLRC_sig,SETC_or_CLRC_sig,en_flag_buf_sig,en_exec_result_sig: in std_logic;

	
	Rdst_buf_in,Rsrc_buf_in: in std_logic_vector(n-1 downto 0); --pass it also 
	ALU_op_ctrl: in std_logic_vector (3 downto 0); --pass immediate_val also
	immediate_val_in : in std_logic_vector (15 downto 0);
	write_en_Rsrc_in,write_en_Rdst_in,inc_SP_in,en_SP_in,en_mem_write_in,out_en_reg_in,S1_WB_in,S0_WB_in: in std_logic;
	--pass these registers 
	Rdst_add_in,Rsrc_add_in: in std_logic_vector (2 downto 0); 
	PC_call_in: in std_logic_vector (n-1 downto 0);
	-- outputs of IE_IM buffer
	write_en_Rsrc_IE_IM,write_en_Rdst_IE_IM,inc_SP_IE_IM,en_SP_IE_IM,en_mem_write_IE_IM,out_en_reg_IE_IM,S1_WB_IE_IM,S0_WB_IE_IM:out std_logic;
	
	
	Rdst_add_IE_IM,Rsrc_add_IE_IM: out std_logic_vector (2 downto 0); 
	PC_call_IE_IM,Rdst_buf_IE_IM,Rsrc_buf_IE_IM: out std_logic_vector (n-1 downto 0);
	immediate_val_IE_IM: out std_logic_vector (15 downto 0);

	execute_result_H_IE_IM,execute_result_L_IE_IM : out std_logic_vector(n-1 downto 0);
	flags_IE_IM: out std_logic_vector (3 downto 0)
);
end component;


component memory IS
	
	port (Clk : IN std_logic;
              Reset,int_en,std,push,exc_int,en_mem_wr,int_pc_sel,sp_address,inc_sp,en_sp: in std_logic;
            s1_wb_ie_im,so_wb_ie_im,out_en_reg_ie_im,en_write_Rdst_IE_IM,en_write_Rsrc_IE_IM: in std_logic;
           pc_call,pc_int,Rdst_buf_ie_im,immediate_ie_m,Exc_result_H_IE_IM,Exc_result_L_IE_IM: IN std_logic_vector(15 DOWNTO 0);

            Rsrc_add_ie_im,Rdst_add_ie_im : IN std_logic_vector(2 DOWNTO 0);

            mem_result,pc_mem,immediate_im_iw,Rdst_buf_im_iw,Exc_result_H_IM_IW,Exc_result_L_IM_IW: out std_logic_vector(15 DOWNTO 0);
            Rsrc_add_im_iw,Rdst_add_im_iw: out std_logic_vector(2 DOWNTO 0);
             s1_wb,so_wb,out_en_reg_im_iw,en_write_Rdst_IM_IW,en_write_Rsrc_IM_IW: out std_logic
           ); 
		
END component;



component WB IS
	port (	clk,rst: in std_logic ;
		Mem_Result,Exec_ResH,Immediate,In_Port,Rdst_buf_IM_IW: in std_logic_vector(15 downto 0);
		S1_WB,S0_WB,Out_en_Reg: in std_logic;
		Write_Data_Rdst,OUT_Port: out std_logic_vector(15 downto 0)
		);
END component;


component controlUnit IS 
GENERIC ( n : integer := 16); 
        PORT (IR,IRBuff : IN std_logic_vector(n-1 DOWNTO 0);
        flagReg : IN std_logic_vector(3 DOWNTO 0);
        clk,rstHard,stallLD,delayJMPDE:in std_logic; 
        jmpCondBuff,
        offsetSel,
        twoOp,incSp,enSP ,enMemWr,lddORpop,setcORclrc,
        imm,wrEnRdst,enExecRes,wrEnRsrc,outEnReg,
        alu1,alu2,alu3,alu4,s1Wb,s0Wb,
        RET,RTI,PUSH,STD: OUT std_logic;
        counterRTout:OUT std_logic_vector (1 downto 0));    
END component;

component forwardingUnit IS 
GENERIC ( n : integer := 16); 
		PORT (IR,IRBuff : IN std_logic_vector(n-1 DOWNTO 0);
		rSrcAddress_DE,rSrcAddress_EM,rDstAddress_DE,rDstAddress_EM :IN std_logic_vector(2 DOWNTO 0);
		writeEnrSrcDE,writeEnrDstDE,writeEnrDstEM,twoOp:IN std_logic;
		memReadEM,memReadMW:  IN std_logic;
		MulDE,RtypeDE,Clk:  IN std_logic;
		rSrc,rDst : IN std_logic_vector(n-1 DOWNTO 0);
		execResultHigh,execResultLow,memoryResult : IN std_logic_vector(n-1 DOWNTO 0);
		rSrcBuf,rDstBuf : OUT std_logic_vector(n-1 DOWNTO 0); 
		stallLD,stallLDBuff,delayJmp: OUT std_logic);       
END component;

component intCircuit IS 
GENERIC ( n : integer := 16); 
        PORT (pc : IN std_logic_vector(n-1 DOWNTO 0);
       int,stallLD,clk,rstHard:IN std_logic;      
        intEn,excINT,selINTPC,flagBuffEn : OUT std_logic;
        counterIntout:OUT std_logic_vector (2 downto 0);
        pcINTOut: OUT std_logic_vector(n-1 DOWNTO 0)
        );    
END component;





	signal Int_en_int_cir_sig,offsetSel_cu_sig,delayJMP_fu_sig,RTI_cu_sig,
		RET_cu_sig,PUSH_cu_sig,STD_cu_sig,selINTPC_int_cir_sig,stallLD_fu_sig,jmpCond_cu_sig,imm_cu_sig: std_logic;
		
		signal counter_RT_sig :std_logic_vector(1 downto 0);
        signal counter_sig :std_logic_vector(2 downto 0);
		
	signal pc_mem_m_sig,Rdst_buf_if_id_sig , Rdst_dec_sig : std_logic_vector(15 downto 0 );
	signal counter_int_cir_sig,counter_RT_cir_sig : std_logic_vector(2 downto 0);
	signal ir_fetch_sig,ir_buf_ID_IF_sig,pc_call_ID_IF_sig : std_logic_vector(15 DOWNTO 0);
	signal write_data_Rdst_WB_sig, Exec_Result_H_IM_IW_sig : std_logic_vector(15 DOWNTO 0);
	signal Rdst_add_IM_IW_sig, Rsrc_add_IM_IW_sig : std_logic_vector(2 downto 0);
	signal write_en_Rsrc_IM_IW_sig,write_en_Rdst_IM_IW_sig , JMP_cond_CU_sig , Stall_LD_FU_sig : std_logic ;
	signal 	Rsrc_buff_ID_IE_sig,Rdst_buff_ID_IE_sig,IR_Immediate_ID_IE_sig,PC_Call_ID_IE_sig:  std_logic_vector(15 downto 0 );
	signal	Rsrc_add_ID_IE_sig,Rdst_add_ID_IE_sig:  std_logic_vector (2 downto 0);
	signal 	Imm_buff_ID_IE_sig:  std_logic;
	
	
	signal 	SETC_CU_sig,CLRC_CU_sig,SETC_or_CLRC_CU_sig,en_exec_result_CU_sig :  std_logic;
	signal 	ALU_op_ctrl_CU_sig : std_logic_vector (3 downto 0);
	signal 	write_en_Rsrc_CU_sig,write_en_Rdst_CU_sig,inc_SP_CU_sig,en_SP_CU_sig,SP_address_CU_sig,en_mem_write_CU_sig,mem_read_CU_sig,LDD_or_pop_CU_sig,out_en_reg_CU_sig,S1_WB_CU_sig,S0_WB_CU_sig:  std_logic;
	
	signal	write_en_Rsrc_ID_IE_sig,write_en_Rdst_ID_IE_sig,inc_SP_ID_IE_sig,en_SP_ID_IE_sig,SP_address_ID_IE_sig,en_mem_write_ID_IE_sig,mem_read_ID_IE_sig,LDD_or_pop_ID_IE_sig,out_en_reg_ID_IE_sig,S1_WB_ID_IE_sig,S0_WB_ID_IE_sig: std_logic;
	signal 	RTI_sig_ID_IE,SETC_sig_ID_IE,CLRC_sig_ID_IE,SETC_or_CLRC_sig_ID_IE,en_exec_result_sig_ID_IE :  std_logic;
	signal 	ALU_op_ctrl_ID_IE_sig :  std_logic_vector (3 downto 0);
	
	signal STD_IE_IM_sig,PUSH_IE_IM_sig,exc_int_sig,en_mem_wr_IE_IM_sig,
	inc_sp_IE_IM_sig,en_sp_IE_IM_sig,s1_wb_IE_IM_sig,so_wb_IE_IM_sig,out_en_reg_IE_IM_sig,
	s1_IM_IW_sig,so_IM_IW_sig,out_en_reg_IM_IW_sig : std_logic;
	
	signal pc_call_IE_IM_sig,pc_int_int_cir,Rdst_buf_IE_IM_sig,immediate_IE_IM_sig,
	mem_result_IM_IW_sig,immediate_IM_IW_sig,Rdst_buf_IM_IW_sig,Exec_Result_L_IE_IM_sig,Exec_Result_H_IE_IM_sig,Exec_Result_L_IM_IW_sig: std_logic_vector(15 DOWNTO 0);
        signal Rsrc_add_IE_IM_sig,Rdst_add_IE_IM_sig:  std_logic_vector (2 downto 0);
	

        -------------------------------------------------------

	signal en_flag_buf_sig_INT, write_en_Rsrc_IE_IM_sig,write_en_Rdst_IE_IM_sig : std_logic;
	signal Rsrc_buf_IE_IM_sig : std_logic_vector (15 downto 0);

	----------------------------------------------------	
	

	signal flag_reg_sig:std_logic_vector(3 downto 0);
        signal delay_jmp_ID_IE_sig,twoOp_cu_sig:std_logic;
        
        -------------------------------------------------------------
        signal pc_to_int_sig: std_logic_vector (15 downto 0);
		-----------------------------Fatema------------mem_read_IE_IM_sig,mem_read_IM_IW_sig-------------
		signal Rsrc_buf_FU,Rdst_buf_FU,rsrc_data,rdst_data:std_logic_vector(15 downto 0);
		signal Stall_LD_buf_FU_sig,mul_ID_IE,rtype_ID_IE,Exec_Result_H_sig,Exec_Result_L_si
		,mem_read_IE_IM_sig,mem_read_IM_IW_sig:std_logic;
		------------------------------------------------
		

     
	
BEGIN

 

int_cir:intCircuit port map(pc_to_int_sig,INTERUPT,stallLD_fu_sig,Clk,Rst,Int_en_int_cir_sig,exc_int_sig,selINTPC_int_cir_sig,en_flag_buf_sig_INT
,counter_sig,pc_int_int_cir);



f:fetch port map(Clk,Rst,Int_en_int_cir_sig,offsetSel_cu_sig,delayJMP_fu_sig,RTI_cu_sig,
	RET_cu_sig,selINTPC_int_cir_sig,stallLD_fu_sig,jmpCond_cu_sig,imm_cu_sig,pc_mem_m_sig,Rdst_buf_IE_IM_sig , Rdst_dec_sig ,counter_sig,counter_RT_sig,ir_fetch_sig,ir_buf_ID_IF_sig,pc_call_ID_IF_sig ,pc_to_int_sig);

CU:controlUnit port map(ir_fetch_sig,ir_buf_ID_IF_sig,flag_reg_sig,Clk,Rst,stallLD_fu_sig,delay_jmp_ID_IE_sig,JMP_cond_CU_sig, 
offsetSel_cu_sig,twoOp_cu_sig,inc_SP_CU_sig,en_SP_CU_sig,en_mem_write_CU_sig,LDD_or_pop_CU_sig,SETC_or_CLRC_CU_sig,
imm_cu_sig,write_en_Rdst_CU_sig,en_exec_result_CU_sig,write_en_Rsrc_CU_sig,out_en_reg_CU_sig,
 ALU_op_ctrl_CU_sig(3),ALU_op_ctrl_CU_sig(2),ALU_op_ctrl_CU_sig(1),ALU_op_ctrl_CU_sig(0),S1_WB_CU_sig,S0_WB_CU_sig,RET_cu_sig,
		RTI_cu_sig,PUSH_cu_sig,STD_cu_sig,counter_RT_sig);


FU: forwardingUnit port map(ir_fetch_sig,ir_buf_ID_IF_sig,Rsrc_add_ID_IE_sig,Rsrc_add_IE_IM_sig,Rdst_add_ID_IE_sig,Rdst_add_IE_IM_sig,
write_en_Rsrc_ID_IE_sig,write_en_Rdst_ID_IE_sig,write_en_Rdst_IE_IM_sig,twoOp_cu_sig,
mem_read_IE_IM_sig,mem_read_IM_IW_sig,mul_ID_IE,rtype_ID_IE,Clk,rsrc_data,rdst_data,
Exec_Result_H_IE_IM_sig,Exec_Result_L_IE_IM_sig,mem_result_IM_IW_sig,Rsrc_buf_FU,Rdst_buf_FU,Stall_LD_FU_sig,Stall_LD_buf_FU_sig,delay_jmp_ID_IE_sig);


D: Decode Generic map (m=>16) port map (Clk,Rst,ir_buf_ID_IF_sig,write_data_Rdst_WB_sig, Exec_Result_H_IM_IW_sig,ir_fetch_sig,
pc_call_ID_IF_sig,Rdst_add_IM_IW_sig, Rsrc_add_IM_IW_sig,write_en_Rsrc_IM_IW_sig,write_en_Rdst_IM_IW_sig,imm_cu_sig,
JMP_cond_CU_sig , Stall_LD_FU_sig,Rsrc_buf_FU,Rdst_buf_FU,RTI_cu_sig,SETC_CU_sig,CLRC_CU_sig,SETC_or_CLRC_CU_sig,en_exec_result_CU_sig,
ALU_op_ctrl_CU_sig,write_en_Rsrc_CU_sig,write_en_Rdst_CU_sig,inc_SP_CU_sig,en_SP_CU_sig,en_mem_write_CU_sig,
out_en_reg_CU_sig,S1_WB_CU_sig,S0_WB_CU_sig,write_en_Rsrc_ID_IE_sig,write_en_Rdst_ID_IE_sig,inc_SP_ID_IE_sig,
en_SP_ID_IE_sig,en_mem_write_ID_IE_sig,out_en_reg_ID_IE_sig,S1_WB_ID_IE_sig,
S0_WB_ID_IE_sig,RTI_sig_ID_IE,SETC_sig_ID_IE,CLRC_sig_ID_IE,SETC_or_CLRC_sig_ID_IE,en_exec_result_sig_ID_IE,	
ALU_op_ctrl_ID_IE_sig,rsrc_data,rdst_data,Rsrc_buff_ID_IE_sig,Rdst_buff_ID_IE_sig,IR_Immediate_ID_IE_sig,PC_Call_ID_IE_sig,Rdst_dec_sig,
Rsrc_add_ID_IE_sig,Rdst_add_ID_IE_sig,Imm_buff_ID_IE_sig);



E: execute port map (Clk,Rst,RTI_cu_sig,SETC_CU_sig,CLRC_CU_sig,SETC_or_CLRC_CU_sig,en_flag_buf_sig_INT,
en_exec_result_CU_sig, Rdst_buff_ID_IE_sig,Rsrc_buff_ID_IE_sig,ALU_op_ctrl_ID_IE_sig,IR_Immediate_ID_IE_sig,
write_en_Rsrc_ID_IE_sig,write_en_Rdst_ID_IE_sig,inc_SP_ID_IE_sig,en_SP_ID_IE_sig,en_mem_write_ID_IE_sig,
out_en_reg_ID_IE_sig,S1_WB_ID_IE_sig,S0_WB_ID_IE_sig,Rdst_add_ID_IE_sig,Rsrc_add_ID_IE_sig,PC_Call_ID_IE_sig,
write_en_Rsrc_IE_IM_sig,write_en_Rdst_IE_IM_sig,inc_sp_IE_IM_sig,en_sp_IE_IM_sig,en_mem_wr_IE_IM_sig,
out_en_reg_IE_IM_sig,s1_IM_IW_sig,so_IM_IW_sig,Rdst_add_IE_IM_sig,Rsrc_add_IE_IM_sig,pc_call_IE_IM_sig,
Rdst_buf_IE_IM_sig,Rsrc_buf_IE_IM_sig,immediate_IE_IM_sig,Exec_Result_H_IE_IM_sig,Exec_Result_L_IE_IM_sig,flag_reg_sig);


M: memory port map(Clk,Rst,Int_en_int_cir_sig,STD_IE_IM_sig,PUSH_IE_IM_sig,exc_int_sig,en_mem_wr_IE_IM_sig,selINTPC_int_cir_sig,en_sp_IE_IM_sig,
inc_sp_IE_IM_sig,en_sp_IE_IM_sig,s1_wb_IE_IM_sig,so_wb_IE_IM_sig,out_en_reg_IE_IM_sig,write_en_Rdst_IE_IM_sig,write_en_Rsrc_IE_IM_sig
,pc_call_IE_IM_sig,pc_int_int_cir,Rdst_buf_IE_IM_sig,immediate_IE_IM_sig,
Exec_Result_H_IE_IM_sig,Exec_Result_L_IE_IM_sig,Rsrc_add_IE_IM_sig,Rdst_add_IE_IM_sig,mem_result_IM_IW_sig,pc_mem_m_sig,immediate_IM_IW_sig,Rdst_buf_IM_IW_sig,
Exec_Result_H_IM_IW_sig,Exec_Result_L_IM_IW_sig,Rsrc_add_IM_IW_sig,Rdst_add_IM_IW_sig,s1_IM_IW_sig,so_IM_IW_sig,out_en_reg_IM_IW_sig,
write_en_Rdst_IM_IW_sig,write_en_Rsrc_IM_IW_sig
);



WRB:WB port map(Clk,Rst,mem_result_IM_IW_sig,Exec_Result_H_IM_IW_sig,immediate_IM_IW_sig,in_port,Rdst_buf_IM_IW_sig,
s1_IM_IW_sig,so_IM_IW_sig,out_en_reg_IM_IW_sig,write_data_Rdst_WB_sig,out_port);



END a_pipeline;

