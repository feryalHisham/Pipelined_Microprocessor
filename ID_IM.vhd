

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity ID_IM IS
	port (	clk,rst: in std_logic ;
		IR,Rsrc_dataBus_read,Rdst_dataBus_read,PC_Call: in std_logic_vector(15 downto 0);
		Rsrc_add,Rdst_add: in std_logic_vector (2 downto 0);
		JMP_cond,Stall_LD, Imm_control_signal: in std_logic;
		Imm_buff_ID_IM: out std_logic;
		Rsrc_buff_ID_IM , Rdst_buff_ID_IM,IR_Immediate_ID_IM,PC_Call_ID_IM:out std_logic_vector(15 downto 0);
		Rsrc_add_ID_IM,Rdst_add_ID_IM: out std_logic_vector(2 downto 0)
		);
END ID_IM;


ARCHITECTURE my_ID_IM of ID_IM is 

component tristatebuff IS
	Generic (m : integer :=16);
	port ( input : in std_logic_vector (m-1 downto 0);
		output : out std_logic_vector (m-1 downto 0);
			enable: in std_logic);
END component;




component my_nDFF IS
GENERIC ( n : integer := 16);
PORT( Clk,Rst,enb : IN std_logic;
		   d : IN std_logic_vector(n-1 DOWNTO 0);
		   q : OUT std_logic_vector(n-1 DOWNTO 0));
END component;





component my_nDFF_fall IS
GENERIC ( n : integer := 16);
PORT( Clk,Rst,enb : IN std_logic;
		   d : IN std_logic_vector(n-1 DOWNTO 0);
		   q : OUT std_logic_vector(n-1 DOWNTO 0));
end component ;



component my_nDFF3 IS
PORT( Clk,Rst,enb : IN std_logic;
		   d : IN std_logic;
		   q : OUT std_logic);
END component;



signal JMP_cond_OR_Stall_LD : std_logic;

begin 

R1_Imm_buff : my_nDFF3 port map (clk,rst,'1',Imm_control_signal,Imm_buff_ID_IM);


R2_Rsrc_buff : my_nDFF_fall generic map (n=>16 ) port map (clk,JMP_cond_OR_Stall_LD,'1',Rsrc_dataBus_read,Rsrc_buff_ID_IM );

R3_Rdst_buff : my_nDFF_fall generic map (n=>16 ) port map (clk,JMP_cond_OR_Stall_LD,'1',Rdst_dataBus_read, Rdst_buff_ID_IM);

R4_Rsrc_add : my_nDFF_fall generic map (n=>3 ) port map (clk,rst,'1',Rsrc_add,Rsrc_add_ID_IM);

R5_Rdst_add : my_nDFF_fall generic map (n=>3 ) port map (clk,rst,'1',Rdst_add,Rdst_add_ID_IM);


R6_IR_immediate : my_nDFF generic map (n=>16 ) port map (clk,JMP_cond_OR_Stall_LD,'1',IR,IR_Immediate_ID_IM);

R7_PC_Call : my_nDFF generic map (n=>16 ) port map (clk,JMP_cond_OR_Stall_LD,'1',PC_Call,PC_Call_ID_IM);


JMP_cond_OR_Stall_LD <= JMP_cond or Stall_LD ;

end my_ID_IM;




