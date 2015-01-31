----------------------------------------------------------
--------------PACKET--------------------------------------
----MSB--- EN  (128 Bit Input) (2 Bit for Output Select)(1 bit for key valid) (256 Bits for Key Select)---LSB-------
-------------------------- TOTAL 87 Bits ------------------
----------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DISPLAY_UNIT is 
generic (N: integer := 388; M: integer:= 9);--- N = No of Bits in Test vector + 1 (For Enable) + Num of Mux in RO + Output Select Mux
                                          --- M = No of Bits Reuired to count the N
port(
TXD : out std_logic := '1';RXD: in std_logic := '1';
clk : in std_logic;
RST : in std_logic	:= '0';

led : out std_logic_vector(7 downto 0)
);
end DISPLAY_UNIT;

architecture behavior of DISPLAY_UNIT is

component HEX2ASC is
Port (VAL	:IN STD_LOGIC_VECTOR(3 downto 0);
		CLK	:IN STD_LOGIC;
      Y  	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
end component;

component ICON
  PORT (
    CONTROL0 : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0));

end component;

component ILA
  PORT (
    CONTROL : INOUT STD_LOGIC_VECTOR(35 DOWNTO 0);
    CLK : IN STD_LOGIC;
    TRIG0 : IN STD_LOGIC_VECTOR(4 DOWNTO 0));

end component;


component clkdivide is
    Port (clkin: in std_logic;
            clkout:out std_logic );
end component;

---- INSERT NEW TEST BENCH MODULE--------

