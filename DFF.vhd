LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY my_DFF IS
     PORT( clk,rst,en,d: IN std_logic;   q : OUT std_logic);
END my_DFF;

ARCHITECTURE a_my_DFF OF my_DFF IS
BEGIN
	PROCESS(clk,rst)
	BEGIN
		IF(rst = '1') THEN
        		q <= '0';
		ELSIF falling_edge(clk) and en='1' THEN     
 	    		q <= d;
		END IF;
	END PROCESS;
END a_my_DFF;


