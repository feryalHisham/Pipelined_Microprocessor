
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY forwardDetect IS 
GENERIC ( n : integer := 3); 
		PORT (  rSrcAddress_Buff,rSrcAddress_DE,rSrcAddress_EM 			:IN std_logic_vector(n-1 DOWNTO 0);
			rDstAddress_Buff,rDstAddress_DE,rDstAddress_EM,rDstAddress_IR 	:IN std_logic_vector(n-1 DOWNTO 0);
			writeEnrDstDE,writeEnrDstEM					:IN std_logic;
			writeEnrSrcDE,twoOperand,forward				:IN std_logic;
			memReadEM,clk 							:IN std_logic;
  		   	stallLD,stallLDBuff,delayJmp : OUT std_logic);    
END ENTITY forwardDetect;


ARCHITECTURE forwarding OF forwardDetect IS
component comparing_component IS 
GENERIC ( n : integer := 3); 
		PORT (  RegAddress_Buff,RegAddress_DE	: IN std_logic_vector(n-1 DOWNTO 0);
			WriteEn,twoOperand		:  IN std_logic;
  		   	execResSel			: OUT std_logic);      
END component;

component my_DFF IS
	 PORT( d,clk,rst,en : IN std_logic;
	    q : OUT std_logic);
END component;
--signal execResultLSrcCmp,execResultLDstCmp,memResSrcCmp,memResDstCmp,execResultHSrcCmp,execResultHDstCmp:std_logic;
signal execResultLSrcSel,execResultLDstSel,memResSrcSel,memResDstSel,execResultHSrcSel,execResultHDstSel:std_logic;
signal execResultLDstSel0,memResDstSel0,execResultHDstSel0:std_logic;
signal forwSrc,forwDst,rstReg,regRes,regIn:std_logic;
--signal stallLD,stallLDBuff,delayJmp :std_logic;

BEGIN
	execResultSrcL: comparing_component GENERIC MAP (n=>3) port map (rSrcAddress_Buff,rDstAddress_DE,writeEnrDstDE,twoOperand,execResultLSrcSel);--,execResultLSrcCmp);

	execResultDstL: comparing_component GENERIC MAP (n=>3) port map (rDstAddress_Buff,rDstAddress_DE,writeEnrDstDE,'1',execResultLDstSel);--,execResultLDstCmp);
	execResultDstL0: comparing_component GENERIC MAP (n=>3) port map (rDstAddress_IR,rDstAddress_DE,writeEnrDstDE,'1',execResultLDstSel0);--,execResultLDstCmp);

	memResSrcSelL: comparing_component GENERIC MAP (n=>3) port map (rSrcAddress_Buff,rDstAddress_EM,writeEnrDstEM,twoOperand,memResSrcSel);--,memResSrcCmp);

	memResDstSelL: comparing_component GENERIC MAP (n=>3) port map (rDstAddress_Buff,rDstAddress_EM,writeEnrDstEM,'1',memResDstSel);--,memResDstCmp);
	memResDstSelL0: comparing_component GENERIC MAP (n=>3) port map (rDstAddress_IR,rDstAddress_EM,writeEnrDstEM,'1',memResDstSel0);--,memResDstCmp);
	
	chooseExecResultSrcL: comparing_component GENERIC MAP (n=>3) port map (rSrcAddress_Buff,rSrcAddress_DE,writeEnrSrcDE,twoOperand,execResultHSrcSel);--,execResultHSrcCmp);
	
	chooseExecResultDstL: comparing_component GENERIC MAP (n=>3) port map (rDstAddress_Buff,rSrcAddress_DE,writeEnrSrcDE,'1',execResultHDstSel);--,execResultHDstCmp);	
	chooseExecResultDstL0: comparing_component GENERIC MAP (n=>3) port map (rDstAddress_IR,rSrcAddress_DE,writeEnrSrcDE,'1',execResultHDstSel0);--,execResultHDstCmp);	

	forwSrc<=(execResultLSrcSel or memResSrcSel or execResultHSrcSel) and forward;
	forwDst<=(execResultLDstSel or memResDstSel or execResultHDstSel) and forward;
	delayJmp<=execResultLDstSel0 or memResDstSel0 or execResultHDstSel0;
	stallLD<=regIn;
	regIn<=(execResultLSrcSel or execResultLDstSel)and memReadEM;
	
	rstReg<=regRes and clk;
	stallLDBuff<=regRes;
	stallLDBuffL: my_DFF port map(regIn,clk,rstReg,'1',regRes);
END forwarding;