COMPONENT aes_start
	PORT(
		Clk : in std_logic;
		rst : in std_logic;
		ENC_DEC_B : in std_logic;
		CV_SIZE : in std_logic_vector(1 downto 0);
		DATA_LOAD: in std_logic;
		CV_LOAD   : in std_logic;
		N1: IN std_logic;
N4: IN std_logic;
N7: IN std_logic;
N10: IN std_logic;
N13: IN std_logic;
N16: IN std_logic;
N19: IN std_logic;
N22: IN std_logic;
N25: IN std_logic;
N28: IN std_logic;
N31: IN std_logic;
N34: IN std_logic;
N37: IN std_logic;
N40: IN std_logic;
N43: IN std_logic;
N46: IN std_logic;
N49: IN std_logic;
N52: IN std_logic;
N55: IN std_logic;
N58: IN std_logic;
N61: IN std_logic;
N64: IN std_logic;
N67: IN std_logic;
N70: IN std_logic;
N73: IN std_logic;
N76: IN std_logic;
N79: IN std_logic;
N82: IN std_logic;
N85: IN std_logic;
N88: IN std_logic;
N91: IN std_logic;
N94: IN std_logic;
N97: IN std_logic;
N100: IN std_logic;
N103: IN std_logic;
N106: IN std_logic;
N109: IN std_logic;
N112: IN std_logic;
N115: IN std_logic;
N118: IN std_logic;
N121: IN std_logic;
N124: IN std_logic;
N127: IN std_logic;
N130: IN std_logic;
N133: IN std_logic;
N136: IN std_logic;
N139: IN std_logic;
N142: IN std_logic;
N145: IN std_logic;
N148: IN std_logic;
N151: IN std_logic;
N154: IN std_logic;
N157: IN std_logic;
N160: IN std_logic;
N163: IN std_logic;
N166: IN std_logic;
N169: IN std_logic;
N172: IN std_logic;
N175: IN std_logic;
N178: IN std_logic;
N181: IN std_logic;
N184: IN std_logic;
N187: IN std_logic;
N190: IN std_logic;
N193: IN std_logic;
N196: IN std_logic;
N199: IN std_logic;
N202: IN std_logic;
N205: IN std_logic;
N208: IN std_logic;
N211: IN std_logic;
N214: IN std_logic;
N217: IN std_logic;
N220: IN std_logic;
N223: IN std_logic;
N226: IN std_logic;
N229: IN std_logic;
N232: IN std_logic;
N235: IN std_logic;
N238: IN std_logic;
N241: IN std_logic;
N244: IN std_logic;
N247: IN std_logic;
N250: IN std_logic;
N253: IN std_logic;
N256: IN std_logic;
N259: IN std_logic;
N262: IN std_logic;
N265: IN std_logic;
N268: IN std_logic;
N271: IN std_logic;
N274: IN std_logic;
N277: IN std_logic;
N280: IN std_logic;
N283: IN std_logic;
N286: IN std_logic;
N289: IN std_logic;
N292: IN std_logic;
N295: IN std_logic;
N298: IN std_logic;
N301: IN std_logic;
N304: IN std_logic;
N307: IN std_logic;
N310: IN std_logic;
N313: IN std_logic;
N316: IN std_logic;
N319: IN std_logic;
N322: IN std_logic;
N325: IN std_logic;
N328: IN std_logic;
N331: IN std_logic;
N334: IN std_logic;
N337: IN std_logic;
N340: IN std_logic;
N343: IN std_logic;
N346: IN std_logic;
N349: IN std_logic;
N352: IN std_logic;
N355: IN std_logic;
N358: IN std_logic;
N361: IN std_logic;
N364: IN std_logic;
N367: IN std_logic;
N370: IN std_logic;
N373: IN std_logic;
N376: IN std_logic;
N379: IN std_logic;
N382: IN std_logic;
		
TE0: IN std_logic;
TE1: IN std_logic;
TE2: IN std_logic;
TE3: IN std_logic;
TE4: IN std_logic;
TE5: IN std_logic;
TE6: IN std_logic;
TE7: IN std_logic;
TE8: IN std_logic;
TE9: IN std_logic;
TE10: IN std_logic;
TE11: IN std_logic;
TE12: IN std_logic;
TE13: IN std_logic;
TE14: IN std_logic;
TE15: IN std_logic;
TE16: IN std_logic;
TE17: IN std_logic;
TE18: IN std_logic;
TE19: IN std_logic;
TE20: IN std_logic;
TE21: IN std_logic;
TE22: IN std_logic;
TE23: IN std_logic;
TE24: IN std_logic;
TE25: IN std_logic;
TE26: IN std_logic;
TE27: IN std_logic;
TE28: IN std_logic;
TE29: IN std_logic;
TE30: IN std_logic;
TE31: IN std_logic;
TE32: IN std_logic;
TE33: IN std_logic;
TE34: IN std_logic;
TE35: IN std_logic;
TE36: IN std_logic;
TE37: IN std_logic;
TE38: IN std_logic;
TE39: IN std_logic;
TE40: IN std_logic;
TE41: IN std_logic;
TE42: IN std_logic;
TE43: IN std_logic;
TE44: IN std_logic;
TE45: IN std_logic;
TE46: IN std_logic;
TE47: IN std_logic;
TE48: IN std_logic;
TE49: IN std_logic;
TE50: IN std_logic;
TE51: IN std_logic;
TE52: IN std_logic;
TE53: IN std_logic;
TE54: IN std_logic;
TE55: IN std_logic;
TE56: IN std_logic;
TE57: IN std_logic;
TE58: IN std_logic;
TE59: IN std_logic;
TE60: IN std_logic;
TE61: IN std_logic;
TE62: IN std_logic;
TE63: IN std_logic;
TE64: IN std_logic;
TE65: IN std_logic;
TE66: IN std_logic;
TE67: IN std_logic;
TE68: IN std_logic;
TE69: IN std_logic;
TE70: IN std_logic;
TE71: IN std_logic;
TE72: IN std_logic;
TE73: IN std_logic;
TE74: IN std_logic;
TE75: IN std_logic;
TE76: IN std_logic;
TE77: IN std_logic;
TE78: IN std_logic;
TE79: IN std_logic;
TE80: IN std_logic;
TE81: IN std_logic;
TE82: IN std_logic;
TE83: IN std_logic;
TE84: IN std_logic;
TE85: IN std_logic;
TE86: IN std_logic;
TE87: IN std_logic;
TE88: IN std_logic;
TE89: IN std_logic;
TE90: IN std_logic;
TE91: IN std_logic;
TE92: IN std_logic;
TE93: IN std_logic;
TE94: IN std_logic;
TE95: IN std_logic;
TE96: IN std_logic;
TE97: IN std_logic;
TE98: IN std_logic;
TE99: IN std_logic;
TE100: IN std_logic;
TE101: IN std_logic;
TE102: IN std_logic;
TE103: IN std_logic;
TE104: IN std_logic;
TE105: IN std_logic;
TE106: IN std_logic;
TE107: IN std_logic;
TE108: IN std_logic;
TE109: IN std_logic;
TE110: IN std_logic;
TE111: IN std_logic;
TE112: IN std_logic;
TE113: IN std_logic;
TE114: IN std_logic;
TE115: IN std_logic;
TE116: IN std_logic;
TE117: IN std_logic;
TE118: IN std_logic;
TE119: IN std_logic;
TE120: IN std_logic;
TE121: IN std_logic;
TE122: IN std_logic;
TE123: IN std_logic;
TE124: IN std_logic;
TE125: IN std_logic;
TE126: IN std_logic;
TE127: IN std_logic;
TE128: IN std_logic;
TE129: IN std_logic;
TE130: IN std_logic;
TE131: IN std_logic;
TE132: IN std_logic;
TE133: IN std_logic;
TE134: IN std_logic;
TE135: IN std_logic;
TE136: IN std_logic;
TE137: IN std_logic;
TE138: IN std_logic;
TE139: IN std_logic;
TE140: IN std_logic;
TE141: IN std_logic;
TE142: IN std_logic;
TE143: IN std_logic;
TE144: IN std_logic;
TE145: IN std_logic;
TE146: IN std_logic;
TE147: IN std_logic;
TE148: IN std_logic;
TE149: IN std_logic;
TE150: IN std_logic;
TE151: IN std_logic;
TE152: IN std_logic;
TE153: IN std_logic;
TE154: IN std_logic;
TE155: IN std_logic;
TE156: IN std_logic;
TE157: IN std_logic;
TE158: IN std_logic;
TE159: IN std_logic;
TE160: IN std_logic;
TE161: IN std_logic;
TE162: IN std_logic;
TE163: IN std_logic;
TE164: IN std_logic;
TE165: IN std_logic;
TE166: IN std_logic;
TE167: IN std_logic;
TE168: IN std_logic;
TE169: IN std_logic;
TE170: IN std_logic;
TE171: IN std_logic;
TE172: IN std_logic;
TE173: IN std_logic;
TE174: IN std_logic;
TE175: IN std_logic;
TE176: IN std_logic;
TE177: IN std_logic;
TE178: IN std_logic;
TE179: IN std_logic;
TE180: IN std_logic;
TE181: IN std_logic;
TE182: IN std_logic;
TE183: IN std_logic;
TE184: IN std_logic;
TE185: IN std_logic;
TE186: IN std_logic;
TE187: IN std_logic;
TE188: IN std_logic;
TE189: IN std_logic;
TE190: IN std_logic;
TE191: IN std_logic;
TE192: IN std_logic;
TE193: IN std_logic;
TE194: IN std_logic;
TE195: IN std_logic;
TE196: IN std_logic;
TE197: IN std_logic;
TE198: IN std_logic;
TE199: IN std_logic;
TE200: IN std_logic;
TE201: IN std_logic;
TE202: IN std_logic;
TE203: IN std_logic;
TE204: IN std_logic;
TE205: IN std_logic;
TE206: IN std_logic;
TE207: IN std_logic;
TE208: IN std_logic;
TE209: IN std_logic;
TE210: IN std_logic;
TE211: IN std_logic;
TE212: IN std_logic;
TE213: IN std_logic;
TE214: IN std_logic;
TE215: IN std_logic;
TE216: IN std_logic;
TE217: IN std_logic;
TE218: IN std_logic;
TE219: IN std_logic;
TE220: IN std_logic;
TE221: IN std_logic;
TE222: IN std_logic;
TE223: IN std_logic;
TE224: IN std_logic;
TE225: IN std_logic;
TE226: IN std_logic;
TE227: IN std_logic;
TE228: IN std_logic;
TE229: IN std_logic;
TE230: IN std_logic;
TE231: IN std_logic;
TE232: IN std_logic;
TE233: IN std_logic;
TE234: IN std_logic;
TE235: IN std_logic;
TE236: IN std_logic;
TE237: IN std_logic;
TE238: IN std_logic;
TE239: IN std_logic;
TE240: IN std_logic;
TE241: IN std_logic;
TE242: IN std_logic;
TE243: IN std_logic;
TE244: IN std_logic;
TE245: IN std_logic;
TE246: IN std_logic;
TE247: IN std_logic;
TE248: IN std_logic;
TE249: IN std_logic;
TE250: IN std_logic;
TE251: IN std_logic;
TE252: IN std_logic;
TE253: IN std_logic;
TE254: IN std_logic;
TE255: IN std_logic;
		
DATA_OUT  : out std_logic_vector(127 downto 0);   -- 128-bit output data word (ciphertext)
DONE      : out std_logic
		);
	END COMPONENT;
