-- *************************************************************************
-- DISCLAIMER. THIS SOFTWARE WAS WRITTEN BY EMPLOYEES OF THE U.S.
-- GOVERNMENT AS A PART OF THEIR OFFICIAL DUTIES AND, THEREFORE, IS NOT
-- PROTECTED BY COPYRIGHT. HOWEVER, THIS SOFTWARE CODIFIES THE FINALIST
-- CANDIDATE ALGORITHMS (i.e., MARS, RC6tm, RIJNDAEL, SERPENT, AND
-- TWOFISH) IN THE ADVANCED ENCRYPTION STANDARD (AES) DEVELOPMENT EFFORT
-- SPONSORED BY THE NATIONAL INSTITUTE OF STANDARDS AND TECHNOLOGY (NIST)
-- AND MAY BE PROTECTED BY ONE OR MORE FORMS OF INTELLECTUAL PROPERTY. THE
-- U.S. GOVERNMENT MAKES NO WARRANTY, EITHER EXPRESSED OR IMPLIED,
-- INCLUDING BUT NO LIMITED TO ANY IMPLIED WARRANTIES OF MERCHANTABILITY
-- OR FITNESS FOR A PARTICULAR PURPOSE, REGARDING THIS SOFTWARE. THE U.S.
-- GOVERNMENT FURTHER MAKES NO WARRANTY THAT THIS SOFTWARE WILL NOT
-- INFRINGE ANY OTHER UNITED STATES OR FOREIGN PATENT OR OTHER
-- INTELLECTUAL PROPERTY RIGHT. IN NO EVENT SHALL THE U.S. GOVERNMENT BE
-- LIABLE TO ANYONE FOR COMPENSATORY, PUNITIVE, EXEMPLARY, SPECIAL,
-- COLLATERAL, INCIDENTAL, CONSEQUENTIAL, OR ANY OTHER TYPE OF DAMAGES IN
-- CONNECTION WITH OR ARISING OUT OF COPY OR USE OF THIS SOFTWARE.
-- *************************************************************************

-- ===========================================================================
-- File Name: rijndael_pkg.vhdl
-- Author   : NSA
-- Date     : December 1999
-- Project  : RIJNDAEL
-- Purpose  : This package defines common types, subtypes, constants,
--            and functions required to implement various VHDL models
--            for the creation of ASIC simulation of RIJNDAEL, an Advanced
--            Encryption Standard (AES) candidate algorithm.
--
-- ===========================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package rijndael_pack is

-- ==========================================================================
-- ======= Type, sub-type and function declarations for general use =========
-- ==========================================================================

type CONTROL_STATES      is ( nop, wait4ks, ready, busy );

subtype ROUND_TYPE       is integer range 0 to 63;
subtype SBOX_INDEX_TYPE  is integer range 0 to 15;
subtype S_BOX_FIELD      is integer range 0 to 255;
subtype SLV_2            is std_logic_vector(1 downto 0);
subtype SLV_6            is std_logic_vector(5 downto 0);
subtype SLV_8            is std_logic_vector(7 downto 0);
subtype SLV_16           is std_logic_vector(15 downto 0);
subtype SLV_32           is std_logic_vector(31 downto 0);
subtype SLV_128          is std_logic_vector(127 downto 0);
subtype SLV_256          is std_logic_vector(255 downto 0);

constant FIRST_ROUND : ROUND_TYPE := 0;
constant LAST_ROUND  : ROUND_TYPE := 13;

constant NB          : INTEGER := 4;
constant NK          : INTEGER := 7;

constant CV128       : SLV_2 := "00";
constant CV192       : SLV_2 := "01";
constant CV256       : SLV_2 := "10";

constant NUM_RUNUP_ROUNDS : integer := 15;   -- used by testbench

type INDEX_TYPE is array (0 to 12) of integer;

constant FAR_INDEX_ENC : INDEX_TYPE := (0, 1, 3, 4, 6, 7, 9, 10, 0, 0, 0, 0, 0);
constant FAR_INDEX_DEC : INDEX_TYPE := (0, 2, 3, 5, 6, 8, 9, 11, 0, 0, 0, 0, 0);
constant SBOX_INDEX    : INDEX_TYPE := (0, 0, 1, 2, 0, 3, 4,  0, 5, 6, 0, 7, 0);
constant NEAR_INDEX    : INDEX_TYPE := (0, 2, 3, 5, 6, 8, 9, 11, 0, 0, 0, 0, 0);
constant SBOX_INDEX192 : INDEX_TYPE := (0, 1, 0, 2, 3, 0, 4,  5, 0, 6, 7, 0, 0);


-- ==========================================================================
-- ============ Declarations for the Encrypt/Decrypt section ================
-- ==========================================================================

type SBOX_TYPE      is array (0 to 255) of S_BOX_FIELD;
type RCON_TYPE      is array (0 to 29) of SLV_8;
type SHIFT_ROW_TYPE is array (0 to 1) of integer range 0 to 3;
type SHIFT_TYPE     is array (0 to 3) of SHIFT_ROW_TYPE;
type STATE_ROW_TYPE is array (0 to NB-1) of SLV_8;
type STATE_TYPE     is array (0 to 3) of STATE_ROW_TYPE;
type TEMP_TYPE      is array (0 to 3) of SLV_8;
type KEY_ROW_TYPE   is array (0 to 3) of SLV_8;
type KEY_TYPE       is array (0 to 3) of KEY_ROW_TYPE;
type PIPE_DATA_TYPE is array (FIRST_ROUND to LAST_ROUND+1) of STATE_TYPE;

type MOD3_TABLE_TYPE is array (0 to 59) of integer range 0 to 3;
type MOD6_TABLE_TYPE is array (0 to 59) of integer range 0 to 5;
type DIV6_TABLE_TYPE is array (0 to 59) of integer range 0 to 10;
-- ==========================================================================
-- ================================ SBOX ====================================
-- ==========================================================================

