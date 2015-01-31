----------------------------------------------------------
--------------PACKET--------------------------------------
----MSB--- EN  (36 Bit Input) (3 Bit for Output Select) (47 Bits for Mux Selection)---LSB-------
-------------------------- TOTAL 87 Bits ------------------
----------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity DISPLAY_UNIT is 
generic (N: integer := 87; M: integer:= 7;I: integer:= 36;J: integer:= 47; R: integer:= 3; O: integer:= 7);
--- N = No of Bits in Test vector + 1 (For Enable) + Num of Mux in RO + Output Select Mux
--- M = No of Bits Reuired to count the N
--- I = No of INPUT BITS
--- J = No of MUXES IN CKT
--- O = No of OUTPUT PINS
--- R = No of BITS FOR SELECTION OF OUTPUT (= Log 'o') 


port(
TXD : out std_logic := '1';RXD: in std_logic := '1';
clk : in std_logic;
RST: in std_logic	:= '0'
);
end DISPLAY_UNIT;
architecture behavior of DISPLAY_UNIT is

---- INSERT NEW TEST BENCH MODULE--------

COMPONENT my_module
	PORT(
		N1 : IN std_logic;
		N4 : IN std_logic;
		N8 : IN std_logic;
		N11 : IN std_logic;
		N14 : IN std_logic;
		N17 : IN std_logic;
		N21 : IN std_logic;
		N24 : IN std_logic;
		N27 : IN std_logic;
		N30 : IN std_logic;
		N34 : IN std_logic;
		N37 : IN std_logic;
		N40 : IN std_logic;
		N43 : IN std_logic;
		N47 : IN std_logic;
		N50 : IN std_logic;
		N53 : IN std_logic;
		N56 : IN std_logic;
		N60 : IN std_logic;
		N63 : IN std_logic;
		N66 : IN std_logic;
		N69 : IN std_logic;
		N73 : IN std_logic;
		N76 : IN std_logic;
		N79 : IN std_logic;
		N82 : IN std_logic;
		N86 : IN std_logic;
		N89 : IN std_logic;
		N92 : IN std_logic;
		N95 : IN std_logic;
		N99 : IN std_logic;
		N102 : IN std_logic;
		N105 : IN std_logic;
		N108 : IN std_logic;
		N112 : IN std_logic;
		N115 : IN std_logic;
		TE0 : IN std_logic;
		TE1 : IN std_logic;
		TE2 : IN std_logic;
		TE3 : IN std_logic;
		TE4 : IN std_logic;
		TE5 : IN std_logic;
		TE6 : IN std_logic;
		TE7 : IN std_logic;
		TE8 : IN std_logic;
		TE9 : IN std_logic;
		TE10 : IN std_logic;
		TE11 : IN std_logic;
		TE12 : IN std_logic;
		TE13 : IN std_logic;
		TE14 : IN std_logic;
		TE15 : IN std_logic;
		TE16 : IN std_logic;
		TE17 : IN std_logic;
		TE18 : IN std_logic;
		TE19 : IN std_logic;
		TE20 : IN std_logic;
		TE21 : IN std_logic;
		TE22 : IN std_logic;
		TE23 : IN std_logic;
		TE24 : IN std_logic;
		TE25 : IN std_logic;
		TE26 : IN std_logic;
		TE27 : IN std_logic;
		TE28 : IN std_logic;
		TE29 : IN std_logic;
		TE30 : IN std_logic;
		TE31 : IN std_logic;
		TE32 : IN std_logic;
		TE33 : IN std_logic;
		TE34 : IN std_logic;
		TE35 : IN std_logic;
		TE36 : IN std_logic;
		TE37 : IN std_logic;
		TE38 : IN std_logic;
		TE39 : IN std_logic;
		TE40 : IN std_logic;
		TE41 : IN std_logic;
		TE42 : IN std_logic;
		TE43 : IN std_logic;
		TE44 : IN std_logic;
		TE45 : IN std_logic;
		TE46 : IN std_logic;          
		N223 : OUT std_logic;
		N329 : OUT std_logic;
		N370 : OUT std_logic;
		N421 : OUT std_logic;
		N430 : OUT std_logic;
		N431 : OUT std_logic;
		N432 : OUT std_logic
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

COMPONENT HEX2ASC
	PORT(
		VAL : IN std_logic_vector(3 downto 0);
		CLK : IN std_logic;          
		Y : OUT std_logic_vector(7 downto 0)
		);
END COMPONENT;
	
	type StateType is (Idle, cnt, receive,Decide, send1, send2,
	                   stInput,stOutput,Test_vector,DisplayI );

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
	signal count   :  std_logic_vector(3 downto 0);
	signal ro		:  std_logic_vector(63 downto 0);
   signal St_indic:  std_logic_vector(2 downto 0);
	signal Rflag   :  std_logic_vector(M-1 downto 0);
	Signal Shift_Length:  std_logic_vector(M-1 downto 0);
	signal tv   	:  std_logic_vector(N-1 downto 0);
   
----------CHANGE WHEN PACKET PARAMETERS CHANGE-------
signal INPUT: std_logic_vector(I-1 downto 0);
signal MUX_SEL: std_logic_vector(J-1 downto 0);
signal ROOUTSEL: std_logic_vector(R-1 downto 0);
signal OUTSEL: std_logic_vector(O-1 downto 0);
-----------------------------------------------------
signal osc : std_logic;
signal EN,D: std_logic;

signal countR,count_RO,count_RO_t,count1: std_logic_vector(31 downto 0);
signal packet: std_logic_vector(N-1 downto 0);

begin
Shift_Length<= std_logic_vector( to_unsigned( N,M ));

--PACKET LATCHING STRUCTURE--
EN<=Packet(N-1);                 -- 1 BIT ENABLE
INPUT<=Packet(N-2 downto N-I-1);  -- Latch Input to N-2 downto N-(No of Inputs +'1') 
	
Process(EN)
begin
if EN='0' then
MUX_SEL<=(OTHERS=>'0');
else
 MUX_SEL<=Packet(J-1 downto 0); 
 end if;
end process;
 ROOUTSEL<= Packet (N-I-2 downto N-I-R-3);

Process(ROOUTSEL,OUTSEL)
Begin
case ROOUTSEL is
when "000" => OSC<= OUTSEL(O-1);
when "001" => OSC<= OUTSEL(O-2);
when "010" => OSC<= OUTSEL(O-3);
when "011" => OSC<= OUTSEL(O-4);
when "100" => OSC<= OUTSEL(O-5);
when "101" => OSC<= OUTSEL(O-6);
when "110" => OSC<= OUTSEL(O-7);
when OTHERS => OSC<= OUTSEL(O-1);
end case;
end process;

--------------INSTATIANTE NEW  TEST MODULE------------------
Inst_my_module: my_module PORT MAP(
		N1 => INPUT(35),
		N4 => INPUT(34),
		N8 => INPUT(33),
		N11 => INPUT(32),
		N14 => INPUT(31),
		N17 => INPUT(30),
		N21 => INPUT(29),
		N24 => INPUT(28),
		N27 => INPUT(27),
		N30 => INPUT(26),
		N34 => INPUT(25),
		N37 => INPUT(24),
		N40 => INPUT(23),
		N43 => INPUT(22),
		N47 => INPUT(21),
		N50 => INPUT(20),
		N53 => INPUT(19),
		N56 => INPUT(18),
		N60 => INPUT(17),
		N63 => INPUT(16),
		N66 => INPUT(15),
		N69 => INPUT(14),
		N73 => INPUT(13),
		N76 => INPUT(12),
		N79 => INPUT(11),
		N82 => INPUT(10),
		N86 => INPUT(9),
		N89 => INPUT(8),
		N92 => INPUT(7),
		N95 => INPUT(6),
		N99 => INPUT(5),
		N102 => INPUT(4),
		N105 => INPUT(3),
		N108 => INPUT(2),
		N112 => INPUT(1),
		N115 => INPUT(0),
		TE0 => MUX_SEL(46),
		TE1 => MUX_SEL(45),
		TE2 => MUX_SEL(44),
		TE3 => MUX_SEL(43),
		TE4 => MUX_SEL(42),
		TE5 => MUX_SEL(41),
		TE6 => MUX_SEL(40),
		TE7 => MUX_SEL(39),
		TE8 => MUX_SEL(38),
		TE9 => MUX_SEL(37),
		TE10 => MUX_SEL(36),
		TE11 => MUX_SEL(35),
		TE12 => MUX_SEL(34),
		TE13 => MUX_SEL(33),
		TE14 => MUX_SEL(32),
		TE15 => MUX_SEL(31),
		TE16 => MUX_SEL(30),
		TE17 => MUX_SEL(29),
		TE18 => MUX_SEL(28),
		TE19 => MUX_SEL(27),
		TE20 => MUX_SEL(26),
		TE21 => MUX_SEL(25),
		TE22 => MUX_SEL(24),
		TE23 => MUX_SEL(23),
		TE24 => MUX_SEL(22),
		TE25 => MUX_SEL(21),
		TE26 => MUX_SEL(20),
		TE27 => MUX_SEL(19),
		TE28 => MUX_SEL(18),
		TE29 => MUX_SEL(17),
		TE30 => MUX_SEL(16),
		TE31 => MUX_SEL(15),
		TE32 => MUX_SEL(14),
		TE33 => MUX_SEL(13),
		TE34 => MUX_SEL(12),
		TE35 => MUX_SEL(11),
		TE36 => MUX_SEL(10),
		TE37 => MUX_SEL(9),
		TE38 => MUX_SEL(8),
		TE39 => MUX_SEL(7),
		TE40 => MUX_SEL(6),
		TE41 => MUX_SEL(5),
		TE42 => MUX_SEL(4),
		TE43 => MUX_SEL(3),
		TE44 => MUX_SEL(2),
		TE45 => MUX_SEL(1),
		TE46 => MUX_SEL(0),
		N223 => OUTSEL(6),
		N329 => OUTSEL(5),
		N370 => OUTSEL(4),
		N421 => OUTSEL(3),
		N430 => OUTSEL(2),
		N431 => OUTSEL(1),
		N432 => OUTSEL(0)
	);
----------------------------------------------------
	UART: RS232RefComp port map (	TXD 	=> TXD,
									RXD 	=> RXD,
									CLK 	=> CLK,
									DBIN 	=> dbInSig,
									DBOUT	=> dbOutSig,
									RDA		=> rdaSig,
									TBE		=> tbeSig,	
									RD		=> rdSig,
									WR		=> wrSig,
									PE		=> peSig,
									FE		=> feSig,
									OE		=> oeSig,
									RST 	=> RST);


-------------REFERENCE COUNT-------
process(clk,en)
Begin
if en ='0' then 
countR <= (others=>'0');
elsif clk='1' and clk'event then
if countR<x"10000000" then
countR <= countR +'1';
end if;
end if;
end process;
-------------RO COUNT-------------
process(osc,en,countR,clk)
Begin
if en ='0' then
count_RO <= (others=>'0'); 
count_RO_t <= (others=>'0');
elsif osc='1' and osc'event then
if countR<x"10000000" then
count_RO_t <= count_RO_t +'1';
elsif countR=x"10000000" then
count_RO<= count_RO_t;
--count1<= countR;
end if;
end if;
end process;
--count_RO<= count_RO_t;
----------------------------------
-----------------------------CONVERSION TO ASCII----------------------------
D1: HEX2ASC PORT MAP(count_RO(31 DOWNTO 28),CLK,RO(63 downto 56));
D2: HEX2ASC PORT MAP(count_RO(27 DOWNTO 24),CLK,RO(55 downto 48));
D3: HEX2ASC PORT MAP(count_RO(23 DOWNTO 20),CLK,RO(47 downto 40));
D4: HEX2ASC PORT MAP(count_RO(19 DOWNTO 16),CLK,RO(39 downto 32));
D5: HEX2ASC PORT MAP(count_RO(15 DOWNTO 12),CLK,RO(31 downto 24));
D6: HEX2ASC PORT MAP(count_RO(11 DOWNTO 8),CLK,RO(23 downto 16));
D7: HEX2ASC PORT MAP(count_RO(7 DOWNTO 4),CLK,RO(15 downto 8));
D8: HEX2ASC PORT MAP(count_RO(3 DOWNTO 0),CLK,RO(7 downto 0));
----------------------------------------------------------------------------

process(clk, rst)
    begin

	if(rst = '1')then
	   state <= idle;
	   rdSig <= '0';
	   wrSig <= '0';
           reg_in <= (others =>'0');
           dbInSig <= (others =>'0');
           count  <= "1111";
           Rflag<=(Others=>'0');
			  tv<=(Others=>'0');

	elsif(clk'event and clk = '1')then
	   
	   case state is
		
		  when idle     => rdSig <= '0';
	                     wrSig <= '0';
                        Rflag<=(Others=>'0');
								count<= "0000";
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
          if dboutsig = x"30" then
          tv<=tv(N-2 downto 0) & '0';
			 Rflag<= Rflag +'1';
          state<= displayI;
			 elsif dboutsig = x"31" then
          tv<=tv(N-2 downto 0) & '1';
          Rflag<= Rflag +'1';
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
          end if;  				

				 
		  when stoutput   => 
		  
		  if count = "0001" then
		  dbInSig <=x"20";
		  ELSif count = "1010" then
		  dbInSig <=x"0A";
		  elsif count = "0010" then
		  dbInSig <=ro (63 downto 56);
		  elsif count = "0011" then
		  dbInSig <=ro (55 downto 48);
			elsif count = "0100" then
		  dbInSig <=ro (47 downto 40);
			elsif count = "0101" then
		  dbInSig <=ro (39 downto 32);
			elsif count = "0110" then
		  dbInSig <=ro (31 downto 24);
			elsif count = "0111" then
		  dbInSig <=ro (23 downto 16);
			elsif count = "1000" then
		  dbInSig <=ro (15 downto 8);
			elsif count = "1001" then
		  dbInSig <=ro (7 downto 0);
		  end if;

        rdsig<='0'; wrsig<='0';
 		  if TBEsig='1' then
		  state <= send1;
   	  end if;

      when send1    => rdSig <= '1'; 
			              wrSig <= '1';
                       state  <= cnt;
      
		when cnt   => count <= count +'1';		
                    state<= send2;  
						  
      when send2    => if (count > "1010") then
							  state  <= idle;
                       rdsig<= '0';
                       wrsig<='0'; 											
							  else
							  state  <= stOutput;
				           end if;
	    end case;
    end if;
end process;
Packet <=TV(N-1 Downto 0);

end behavior;