----------------------------------	

component RS232RefComp
   Port (  	TXD 	: out	std_logic	:= '1';
		 	RXD 	: in	std_logic;					
  		 	CLK 	: in	std_logic;							
			DBIN 	: in	std_logic_vector (7 downto 0);
			DBOUT 	: out	std_logic_vector (7 downto 0);
			RDA		: inout	std_logic;							
			TBE		: inout	std_logic 	:= '1';				
			RD		: in	std_logic;							
			WR		: in	std_logic;							
			PE		: out	std_logic;							
			FE		: out	std_logic;							
			OE		: out	std_logic;											
			RST		: in	std_logic	:= '0');				
end component;	


	type StateType is (Idle,receive,Decide,cnt,send11,send13,send2,trans_out,state_1,state_2,state_3,state_12,
	                   stInput,stOutput,st_output1,Test_vector,dummy,DisplayI );

	signal dbInSig	:	std_logic_vector(7 downto 0);
	signal dbOutSig:  std_logic_vector(7 downto 0);
	signal rdaSig	:	std_logic;
	signal tbeSig	:	std_logic;
	signal rdSig	:	std_logic;
	signal wrSig	:	std_logic;
	signal peSig	:	std_logic;
	signal feSig	:	std_logic;
	signal oeSig	:	std_logic;
	signal state	:	StateType;
   signal RST_TEMP:	Std_logic;
   signal reg_in  :  std_logic_vector(7 downto 0);
	signal count   :  std_logic_vector(5 downto 0):= "000001";
	signal ro		:  std_logic_vector(63 downto 0);
   signal St_indic:  std_logic_vector(2 downto 0);
	signal Rflag   :  std_logic_vector(M-1 downto 0);
	Signal Shift_Length:  std_logic_vector(M-1 downto 0);
	signal tv   	:  std_logic_vector(N-1 downto 0);
	signal count1 	: std_logic_vector(4 downto 0);
	signal count31 :  std_logic_vector(5 downto 0);
   
----------CHANGE WHEN PACKET PARAMETERS CHANGE-------
signal INPUT: std_logic_vector(127 downto 0);
signal MUX_SEL: std_logic_vector(255 downto 0);
signal ROOUTSEL: std_logic_vector(2 downto 0);
signal OUTSEL: std_logic_vector(6 downto 0);
-----------------------------------------------------
signal osc : std_logic;
signal EN,D: std_logic;

signal countR,count_RO,count_RO_t: std_logic_vector(31 downto 0);
signal packet: std_logic_vector(N-1 downto 0);
signal clk1 : std_logic;
signal data : std_logic_vector(127 downto 0);
signal CV_SIZE : std_logic_vector(1 downto 0);
signal CV_LOAD :std_logic := '0';
signal DATA_LOAD : std_logic := '0';

signal DATA_OUT,Data_reg : std_logic_vector(127 downto 0);            	----------------###########transmit on uart or ssd########--------
signal DONE_1,Done_12 : std_logic := '0';

signal dummy_led: std_logic_vector(3 downto 0);
signal hex : std_logic_vector(7 downto 0);
signal val : std_logic_vector(3 downto 0);

