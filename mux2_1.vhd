LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY mux2_1 IS 
GENERIC ( n : integer := 16); 
		PORT (in1,in2 : IN std_logic_vector(n-1 DOWNTO 0);
                    s	:  IN std_logic;
  		   out1 : OUT std_logic_vector(n-1 DOWNTO 0));    
END ENTITY mux2_1;


ARCHITECTURE mux2_1_a OF mux2_1 IS
BEGIN
     
   out1 <=  in1 when s='0' 
      else in2;

     
END mux2_1_a;
