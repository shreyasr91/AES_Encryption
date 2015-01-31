----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:45:45 12/09/2014 
-- Design Name: 
-- Module Name:    my_module - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity aes_start is
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


end aes_start;

architecture Behavioral of aes_start is
component RIJNDAEL_TOP_ITER is

  port (clock     : in std_logic;
        reset     : in std_logic;

        ENC_DEC_B : in std_logic;  -- '1' = encrypt, '0' = decrypt
        DATA_IN   : in std_logic_vector(127 downto 0);    -- 128-bit input data word (plaintext)
        DATA_LOAD : in std_logic;  -- data valid; load new input data word
        CV_IN     : in std_logic_vector(255 downto 0);    -- 128, 192, 256-bit cv (user supplied key)
        CV_LOAD   : in std_logic;  -- cv_in is valid; load new cryptovariable
        CV_SIZE   : in std_logic_vector(1 downto 0);      -- '00'= 128, '01'= 192, '10'= 256

        DATA_OUT  : out std_logic_vector(127 downto 0);   -- 128-bit output data word (ciphertext)
        DONE      : out std_logic  -- indicates 'data_out' is valid
		);
end component;

signal data : std_logic_vector(127 downto 0);	
signal Key : std_logic_vector(255 downto 0);
signal DATA_OUT_1 : std_logic_vector(127 downto 0);							-----should connect to output
signal DONE_1 : std_logic;

begin

--DATA_OUT <= x"12345678912345671234567891234567";
--DONE <= '1';
aes_portmap: RIJNDAEL_TOP_ITER  port map (
		  clock 	  => clk,
        reset    => rst,

        ENC_DEC_B => ENC_DEC_B,  -- '1' = encrypt, '0' = decrypt
        DATA_IN   => data,   -- 128-bit input data word (plaintext)
        DATA_LOAD => DATA_LOAD, -- data valid; load new input data word
        CV_IN     => Key,   -- 128, 192, 256-bit cv (user supplied key)
        CV_LOAD   =>CV_LOAD,  -- cv_in is valid; load new cryptovariable
        CV_SIZE   => CV_SIZE,      -- '00'= 128, '01'= 192, '10'= 256

        DATA_OUT  => DATA_OUT_1,   -- 128-bit output data word (ciphertext)				---change to data_out
        DONE      => DONE_1  -- indicates 'data_out' is valid
		  );

Key <= TE0 & TE1 & TE2 & TE3 & TE4 & TE5 & TE6 & TE7 & TE8 & TE9 & TE10 & TE11 & TE12 & TE13 & TE14 & TE15 & TE16 & TE17 & TE18 & TE19 & TE20 & TE21 & TE22 & TE23 & TE24 & TE25 & TE26 & TE27 & TE28 & TE29 & TE30 & TE31 & TE32 & TE33 & TE34 & TE35 & TE36 & TE37 & TE38 & TE39 & TE40 & TE41 & TE42 & TE43 & TE44 & TE45 & TE46 & TE47 & TE48 & TE49 & TE50 & TE51 & TE52 & TE53 & TE54 & TE55 & TE56 & TE57 & TE58 & TE59 & TE60 & TE61 & TE62 & TE63 & TE64 & TE65 & TE66 & TE67 & TE68 & TE69 & TE70 & TE71 & TE72 & TE73 & TE74 & TE75 & TE76 & TE77 & TE78 & TE79 & TE80 & TE81 & TE82 & TE83 & TE84 & TE85 & TE86 & TE87 & TE88 & TE89 & TE90 & TE91 & TE92 & TE93 & TE94 & TE95 & TE96 & TE97 & TE98 & TE99 & TE100 & TE101 & TE102 & TE103 & TE104 & TE105 & TE106 & TE107 & TE108 & TE109 & TE110 & TE111 & TE112 & TE113 & TE114 & TE115 & TE116 & TE117 & TE118 & TE119 & TE120 & TE121 & TE122 & TE123 & TE124 & TE125 & TE126 & TE127 & TE128 & TE129 & TE130 & TE131 & TE132 & TE133 & TE134 & TE135 & TE136 & TE137 & TE138 & TE139 & TE140 & TE141 & TE142 & TE143 & TE144 & TE145 & TE146 & TE147 & TE148 & TE149 & TE150 & TE151 & TE152 & TE153 & TE154 & TE155 & TE156 & TE157 & TE158 & TE159 & TE160 & TE161 & TE162 & TE163 & TE164 & TE165 & TE166 & TE167 & TE168 & TE169 & TE170 & TE171 & TE172 & TE173 & TE174 & TE175 & TE176 & TE177 & TE178 & TE179 & TE180 & TE181 & TE182 & TE183 & TE184 & TE185 & TE186 & TE187 & TE188 & TE189 & TE190 & TE191 & TE192 & TE193 & TE194 & TE195 & TE196 & TE197 & TE198 & TE199 & TE200 & TE201 & TE202 & TE203 & TE204 & TE205 & TE206 & TE207 & TE208 & TE209 & TE210 & TE211 & TE212 & TE213 & TE214 & TE215 & TE216 & TE217 & TE218 & TE219 & TE220 & TE221 & TE222 & TE223 & TE224 & TE225 & TE226 & TE227 & TE228 & TE229 & TE230 & TE231 & TE232 & TE233 & TE234 & TE235 & TE236 & TE237 & TE238 & TE239 & TE240 & TE241 & TE242 & TE243 & TE244 & TE245 & TE246 & TE247 & TE248 & TE249 & TE250 & TE251 & TE252 & TE253 & TE254 & TE255 ;
data <= N1 & N4 & N7 & N10 & N13 & N16 & N19 & N22 & N25 & N28 & N31 & N34 & N37 & N40 & N43 & N46 & N49 & N52 & N55 & N58 & N61 & N64 & N67 & N70 & N73 & N76 & N79 & N82 & N85 & N88 & N91 & N94 & N97 & N100 & N103 & N106 & N109 & N112 & N115 & N118 & N121 & N124 & N127 & N130 & N133 & N136 & N139 & N142 & N145 & N148 & N151 & N154 & N157 & N160 & N163 & N166 & N169 & N172 & N175 & N178 & N181 & N184 & N187 & N190 & N193 & N196 & N199 & N202 & N205 & N208 & N211 & N214 & N217 & N220 & N223 & N226 & N229 & N232 & N235 & N238 & N241 & N244 & N247 & N250 & N253 & N256 & N259 & N262 & N265 & N268 & N271 & N274 & N277 & N280 & N283 & N286 & N289 & N292 & N295 & N298 & N301 & N304 & N307 & N310 & N313 & N316 & N319 & N322 & N325 & N328 & N331 & N334 & N337 & N340 & N343 & N346 & N349 & N352 & N355 & N358 & N361 & N364 & N367 & N370 & N373 & N376 & N379 & N382;
--key <= x"0000000000000000000000000000000000000000000000000000000000000000";
--data <= x"014730f80ac625fe84f026c60bfd547d";
--DATA_OUT <= key(127 downto 0);
--DONE <= '1';
Process(clk,DONE_1,rst)
begin
If rst = '1' then
DONE <= '0';
elsIf(clk'event and clk = '1') then
if(done_1 = '1')then
--DATA_OUT <= x"12345678912345671234567891234567";
DONE <= '1';
DATA_OUT <= DATA_OUT_1;
end if;
end if;

--DATA_OUT <= data;
--end if;
end process;





end Behavioral;

