library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
entity DISPLAY_UNIT is port
(
DU : in STD_LOGIC;  EN : in STD_LOGIC;ROC : in STD_LOGIC;
REF : in STD_LOGIC; G1,G2,G3,G6: in STD_LOGIC; 
clk : in std_logic; OUTDIGIT: out STD_LOGIC_VECTOR (7 downto 0);
ANODE : out STD_LOGIC_VECTOR (3 downto 0)
);
end DISPLAY_UNIT;
architecture behavior of DISPLAY_UNIT is

component Dec2LED 
port (CLK: in STD_LOGIC; X: in STD_LOGIC_VECTOR (3 downto 0); Y: out STD_LOGIC_VECTOR (7 downto 0)); 
end component; 
signal DIGIT : STD_LOGIC_VECTOR(7 downto 0) :="00000000";
type arr is array(0 to 15) of std_logic_vector(7 downto 0);
signal NAME: arr;
type ARR2 is array(0 to 3) of std_logic_vector(7 downto 0);
signal TMPDGT: ARR2;
signal TEMP: STD_LOGIC_VECTOR(3 downto 0) :="0111";
signal CLKM : STD_LOGIC :='0';
signal Z : integer :=0;
signal G : integer :=30;
signal NAMEA : integer :=3;
signal NAMEB : integer :=2;
signal NAMEC : integer :=1;
signal NAMED : integer :=0;
signal pt1:STD_LOGIC_VECTOR(32 downto 0);

COMPONENT Circuit17
	PORT(
		TE : IN std_logic;
		G1 : IN std_logic;
		G2 : IN std_logic;
		G3 : IN std_logic;
		G6 : IN std_logic;
		G7 : IN std_logic;          
		G22 : OUT std_logic;
		G23 : OUT std_logic
		);
END COMPONENT;

signal osc,out1 : std_logic;
signal G7: std_logic:='1';
signal count,count_RO,count_RO_t,count1: std_logic_vector(31 downto 0);

begin

--------------RO1------------------
RO: Circuit17 PORT MAP(EN,G1,G2,G3,G6,G7,out1,osc);
-------------REFERENCE COUNT-------
process(clk,en)
Begin
if en ='0' then 
count <= (others=>'0');
elsif clk='1' and clk'event then
if count<x"40000000" then
count <= count +'1';
end if;
end if;
end process;
-------------RO COUNT-------------
process(osc,en,count,clk)
Begin
if en ='0' then 
count_RO_t <= (others=>'0');
elsif osc='1' and osc'event then
if count<x"40000000" then
count_RO_t <= count_RO_t +'1';
elsif count=x"40000000" then
count_RO<= count_RO_t;
count1<= count;
end if;
end if;
end process;
----------------------------------

-----INTERFACING TO FPGA-------
----- 7 SEGMENT CLOCK----------
process (CLK)
begin
if CLK'event and CLK='1' then
if Z=200000 then
CLKM <= '1';
elsif Z=400000 then
CLKM <= '0';
Z <= 0;
end if;
if Z /=400000  then
Z <= Z+1;
end if;
end if;
end process;
NAME(14)<= "11111111";
NAME(13)<= "11111111";
NAME(12)<= "11111111";
NAME(15)<= "11111111";

process(ROC,REF,EN,DU,count,count_RO)
begin
 if REF='1' and DU='1' then
	pt1(32 downto 1)<= count;
		NAME(0)<= "10101111";
		NAME(1)<= "10000110";
		NAME(2)<= "10001110";
		NAME(3)<= "10111111";
 elsif ROC='1' then
	  pt1(32 downto 1)<= count_RO;
	  NAME(0)<= "10101111";
	  NAME(1)<= "11000000";
	  NAME(2)<= "11000110";
	  NAME(3)<= "10111111";
 else 
     pt1(32 downto 1)<= "000000000000000000000000000000" & out1 & osc; 
	  NAME(0)<= "10111111";
	  NAME(1)<= "10111111";
	  NAME(2)<= "10111111";
	  NAME(3)<= "10111111";
 end if;
 end process;
CONV1: Dec2LED port map (CLK => CLK, X => pt1(32 downto 29), Y => NAME(4));
CONV2: Dec2LED port map (CLK => CLK, X => pt1(28 downto 25), Y => NAME(5));
CONV3: Dec2LED port map (CLK => CLK, X => pt1(24 downto 21), Y => NAME(6));
CONV4: Dec2LED port map (CLK => CLK, X => pt1(20 downto 17), Y => NAME(7));
CONV5: Dec2LED port map (CLK => CLK, X => pt1(16 downto 13), Y => NAME(8));
CONV6: Dec2LED port map (CLK => CLK, X => pt1(12 downto 9), Y => NAME(9));
CONV7: Dec2LED port map (CLK => CLK, X => pt1(8 downto 5), Y => NAME(10));
CONV8: Dec2LED port map (CLK => CLK, X => pt1(4 downto 1), Y => NAME(11));

process (CLKM) 
begin
if CLKM'event and CLKM='1' then
 if DU='1' then
  if G=60 then
   TMPDGT(0) <= NAME(NAMEA);
    if NAMEA=15 then
     NAMEA <= 0;
    else
     NAMEA <= NAMEA + 1;
    end if;
   TMPDGT(1) <= NAME(NAMEB);
    if NAMEB=15 then
     NAMEB <= 0;
    else
     NAMEB <= NAMEB + 1;
    end if;
   TMPDGT(2) <= NAME(NAMEC);
    if NAMEC=15 then
     NAMEC <= 0;
    else
     NAMEC <= NAMEC + 1;
    end if;
  TMPDGT(3) <= NAME(NAMED);
    if NAMED=15 then
      NAMED <= 0;
    else
      NAMED <= NAMED + 1;
    end if;
   G <= 0;
  else
   G <= G + 1;
 end if;
end if;
end if;
end process;

process (CLKM)
begin
if CLKM'event and CLKM='1' then  
if DU='1' then  
if TEMP="0111" then
TEMP <= "1110";
DIGIT <= TMPDGT(0);
elsif TEMP="1110" then
TEMP <= "1101";
DIGIT <= TMPDGT(1);
elsif TEMP="1101" then
TEMP <= "1011";
DIGIT <= TMPDGT(2);
else 
TEMP <= "0111";
DIGIT <= TMPDGT(3);
end if;
end if;
end if;
end process;
ANODE <= TEMP;
OUTDIGIT <= DIGIT;


end behavior;