constant SBOX : SBOX_TYPE := (

 99, 124, 119, 123, 242, 107, 111, 197,  48,   1, 103,  43, 254, 215, 171, 118, 
202, 130, 201, 125, 250,  89,  71, 240, 173, 212, 162, 175, 156, 164, 114, 192, 
183, 253, 147,  38,  54,  63, 247, 204,  52, 165, 229, 241, 113, 216,  49,  21, 
  4, 199,  35, 195,  24, 150,   5, 154,   7,  18, 128, 226, 235,  39, 178, 117, 
  9, 131,  44,  26,  27, 110,  90, 160,  82,  59, 214, 179,  41, 227,  47, 132, 
 83, 209,   0, 237,  32, 252, 177,  91, 106, 203, 190,  57,  74,  76,  88, 207, 
208, 239, 170, 251,  67,  77,  51, 133,  69, 249,   2, 127,  80,  60, 159, 168, 
 81, 163,  64, 143, 146, 157,  56, 245, 188, 182, 218,  33,  16, 255, 243, 210, 
205,  12,  19, 236,  95, 151,  68,  23, 196, 167, 126,  61, 100,  93,  25, 115, 
 96, 129,  79, 220,  34,  42, 144, 136,  70, 238, 184,  20, 222,  94,  11, 219, 
224,  50,  58,  10,  73,   6,  36,  92, 194, 211, 172,  98, 145, 149, 228, 121, 
231, 200,  55, 109, 141, 213,  78, 169, 108,  86, 244, 234, 101, 122, 174,   8, 
186, 120,  37,  46,  28, 166, 180, 198, 232, 221, 116,  31,  75, 189, 139, 138, 
112,  62, 181, 102,  72,   3, 246,  14,  97,  53,  87, 185, 134, 193,  29, 158, 
225, 248, 152,  17, 105, 217, 142, 148, 155,  30, 135, 233, 206,  85,  40, 223, 
140, 161, 137,  13, 191, 230,  66, 104,  65, 153,  45,  15, 176,  84, 187,  22

);


-- ==========================================================================
-- ============================= INVERSE SBOX ===============================
--  Note: Inverse S-Box is specified in reverse order for ease of indexing
-- ==========================================================================

constant InvSBOX : SBOX_TYPE := (

 82,   9, 106, 213,  48,  54, 165,  56, 191,  64, 163, 158, 129, 243, 215, 251, 
124, 227,  57, 130, 155,  47, 255, 135,  52, 142,  67,  68, 196, 222, 233, 203, 
 84, 123, 148,  50, 166, 194,  35,  61, 238,  76, 149,  11,  66, 250, 195,  78, 
  8,  46, 161, 102,  40, 217,  36, 178, 118,  91, 162,  73, 109, 139, 209,  37, 
114, 248, 246, 100, 134, 104, 152,  22, 212, 164,  92, 204,  93, 101, 182, 146, 
108, 112,  72,  80, 253, 237, 185, 218,  94,  21,  70,  87, 167, 141, 157, 132, 
144, 216, 171,   0, 140, 188, 211,  10, 247, 228,  88,   5, 184, 179,  69,   6, 
208,  44,  30, 143, 202,  63,  15,   2, 193, 175, 189,   3,   1,  19, 138, 107, 
 58, 145,  17,  65,  79, 103, 220, 234, 151, 242, 207, 206, 240, 180, 230, 115, 
150, 172, 116,  34, 231, 173,  53, 133, 226, 249,  55, 232,  28, 117, 223, 110, 
 71, 241,  26, 113,  29,  41, 197, 137, 111, 183,  98,  14, 170,  24, 190,  27, 
252,  86,  62,  75, 198, 210, 121,  32, 154, 219, 192, 254, 120, 205,  90, 244, 
 31, 221, 168,  51, 136,   7, 199,  49, 177,  18,  16,  89,  39, 128, 236,  95, 
 96,  81, 127, 169,  25, 181,  74,  13,  45, 229, 122, 159, 147, 201, 156, 239, 
160, 224,  59,  77, 174,  42, 245, 176, 200, 235, 187,  60, 131,  83, 153,  97, 
 23,  43,   4, 126, 186, 119, 214,  38, 225, 105,  20,  99,  85,  33,  12, 125

);


-- ==========================================================================
-- Modulo 3 lookup table
-- ==========================================================================

constant mod3_table : MOD3_TABLE_TYPE := ( 
   0, 1, 2,
   0, 1, 2,
   0, 1, 2,
   0, 1, 2,
   0, 1, 2,
   0, 1, 2,
   0, 1, 2,
   0, 1, 2,
   0, 1, 2,
   0, 1, 2,
   0, 1, 2,
   0, 1, 2,
   0, 1, 2,
   0, 1, 2,
   0, 1, 2,
   0, 1, 2,
   0, 1, 2,
   0, 1, 2,
   0, 1, 2,
   0, 1, 2 );

-- ==========================================================================
-- Modulo 6 lookup table
-- ==========================================================================

constant mod6_table : MOD6_TABLE_TYPE := ( 
   0, 1, 2, 3, 4, 5,
   0, 1, 2, 3, 4, 5,
   0, 1, 2, 3, 4, 5,
   0, 1, 2, 3, 4, 5,
   0, 1, 2, 3, 4, 5,
   0, 1, 2, 3, 4, 5,
   0, 1, 2, 3, 4, 5,
   0, 1, 2, 3, 4, 5,
   0, 1, 2, 3, 4, 5,
   0, 1, 2, 3, 4, 5 );

-- ==========================================================================
-- Divide by 6 lookup table
-- ==========================================================================

constant div6_table : DIV6_TABLE_TYPE := ( 
   0,  0,  0,  0,  0,  0,
   1,  1,  1,  1,  1,  1, 
   2,  2,  2,  2,  2,  2,
   3,  3,  3,  3,  3,  3,
   4,  4,  4,  4,  4,  4,
   5,  5,  5,  5,  5,  5,
   6,  6,  6,  6,  6,  6, 
   7,  7,  7,  7,  7,  7, 
   8,  8,  8,  8,  8,  8, 
   9,  9,  9,  9,  9,  9 );

-- ==========================================================================
-- ============================= ROUND CONSTANTS ============================
-- ==========================================================================

constant Rcon : RCON_TYPE := (

X"01", X"02", X"04", X"08", X"10", X"20", X"40", X"80", X"1b", X"36",
X"6c", X"d8", X"ab", X"4d", X"9a", X"2f", X"5e", X"bc", X"63", X"c6",
X"97", X"35", X"6a", X"d4", X"b3", X"7d", X"fa", X"ef", X"c5", X"91"

);

-- ==========================================================================
-- ============================= SHIFT CONSTANTS ============================
-- ==========================================================================

constant SHIFTS : SHIFT_TYPE := (
   (0, 0),
   (1, 3),
   (2, 2),
   (3, 1)
);

-- ==========================================================================

function SBOX_LOOKUP ( a : SLV_8 )
                       return SLV_8;

function SBOX32_FUNCT ( w : SLV_32 )
                        return SLV_32;

function INV_SBOX_LOOKUP ( a : SLV_8 )
                           return SLV_8;

function BYTE_SUB_FUNCT ( state : STATE_TYPE )
                          return STATE_TYPE;

function INV_BYTE_SUB_FUNCT ( state : STATE_TYPE )
                              return STATE_TYPE;

function SHIFT_ROW_FUNCT ( state : STATE_TYPE )
                           return STATE_TYPE;

