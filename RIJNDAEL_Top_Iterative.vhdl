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
-- ============================== UNCLASSIFIED ===============================
-- ===========================================================================
-- File Name : RIJNDAEL_Top_Iterative.vhdl
-- Author    : NSA
-- Date      : December 99
-- Project   : AES Candidate Evaluation
-- Purpose   : This model is the top level structural model for an
--             iterative implementation of RIJNDAEL, an Advanced Encryption
--             Standard Candidate. It consists of port mappings among the
--             lower level components.
-- Notes     :
-- ===========================================================================

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use WORK.rijndael_pack.all;

-- ===========================================================================
-- =========================== Interface Description =========================
-- ===========================================================================

entity RIJNDAEL_TOP_ITER is

  port (clock     : in std_logic;
        reset     : in std_logic;

        ENC_DEC_B : in std_logic;  -- '1' = encrypt, '0' = decrypt
        DATA_IN   : in SLV_128;    -- 128-bit input data word (plaintext)
        DATA_LOAD : in std_logic;  -- data valid; load new input data word
        CV_IN     : in SLV_256;    -- 128, 192, 256-bit cv (user supplied key)
        CV_LOAD   : in std_logic;  -- cv_in is valid; load new cryptovariable
        CV_SIZE   : in SLV_2;      -- '00'= 128, '01'= 192, '10'= 256

        DATA_OUT  : out SLV_128;   -- 128-bit output data word (ciphertext)
        DONE      : out std_logic  -- indicates 'data_out' is valid
--		Out_CTRL_ALG_START,Out_CTRL_KS_START : out std_logic;
--		Out_ALG_DONE : out std_logic;
--		Out_CTRL_DATA_LOAD,Out_CTRL_ENC_DEC_B,Out_KS_CVLOAD : out std_logic;Out_KS_CVSIZE : out SLV_2;
--		Out_KS_ROUND_KEY: out KEY_TYPE
  );

end RIJNDAEL_TOP_ITER;

architecture STRUCTURAL of RIJNDAEL_TOP_ITER is
--signal DATA_IN : SLV_128;
--signal CV_IN   : SLV_256;

-- ===========================================================================
-- =========================== Component Definition ==========================
-- ===========================================================================

component CONTROL_ITER is

  port (clock          :  in std_logic;
        reset          :  in std_logic;

        DATA_LOAD      :  in std_logic;   -- data start signal from interface
        CTRL_ENC       : in std_logic;    -- encrypt/decrypt signal

        CTRL_ALG_START :  out std_logic;  -- start encryption
        CTRL_KS_START  :  out std_logic   -- start key schedule
       
  );

end component;

component ALG_ITERATIVE

  port (clock       :  in STD_LOGIC;
        reset       :  in STD_LOGIC;

        ALG_DATAIN  :  in SLV_128;
        ALG_KEY     :  in KEY_TYPE;
        ALG_START   :  in STD_LOGIC;
        ALG_ENC     :  in STD_LOGIC;
        ALG_CVSIZE  :  in SLV_2;

        ALG_DATAOUT :  out SLV_128;
        ALG_DONE    :  out STD_LOGIC
  );

end component;

component INTERFACE is

  port (clock          :  in std_logic;
        reset          :  in std_logic;

        DATA_LOAD      :  in std_logic;     -- data load pulse
        DATAIN         :  in SLV_128;       -- 128 bit block
        CV_LOAD        :  in std_logic;     -- crypto variable load pulse
        CV_SIZE        :  in SLV_2;         -- '00'= 128, '01'= 192, '10'= 256
        CVIN           :  in SLV_256;
        ENC_DEC_B      :  in std_logic;     -- '1' = encrypt, '0' = decrypt

        CTRL_DATA_LOAD :  out std_logic;    -- data load signal to controller
        CTRL_ENC_DEC_B :  out std_logic;
        ALG_DATA       :  out SLV_128;      -- 128 bit data block to algorithm
        KS_CVLOAD      :  out std_logic;
        KS_CV          :  out SLV_256;
        KS_CVSIZE      :  out SLV_2
  );


end component;

component Key_Schedule_Iterative

  port (clock        :  in std_logic;    -- clock signal
        reset        :  in std_logic;    -- active high reset (asynch)

        KS_LOADCV    :  in std_logic;    -- load a new cryptovariable
        KS_START     :  in std_logic;    -- start a new expansion sequence
        KS_CV        :  in SLV_256;      -- cryptovariable input bus
        KS_CV_SIZE   :  in SLV_2;        -- cryptovariable input bus
        KS_ENC       :  in std_logic;    -- encrypt select (1=enc, 0=dec)

        KS_ROUND_KEY :  out KEY_TYPE      -- output round key

  );