signal control : std_logic_vector(35 downto 0);
signal ENC_DEC_B : std_logic;

begin
--For debug only
led(7) <= Done_12 ;
--led(5 downto 0) <= count31;
led(6) <= EN;
--led<=dboutsig;
led(5 downto 0) <= DATA_OUT(5 downto 0); 
---For debug only

clock_div: clkdivide 
					port map(clkin => clk,
								 clkout => clk1);

Shift_Length<= std_logic_vector( to_unsigned( N,M ));

--PACKET LATCHING STRUCTURE--
EN<=Packet(N-1);                 -- 1 BIT ENABLE
--EN <= packet(0);
INPUT<=Packet(N-2 downto N-129);  -- Latch Input to N-2 downto N-(No of Inputs +'1') 
	
Process(EN)
begin
if EN='0' then
	MUX_SEL<=(OTHERS=>'0');
	CV_SIZE<=(OTHERS=>'0');

else
	
	 MUX_SEL<=Packet(N-133 downto 0); 
	-- CV_SIZE<= Packet (N-130 downto N-131);
	CV_SIZE <= "10";
	ENC_DEC_B<= Packet (N-132);
 end if;
end process;

ICON_core : ICON
  port map (
    CONTROL0 => CONTROL);

 ILA_core: ILA
  port map (
    CONTROL => CONTROL,
    CLK => CLK1,
    TRIG0 => done_12 & DATA_OUT(127 downto 124));

--Process(ROOUTSEL,OUTSEL)
--Begin
--case ROOUTSEL is
--when "000" => OSC<= OUTSEL(6);
--when "001" => OSC<= OUTSEL(5);
--when "010" => OSC<= OUTSEL(4);
--when "011" => OSC<= OUTSEL(3);
--when "100" => OSC<= OUTSEL(2);
--when "101" => OSC<= OUTSEL(1);
--when "110" => OSC<= OUTSEL(0);
--when OTHERS => OSC<= OUTSEL(6);
--end case;
--end process;

