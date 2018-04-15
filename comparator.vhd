LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY comparator IS 
GENERIC ( n : integer := 16); 
		PORT (operand1,operand2 : IN std_logic_vector(n-1 DOWNTO 0);
  		   equal : OUT std_logic);    
END ENTITY comparator;


ARCHITECTURE comparing OF comparator IS
signal xoredBits,check:std_logic_vector(n-1 DOWNTO 0);
BEGIN
     
	xoredBits<=operand1 xor operand2;
	check<=(OTHERS=>'0');
	equal<= '1' when xoredBits=check
	else '0';


END comparing;