
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY my_nDFF3 IS
PORT( Clk,Rst,enb : IN std_logic;
		   d : IN std_logic;
		   q : OUT std_logic);
END my_nDFF3;

ARCHITECTURE a_my_nDFF3 OF my_nDFF3 IS
--Signal rstt : std_logic;
BEGIN
PROCESS (Clk,Rst,enb,d)
BEGIN
IF Rst = '1' THEN
		q <= '0';
ELSIF Clk='0' and enb = '1' THEN
		q <= d;
END IF;
END PROCESS;
END a_my_nDFF3;