--------------INSTATIANTE NEW  TEST MODULE------------------
AES: aes_start PORT MAP(
clk => CLK1,
rst =>rst,
ENC_DEC_B => ENC_DEC_B,
CV_SIZE => CV_SIZE,
DATA_LOAD => DATA_LOAD,
CV_LOAD  => CV_LOAD,
 
N1=> INPUT(127),
N4=> INPUT(126),
N7=> INPUT(125),
N10=> INPUT(124),
N13=> INPUT(123),
N16=> INPUT(122),
N19=> INPUT(121),
N22=> INPUT(120),
N25=> INPUT(119),
N28=> INPUT(118),
N31=> INPUT(117),
N34=> INPUT(116),
N37=> INPUT(115),
N40=> INPUT(114),
N43=> INPUT(113),
N46=> INPUT(112),
N49=> INPUT(111),
N52=> INPUT(110),
N55=> INPUT(109),
N58=> INPUT(108),
N61=> INPUT(107),
N64=> INPUT(106),
N67=> INPUT(105),
N70=> INPUT(104),
N73=> INPUT(103),
N76=> INPUT(102),
N79=> INPUT(101),
N82=> INPUT(100),
N85=> INPUT(99),
N88=> INPUT(98),
N91=> INPUT(97),
N94=> INPUT(96),
N97=> INPUT(95),
N100=> INPUT(94),
N103=> INPUT(93),
N106=> INPUT(92),
N109=> INPUT(91),
N112=> INPUT(90),
N115=> INPUT(89),
N118=> INPUT(88),
N121=> INPUT(87),
N124=> INPUT(86),
N127=> INPUT(85),
N130=> INPUT(84),
N133=> INPUT(83),
N136=> INPUT(82),
N139=> INPUT(81),
N142=> INPUT(80),
N145=> INPUT(79),
N148=> INPUT(78),
N151=> INPUT(77),
N154=> INPUT(76),
N157=> INPUT(75),
N160=> INPUT(74),
N163=> INPUT(73),
N166=> INPUT(72),
N169=> INPUT(71),
N172=> INPUT(70),
N175=> INPUT(69),
N178=> INPUT(68),
N181=> INPUT(67),
N184=> INPUT(66),
N187=> INPUT(65),
N190=> INPUT(64),
N193=> INPUT(63),
N196=> INPUT(62),
N199=> INPUT(61),
N202=> INPUT(60),
N205=> INPUT(59),
N208=> INPUT(58),
N211=> INPUT(57),
N214=> INPUT(56),
N217=> INPUT(55),
N220=> INPUT(54),
N223=> INPUT(53),
N226=> INPUT(52),
N229=> INPUT(51),
N232=> INPUT(50),
N235=> INPUT(49),
N238=> INPUT(48),
N241=> INPUT(47),
N244=> INPUT(46),
N247=> INPUT(45),
N250=> INPUT(44),
N253=> INPUT(43),
N256=> INPUT(42),
N259=> INPUT(41),
N262=> INPUT(40),
N265=> INPUT(39),
N268=> INPUT(38),
N271=> INPUT(37),
N274=> INPUT(36),
N277=> INPUT(35),
N280=> INPUT(34),
N283=> INPUT(33),
N286=> INPUT(32),
N289=> INPUT(31),
N292=> INPUT(30),
N295=> INPUT(29),
N298=> INPUT(28),
N301=> INPUT(27),
N304=> INPUT(26),
N307=> INPUT(25),
N310=> INPUT(24),
N313=> INPUT(23),
N316=> INPUT(22),
N319=> INPUT(21),
N322=> INPUT(20),
N325=> INPUT(19),
N328=> INPUT(18),
N331=> INPUT(17),
N334=> INPUT(16),
N337=> INPUT(15),
N340=> INPUT(14),
N343=> INPUT(13),
N346=> INPUT(12),
N349=> INPUT(11),
N352=> INPUT(10),
N355=> INPUT(9),
N358=> INPUT(8),
N361=> INPUT(7),
N364=> INPUT(6),
N367=> INPUT(5),
N370=> INPUT(4),
N373=> INPUT(3),
N376=> INPUT(2),
N379=> INPUT(1),
N382=> INPUT(0),
		
TE0=> MUX_SEL(255),
TE1=> MUX_SEL(254),
TE2=> MUX_SEL(253),
TE3=> MUX_SEL(252),
TE4=> MUX_SEL(251),
TE5=> MUX_SEL(250),
TE6=> MUX_SEL(249),
TE7=> MUX_SEL(248),
TE8=> MUX_SEL(247),
TE9=> MUX_SEL(246),
TE10=> MUX_SEL(245),
TE11=> MUX_SEL(244),
TE12=> MUX_SEL(243),
TE13=> MUX_SEL(242),
TE14=> MUX_SEL(241),
TE15=> MUX_SEL(240),
TE16=> MUX_SEL(239),
TE17=> MUX_SEL(238),
TE18=> MUX_SEL(237),
TE19=> MUX_SEL(236),
TE20=> MUX_SEL(235),
TE21=> MUX_SEL(234),
TE22=> MUX_SEL(233),
TE23=> MUX_SEL(232),
TE24=> MUX_SEL(231),
TE25=> MUX_SEL(230),
TE26=> MUX_SEL(229),
TE27=> MUX_SEL(228),
TE28=> MUX_SEL(227),
TE29=> MUX_SEL(226),
TE30=> MUX_SEL(225),
TE31=> MUX_SEL(224),
TE32=> MUX_SEL(223),
TE33=> MUX_SEL(222),
TE34=> MUX_SEL(221),
TE35=> MUX_SEL(220),
TE36=> MUX_SEL(219),
TE37=> MUX_SEL(218),
TE38=> MUX_SEL(217),
TE39=> MUX_SEL(216),
TE40=> MUX_SEL(215),
TE41=> MUX_SEL(214),
TE42=> MUX_SEL(213),
TE43=> MUX_SEL(212),
TE44=> MUX_SEL(211),
TE45=> MUX_SEL(210),
TE46=> MUX_SEL(209),
TE47=> MUX_SEL(208),
TE48=> MUX_SEL(207),
TE49=> MUX_SEL(206),
TE50=> MUX_SEL(205),
TE51=> MUX_SEL(204),
TE52=> MUX_SEL(203),
TE53=> MUX_SEL(202),
TE54=> MUX_SEL(201),
TE55=> MUX_SEL(200),
TE56=> MUX_SEL(199),
TE57=> MUX_SEL(198),
TE58=> MUX_SEL(197),
TE59=> MUX_SEL(196),
TE60=> MUX_SEL(195),
TE61=> MUX_SEL(194),
TE62=> MUX_SEL(193),
TE63=> MUX_SEL(192),
TE64=> MUX_SEL(191),
TE65=> MUX_SEL(190),
TE66=> MUX_SEL(189),
TE67=> MUX_SEL(188),
TE68=> MUX_SEL(187),
TE69=> MUX_SEL(186),
TE70=> MUX_SEL(185),
TE71=> MUX_SEL(184),
TE72=> MUX_SEL(183),
TE73=> MUX_SEL(182),
TE74=> MUX_SEL(181),
TE75=> MUX_SEL(180),
TE76=> MUX_SEL(179),
TE77=> MUX_SEL(178),
TE78=> MUX_SEL(177),
TE79=> MUX_SEL(176),
TE80=> MUX_SEL(175),
TE81=> MUX_SEL(174),
TE82=> MUX_SEL(173),
TE83=> MUX_SEL(172),
TE84=> MUX_SEL(171),
TE85=> MUX_SEL(170),
TE86=> MUX_SEL(169),
TE87=> MUX_SEL(168),
TE88=> MUX_SEL(167),
TE89=> MUX_SEL(166),
TE90=> MUX_SEL(165),
TE91=> MUX_SEL(164),
TE92=> MUX_SEL(163),
TE93=> MUX_SEL(162),
TE94=> MUX_SEL(161),
TE95=> MUX_SEL(160),
TE96=> MUX_SEL(159),
TE97=> MUX_SEL(158),
TE98=> MUX_SEL(157),
TE99=> MUX_SEL(156),
TE100=> MUX_SEL(155),
TE101=> MUX_SEL(154),
TE102=> MUX_SEL(153),
TE103=> MUX_SEL(152),
TE104=> MUX_SEL(151),
TE105=> MUX_SEL(150),
TE106=> MUX_SEL(149),
TE107=> MUX_SEL(148),
TE108=> MUX_SEL(147),
TE109=> MUX_SEL(146),
TE110=> MUX_SEL(145),
TE111=> MUX_SEL(144),
TE112=> MUX_SEL(143),
TE113=> MUX_SEL(142),
TE114=> MUX_SEL(141),
TE115=> MUX_SEL(140),
TE116=> MUX_SEL(139),
TE117=> MUX_SEL(138),
TE118=> MUX_SEL(137),
TE119=> MUX_SEL(136),
TE120=> MUX_SEL(135),
TE121=> MUX_SEL(134),
TE122=> MUX_SEL(133),
TE123=> MUX_SEL(132),
TE124=> MUX_SEL(131),
TE125=> MUX_SEL(130),
TE126=> MUX_SEL(129),
TE127=> MUX_SEL(128),
TE128=> MUX_SEL(127),
TE129=> MUX_SEL(126),
TE130=> MUX_SEL(125),
TE131=> MUX_SEL(124),
TE132=> MUX_SEL(123),
TE133=> MUX_SEL(122),
TE134=> MUX_SEL(121),
TE135=> MUX_SEL(120),
TE136=> MUX_SEL(119),
TE137=> MUX_SEL(118),
TE138=> MUX_SEL(117),
TE139=> MUX_SEL(116),
TE140=> MUX_SEL(115),
TE141=> MUX_SEL(114),
TE142=> MUX_SEL(113),
TE143=> MUX_SEL(112),
TE144=> MUX_SEL(111),
TE145=> MUX_SEL(110),
TE146=> MUX_SEL(109),
TE147=> MUX_SEL(108),
TE148=> MUX_SEL(107),
TE149=> MUX_SEL(106),
TE150=> MUX_SEL(105),
TE151=> MUX_SEL(104),
TE152=> MUX_SEL(103),
TE153=> MUX_SEL(102),
TE154=> MUX_SEL(101),
TE155=> MUX_SEL(100),
TE156=> MUX_SEL(99),
TE157=> MUX_SEL(98),
TE158=> MUX_SEL(97),
TE159=> MUX_SEL(96),
TE160=> MUX_SEL(95),
TE161=> MUX_SEL(94),
TE162=> MUX_SEL(93),
TE163=> MUX_SEL(92),
TE164=> MUX_SEL(91),
TE165=> MUX_SEL(90),
TE166=> MUX_SEL(89),
TE167=> MUX_SEL(88),
TE168=> MUX_SEL(87),
TE169=> MUX_SEL(86),
TE170=> MUX_SEL(85),
TE171=> MUX_SEL(84),
TE172=> MUX_SEL(83),
TE173=> MUX_SEL(82),
TE174=> MUX_SEL(81),
TE175=> MUX_SEL(80),
TE176=> MUX_SEL(79),
TE177=> MUX_SEL(78),
TE178=> MUX_SEL(77),
TE179=> MUX_SEL(76),
TE180=> MUX_SEL(75),
TE181=> MUX_SEL(74),
TE182=> MUX_SEL(73),
TE183=> MUX_SEL(72),
TE184=> MUX_SEL(71),
TE185=> MUX_SEL(70),
TE186=> MUX_SEL(69),
TE187=> MUX_SEL(68),
TE188=> MUX_SEL(67),
TE189=> MUX_SEL(66),
TE190=> MUX_SEL(65),
TE191=> MUX_SEL(64),
TE192=> MUX_SEL(63),
TE193=> MUX_SEL(62),
TE194=> MUX_SEL(61),
TE195=> MUX_SEL(60),
TE196=> MUX_SEL(59),
TE197=> MUX_SEL(58),
TE198=> MUX_SEL(57),
TE199=> MUX_SEL(56),
TE200=> MUX_SEL(55),
TE201=> MUX_SEL(54),
TE202=> MUX_SEL(53),
TE203=> MUX_SEL(52),
TE204=> MUX_SEL(51),
TE205=> MUX_SEL(50),
TE206=> MUX_SEL(49),
TE207=> MUX_SEL(48),
TE208=> MUX_SEL(47),
TE209=> MUX_SEL(46),
TE210=> MUX_SEL(45),
TE211=> MUX_SEL(44),
TE212=> MUX_SEL(43),
TE213=> MUX_SEL(42),
TE214=> MUX_SEL(41),
TE215=> MUX_SEL(40),
TE216=> MUX_SEL(39),
TE217=> MUX_SEL(38),
TE218=> MUX_SEL(37),
TE219=> MUX_SEL(36),
TE220=> MUX_SEL(35),
TE221=> MUX_SEL(34),
TE222=> MUX_SEL(33),
TE223=> MUX_SEL(32),
TE224=> MUX_SEL(31),
TE225=> MUX_SEL(30),
TE226=> MUX_SEL(29),
TE227=> MUX_SEL(28),
TE228=> MUX_SEL(27),
TE229=> MUX_SEL(26),
TE230=> MUX_SEL(25),
TE231=> MUX_SEL(24),
TE232=> MUX_SEL(23),
TE233=> MUX_SEL(22),
TE234=> MUX_SEL(21),
TE235=> MUX_SEL(20),
TE236=> MUX_SEL(19),
TE237=> MUX_SEL(18),
TE238=> MUX_SEL(17),
TE239=> MUX_SEL(16),
TE240=> MUX_SEL(15),
TE241=> MUX_SEL(14),
TE242=> MUX_SEL(13),
TE243=> MUX_SEL(12),
TE244=> MUX_SEL(11),
TE245=> MUX_SEL(10),
TE246=> MUX_SEL(9),
TE247=> MUX_SEL(8),
TE248=> MUX_SEL(7),
TE249=> MUX_SEL(6),
TE250=> MUX_SEL(5),
TE251=> MUX_SEL(4),
TE252=> MUX_SEL(3),
TE253=> MUX_SEL(2),
TE254=> MUX_SEL(1),
TE255=> MUX_SEL(0),

DATA_OUT  => DATA_OUT,
DONE   => DONE_1 

	);
