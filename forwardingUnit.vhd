LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY forwardingUnit IS 
GENERIC ( n : integer := 16); 
		PORT (	IR,IRBuff : IN std_logic_vector(n-1 DOWNTO 0);
				rSrcAddress_DE,rSrcAddress_EM,rDstAddress_DE,rDstAddress_EM :IN std_logic_vector(2 DOWNTO 0);
				writeEnrSrcDE,writeEnrDstDE,writeEnrDstEM,twoOp:IN std_logic;
                memReadEM,memReadMW:  IN std_logic;
                MulDE,RtypeDE,Clk,hardRst:  IN std_logic;
				rSrc,rDst : IN std_logic_vector(n-1 DOWNTO 0);
				execResultHigh,execResultLow,memoryResult : IN std_logic_vector(n-1 DOWNTO 0);
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
			memReadEM,clk ,hardRst							:IN std_logic;
			execResultLSrcSel,execResultLDstSel,
			forwSrc,forwDst,
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

signal execResultLSrcSelSig,execResultLDstSelSig,forward,forwardSelSrc,forwardSelDst:std_logic;
BEGIN
--------------feryal sorry 2oltlk 8alt-----------------
	forward<=memReadEM or MulDE or RtypeDE;
--	twoOp<=
   	ForwardDetection: forwardDetect port map (IRBuff(5 downto 3),rSrcAddress_DE,rSrcAddress_EM,IRBuff(2 downto 0),
		rDstAddress_DE,rDstAddress_EM,IR(5 downto 3),writeEnrSrcDE,writeEnrDstDE,writeEnrDstEM,
		twoOp,forward,memReadEM,Clk,hardRst,execResultLSrcSelSig,execResultLDstSelSig,forwardSelSrc,forwardSelDst,stallLD,stallLDBuff,delayJmp);
	Rtype: R_type GENERIC MAP (n=>16) port map (rSrc,rDst,execResultHigh,execResultLow,
		memoryResult,execResultLSrcSelSig,writeEnrSrcDE,forwardSelSrc,
		execResultLDstSelSig,writeEnrDstDE,forwardSelDst,rSrcBuf,rDstBuf);
     
END forwardUnit;

	-- rSrcAddress_DE->IR(5 downto 3)
	-- rSrcAddress_EM->IRBuff(5 downto 3)
	-- rDstAddress_DE->IR(2 downto 0)
	-- rDstAddress_EM->IRBuff(2 downto 0)