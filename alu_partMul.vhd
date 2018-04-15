LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity alu_partMul is 

GENERIC (n : integer := 16);

PORT ( a,b: IN std_logic_vector (n-1 DOWNTO 0);
sel_op : IN std_logic_vector (1 DOWNTO 0);
result: OUT std_logic_vector (2*n-1 DOWNTO 0);
neg:out std_logic);
end entity alu_partMul;


ARCHITECTURE alu_partMul_arch OF alu_partMul IS

signal result_temp: std_logic_vector(2*n-1 DOWNTO 0);
begin


result_temp <= a * b;
result<=result_temp;

neg <=result_temp(n-1);



end alu_partMul_arch;