----------------------------------------------------
	UART: RS232RefComp port map (	TXD 	=> TXD,
									RXD 	=> RXD,
									CLK 	=> CLK1,
									DBIN 	=> dbInSig,
									DBOUT	=> dbOutSig,
									RDA	=> rdaSig,
									TBE	=> tbeSig,	
									RD		=> rdSig,
									WR		=> wrSig,
									PE		=> peSig,
									FE		=> feSig,
									OE		=> oeSig,
									RST 	=> RST);


---------------REFERENCE COUNT-------
--process(clk1,DONE_12)
--Begin
--if DONE_12 ='0' then 
--countR <= (others=>'0');
--elsif clk1='1' and clk1'event then
--if countR < "10000000" then
--countR <= countR +'1';
--end if;
--end if;
--end process;
---------------RO COUNT-------------
--process(osc,en,countR,clk1)
--Begin
--if en ='0' then
--count_RO <= (others=>'0'); 
--count_RO_t <= (others=>'0');
--elsif osc='1' and osc'event then
--if countR < "10000000" then
--count_RO_t <= count_RO_t +'1';
--elsif countR = "10000000" then
--count_RO<= count_RO_t;
----count1<= countR;
--end if;
--end if;
--end process;
----count_RO<= count_RO_t;
------------------------------------
-----------------------------CONVERSION TO ASCII----------------------------
--D1: HEX2ASC PORT MAP(count_RO(31 DOWNTO 28),CLK1,RO(63 downto 56));
--D2: HEX2ASC PORT MAP(count_RO(27 DOWNTO 24),CLK1,RO(55 downto 48));
--D3: HEX2ASC PORT MAP(count_RO(23 DOWNTO 20),CLK1,RO(47 downto 40));
--D4: HEX2ASC PORT MAP(count_RO(19 DOWNTO 16),CLK1,RO(39 downto 32));
--D5: HEX2ASC PORT MAP(count_RO(15 DOWNTO 12),CLK1,RO(31 downto 24));
--D6: HEX2ASC PORT MAP(count_RO(11 DOWNTO 8),CLK1,RO(23 downto 16));
--D7: HEX2ASC PORT MAP(count_RO(7 DOWNTO 4),CLK1,RO(15 downto 8));
--D8: HEX2ASC PORT MAP(count_RO(3 DOWNTO 0),CLK1,RO(7 downto 0));
----------------------------------------------------------------------------

