LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY controlUnit IS 
GENERIC ( n : integer := 16); 
        PORT (IR,IRBuff : IN std_logic_vector(n-1 DOWNTO 0);
        flagReg : IN std_logic_vector(3 DOWNTO 0);
        clk,rstHard,stallLD,delayJMP,delayJMPDE:in std_logic; 
        jmpCondBuff,
        stallRT,stallRTbuff,offsetSel,jmpCondReg,
        twoOp,jmpCond,incSp,enSP ,enMemWr,lddORpop,setcORclrc,
        imm,wrEnRdst,enExecRes,wrEnRsrc,memRead,outEnReg,
        alu1,alu2,alu3,s1Wb,s0Wb,
        RET,RTI,PUSH,STD: OUT std_logic;
        counterRTout:OUT std_logic_vector (1 downto 0));    
END ENTITY controlUnit;

ARCHITECTURE controlU OF controlUnit IS

component rtCircuit IS 
GENERIC ( n : integer := 16); 
PORT (IR : IN std_logic_vector(n-1 DOWNTO 0);
    stallLD,clk: std_logic;
    stallRT,stallRTbuff : OUT std_logic;
    counterRTout:OUT std_logic_vector (1 downto 0));         
END component;

component jmpOffset IS 
GENERIC ( n : integer := 16); 
        PORT (IRBuff: IN std_logic_vector(n-1 DOWNTO 0);
        flagReg : IN std_logic_vector(3 DOWNTO 0);
        delayJMP,delayJMPDE,clk,rstHard:in std_logic;
        offsetSel,jmpCondReg : OUT std_logic);    
END component;


component irSignals IS 
GENERIC ( n : integer := 16);  
        PORT (IRBuff : IN std_logic_vector(n-1 DOWNTO 0);
        twoOp,jmpCond,incSp,enSP ,enMemWr,lddORpop,setcORclrc,
        imm,wrEnRdst,enExecRes,wrEnRsrc,memRead,outEnReg,
        alu1,alu2,alu3,s1Wb,s0Wb,
        RET,RTI : OUT std_logic);    
END component;


BEGIN
irSignalsL: irSignals GENERIC MAP (n=>16) port map (IRBuff,twoOp,jmpCond,incSp,enSP ,enMemWr,lddORpop,setcORclrc,
                imm,wrEnRdst,enExecRes,wrEnRsrc,memRead,outEnReg,alu1,alu2,alu3,s1Wb,s0Wb,RET,RTI,PUSH,STD);
RTcircuitL: rtCircuit GENERIC MAP (n=>16) port map (IR,stallLD,clk,stallRT,stallRTbuff,counterRTout);
jmpOffsetL: jmpOffset  GENERIC MAP (n=>16) port map (IRBuff,flagReg,delayJMP,delayJMPDE,clk,rstHard,offsetSel,jmpCondReg);

END controlU;
