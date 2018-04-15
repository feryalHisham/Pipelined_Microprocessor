LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity alu_partA is 

GENERIC (n : integer := 16);

PORT ( a,b: IN std_logic_vector (n-1 DOWNTO 0);
sel_op : IN std_logic_vector (1 DOWNTO 0);
result: OUT std_logic_vector (n-1 DOWNTO 0);
cout,overflow,neg: OUT std_logic);
end entity alu_partA;


ARCHITECTURE alu_partA_arch OF alu_partA IS

component my_nadder 
      GENERIC (n : integer := 16);
PORT(a,b : IN std_logic_vector(n-1  DOWNTO 0);
             cin : IN std_logic;
             f : OUT std_logic_vector(n-1 DOWNTO 0);    
             cout,cout_before_last : OUT std_logic);
END component;

component mux2_1
GENERIC ( n : integer := 16); 
		PORT (in1,in2 : IN std_logic_vector(n-1 DOWNTO 0);
                    s	:  IN std_logic;
  		   out1 : OUT std_logic_vector(n-1 DOWNTO 0)); 
end component;


--signal res_with_cout : std_logic_vector(n downto 0);
signal one : std_logic_vector (n-1 downto 0) := (0 =>'1', others => '0');
signal zero : std_logic_vector (n-1 downto 0) := (others => '0');
signal carry_in,carry_out_before_last,carry_out: std_logic;
signal b_to_add,result_temp : std_logic_vector (n-1 downto 0);
begin


--res_with_cout <= ('0' & a) + ('0' & b) when sel_op(0) = '0' and sel_op(1) = '0'
--	else ('0' & a) - ('0' & b) when sel_op(0) = '1' and sel_op(1) = '0'
--	else ('0' & a) + one when sel_op(0) = '0' and sel_op(1) = '1'
--	else ('0' & a) - one;
	

--result <= res_with_cout(n-1 downto 0);
--cout<= res_with_cout(n);

muxb: mux2_1 generic map (n=>16) port map (b,one,sel_op(1),b_to_add);

carry_in <= '1' when sel_op(0)='1'
	else '0';

add0: my_nadder generic map (n => 16)  port map ( a, b_to_add,carry_in ,result_temp,carry_out,carry_out_before_last);

cout <= carry_out; 
overflow <= carry_out xor carry_out_before_last;
neg<= result_temp(n-1);
result <= result_temp;

end alu_partA_arch;