function INV_SHIFT_ROW_FUNCT ( state : STATE_TYPE )
                               return STATE_TYPE;

function MIX_COLUMN_FUNCT ( state : STATE_TYPE )
                            return STATE_TYPE;

function INV_MIX_COLUMN_FUNCT ( state : STATE_TYPE )
                                return STATE_TYPE;

function POLY_MULTE_FUNCT ( a : SLV_8;
                           b : SLV_8 )
                           return SLV_8;
function POLY_MULTD_FUNCT ( a : SLV_8;
                           b : SLV_8 )
                           return SLV_8;

function ADD_ROUNDKEY_FUNCT ( roundkey : KEY_TYPE;
                              state    : STATE_TYPE )
                              return STATE_TYPE;


procedure ADD_ROUNDKEY ( state     : in STATE_TYPE;
                         roundkey  : in KEY_TYPE;
                  signal state_out : out STATE_TYPE );


procedure PRE_ADD ( state     : in STATE_TYPE;
                    encrypt   : in std_logic;
                    roundkey  : in KEY_TYPE;
             signal state_out : out STATE_TYPE );


procedure POST_ADD ( state     : in STATE_TYPE;
                     encrypt   : in std_logic;
                     roundkey  : in KEY_TYPE;
              signal state_out : out STATE_TYPE );


function RIJNDAEL_ROUND_FUNCT ( encrypt  : std_logic;
                                roundkey : KEY_TYPE;
                                state    : STATE_TYPE )
                                return STATE_TYPE;


procedure RIJNDAEL_ROUND ( state     :  in STATE_TYPE;
                           encrypt   :  in std_logic;
                           roundkey  :  in KEY_TYPE;
                    signal state_out :  out STATE_TYPE );


function INITIAL_ROUND_FUNCT ( encrypt  : std_logic;
                               roundkey : KEY_TYPE;
                               state    : STATE_TYPE )
                               return STATE_TYPE;


procedure INITIAL_ROUND ( state     : in STATE_TYPE;
                          encrypt   : in std_logic;
                          roundkey  : in KEY_TYPE;
                   signal state_out : out STATE_TYPE ); 



function FINAL_ROUND_FUNCT ( encrypt  : std_logic;
                             roundkey : KEY_TYPE;
                             state    : STATE_TYPE )
                             return STATE_TYPE;


procedure FINAL_ROUND ( state     : in STATE_TYPE;
                        encrypt   : in std_logic;
                        roundkey  : in KEY_TYPE;
                 signal state_out : out STATE_TYPE ); 



-- ==========================================================================
-- ============== Declarations for the Key Schedule section =================
-- ==========================================================================

constant HOLD               : integer := 0;
constant LAST_ECVRUNUP_STEP : integer := 1;   -- # of steps for cv runup
constant LAST_DCVRUNUP_128  : integer := 9;   -- # of steps for cv runup
constant LAST_DCVRUNUP_192  : integer := 11;  -- # of steps for cv runup
constant LAST_DCVRUNUP_256  : integer := 13;  -- # of steps for cv runup

type PIPE_KEY_TYPE is array (FIRST_ROUND to LAST_ROUND+2) of KEY_TYPE;
type W_TYPE        is array (-8 to -1) of SLV_32;
type W_HALF_TYPE   is array (-4 to -1) of SLV_32;
type W_FAR_TYPE    is array ( 0 to  9) of SLV_32;
type W_NEAR_TYPE   is array ( 0 to  9) of SLV_32;
type W_BOX_TYPE    is array ( 0 to 11) of SLV_32;
type W_NOBOX_TYPE  is array ( 0 to 13) of W_HALF_TYPE;
type W_INPUT_TYPE  is array ( 0 to 18) of W_TYPE;
type W_PIPE_TYPE   is array ( 0 to 18) of W_TYPE;
type W_ARRAY_TYPE  is array ( 0 to 59) of SLV_32;

-- ==========================================================================

function EXPANSION_FUNCT ( cv_in   : SLV_256;
                            cv_size : SLV_2;
                            round   : SLV_6;
                            w_in    : W_TYPE )
                                 return W_TYPE;

function KS_SBOX_FUNCT ( cv_size : SLV_2;
                         encrypt : std_logic;
                         i       : SLV_16;
                         w_far   : SLV_32;
                         w_near  : SLV_32 )
                         return SLV_32;


procedure KS_SBOX( encrypt : std_logic;
                   cv_size : SLV_2;
                   i       : in  SLV_16;
                   w_far   : in  SLV_32;
                   w_near  : in  SLV_32;
            signal w_box   : out SLV_32 );


function KS_ROUND_FUNCT ( cv_size : SLV_2;
                          encrypt : std_logic;
                          i       : SLV_16;
                          w       : W_TYPE )
                          return W_TYPE;


end rijndael_pack;

-- ==========================================================================

package body rijndael_pack is

-- ==========================================================================
-- ============= Definitions for the Encrypt/Decrypt section ================
-- ==========================================================================

-- ==========================================================================
--
--  function SBOX_LOOKUP
--
--  Performs the sbox function implemented as a lookup table. There
--  are 4 copies of the 8-bit sbox to cover 32 bits of input/output.
--
-- ==========================================================================

function SBOX_LOOKUP ( a : SLV_8 )
                       return SLV_8 is

-- pragma map_to_operator SBOX_LOOKUP_dw_op
-- pragma return_port_name SBOX_LOOKUP_out


begin

   return std_logic_vector(TO_UNSIGNED
                          (SBOX(TO_INTEGER(unsigned(a(7 downto 0)))), 8));

end SBOX_LOOKUP;

-- ==========================================================================
--
--  function SBOX32_FUNCT
--
--  Performs the sbox function implemented as a lookup table. There
--  are 4 copies of the 8-bit sbox to cover 32 bits of input/output.
--
-- ==========================================================================

function SBOX32_FUNCT ( w : SLV_32 )
                        return SLV_32 is

-- pragma map_to_operator SBOX32_FUNCT_dw_op
-- pragma return_port_name SBOX32_FUNCT_out


begin

   return std_logic_vector(
               TO_UNSIGNED(SBOX(TO_INTEGER(unsigned(w(31 downto 24)))), 8) &
               TO_UNSIGNED(SBOX(TO_INTEGER(unsigned(w(23 downto 16)))), 8) &
               TO_UNSIGNED(SBOX(TO_INTEGER(unsigned(w(15 downto  8)))), 8) &
               TO_UNSIGNED(SBOX(TO_INTEGER(unsigned(w( 7 downto  0)))), 8)
   );

end SBOX32_FUNCT;

