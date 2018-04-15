
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY rtCircuit IS 
GENERIC ( n : integer := 16); 
        PORT (IR : IN std_logic_vector(n-1 DOWNTO 0);
        stallLD,clk: std_logic;
        stallRT,stallRTbuff : OUT std_logic;
          counterRTout:OUT std_logic_vector (1 downto 0));    
END ENTITY rtCircuit;

ARCHITECTURE circuitRT OF rtCircuit IS


component my_DFF IS
     PORT( d,clk,rst,en : IN std_logic;   q : OUT std_logic);
END component;

component counter is
    generic (n:integer :=2); 
    Port ( rst,clk : in STD_LOGIC;
     up: in STD_LOGIC;                             
     z : out STD_LOGIC_vector( n-1 downto 0 ));
  end component;

constant rtiOp :std_logic_vector(6 downto 0):= "0100000";
constant retOp :std_logic_vector(6 downto 0):= "0100001";
signal  counter3,counterEn,stallRTsig,stallRTbuffsig: std_logic ;
signal counterRToutsig:std_logic_vector (1 downto 0);
BEGIN

stallRT <= '1' when IR(15 downto 9)=rtiOp 
    or IR(15 downto 9) =retOp 
    else '0';

counterEn <=((not stallLD) and (stallRTsig or stallRTbuffsig)); --awl mra w stallRT msh 3arfenha ???


counter3 <='1'when counterRToutsig ="11"
    else '0';
    stallRT<=stallRTsig;
    stallRTbuff<=stallRTbuffsig;
    counterRTout<=counterRToutsig;
    condJMP: my_DFF port map(counter3,clk,stallRTsig,stallRTbuffsig,stallRTsig);
    counterRTReg: counter GENERIC MAP (n=>2) port map (counter3,clk,counterEn,counterRToutsig);
   

END circuitRT;
