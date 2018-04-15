LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY forwardingUnit IS 
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
END ENTITY forwardingUnit;


ARCHITECTURE forwardUnit OF forwardingUnit IS

component forwardDetect IS 
GENERIC ( n : integer := 3); 
		PORT (  rSrcAddress_Buff,rSrcAddress_DE,rSrcAddress_EM 			:IN std_logic_vector(n-1 DOWNTO 0);
			rDstAddress_Buff,rDstAddress_DE,rDstAddress_EM,rDstAddress_IR 	:IN std_logic_vector(n-1 DOWNTO 0);
			writeEnrDstDE,writeEnrDstEM					:IN std_logic;
			writeEnrSrcDE,twoOperand,forward				:IN std_logic;
			memReadEM,clk 							:IN std_logic;
  		   	stallLD,stallLDBuff,delayJmp : OUT std_logic);    
END component;

component R_type IS 
GENERIC ( n : integer := 16); 
		PORT ( 	rSrc,rDst : IN std_logic_vector(n-1 DOWNTO 0);
			execResultHigh,execResultLow,memoryResult : IN std_logic_vector(n-1 DOWNTO 0);
			execResultLowSelSrc,writeEnSrc,forwardSelSrc:  IN std_logic;
			execResultLowSelDst,writeEnDst,forwardSelDst:  IN std_logic;
			rSrcBuf,rDstBuf : OUT std_logic_vector(n-1 DOWNTO 0));    
END component;

signal forward,twoOp:std_logic;
BEGIN
	forward<=memReadMW or MulDE or RtypeDE;
--	twoOp<=
   	ForwardDetection: forwardDetect port map (IRBuff(5 downto 3),rSrcAddress_DE,rSrcAddress_EM,IRBuff(2 downto 0),
		rDstAddress_DE,rDstAddress_EM,IR(5 downto 3),writeEnrSrcDE,writeEnrDstDE,writeEnrDstEM,
		twoOp,forward,memReadEM,Clk,stallLD,stallLDBuff,delayJmp);
	Rtype: R_type GENERIC MAP (n=>16) port map (rSrc,rDst,execResultHigh,execResultLow,
		memoryResult,execResultLowSelSrc,writeEnrRsrcEM,forwardSelSrc,
		execResultLowSelDst,writeEnrDstEM,forwardSelDst,rSrcBuf,rDstBuf);
     
END forwardUnit;

	-- rSrcAddress_DE->IR(5 downto 3)
	-- rSrcAddress_EM->IRBuff(5 downto 3)
	-- rDstAddress_DE->IR(2 downto 0)
	-- rDstAddress_EM->IRBuff(2 downto 0)