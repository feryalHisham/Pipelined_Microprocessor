
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY rtCircuit IS 
GENERIC ( n : integer := 16); 
        PORT (IR,IR_Buff : IN std_logic_vector(n-1 DOWNTO 0);
        stallLD,clk,rstHard: IN std_logic;
        --stallRT : OUT std_logic;
        counterRTout:OUT std_logic_vector (1 downto 0));    
END ENTITY rtCircuit;

ARCHITECTURE circuitRT OF rtCircuit IS


component my_DFF IS
     PORT(clk,rst,en,d : IN std_logic;   q : OUT std_logic);
END component;

component counter is
    generic (n:integer :=2); 
    Port ( rst,clk : in STD_LOGIC;
     up: in STD_LOGIC;                             
     z : out STD_LOGIC_vector( n-1 downto 0 ));
  end component;

constant retOp :std_logic_vector(6 downto 0):= "0100000";
constant rtiOp :std_logic_vector(6 downto 0):= "0100001";
signal  counter3,counterEn,stallRTsig,stallRT_buff_sig: std_logic ;
signal counterRToutsig:std_logic_vector (1 downto 0);
BEGIN

stallRTsig <= '1' when  IR(15 downto 9) =retOp or
    IR(15 downto 9) =rtiOp 
    else '0' when counter3='1';

---------------------- feryal buffering stallRT -----------------
stallRT_buff_sig <= '1' when  IR_Buff(15 downto 9) =retOp or
    IR_Buff(15 downto 9) =rtiOp 
    else '0' when counter3='1';

--------------------------------------------------


-------------------- feryal 5leet de el buff 34an ady forsa ll RET td5ol IR_Buff--------
counterEn <=(not stallLD) and (stallRT_buff_sig); --awl mra w stallRT msh 3arfenha ???


counter3 <='1'when counterRToutsig ="11" or rstHard='1'
    else '0';
    --stallRT<=stallRTsig;
    --  stallRTbuff<=stallRTbuffsig;
    counterRTout<=counterRToutsig;
    --condJMP: my_DFF port map(stallRTsig,counter3,clk,stallRTsig,stallRTbuffsig);

    counterRTReg: counter GENERIC MAP (n=>2) port map (counter3,clk,counterEn,counterRToutsig);
   

END circuitRT;
