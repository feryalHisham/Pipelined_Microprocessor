LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity alu_partB is 

GENERIC (n : integer := 16);

PORT ( a,b: IN std_logic_vector (n-1 DOWNTO 0);
sel_op : IN std_logic_vector (1 DOWNTO 0);
result: OUT std_logic_vector (n-1 DOWNTO 0));
end entity alu_partB;


ARCHITECTURE alu_partB_arch OF alu_partB IS

begin


result <= b when sel_op(0) = '0' and sel_op(1) = '0'
	else a and b when sel_op(0) = '1' and sel_op(1) = '0'
	else a or b when sel_op(0) = '0' and sel_op(1) = '1'
	else not a ;
	



end alu_partB_arch;
