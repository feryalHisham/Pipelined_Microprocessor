LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY mux_2x1_1_bit IS 
GENERIC ( n : integer := 16); 
		PORT (in1,in2 : IN std_logic;
                    s	:  IN std_logic;
  		   out1 : OUT std_logic);    
END ENTITY mux_2x1_1_bit;


ARCHITECTURE mux_2x1_1_bit_a OF mux_2x1_1_bit IS
BEGIN
     
   out1 <=  in1 when s='0' 
      else in2;

     
END mux_2x1_1_bit_a;