-- ==========================================================================
--
--  function INV_SBOX_LOOKUP
--
--  Performs the inverse sbox function implemented as a lookup table.
--  There are 4 copies of the 8-bit sbox to cover 32 bits of input/output.
--
-- ==========================================================================

function INV_SBOX_LOOKUP ( a : SLV_8 )
                           return SLV_8 is

-- pragma map_to_operator INV_SBOX_LOOKUP_dw_op
-- pragma return_port_name INV_SBOX_LOOKUP_out


begin

   return std_logic_vector(TO_UNSIGNED
                          (InvSBOX(TO_INTEGER(unsigned(a(7 downto 0)))), 8));

end INV_SBOX_LOOKUP;


-- ==========================================================================
--
--  function BYTE_SUB_FUNCT
--
--  Performs the byte sub function implemented as combinational logic 
--  as described in the RIJNDAEL algorithm specification.
--
-- ==========================================================================

function BYTE_SUB_FUNCT ( state : STATE_TYPE )
                          return STATE_TYPE is

-- pragma map_to_operator BYTE_SUB_FUNCT_dw_op
-- pragma return_port_name BYTE_SUB_FUNCT_out


variable row    : integer range 0 to 3;
variable column : integer range 0 to 3;
variable b      : STATE_TYPE;

begin

   for row in 0 to 3 loop
      for column in 0 to 3 loop
         b(row)(column) := SBOX_LOOKUP( state(row)(column) );
      end loop;
   end loop;

   return b;

end BYTE_SUB_FUNCT;


-- ==========================================================================
--
--  function INV_BYTE_SUB_FUNCT
--
--  Performs the inverse byte sub function implemented as combinational 
--  logic as described in the RIJNDAEL algorithm specification.
--
-- ==========================================================================

function INV_BYTE_SUB_FUNCT ( state : STATE_TYPE )
                              return STATE_TYPE is

-- pragma map_to_operator INV_BYTE_SUB_FUNCT_dw_op
-- pragma return_port_name INV_BYTE_SUB_FUNCT_out

variable row    : integer range 0 to 3;
variable column : integer range 0 to 3;
variable b      : STATE_TYPE;

begin

   for row in 0 to 3 loop
      for column in 0 to 3 loop
         b(row)(column) := INV_SBOX_LOOKUP( state(row)(column) );
      end loop;
   end loop;

   return b;

end INV_BYTE_SUB_FUNCT;


-- ==========================================================================
--
--  function SHIFT_ROW_FUNCT
--
--  Performs the row shift function implemented as combinational logic 
--  as described in the RIJNDAEL algorithm specification.
--
-- ==========================================================================

function SHIFT_ROW_FUNCT ( state : STATE_TYPE ) 
                           return STATE_TYPE is

-- pragma map_to_operator SHIFT_ROW_FUNCT_dw_op
-- pragma return_port_name SHIFT_ROW_FUNCT_out

variable a      : STATE_TYPE;
variable row    : integer range 0 to 3;
variable column : integer range 0 to 3;
variable temp   : TEMP_TYPE;

begin

   a := state;        -- This variable added to stay consistent with C Code

   for row in 1 to 3 loop

      for column in 0 to 3 loop
         temp(column) := a(row) ((column + shifts(row)(0)) mod 4);
      end loop;

      for column in 0 to 3 loop
         a(row) (column) := temp(column);
      end loop;

   end loop;

   return a;

end SHIFT_ROW_FUNCT;


-- ==========================================================================
--
--  function INV_SHIFT_ROW_FUNCT
--
--  Performs the inverse row shift function implemented as combinational 
--  logic as described in the RIJNDAEL algorithm specification.
--
-- ==========================================================================

function INV_SHIFT_ROW_FUNCT ( state : STATE_TYPE )
                               return STATE_TYPE is

-- pragma map_to_operator INV_SHIFT_ROW_FUNCT_dw_op
-- pragma return_port_name INV_SHIFT_ROW_FUNCT_out

variable a      : STATE_TYPE;
variable row    : integer range 0 to 3;
variable column : integer range 0 to 3;
variable temp   : TEMP_TYPE;

begin

   a := state;        -- This variable added to stay consistent with C Code

   for row in 1 to 3 loop

      for column in 0 to 3 loop
         temp(column) := a(row) ((column + shifts(row)(1)) mod 4);
      end loop;

      for column in 0 to 3 loop
         a(row) (column) := temp(column);
      end loop;

   end loop;

   return a;

end INV_SHIFT_ROW_FUNCT;


-- ==========================================================================
--
--  function MIX_COLUMN_FUNCT
--
--  Performs the column mixing function implemented as combinational logic 
--  as described in the RIJNDAEL algorithm specification.
--
-- ==========================================================================

function MIX_COLUMN_FUNCT ( state : STATE_TYPE )
                            return STATE_TYPE is

-- pragma map_to_operator MIX_COLUMN_FUNCT_dw_op
-- pragma return_port_name MIX_COLUMN_FUNCT_out

variable row    : integer range 0 to 3;
variable column : integer range 0 to 3;
variable b      : STATE_TYPE;

begin

   for row in 0 to 3 loop
      for column in 0 to 3 loop

         b(row)(column) :=
            POLY_MULTE_FUNCT ( "00000010", state(row)(column) ) xor
            POLY_MULTE_FUNCT ( "00000011", state((row + 1) mod 4)(column) ) xor
            state ((row + 2) mod 4)(column) xor
            state ((row + 3) mod 4)(column);

      end loop;  -- column
   end loop; -- row

   return b;

end MIX_COLUMN_FUNCT;


-- ==========================================================================
--
--  function INV_MIX_COLUMN_FUNCT
--
--  Performs the inverse column mixing function implemented as combinational
--  logic as described in the RIJNDAEL algorithm specification.
--
-- ==========================================================================

function INV_MIX_COLUMN_FUNCT ( state : STATE_TYPE )
                                return STATE_TYPE is

-- pragma map_to_operator INV_MIX_COLUMN_FUNCT_dw_op
-- pragma return_port_name INV_MIX_COLUMN_FUNCT_out

variable row    : integer range 0 to 3;
variable column : integer range 0 to 3;
variable b      : STATE_TYPE;

begin

   for row in 0 to 3 loop
      for column in 0 to 3 loop

         b(row)(column) :=
            POLY_MULTD_FUNCT ( "00001110", state(row)(column) ) xor
            POLY_MULTD_FUNCT ( "00001011", state((row + 1) mod 4)(column) ) xor
            POLY_MULTD_FUNCT ( "00001101", state((row + 2) mod 4)(column) ) xor
            POLY_MULTD_FUNCT ( "00001001", state((row + 3) mod 4)(column) );

      end loop;  -- column
   end loop; -- row

   return b;

end INV_MIX_COLUMN_FUNCT;

