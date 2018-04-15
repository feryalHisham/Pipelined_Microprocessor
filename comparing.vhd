LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY comparing_component IS 
GENERIC ( n : integer := 3); 
		PORT (  RegAddress_Buff,RegAddress_DE : IN std_logic_vector(n-1 DOWNTO 0);
			WriteEn,twoOperand	:  IN std_logic;
  		   	execResSel : OUT std_logic);    
END ENTITY comparing_component;


ARCHITECTURE comparing OF comparing_component IS
component comparator IS 
GENERIC ( n : integer := 3); 
		PORT (operand1,operand2 : IN std_logic_vector(n-1 DOWNTO 0);
  		   equal : OUT std_logic);    
END component;

signal comparatorOutput:std_logic;
BEGIN
	comparatorRes: comparator GENERIC MAP (n=>3) port map (RegAddress_Buff,RegAddress_DE,comparatorOutput);
--	compareRes<=comparatorOutput;
	execResSel<=WriteEn and twoOperand and comparatorOutput;
	
   
END comparing;