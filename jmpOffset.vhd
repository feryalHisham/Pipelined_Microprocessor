
LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY jmpOffset IS 
GENERIC ( n : integer := 16); 
        PORT (IRBuff: IN std_logic_vector(n-1 DOWNTO 0);
        flagReg : IN std_logic_vector(3 DOWNTO 0);
        delayJMPDE,clk,rstHard:in std_logic;
        offsetSel,jmpCondDelayedReg : OUT std_logic);    
END ENTITY jmpOffset;


ARCHITECTURE offset OF jmpOffset IS


component my_DFF IS
     PORT(clk,rst,en,d : IN std_logic;   q : OUT std_logic);
END component;

signal jmpCond,jmpCondRegsig,jmpCondRegRst,jmpCondToReg,jmpCondDelayedRegRst,jmpCondReg,jmpCondDelayedRegsig :std_logic;

constant jzOp :std_logic_vector(6 downto 0):= "0000110";  -- feryal opcode kan 000000
constant jnOp :std_logic_vector(6 downto 0):= "0000001";
constant jcOp :std_logic_vector(6 downto 0):= "0000010";


BEGIN
    

    jmpCond<= '1' when ((IRBuff(15 downto 9) =jzOp and flagReg(3)='1')
    or (IRBuff(15 downto 9) =jcOp and flagReg(2)='1')
    or (IRBuff(15 downto 9) =jnOp and flagReg(1)='1'))
    else '0';

    jmpCondToReg<=jmpCond or delayJMPDE;   -- feryaaal 7sb el design
    offsetSel<=jmpCond or delayJMPDE;
    jmpCondReg<=jmpCondRegsig;
    jmpCondDelayedRegRst<=(jmpCondDelayedRegsig and ( clk))or rstHard;
    condJMP: my_DFF port map(clk,rstHard,'1',jmpCondToReg,jmpCondRegsig); --make sure of enable
    condJMP_delayed : my_DFF port map(clk,jmpCondDelayedRegRst,'1',jmpCondRegsig,jmpCondDelayedRegsig);
    jmpCondDelayedReg<= jmpCondDelayedRegsig;
    


END offset;