-- ==========================================================================
--
--  function POLY_MULTE_FUNCT
--
--  Performs the polynomial multiply function implemented as combinational
--  logic as described in the RIJNDAEL algorithm specification.
--
-- ==========================================================================

function POLY_MULTE_FUNCT ( a : SLV_8;
                           b : SLV_8 )
                           return SLV_8 is

-- pragma map_to_operator POLY_MULTE_FUNCT_dw_op
-- pragma return_port_name POLY_MULTE_FUNCT_out


variable temp     : SLV_8;
variable temp1    : SLV_8;
variable temp2    : SLV_8;
variable temp3    : SLV_8;
variable and_mask : SLV_8;


begin

   and_mask := b(7) & b(7) & b(7) & b(7) & b(7) & b(7) & b(7) & b(7);

   case a(3 downto 0) is

      when "0001" => 
         temp := b;

      when "0010" =>
         temp := (b(6 downto 0) & '0') xor (("00011011") and and_mask);

      when "0011"=>
         temp := (b(6 downto 0) & '0') xor (("00011011") and and_mask) xor b;

      when others =>
         temp := ( others => '0' );

   end case;

   return temp;
 
end POLY_MULTE_FUNCT;

-- ==========================================================================
--
--  function POLY_MULTD_FUNCT
--
--  Performs the polynomial multiply function implemented as combinational
--  logic as described in the RIJNDAEL algorithm specification.
--
-- ==========================================================================

function POLY_MULTD_FUNCT ( a : SLV_8;
                           b : SLV_8 )
                           return SLV_8 is

-- pragma map_to_operator POLY_MULTD_FUNCT_dw_op
-- pragma return_port_name POLY_MULTD_FUNCT_out


variable temp     : SLV_8;
variable temp1    : SLV_8;
variable temp2    : SLV_8;
variable temp3    : SLV_8;
variable and_mask : SLV_8;


begin

   and_mask := b(7) & b(7) & b(7) & b(7) & b(7) & b(7) & b(7) & b(7);

   case a(3 downto 0) is


      when "1001"=>

         temp1    := (b(6 downto 0) & '0') xor (("00011011") and and_mask);
         and_mask := temp1(7) & temp1(7) & temp1(7) & temp1(7) & 
                     temp1(7) & temp1(7) & temp1(7) & temp1(7);
         temp2    := (temp1(6 downto 0) & '0') xor (("00011011") and and_mask);
         and_mask := temp2(7) & temp2(7) & temp2(7) & temp2(7) & 
                     temp2(7) & temp2(7) & temp2(7) & temp2(7);
         temp3    := (temp2(6 downto 0) & '0') xor (("00011011") and and_mask);
         temp     := temp3 xor b;

      when "1011"=>

         temp1    := (b(6 downto 0) & '0') xor (("00011011") and and_mask);
         and_mask := temp1(7) & temp1(7) & temp1(7) & temp1(7) & 
                     temp1(7) & temp1(7) & temp1(7) & temp1(7);
         temp2    := (temp1(6 downto 0) & '0') xor (("00011011") and and_mask);
         and_mask := temp2(7) & temp2(7) & temp2(7) & temp2(7) & 
                     temp2(7) & temp2(7) & temp2(7) & temp2(7);
         temp3    := (temp2(6 downto 0) & '0') xor (("00011011") and and_mask);
         temp     := temp1 xor temp3 xor b;

      when "1101"=>

         temp1    := (b(6 downto 0) & '0') xor (("00011011") and and_mask);
         and_mask := temp1(7) & temp1(7) & temp1(7) & temp1(7) & 
                     temp1(7) & temp1(7) & temp1(7) & temp1(7);
         temp2    := (temp1(6 downto 0) & '0') xor (("00011011") and and_mask);
         and_mask := temp2(7) & temp2(7) & temp2(7) & temp2(7) & 
                     temp2(7) & temp2(7) & temp2(7) & temp2(7);
         temp3    := (temp2(6 downto 0) & '0') xor (("00011011") and and_mask);
         temp     := temp2 xor temp3 xor b;


      when "1110"=>

         temp1    := (b(6 downto 0) & '0') xor (("00011011") and and_mask);
         and_mask := temp1(7) & temp1(7) & temp1(7) & temp1(7) & 
                     temp1(7) & temp1(7) & temp1(7) & temp1(7);
         temp2    := (temp1(6 downto 0) & '0') xor (("00011011") and and_mask);
         and_mask := temp2(7) & temp2(7) & temp2(7) & temp2(7) & 
                     temp2(7) & temp2(7) & temp2(7) & temp2(7);
         temp3    := (temp2(6 downto 0) & '0') xor (("00011011") and and_mask);
         temp     := temp1 xor temp2 xor temp3;


      when others =>
         temp := ( others => '0' );

   end case;

   return temp;
 
end POLY_MULTD_FUNCT;


-- ==========================================================================
--
--  function ADD_ROUNDKEY_FUNCT
--
--  Performs the roundkey addition function implemented as combinational 
--  logic as described in the RIJNDAEL algorithm specification.
--
-- ==========================================================================

function ADD_ROUNDKEY_FUNCT ( roundkey : KEY_TYPE;
                              state    : STATE_TYPE)
                              return STATE_TYPE is

-- pragma map_to_operator ADD_ROUNDKEY_FUNCT_dw_op
-- pragma return_port_name ADD_ROUNDKEY_FUNCT_out


variable row    : integer range 0 to 3;
variable column : integer range 0 to 3;
variable b      : STATE_TYPE;

begin

   for row in 0 to 3 loop
      for column in 0 to 3 loop
         b(row)(column) := state(row)(column) xor roundkey(row)(column);
      end loop;
   end loop;

   return b;

end ADD_ROUNDKEY_FUNCT;

-- ==========================================================================


-- ==========================================================================
--
--  procedure ADD_ROUNDKEY
--
--  Wrapper for ROUND_KEY function
--
-- ==========================================================================

procedure ADD_ROUNDKEY ( state     :  in STATE_TYPE;
                         roundkey  :  in KEY_TYPE;
                  signal state_out :  out STATE_TYPE ) is



begin

   state_out <= ADD_ROUNDKEY_FUNCT ( roundkey, state );

end ADD_ROUNDKEY;




-- ==========================================================================
--
--  procedure PRE_ADD
--
--  Wrapper for PRE_ADD function
--
-- ==========================================================================

procedure PRE_ADD ( state     : in STATE_TYPE;
                    encrypt   : in std_logic;
                    roundkey  : in KEY_TYPE;
             signal state_out : out STATE_TYPE ) is



begin

   if encrypt = '1' then
      state_out <= ADD_ROUNDKEY_FUNCT ( roundkey, state );
   else
      state_out <= state;
   end if;

