LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY my_dec8 IS

PORT( in_dec : in std_logic_vector (3 downto 0);
      out_dec: out std_logic_vector (7 downto 0));
END my_dec8;

ARCHITECTURE a_my_dec8 OF my_dec8 IS
BEGIN
PROCESS (in_dec)
BEGIN
IF in_dec(3) = '0' THEN
		out_dec <= (OTHERS=>'0');
ELSIF in_dec(2 downto 0) = "000" THEN
		out_dec <= ("00000001");
ELSIF in_dec(2 downto 0) = "001" THEN
		out_dec <= ("00000010");
ELSIF in_dec(2 downto 0) = "010" THEN
		out_dec <= ("00000100");
ELSIF in_dec(2 downto 0) = "011" THEN
		out_dec <= ("00001000");
ELSIF in_dec(2 downto 0) = "100" THEN
		out_dec <= ("00010000");
ELSIF in_dec(2 downto 0) = "101" THEN
		out_dec <= ("00100000");
ELSIF in_dec(2 downto 0) = "110" THEN
		out_dec <= ("01000000");
ELSE 
out_dec <= ("10000000");
END IF;
END PROCESS;
END a_my_dec8;