process(clk1, rst)
    begin

	if(rst = '1')then
	   state <= idle;
	   rdSig <= '0';
	   wrSig <= '0';
		count1 <= "00000";
		count <= "000001";
           reg_in <= (others =>'0');
           dbInSig <= (others =>'0');
           count  <= "111111";
           Rflag<=(Others=>'0');
			  tv<=(Others=>'0');

	elsif(clk1'event and clk1 = '1')then
	   
	   case state is
		
		  when idle     => rdSig <= '0';
	                     wrSig <= '0';
                        Rflag<=(Others=>'0');
								count<= "000000";
								count31 <= "000001";
				               if(rdaSig = '1')then
				                 state <= receive;
				               end if;

		when receive  => reg_in <= dbOutSig;
							         state <= decide;
		
          when decide => 
				if (dbOutSig = x"49") then 
       		state <= StInput;
				elsif	(dbOutSig<=x"69") then
				state <= StInput;
				elsif (dbOutSig = x"4F") then 
 				state <= StOutput;
				elsif (dbOutSig<=x"6F") then
				state <= StOutput;
				else
				state<= Idle;
          	End if;					

		  when StInput =>
		    rdsig <= '0';
			 wrsig <= '0';
			 if (rdaSig = '1') then
			 if (dbOutSig = x"4F" or dbOutSig = x"6F") then 
 				state <= StOutput;
				else
				state<= test_vector;
			 end if;
			end if;
        when test_vector =>
				--count31 <= "111111";
          if dboutsig(6 downto 0) = "0110001" then
          tv<=tv(N-2 downto 0) & '1';
			 Rflag<= Rflag +'1';										--count31 <= count31 + "000001";
			 state<= displayI;
			 elsif dboutsig(6 downto 0) = "0110000" then
          tv<=tv(N-2 downto 0) & '0';
			 Rflag<= Rflag +'1';										--count31 <= count31 + "000001";
			 state<= displayI;
			 elsif (dboutsig = x"72") then
			 tv<=(Others=>'0');
			 state<= Idle ;
			 elsif (dboutsig = x"52") then
          tv<=(Others=>'0');
			 state<= Idle;
			 elsif (dbOutSig = x"4F") then 
 			 state <= StOutput;
			 elsif (dbOutSig<=x"6F") then
			 state <= StOutput;
			 else 
		    tv<= tv;
			 state<= idle;
			 end if;
          state<= displayI;
			 
		 When displayI =>
          wrsig<='1'; rdsig<='1';
          --dbInsig<=dboutsig;
          If Rflag =Shift_length then
          	state<= Idle;
          else
            state <= StInput;
				--count31<="111101";
          end if;  				
				 
		  when stoutput   => 
		  state <= dummy;
		  when dummy => 
		  CV_LOAD <= '1';
		  state <= state_1;
		  
		  when state_1 =>
		  CV_LOAD <= '0';
		  state <= state_12;
		  
		  when state_12 =>
		  If(count1 > "10000") then
		  state <= state_2;
		  else
		  state <= state_12;
		  count1 <= count1 + "00001";
		  end if;
		  
		  when state_2 =>
		  DATA_LOAD <= '1';
		  state <= state_3;
		  
		  when state_3 =>
		  DATA_LOAD <= '0';
		  state <= st_output1;
		  
		  when st_output1 =>

		  --if(Done_1 = '1' and Done_1'event) then						---change here to done_1
			if (Done_1 = '1') then	
				Data_reg <= DATA_OUT;
				count <= "000001";count31 <= "100001";	state <= trans_out;	
				DONE_12 <= '1';
			else
				state <= st_output1;
			end if;
--			if(DONE_12 = '1') then
--				state <= trans_out;
--			end if;
--		  
		  when trans_out =>
		  if count = "000001" then
		  val <=x"A";count31 <= "100111";
		  elsif count = "000010" then
		  val <=Data_reg(127 downto 124);
		  elsif count = "000011" then
		  val <=Data_reg(123 downto 120);
		 	elsif count = "000100" then
			val <=Data_reg(119 downto 116);
			elsif count = "000101" then
		  val <=Data_reg(115 downto 112);
			elsif count = "000110" then
		  val <=Data_reg(111 downto 108);
		  elsif count = "000111" then
		  val <=Data_reg(107 downto 104);
		  elsif count = "001000" then
		  val <=Data_reg(103 downto 100);
		  elsif count = "001001" then
		  val <=Data_reg(99 downto 96);
			elsif count = "001010" then
		  val <=Data_reg(95 downto 92);
			elsif count = "001011" then
			val <=Data_reg(91 downto 88);
			elsif count = "001100" then
		  val <=Data_reg(87 downto 84);
			elsif count = "001101" then
		  val <=Data_reg(83 downto 80);
		  elsif count = "001110" then
		  val <=Data_reg(79 downto 76);
			elsif count = "001111" then
		  val <=Data_reg(75 downto 72);
		  elsif count = "010000" then
		  val <=Data_reg(71 downto 68);
		  	elsif count = "010001" then
			val <=Data_reg(67 downto 64);
			elsif count = "010010" then
		  val <=Data_reg(63 downto 60);
		  elsif count = "010011" then
		  val <=Data_reg(59 downto 56);
			elsif count = "010100" then
		  val <=Data_reg(55 downto 52);
		  elsif count = "010101" then
		   val <=Data_reg(51 downto 48);
			elsif count = "010110" then
		  val <=Data_reg(47 downto 44);
		  elsif count = "010111" then
		  val <=Data_reg(43 downto 40);
			elsif count = "011000" then
		  val <=Data_reg(39 downto 36);
		  elsif count = "011001" then
		  val <=Data_reg(35 downto 32);
			elsif count = "011010" then
		  val <=Data_reg(31 downto 28);
		  elsif count = "011011" then
		   val <=Data_reg(27 downto 24);
			elsif count = "011100" then
		  val <=Data_reg(23 downto 20);
		  elsif count = "011101" then
		  val <=Data_reg(19 downto 16);
			elsif count = "011110" then
		  val <=Data_reg(15 downto 12);
		  elsif count = "011111" then
		  val <=Data_reg(11 downto 8);
			elsif count = "100000" then
		  val <=Data_reg(7 downto 4);
		  elsif count = "100001" then
		  val <=Data_reg(3 downto 0);
			elsif count = "100010" then
		  val <="0001";
		  end if;
			state <= send11;
		when send11 =>
		CASE VAL IS
			when "0000" => hex<= X"30";
			when "0001" => hex<= X"b1";
			when "0010" => hex<= X"b2";
			when "0011" => hex<= X"33";
			when "0100" => hex<= X"b4";
			when "0101" => hex<= X"35";
			when "0110" => hex<= X"36";
			when "0111" => hex<= X"b7";
			when "1000" => hex<= X"b8";
			when "1001" => hex<= X"39";
			when "1010" => hex<= X"e1"; 
			when "1011" => hex<= X"e2"; 
			when "1100" => hex<= X"63"; 
			when "1101" => hex<= X"e4"; 
			when "1110" => hex<= X"65";
			when "1111" => hex<= X"66"; 
			when others => hex<= X"2D"; 
		end case;
			dbInSig <= hex;
			rdsig<='0'; wrsig<='0';
			countR <= x"00000000";
				if TBEsig='1' then
					 state <= send13;
				end if;
		when send13 => 		  

							rdsig<='1';
							wrSig <= '1';	
                       state  <= cnt;
							
	when cnt  =>        rdsig<= '0';
                       wrsig<='0'; 	
						if countR<x"00100000" then
							countR <= countR +'1';
								state <= cnt;
							else	
								count <= count + "000001";		
								state<= send2;  
					end if;
						  
      when send2    => if (count >= "100011") then
							  state  <= idle;
                       rdsig<= '0';
                       wrsig<='0'; 											
							  else
							  state  <= trans_out;
				           end if;
		  
	    end case;
    end if;
end process;
Packet <=TV(N-1 Downto 0);


--hex2asc_map: HEX2ASC	Port map 
--				(VAL => val,
--				CLK => clk1,
--				Y  =>hex);


end behavior;