end component;


-- ===========================================================================
-- =========================== Signal Definition =============================
-- ===========================================================================

signal top_datain     : SLV_128;        -- top level data interconnection
signal top_dataload   : std_logic;      -- start new data connection
signal top_loadcv     : std_logic;      -- start new cv
signal top_cv_size    : SLV_2;          -- cryptovariable size interconnect
signal top_cv         : SLV_256;        -- cryptovariable bus interconnect
signal top_enc_decb   : std_logic;      -- encrypt select interconnect
signal top_round_key1 : KEY_TYPE;       -- round key interconnects
signal top_alg_start  : std_logic;      -- algorithm start connection
signal top_done       : std_logic;      -- done signal connection
signal top_ks_start   : std_logic;      -- key expansion start signal
signal top_ks_ready   : std_logic;      -- key runup complete signal

begin 
--Out_CTRL_ALG_START<= top_alg_start;
--Out_CTRL_KS_START<= top_ks_start;
--Out_ALG_DONE<= top_done;
--Out_CTRL_DATA_LOAD<= top_dataload;
--Out_CTRL_ENC_DEC_B<=top_enc_decb;
--Out_KS_CVLOAD<=top_loadcv;
--Out_KS_CVSIZE <=top_cv_size;
--DATA_IN <= x"014730f80ac625fe84f026c60bfd547d";
--CV_IN <= x"0000000000000000000000000000000000000000000000000000000000000000";                                                                                                                                                                                                                     
CTRL : CONTROL_ITER port map (clock,           -- rising edge clock
                              reset,           -- active high reset
                              top_dataload,    -- process new data
                              top_enc_decb,    -- encrypt select
                              top_alg_start,   -- start alg processing
                              top_ks_start );  -- start key expansion

ALG : ALG_ITERATIVE port map (clock,           -- rising edge clock  
                              reset,           -- active high reset
                              top_datain,      -- input data
                              top_round_key1,  -- round key inputs
                              top_alg_start,   -- start processing 
                              top_enc_decb,    -- encrypt select
                              top_cv_size,     -- cv size select
                              DATA_OUT,        -- processed data output
                              top_done );      -- processing complete

KEYSCH : Key_Schedule_Iterative port map (clock,            -- rising edge
                                          reset,            -- active high
                                          top_loadcv,       -- load new cv
                                          top_ks_start,     -- start key expan
                                          top_cv,           -- cv input bus
                                          top_cv_size,      -- cv size select
                                          top_enc_decb,     -- encrypt select
                                          top_round_key1);  -- key output

INTER : INTERFACE port map (clock,             -- rising edge clock
                            reset,             -- active high reset
                            data_load,         -- ext. load new data
                            data_in,           -- ext. data input 
                            cv_load,           -- ext. load new cv
                            cv_size,           -- ext. cv size select
                            cv_in,             -- ext. cv input bus
                            enc_dec_b,         -- ext. encrypt select
                            top_dataload,      -- start new data
                            top_enc_decb,      -- encrypt select intercon.
                            top_datain,        -- data interconnect
                            top_loadcv,        -- load new cv intercon.
                            top_cv,            -- cv bus connection
                            top_cv_size );     -- cryptovariable select


-- ===========================================================================
-- =========================== Concurrent Assignments ========================
-- ===========================================================================

DONE <= top_done;          -- map done signal from controller to output

end STRUCTURAL;


-- ===========================================================================
-- =========================== Configuration =================================
-- ===========================================================================


configuration conf_RIJNDAEL_TOP_ITER of RIJNDAEL_TOP_ITER is

   for STRUCTURAL

      for CTRL: CONTROL_ITER use
         entity work.CONTROL_ITER(CONTROL_ITER_RTL);
      end for;

      for all: Key_Schedule_Iterative use
         entity work.Key_Schedule_Iterative(Key_Schedule_Iterative_RTL);
      end for;

      for all: ALG_ITERATIVE use
         entity work.ALG_ITERATIVE(ALG_ITERATIVE_RTL);
      end for;

      for INTER: INTERFACE USE
         entity work.INTERFACE(INTERFACE_RTL);
      end for;

   end for;

end conf_RIJNDAEL_TOP_ITER;
