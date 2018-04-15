LIBRARY IEEE;
USE IEEE.std_logic_1164.all;
-- n-bit adder
ENTITY my_nadder IS
       GENERIC (n : integer := 16);
PORT(a,b : IN std_logic_vector(n-1  DOWNTO 0);
             cin : IN std_logic;
	     --sel : IN std_logic_vector(3 downto 0); 
             f : OUT std_logic_vector(n-1 DOWNTO 0);    
             cout,cout_before_last : OUT std_logic);
END my_nadder;

ARCHITECTURE a_my_nadder OF my_nadder IS
      COMPONENT my_adder IS
              PORT( a,b,cin : IN std_logic; 
                    s,cout : OUT std_logic);
        END COMPONENT;
SIGNAL temp_carry : std_logic_vector(n-1 DOWNTO 0);
SIGNAl b_xor : std_logic_vector(n-1 downto 0);

BEGIN
 process(b,cin)
 begin
	for i in 0 to n-1 loop
		 b_xor(i) <= b(i) xor cin;  
	end loop;

 end process;

  f0: my_adder PORT MAP(a(0),b_xor(0),cin,f(0),temp_carry(0)); --cin if zero addition operation if 1 subtraction operation
  loop1: FOR i IN 1 TO n-1 GENERATE
          fx: my_adder PORT MAP(a(i),b_xor(i),temp_carry(i-1),f(i),temp_carry(i));
    END GENERATE;
    cout <= temp_carry(n-1);
    cout_before_last <= temp_carry(n-2);
END a_my_nadder;


