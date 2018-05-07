
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY forwardDetect IS 
GENERIC ( n : integer := 3); 
	
	PORT ( rSrcAddress_Buff,rSrcAddress_DE,rSrcAddress_EM 			:IN std_logic_vector(n-1 DOWNTO 0);
		rDstAddress_Buff,rDstAddress_DE,rDstAddress_EM,rDstAddress_IR 	:IN std_logic_vector(n-1 DOWNTO 0);

		clk ,hardRst,RtypeEM,RtypeDE,RtypeIR,LDM_EM,IN_EM,IN_DE,LDD_EM,POP_DE, Call_JMP_IR,
		twoOperand,memReadEM,memReadDE,
		writeEnrDstEM,writeEnrSrcEM,writeEnrDstDE,writeEnrSrcDE,
		writeEnrDstIR,writeEnrSrcIR	: IN std_logic;
		
		stallLDout,stallLDReg,delayJMP,execResultLSrcSelMW, execResultLDstSelMW,execResultHDstSelEM,execResultHSrcSelEM,
		execResultHSrcSelMW,execResultHDstSelMW,execResultLSrcSelEM,execResultLDstSelEM,inPortMWSrc,inPortMWDst,
		memResSrcSelMW,memResDstSelMW,immedMWSrc,immedMWDst,inPortEMSrc,inPortEMDst	:OUT std_logic);   

END ENTITY forwardDetect;


ARCHITECTURE forwarding OF forwardDetect IS
component comparing_component IS 
GENERIC ( n : integer := 3); 
		PORT (  RegAddress_Buff,RegAddress_DE	: IN std_logic_vector(n-1 DOWNTO 0);
			WriteEn,twoOperand		:  IN std_logic;
  		   	execResSel			: OUT std_logic);      
END component;

component my_DFF IS
	 PORT(clk,rst,en,d : IN std_logic;
	    q : OUT std_logic);
END component;
	 --execResultLSrcSelMWSig,execResultLDstSelMWSig,execResultLSrcSelEMSig,execResultHSrcSelEMSig
		   --execResultHSrcSelMWSig,execResultHDstSelMWSig,execResultLDstSelEMSig,execResultHDstSelEMSig
		   --memResSrcSelMWSig,memResDstSelMWSig, immedMWSrcSig,immedMWDstSig,	
		   --inPortMWSrcSig,inPortMWDstSig,inPortEMSrcSig,inPortEMDstSig,forwardIN_LDMSrc,forwardIN_LDMDst,
		signal   stallLDSrcSig,stallLDDstSig,stallLD, rststallLDReg,
		   delayJMPLDD, delayJMPRtype, delayJMPmul, delayJMPmem, delayJMPrtypeDE, delayJMPmulDE,				 
		   enExecResMW,	enExecResEM,enExecResDE					:std_logic;

------------------- feryaal ---------------------


signal JMP_LDD_condition,JMP_Rtype_condition,JMP_MUL_condition,JMP_Mem_condition,
JMP_Rtype_DE_condition,JMP_MUL_DE_condition : std_logic;





BEGIN
--Abl Ably Rtype:>

	enExecResMW<=writeEnrDstEM and RtypeEM;
	execResultSrcLMW: comparing_component GENERIC MAP (n=>3) port map (rSrcAddress_Buff,rDstAddress_EM,enExecResMW,twoOperand,execResultLSrcSelMW);
	execResultDstLMW: comparing_component GENERIC MAP (n=>3) port map (rDstAddress_Buff,rDstAddress_EM,enExecResMW,'1',execResultLDstSelMW);

--abl ably Mul	
	execResultScrMW: comparing_component GENERIC MAP (n=>3) port map (rSrcAddress_Buff,rSrcAddress_EM,writeEnrSrcEM,twoOperand,execResultHSrcSelMW);
	execResultDstMW: comparing_component GENERIC MAP (n=>3) port map (rDstAddress_Buff,rSrcAddress_EM,writeEnrSrcEM,'1',execResultHDstSelMW);

--abl ably pop/LDD
	memResSrcSelMWL: comparing_component GENERIC MAP (n=>3) port map (rSrcAddress_Buff,rDstAddress_EM,memReadEM,twoOperand,memResSrcSelMW);
	memResDstSelLL: comparing_component GENERIC MAP (n=>3) port map (rDstAddress_Buff,rDstAddress_EM,memReadEM,'1',memResDstSelMW);

	enExecResEM<=writeEnrDstDE and RtypeDE;
--ably Rtype (MUL)
	execResultSrcHEM: comparing_component GENERIC MAP (n=>3) port map (rSrcAddress_Buff,rSrcAddress_DE,writeEnrSrcDE,twoOperand,execResultHSrcSelEM);
	execResultDstHEM: comparing_component GENERIC MAP (n=>3) port map (rDstAddress_Buff,rSrcAddress_DE,writeEnrSrcDE,'1',execResultHDstSelEM);


--ably Rtype   --------------- feryaal dol kano na2seen -----------------------
enExecResDE<=writeEnrDstDE and RtypeDE;
execResultSrcLEM: comparing_component GENERIC MAP (n=>3) port map (rSrcAddress_Buff,rDstAddress_DE,enExecResDE,twoOperand,execResultLSrcSelEM);
execResultDstLEM: comparing_component GENERIC MAP (n=>3) port map (rDstAddress_Buff,rDstAddress_DE,enExecResDE,'1',execResultLDstSelEM);

----------------------------------------------------------------------------------

