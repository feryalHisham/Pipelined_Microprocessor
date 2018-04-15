LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY R_type IS 
GENERIC ( n : integer := 16); 
		PORT ( 	rSrc,rDst : IN std_logic_vector(n-1 DOWNTO 0);
			execResultHigh,execResultLow,memoryResult : IN std_logic_vector(n-1 DOWNTO 0);
			execResultLowSelSrc,writeEnSrc,forwardSelSrc:  IN std_logic;
			execResultLowSelDst,writeEnDst,forwardSelDst:  IN std_logic;
			rSrcBuf,rDstBuf : OUT std_logic_vector(n-1 DOWNTO 0));    
END ENTITY R_type;


ARCHITECTURE SrcDstRType OF R_type IS

component R_type_component IS 
GENERIC ( n : integer := 16); 
		PORT ( inputReg,execResultH,execResultL,memResult : IN std_logic_vector(n-1 DOWNTO 0);
			execResultLowSel,writeEn,forwardSel:  IN std_logic;
  		   	rBuf : OUT std_logic_vector(n-1 DOWNTO 0));    
END component;

BEGIN
	srcRType: R_type_component GENERIC MAP (n=>16) port map (rSrc,execResultHigh,execResultLow,memoryResult,execResultLowSelSrc,writeEnSrc,forwardSelSrc,rSrcBuf);
	dstRType: R_type_component GENERIC MAP (n=>16) port map (rDst,execResultHigh,execResultLow,memoryResult,execResultLowSelDst,writeEnDst,forwardSelDst,rDstBuf);
	
     
END SrcDstRType;