end PRE_ADD;



-- ==========================================================================
--
--  procedure POST_ADD
--
--  Wrapper for POST_ADD function
--
-- ==========================================================================

procedure POST_ADD ( state     : in STATE_TYPE;
                     encrypt   : in std_logic;
                     roundkey  : in KEY_TYPE;
              signal state_out : out STATE_TYPE ) is



begin

   if encrypt = '0' then
      state_out <= ADD_ROUNDKEY_FUNCT ( roundkey, state );
   else
      state_out <= state;
   end if;

end POST_ADD;



-- ==========================================================================
--
--  function RIJNDAEL_ROUND_FUNCT
--
--  Performs one round of the RIJNDAEL block cipher. Encryption or decryption
--  is performed based on the 'encrypt' signal.
--
-- ==========================================================================

function RIJNDAEL_ROUND_FUNCT ( encrypt  : std_logic;
                                roundkey : KEY_TYPE;
                                state    : STATE_TYPE )
                                return STATE_TYPE is

-- pragma map_to_operator RIJNDAEL_ROUND_FUNCT_dw_op
-- pragma return_port_name RIJNDAEL_ROUND_FUNCT_out


variable temp_state : STATE_TYPE;

begin

-- ===========================================================================
-- ============================== Encryption =================================
-- ===========================================================================

   if encrypt = '1' then

      temp_state := BYTE_SUB_FUNCT ( state );
      temp_state := SHIFT_ROW_FUNCT ( temp_state );
      temp_state := MIX_COLUMN_FUNCT ( temp_state );
      temp_state := ADD_ROUNDKEY_FUNCT (  roundkey, temp_state );


-- ===========================================================================
-- ============================== Decryption =================================
-- ===========================================================================

   else

      temp_state := ADD_ROUNDKEY_FUNCT ( roundkey, state );
      temp_state := INV_MIX_COLUMN_FUNCT ( temp_state );
      temp_state := INV_BYTE_SUB_FUNCT ( temp_state );
      temp_state := INV_SHIFT_ROW_FUNCT ( temp_state );

   end if; -- encrypt = '1'

   return temp_state;

end RIJNDAEL_ROUND_FUNCT;


-- ==========================================================================
--
--  procedure RIJNDAEL_ROUND
--
--  Performs one round of the RIJNDAEL block cipher. Encryption or decryption
--  is performed based on the 'encrypt' signal.
--
-- ==========================================================================

procedure RIJNDAEL_ROUND ( state     : in STATE_TYPE;
                           encrypt   : in std_logic;
                           roundkey  : in KEY_TYPE;
                    signal state_out : out STATE_TYPE ) is



begin

   state_out <= RIJNDAEL_ROUND_FUNCT (encrypt, roundkey, state );

end RIJNDAEL_ROUND;



-- ==========================================================================
--
--  function INITIAL_ROUND_FUNCT
--
--  Performs the initial round of the RIJNDAEL block cipher. Encryption or
--  decryption is performed based on the 'encrypt' signal.
--
-- ==========================================================================

function INITIAL_ROUND_FUNCT ( encrypt  : std_logic;
                               roundkey : KEY_TYPE;
                               state    : STATE_TYPE )
                               return STATE_TYPE is

-- pragma map_to_operator INITIAL_ROUND_FUNCT_dw_op
-- pragma return_port_name INITIAL_ROUND_FUNCT_out


variable temp_state : STATE_TYPE;

begin

-- ===========================================================================
-- ============================== Encryption =================================
-- ===========================================================================

   if encrypt = '1' then

      temp_state := BYTE_SUB_FUNCT ( state );
      temp_state := SHIFT_ROW_FUNCT ( temp_state );
      temp_state := MIX_COLUMN_FUNCT ( temp_state );
      temp_state := ADD_ROUNDKEY_FUNCT ( roundkey, temp_state );

-- ===========================================================================
-- ============================== Decryption =================================
-- ===========================================================================

   else

      temp_state := ADD_ROUNDKEY_FUNCT ( roundkey, state );
      temp_state := INV_BYTE_SUB_FUNCT ( temp_state );
      temp_state := INV_SHIFT_ROW_FUNCT ( temp_state );

   end if; -- encrypt = '1'

   return temp_state;

end INITIAL_ROUND_FUNCT;


-- ==========================================================================
--
--  procedure INITIAL_ROUND
--
--  Wrapper for the INITIAL_ROUND function.
--
-- ==========================================================================

procedure INITIAL_ROUND ( state     : in STATE_TYPE;
                          encrypt   : in std_logic;
                          roundkey  : in KEY_TYPE;
                   signal state_out : out STATE_TYPE ) is



begin

   state_out <= INITIAL_ROUND_FUNCT ( encrypt, roundkey, state );

end INITIAL_ROUND;


-- ==========================================================================
--
--  function FINAL_ROUND_FUNCT
--
--  Performs the final round of the RIJNDAEL block cipher. Encryption or
--  decryption is performed based on the 'encrypt' signal.
--
-- ==========================================================================

function FINAL_ROUND_FUNCT ( encrypt  : std_logic;
                             roundkey : KEY_TYPE;
                             state    : STATE_TYPE )
                             return STATE_TYPE is

-- pragma map_to_operator FINAL_ROUND_FUNCT_dw_op
-- pragma return_port_name FINAL_ROUND_FUNCT_out


variable temp_state : STATE_TYPE;

begin

-- ===========================================================================
-- ============================== Encryption =================================
-- ===========================================================================

   if encrypt = '1' then

      temp_state := BYTE_SUB_FUNCT ( state );
      temp_state := SHIFT_ROW_FUNCT ( temp_state );
      temp_state := ADD_ROUNDKEY_FUNCT ( roundkey, temp_state );


-- ===========================================================================
-- ============================== Decryption =================================
-- ===========================================================================

   else

      temp_state := ADD_ROUNDKEY_FUNCT ( roundkey, state );
      temp_state := INV_MIX_COLUMN_FUNCT ( temp_state );
      temp_state := INV_BYTE_SUB_FUNCT ( temp_state );
      temp_state := INV_SHIFT_ROW_FUNCT ( temp_state );

   end if; -- encrypt = '1'

   return temp_state;

end FINAL_ROUND_FUNCT;


-- ==========================================================================
--
--  procedure FINAL_ROUND
--
--  Wrapper for the FINAL_ROUND function.
--
-- ==========================================================================

procedure FINAL_ROUND ( state     : in STATE_TYPE;
                        encrypt   : in std_logic;
                        roundkey  : in KEY_TYPE;
                 signal state_out : out STATE_TYPE ) is



begin

   state_out <= FINAL_ROUND_FUNCT ( encrypt, roundkey, state );