--LDM ably
	immedMWSrcL: comparing_component GENERIC MAP (n=>3) port map (rSrcAddress_Buff,rDstAddress_EM,LDM_EM,'1',immedMWSrc);
	immedMWDstL: comparing_component GENERIC MAP (n=>3) port map (rDstAddress_Buff,rDstAddress_EM,LDM_EM,'1',immedMWDst);

--IN 
	inPortMWSrcL: comparing_component GENERIC MAP (n=>3) port map (rSrcAddress_Buff,rDstAddress_EM,IN_EM,'1',inPortMWSrc);
	inPortMWDstL: comparing_component GENERIC MAP (n=>3) port map (rDstAddress_Buff,rDstAddress_EM,IN_EM,'1',inPortMWDst);

	inPortEMSrcL: comparing_component GENERIC MAP (n=>3) port map (rSrcAddress_Buff,rDstAddress_EM,IN_DE,'1',inPortEMSrc);
	inPortEMDstL: comparing_component GENERIC MAP (n=>3) port map (rDstAddress_Buff,rDstAddress_EM,IN_DE,'1',inPortEMDst);

	-- forwardIN_LDMSrcSig<= immedMWSrcSig or inPortMWSrcSig or inPortEMSrcSig;
	-- forwardIN_LDMDstSig<= immedMWDstSig or inPortMWDstSig or inPortEMDstSig;
	
	-- forwardIN_LDMSrc<=forwardIN_LDMSrcSig;
	-- forwardIN_LDMDst<=forwardIN_LDMDstSig;

	-- forwardSrc<= forwardIN_LDMSrcSig or execResultLSrcSelMWSig or execResultHSrcSelMWSig or
	--  memResSrcSelMWSig or execResultLSrcSelEMSig or execResultHSrcSelEMSig;
	-- forwardDst<= forwardIN_LDMDstSig or execResultLDstSelMWSig or execResultHDstSelMWSig or
	--  memResDstSelMWSig or execResultLDstSelEMSig or execResultHDstSelEMSig;

	-- execResultLSrcSelMW<=execResultLSrcSelMWSig;
	-- execResultLDstSelMW<=execResultLDstSelMWSig;
	-- execResultHDstSelEM<=execResultHDstSelEMSig;
	-- execResultHSrcSelEM<=execResultHSrcSelEMSig;
	-- execResultHSrcSelMW<=execResultHSrcSelMWSig;
	-- execResultHDstSelMW<=execResultHDstSelMWSig;
	-- memResSrcSelMW<=memResSrcSelMWSig;
	-- memResDstSelMW<=memResDstSelMWSig;
	-- immedMWSrc<=immedMWSrcSig;
	-- immedMWDst<=immedMWDstSig;
	-- inPortMWSrc<=inPortMWSrcSig;
	-- inPortMWDst<=inPortMWDstSig;
	-- inPortEMSrc<=inPortEMSrcSig;
	-- inPortEMDst<=inPortEMDstSig;
	

-- Delay JMP/Call
	
JMP_LDD_condition<= Call_JMP_IR and LDD_EM; 
	
JMP_Rtype_condition<= Call_JMP_IR and writeEnrDstIR;
JMP_MUL_condition<= Call_JMP_IR and writeEnrSrcIR;
JMP_Mem_condition<= Call_JMP_IR and memReadDE;

JMP_Rtype_DE_condition<= Call_JMP_IR and writeEnrDstDE;
JMP_MUL_DE_condition<= Call_JMP_IR and writeEnrSrcDE;




	delayJMP1: comparing_component GENERIC MAP (n=>3) port map (rDstAddress_IR,rDstAddress_EM,JMP_LDD_condition,'1',delayJMPLDD);	
	delayJMP2: comparing_component GENERIC MAP (n=>3) port map (rDstAddress_IR,rDstAddress_Buff,JMP_Rtype_condition,RtypeIR,delayJMPRtype);
	delayJMP3: comparing_component GENERIC MAP (n=>3) port map (rDstAddress_IR,rSrcAddress_Buff,JMP_MUL_condition,'1',delayJMPmul);
	delayJMP4: comparing_component GENERIC MAP (n=>3) port map (rDstAddress_IR,rDstAddress_Buff,JMP_Mem_condition,'1',delayJMPmem);
	--ably LDD/POP cases
	delayJMP5: comparing_component GENERIC MAP (n=>3) port map (rDstAddress_IR,rDstAddress_DE,writeEnrDstDE,RtypeDE,delayJMPrtypeDE);
	delayJMP6: comparing_component GENERIC MAP (n=>3) port map (rDstAddress_IR,rSrcAddress_DE,writeEnrSrcDE,RtypeDE,delayJMPmulDE);
	--abl ably Rtype
	--********************************************************************************************************************--
	delayJMP<=delayJMPLDD or delayJMPRtype or delayJMPmul or delayJMPmem or delayJMPrtypeDE or delayJMPmulDE;
--StallLD
	stallLD1: comparing_component GENERIC MAP (n=>3) port map (rSrcAddress_Buff,rDstAddress_DE,POP_DE,'1',stallLDSrcSig);
	stallLD2: comparing_component GENERIC MAP (n=>3) port map (rDstAddress_Buff,rDstAddress_DE,POP_DE,'1',stallLDDstSig);

	stallLDout<=stallLD;
	stallLD<=stallLDDstSig or stallLDSrcSig;
	rststallLDReg<=stallLD and (clk);
	stallLDBuffL: my_DFF port map(clk,rststallLDReg,'1',stallLD,stallLDReg);

END forwarding;