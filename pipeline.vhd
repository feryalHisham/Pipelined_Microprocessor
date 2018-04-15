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
          counter,counter_RT: IN std_logic_vector(2 DOWNTO 0);
            ir_fetch,ir_buf,pc_call: out std_logic_vector(15 DOWNTO 0)
           ); 
		
END component;



component  Decode IS
	Generic (m : integer :=16);
	port (	clk,rst: in std_logic ;
		IR_Buff , write_data_Rdst, Exec_Result_H , IR,PC_Call:in std_logic_vector (m-1 downto 0);
		Rdst_add_IM_IW, Rsrc_add_IM_IW: in std_logic_vector(2 downto 0);
		write_en_Rsrc_IM_IW,write_en_Rdst_IM_IW ,Imm_control_signal , JMP_cond , Stall_LD : in std_logic;
		Rsrc_buff_ID_IE , Rdst_buff_ID_IE , IR_Immediate_ID_IM ,PC_Call_ID_IM: out std_logic_vector(m-1 downto 0 );
		Rsrc_add_ID_IE,Rdst_add_ID_IE: out std_logic_vector (2 downto 0);
		Imm_buff_ID_IE: out std_logic
		);
END component ;





component memory IS
	
	port (Clk : IN std_logic;
              Reset,int_en,std,push,exc_int,en_mem_wr,int_pc_sel,sp_address,inc_sp,en_sp: in std_logic;
            s1_wb_ie_im,so_wb_ie_im,out_en_reg_ie_im: in std_logic;
           pc_call,pc_int,Rdst_buf_ie_im,immediate_ie_m,Rsrc_add_ie_im,Rdst_add_ie_im : IN std_logic_vector(15 DOWNTO 0);

            mem_result,pc_mem,immediate_im_iw,Rdst_buf_im_iw,Rsrc_add_im_iw,Rdst_add_im_iw: out std_logic_vector(15 DOWNTO 0);
             s1_wb,so_wb,out_en_reg_im_iw: out std_logic
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
        clk,stallLD,delayJMP,delayJMPDE:std_logic;
             jmpCondBuff : OUT std_logic;
        stallRT,stallRTbuff,offsetSel,jmpCondReg : OUT std_logic;
        counterRTout:OUT std_logic_vector (1 downto 0));    
END component;


component forwardingUnit IS 
GENERIC ( n : integer := 16); 
		PORT (	IR,IRBuff : IN std_logic_vector(n-1 DOWNTO 0);
				rSrcAddress_DE,rSrcAddress_EM,rDstAddress_DE,rDstAddress_EM :IN std_logic_vector(2 DOWNTO 0);
				writeEnrSrcDE,writeEnrDstDE,writeEnrRsrcEM,writeEnrDstEM:IN std_logic;
                memReadEM,memReadMW:  IN std_logic;
                MulDE,RtypeDE,Clk:  IN std_logic;
				rSrc,rDst : IN std_logic_vector(n-1 DOWNTO 0);
				execResultHigh,execResultLow,memoryResult : IN std_logic_vector(n-1 DOWNTO 0);
				execResultLowSelSrc,forwardSelSrc:  IN std_logic;
				execResultLowSelDst,forwardSelDst:  IN std_logic;
				rSrcBuf,rDstBuf : OUT std_logic_vector(n-1 DOWNTO 0); 
				stallLD,stallLDBuff,delayJmp: OUT std_logic);       
END component;

BEGIN





END a_pipeline;

