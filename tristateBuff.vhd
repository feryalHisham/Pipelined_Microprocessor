
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;

entity tristatebuff IS
	Generic (m : integer :=16);
	port ( input : in std_logic_vector (m-1 downto 0);
		output : out std_logic_vector (m-1 downto 0);
			enable: in std_logic);
END tristatebuff;



ARCHITECTURE a_tristatebuff of tristatebuff is 
begin 
	output <= input when enable='1'
		else (others=> 'Z') ;
	


end a_tristatebuff;