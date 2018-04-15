
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity alu_partC is 

GENERIC (n : integer := 16);

PORT ( a,b: IN std_logic_vector (n-1 DOWNTO 0);
sel_op : IN std_logic_vector (1 DOWNTO 0);
cin : in std_logic;
immediate_val: in std_logic_vector(3 downto 0);
result: OUT std_logic_vector (n-1 DOWNTO 0);
cout : out std_logic);
end entity alu_partC;


ARCHITECTURE alu_partC_arch OF alu_partC IS

signal b_shifted_left,b_shifted_right: std_logic_vector (n-1 downto 0);
signal zeroes : std_logic_vector ( n-1 downto 0):= (others => '0');
begin


--b_shifted_left <= b (n-1 downto 1) & '0'; 
--process(b)
--begin
--	for i in 1 to immediate_val loop
--		 b_shifted_left(i) <= b(i) ;  
--	end loop;

--end process;

b_shifted_left <= b (n-1-to_integer(unsigned((immediate_val))) downto 0) & zeroes(to_integer(unsigned((immediate_val)))-1 downto 0) ;
b_shifted_right <=  zeroes(to_integer(unsigned((immediate_val)))-1 downto 0) & b (n-1 downto to_integer(unsigned((immediate_val)))) ;


result <= b_shifted_right when  sel_op(0)='0' and sel_op(1)='0'
	else b_shifted_left when sel_op(0)='1' and sel_op(1)='0'
	else  a(n-2 downto 0) & cin when sel_op(0)='0' and sel_op(1)='1'
	else cin & a(n-1 downto 1); 


cout<= a(n-1) when sel_op(0)='0' and sel_op(1)='1'
	else a(0) when sel_op(0)='1' and sel_op(1)='1'
	else '0';


end alu_partC_arch;