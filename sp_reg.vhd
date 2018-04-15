LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

ENTITY my_nDFF_sp IS
GENERIC ( n : integer := 16);
PORT( Clk,Rst,enb : IN std_logic;
		   d : IN std_logic_vector(n-1 DOWNTO 0);
		   q : OUT std_logic_vector(n-1 DOWNTO 0));
END my_nDFF_sp;

ARCHITECTURE a_my_nDFF_sp OF my_nDFF_sp IS
BEGIN
PROCESS (Clk,Rst,enb)
BEGIN
IF Rst = '1' THEN
		q <= X"FFFF";
ELSIF falling_edge(Clk) and enb = '1' THEN
		q <= d;
END IF;
END PROCESS;
END a_my_nDFF_sp;