end FINAL_ROUND;


-- ==========================================================================
-- =============== Definitions for the Key Schedule section =================
-- ==========================================================================


-- ==========================================================================
--
-- function EXPANSION_FUNCT
--
-- Performs the initial key expansion implemented as combinational 
-- logic as described in the RIJNDAEL algorithm specification.
--
-- ==========================================================================

function EXPANSION_FUNCT ( cv_in   : SLV_256;
                            cv_size : SLV_2;
                            round   : SLV_6;
                            w_in    : W_TYPE )
                                 return W_TYPE is

-- pragma map_to_operator EXPANSION_FUNCT_dw_op
-- pragma return_port_name EXPANSION_FUNCT_out

variable new_w    : W_TYPE;
variable w_output : W_TYPE;
variable bank : integer;

begin
   bank := TO_INTEGER(unsigned(round)); 
   case cv_size is

      when "00" =>

         new_w(-4) := KS_SBOX_FUNCT( cv_size,
                                         '1',
            std_logic_vector(TO_UNSIGNED(bank,16)),
                                         w_in(-4),
                                         w_in(-1) );
         new_w(-3) := new_w(-4) xor w_in(-3);
         new_w(-2) := new_w(-3) xor w_in(-2);
         new_w(-1) := new_w(-2) xor w_in(-1);

      when "01" =>
         if mod3_table(bank) = 0 then

            new_w(-4) := KS_SBOX_FUNCT( cv_size,
                                        '1',
            std_logic_vector(TO_UNSIGNED(SBOX_INDEX192(bank),16)),
                                         w_in(-6),
                                         w_in(-1) );
            new_w(-3) := new_w(-4) xor w_in(-5);
            new_w(-2) := new_w(-3) xor w_in(-4);
            new_w(-1) := new_w(-2) xor w_in(-3);

         elsif mod3_table(bank) = 1 then

            new_w(-4) := w_in(-1) xor w_in(-6);
            new_w(-3) := new_w(-4) xor w_in(-5);
            new_w(-2) := KS_SBOX_FUNCT( cv_size,
                                        '1',
            std_logic_vector(TO_UNSIGNED(SBOX_INDEX192(bank),16)),
                                         w_in(-4),
                                         new_w(-3) );

            new_w(-1) := new_w(-2) xor w_in(-3);

         else
            new_w(-4) := w_in(-1) xor w_in(-6);
            new_w(-3) := new_w(-4) xor w_in(-5);
            new_w(-2) := new_w(-3) xor w_in(-4);
            new_w(-1) := new_w(-2) xor w_in(-3);

         end if; -- i mod 6 = 0

      when others =>

         if bank mod 2 = 0 then

            new_w(-4) := KS_SBOX_FUNCT( cv_size,
                                        '1',
                    std_logic_vector(TO_UNSIGNED( bank/2,16)),
                                        w_in(-8),
                                        w_in(-1) );

         else

            new_w(-4) := SBOX32_FUNCT( w_in(-1)) xor
                                       w_in(-8);

         end if; -- i mod 2 = 0
         new_w(-3) := new_w(-4) xor w_in(-7);
         new_w(-2) := new_w(-3) xor w_in(-6);
         new_w(-1) := new_w(-2) xor w_in(-5);

   end case;
   for i in -8 to -5 loop
      new_w(i) := w_in(i+4);
   end loop;
   return new_w;

end EXPANSION_FUNCT;

-- ==========================================================================
--
-- function KS_SBOX_FUNCT
--
-- This function performs the sbox key expansion component of the
-- key schedule.
--
-- ==========================================================================

function KS_SBOX_FUNCT ( cv_size : SLV_2;
                         encrypt : std_logic;
                         i       : SLV_16;
                         w_far   : SLV_32;
                         w_near  : SLV_32 )
                         return SLV_32 is

-- pragma map_to_operator KS_SBOX_FUNCT_dw_op
-- pragma return_port_name KS_SBOX_FUNCT_out


variable temp      : SLV_32;
variable byte1     : SLV_8;
variable byte2     : SLV_8;
variable byte3     : SLV_8;
variable byte4     : SLV_8;
variable RconValue : integer;

begin

   byte1 := SBOX_LOOKUP(w_near(31 downto 24));
   byte2 := SBOX_LOOKUP(w_near(23 downto 16));
   byte3 := SBOX_LOOKUP(w_near(15 downto  8));
   byte4 := SBOX_LOOKUP(w_near( 7 downto  0));

   temp := byte2 & byte3 & byte4 & byte1;  -- ROTL by a byte

   case cv_size is

      when "00" =>

         if encrypt = '1' then
            RconValue := TO_INTEGER(unsigned(i));
         elsif TO_INTEGER(unsigned(i)) > 9 then
            RconValue := 0;        -- handle unused conditions
         else
            RconValue := 9-TO_INTEGER(unsigned(i));
         end if;

      when "01" =>

         if encrypt = '1' then
            RconValue := TO_INTEGER(unsigned(i));
         elsif TO_INTEGER(unsigned(i)) > 7 then
            RconValue := 0;        -- handle unused conditions
         else
            RconValue := 7-TO_INTEGER(unsigned(i));
         end if;

      when others => 

         if encrypt = '1' then
            RconValue := TO_INTEGER(unsigned(i));
         elsif TO_INTEGER(unsigned(i)) > 6 then
            RconValue := 0;        -- handle unused conditions
         else
            RconValue := 6-TO_INTEGER(unsigned(i));
         end if;

   end case;

   temp := temp xor w_far xor Rcon(RconValue) & X"000000";

   return temp;

end KS_SBOX_FUNCT;


-- ====================================================================

-- Procedure KS_SBOX
-- 
-- Wrapper for KS_SBOX_FUNCT

-- ====================================================================

procedure KS_SBOX( encrypt : std_logic;
                   cv_size : SLV_2;
                   i       : in  SLV_16;
                   w_far   : in  SLV_32;
                   w_near  : in  SLV_32;
            signal w_box   : out SLV_32 ) is

begin

   w_box <= KS_SBOX_FUNCT( cv_size, encrypt, i, w_far, w_near );

end KS_SBOX;



-- ==========================================================================
--
-- function KS_ROUND_FUNCT
--
-- This function performs the key expansion component of the
-- key schedule by calling the s-box routines and implementing the linear
-- addition for the W registers.
--
-- ==========================================================================

function KS_ROUND_FUNCT ( cv_size : SLV_2;
                          encrypt : std_logic;
                          i       : SLV_16;
                          w       : W_TYPE )
                          return W_TYPE is

-- pragma map_to_operator KS_ROUND_FUNCT_dw_op
-- pragma return_port_name KS_ROUND_FUNCT_out


