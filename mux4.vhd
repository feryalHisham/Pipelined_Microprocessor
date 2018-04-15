LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity mux4 is 
	Generic (m : integer :=16);
port ( s1,s0: in std_logic;
	input1,input2,input3,input4: in std_logic_vector(m-1 downto 0);
	output: out std_logic_vector(m-1 downto 0));
end mux4;

architecture my_mux4 of mux4 is 
begin 
	output <= input1 when s1='0' and s0='0'
		else input2 when  s1='0' and s0='1'
		else input3 when  s1='1' and s0='0'
		else input4 when  s1='1' and s0='1';
end my_mux4;
