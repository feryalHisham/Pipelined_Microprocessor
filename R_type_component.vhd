LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY R_type_component IS 
GENERIC ( n : integer := 16); 
		PORT ( inputReg,execResultH,execResultL,memResult : IN std_logic_vector(n-1 DOWNTO 0);
			execResultLowSel,writeEn,forwardSel:  IN std_logic;
			rBuf : OUT std_logic_vector(n-1 DOWNTO 0));    
END ENTITY R_type_component;


ARCHITECTURE toBuff OF R_type_component IS

component mux2_1 IS 
GENERIC ( n : integer := 16); 
		PORT (in1,in2 : IN std_logic_vector(n-1 DOWNTO 0);
                    s	:  IN std_logic;
  		   out1 : OUT std_logic_vector(n-1 DOWNTO 0));    
END component;

signal memORresultLow,resultHighOrLow,changedOrnot:std_logic_vector(n-1 DOWNTO 0);    
BEGIN
	memORresult: mux2_1 GENERIC MAP (n=>16) port map (memResult,execResultL,execResultLowSel,memORresultLow);
	highORlow: mux2_1 GENERIC MAP (n=>16) port map (memORresultLow,execResultH,writeEn,resultHighOrLow);
	toReg: mux2_1 GENERIC MAP (n=>16) port map (inputReg,resultHighOrLow,forwardSel,rBuf);
     
END toBuff;