variable index       : integer;
variable w_temp      : W_TYPE;
variable sbox_round  : SLV_16;
variable sbox_in1    : SLV_32;
variable sbox_in2    : SLV_32;
variable sbox_result : SLV_32;


begin
  for index in -8 to -1 loop
     w_temp(index) := w(index);
  end loop;
  if encrypt = '1' then
     case cv_size is
        when CV128 =>
           sbox_round := i;
           sbox_in1   := w(-4);
           sbox_in2   := w(-1);
        when CV192 =>
           sbox_round := std_logic_vector(
                            TO_UNSIGNED(SBOX_INDEX192(
                            TO_INTEGER(unsigned(i))),16));

           if mod3_table(TO_INTEGER(unsigned(i))) = 0 then
              sbox_in1   := w(-6);
              sbox_in2   := w(-1);
           else
              sbox_in1   := w(-4);
              sbox_in2   := w(-1) xor w(-6) xor w(-5);
           end if;

        when others =>
            sbox_round := std_logic_vector(
                               TO_UNSIGNED(TO_INTEGER(unsigned(i))/2, 16));
            sbox_in1   := w(-8);
            sbox_in2   := w(-1);

     end case;

  else 
     case cv_size is
        when CV128 =>
           sbox_round := std_logic_vector(
                            TO_UNSIGNED(9-TO_INTEGER(unsigned(i)), 16));
           sbox_in1   := w_temp(-1);
           sbox_in2   := w_temp(-3) xor w_temp(-4);
        when CV192 =>
           sbox_round := std_logic_vector(TO_UNSIGNED(
                              7 - SBOX_INDEX(TO_INTEGER(unsigned(i))), 16));
           if mod3_table(TO_INTEGER(unsigned(i))) = 2 then

              sbox_in1   := w(-5);
              sbox_in2   := w(-4);
           else
              sbox_in1   := w(-3);
              sbox_in2   := w(-2);
           end if;
        when others =>
            sbox_round := std_logic_vector(
                          TO_UNSIGNED(6-TO_INTEGER(unsigned(i))/2, 16));
            sbox_in1   := w(-5);
            sbox_in2   := w(-4);

     end case;
  end if;
 
  sbox_result := KS_SBOX_FUNCT( cv_size, '1', sbox_round, sbox_in1, sbox_in2 );


  for index in -8 to -1 loop
     w_temp(index) := w(index);
  end loop;

   if encrypt = '1' then

      case cv_size is

         when CV128 =>

            w_temp(-4) := sbox_result;
            w_temp(-3) := w_temp(-4) xor w_temp(-3);
            w_temp(-2) := w_temp(-3) xor w_temp(-2);
            w_temp(-1) := w_temp(-2) xor w_temp(-1);

         when CV192 =>

            for index in -8 to -5 loop
               w_temp(index) := w(index+4);    -- shift previous 4 keys to top
            end loop;

            if mod3_table(TO_INTEGER(unsigned(i))) = 0 then

               w_temp(-4) := sbox_result;
               w_temp(-3) := w_temp(-4) xor w(-5);
               w_temp(-2) := w(-4) xor w_temp(-3);
               w_temp(-1) := w(-3) xor w_temp(-2);

            elsif mod3_table(TO_INTEGER(unsigned(i))) = 1 then

               w_temp(-4) := w(-1) xor w(-6);
               w_temp(-3) := w_temp(-4) xor w(-5);
               w_temp(-2) := sbox_result;
               w_temp(-1) := w(-3) xor w_temp(-2);

            else

               w_temp(-4) := w(-1) xor w(-6);
               w_temp(-3) := w_temp(-4) xor w(-5);
               w_temp(-2) := w(-4) xor w_temp(-3);
               w_temp(-1) := w(-3) xor w_temp(-2);

            end if;

         when others =>

            for index in -8 to -5 loop
               w_temp(index) := w(index+4);    -- shift previous 4 keys to top
            end loop;

            if TO_INTEGER(unsigned(i)) mod 2 = 0 then

               w_temp(-4) := sbox_result;
               w_temp(-3) := w(-7) xor w_temp(-4);
               w_temp(-2) := w(-6) xor w_temp(-3);
               w_temp(-1) := w(-5) xor w_temp(-2);

            else

               w_temp(-4) := SBOX32_FUNCT(W(-1)) xor W(-8);
               w_temp(-3) := w(-7) xor w_temp(-4);
               w_temp(-2) := w(-6) xor w_temp(-3);
               w_temp(-1) := w(-5) xor w_temp(-2);

            end if;

      end case;

   else

     case cv_size is

         when CV128 =>

            w_temp(-4) := w_temp(-3) xor w_temp(-4);
            w_temp(-3) := w_temp(-2) xor w_temp(-3);
            w_temp(-2) := w_temp(-1) xor w_temp(-2);
            w_temp(-1) := sbox_result;

         when CV192 =>

            for index in -8 to -5 loop
               w_temp(index) := w(index+4);  -- shift previous 4 keys to top
            end loop;

            if mod3_table(TO_INTEGER(unsigned(i))) = 1 then

               w_temp(-4) := w(-6) xor w(-5);
               w_temp(-3) := w(-5) xor w(-4);
               w_temp(-2) := w(-4) xor w(-3);
               w_temp(-1) := w(-3) xor w(-2);

            elsif mod3_table(TO_INTEGER(unsigned(i))) = 2 then

               w_temp(-4) := w(-6) xor w(-5);
               w_temp(-3) := sbox_result;
               w_temp(-2) := w(-4) xor w(-3);
               w_temp(-1) := w(-3) xor w(-2);

            else

               w_temp(-4) := w(-6) xor w(-5);
               w_temp(-3) := w(-5) xor w(-4);
               w_temp(-2) := w(-4) xor w(-3);
               w_temp(-1) := sbox_result;

            end if;

         when others =>

            for index in -8 to -5 loop
               w_temp(index) := w(index+4);  -- shift previous 4 keys to top
            end loop;

            if TO_INTEGER(unsigned(i)) mod 2 = 0 then

               w_temp(-4) := w(-8) xor w(-7);
               w_temp(-3) := w(-7) xor w(-6);
               w_temp(-2) := w(-6) xor w(-5);
               w_temp(-1) := sbox_result;

            else

               w_temp(-4) := w(-8) xor w(-7);
               w_temp(-3) := w(-7) xor w(-6);
               w_temp(-2) := w(-6) xor w(-5);
               w_temp(-1) := w(-5) xor SBOX32_FUNCT(w(-4));

            end if;

      end case;

   end if; -- encrypt = '1'

   return w_temp;

end KS_ROUND_FUNCT;



-- ==========================================================================

end rijndael_pack;
