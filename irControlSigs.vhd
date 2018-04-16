LIBRARY IEEE;
USE IEEE.std_logic_1164.all;

ENTITY irSignals IS 
GENERIC ( n : integer := 16); 
		PORT (IRBuff : IN std_logic_vector(n-1 DOWNTO 0);
        twoOp,jmpCond,incSp,enSP ,enMemWr,lddORpop,setcORclrc,
        imm,wrEnRdst,enExecRes,wrEnRsrc,memRead,outEnReg,
        alu1,alu2,alu3,s1Wb,s0Wb,
        RET,RTI,PUSH,STD : OUT std_logic);    
END ENTITY irSignals;


ARCHITECTURE controlIR OF irSignals IS

--signal twoOp,jmpCond,incSp,enSP ,enMemWr,lddORpop,setcORclrc,
--imm,wrEnRdst,enExecRes,wrEnRsrc,memRead,outEnReg :std_logic;
constant addOp :std_logic_vector(6 downto 0):= "0010000";
constant subOp :std_logic_vector(6 downto 0):= "0010001";
constant movOp :std_logic_vector(6 downto 0):= "0010100";
constant andOp :std_logic_vector(6 downto 0):= "0010101";
constant orOp :std_logic_vector(6 downto 0):= "0010110";
constant shlOp :std_logic_vector(6 downto 0):= "0011000";
constant shrOp :std_logic_vector(6 downto 0):= "0011001";
constant mulOp :std_logic_vector(6 downto 0):= "0011100";

--signal jmpCond :std_logic;
constant jzOp :std_logic_vector(6 downto 0):= "0000000";
constant jnOp :std_logic_vector(6 downto 0):= "0000001";
constant jcOp :std_logic_vector(6 downto 0):= "0000010";

--signal incSp :std_logic;
constant retOp :std_logic_vector(6 downto 0):= "0100000";
constant rtiOp :std_logic_vector(6 downto 0):= "0100001";
constant lddOp :std_logic_vector(6 downto 0):= "0100010";
constant popOp :std_logic_vector(6 downto 0):= "0100011";

--signal enSP :std_logic; 
constant callOp :std_logic_vector(6 downto 0):= "1000000";
constant pushOp :std_logic_vector(6 downto 0):= "1000001";
constant stdOp :std_logic_vector(6 downto 0):=  "1000010";

--signal enMemWr,lddORpop,setcORclrc,imm :std_logic;
constant setcOp :std_logic_vector(6 downto 0):=  "0000100";
constant clrcOp :std_logic_vector(6 downto 0):= "0000101";
constant ldmOp :std_logic_vector(6 downto 0):=  "0110010";

--signal wrEnRdst,enExecRes,wrEnRsrc,memRead,outEnReg :std_logic;
constant inOp :std_logic_vector(6 downto 0):=  "0110000";
constant outOp :std_logic_vector(6 downto 0):= "0110001";
constant nopOp :std_logic_vector(6 downto 0):= "0000110";

signal tempIncSP,tempEnSP,tempOutEnReg:std_logic;
BEGIN

    twoOp<='1' when IRBuff(15 downto 9) =addOp
    or IRBuff(15 downto 9) =subOp
    or IRBuff(15 downto 9) =movOp
    or IRBuff(15 downto 9) =andOp
    or IRBuff(15 downto 9) =orOp
    or IRBuff(15 downto 9) =shlOp
    or IRBuff(15 downto 9) =shrOp
    or IRBuff(15 downto 9) =mulOp
    else '0';

    imm<='1' when IRBuff(15 downto 9) =shlOp
    or IRBuff(15 downto 9) =shrOp
    or IRBuff(15 downto 9) =ldmOp
    or IRBuff(15 downto 9) =lddOp
    or IRBuff(15 downto 9) =stdOp
    else '0';
    
    jmpCond<='1' when IRBuff(15 downto 9) =jzOp
    or IRBuff(15 downto 9) =jnOp
    or IRBuff(15 downto 9) =jcOp
    else '0';

    tempIncSP<='1' when IRBuff(15 downto 9)= rtiOp
    or IRBuff(15 downto 9) =  retOp
    or IRBuff(15 downto 9) =  popOp
    else '0';
    incSp<=tempIncSP;

    tempEnSP<= '1' when tempIncSP = '1'
    else '1' when IRBuff(15 downto 9) =  callOp
    or IRBuff(15 downto 9) =  pushOp
    else '0';

    enSP<=tempEnSP;
    enMemWr <='1' when tempEnSP= '1'
    else '1' when IRBuff(15 downto 9) =  stdOp
    else '0';
    

    lddORpop <='1' when IRBuff(15 downto 9) =  lddOp
    or IRBuff(15 downto 9) =  popOp
    else '0';

    setcORclrc <='1' when IRBuff(15 downto 9) = setcOp or  IRBuff(15 downto 9) = clrcOp
    else '0';


    enExecRes <='1' when IRBuff(15 downto 9) = nopOp
    or IRBuff(15 downto 13) = addOp(6 downto 4)
    else '0';


    wrEnRdst <='1' when IRBuff(15 downto 13) = addOp(6 downto 4)
    or (IRBuff(15 downto 13) = popOp(6 downto 4) and not(IRBuff(15 downto 9)= rtiOp or IRBuff(15 downto 9) =  retOp))
    or (IRBuff(15 downto 13) = ldmOp(6 downto 4) and tempOutEnReg='0')
    else '0';

    memRead <='1' when IRBuff(15 downto 9) = popOp
    or IRBuff(15 downto 9) = lddOp
    else '0';

    outEnReg<=tempOutEnReg;
    tempOutEnReg  <='1' when IRBuff(15 downto 9) = outOp
    else '0';

    wrEnRsrc <='1' when IRBuff(15 downto 9) = mulOp
    else '0';

    RET<='1' when IRBuff(15 downto 9) =  retOp
    else '0';
    RTI<='1' when IRBuff(15 downto 9) =  retOp
    else '0';
    PUSH<='1' when IRBuff(15 downto 9) =  pushOp
    else '0';
    STD<='1' when IRBuff(15 downto 9) =  stdOp
    else '0';
    alu1<=IRBuff(12);
    alu2<=IRBuff(11);
    alu3<=IRBuff(10);
    s1Wb<='1' when IRBuff(15 downto 9) =  inOp
    or IRBuff(15 downto 9) =  ldmOp
    else '0';
    s0Wb<='1' when IRBuff(15 downto 9) =  inOp
    or IRBuff(15 downto 13) =  addOp(6 downto 4)
    else '0';

END controlIR;

