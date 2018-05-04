
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;  
entity counter is
  generic (n:integer :=2); 
  Port ( rst,clk : in STD_LOGIC;
   up: in STD_LOGIC;                             
   z : out STD_LOGIC_vector( n-1 downto 0 ));
end counter;

architecture Behavioral of Counter is
  signal zint:  unsigned( n-1 downto 0 ) ;   
begin
  z<= std_logic_vector(zint);             
  process (clk)
  begin
    if falling_edge(clk) then              
      if rst ='1' then                   
        zint <= "00" ;                  
     -- elsif zint = "11" then 
       -- zint <= "11";
      elsif up='1' then
        zint <= zint+1;
      --else 
        --zint <= zint-1;
      end if;
    end if;
  end process;
end Behavioral;

