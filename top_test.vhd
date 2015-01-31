--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:06:24 12/01/2014
-- Design Name:   
-- Module Name:   C:/Users/Shreyas/Desktop/vhdl_prj/project_aes/top_test.vhd
-- Project Name:  project_aes
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: RIJNDAEL_TOP_ITER
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY top_test IS
END top_test;
 
ARCHITECTURE behavior OF top_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT RIJNDAEL_TOP_ITER
    PORT(
         clock : IN  std_logic;
         reset : IN  std_logic;
         ENC_DEC_B : IN  std_logic;
         DATA_LOAD : IN  std_logic;
         CV_LOAD : IN  std_logic;
         CV_SIZE : IN  std_logic_vector(1 downto 0);
         DATA_OUT : OUT  std_logic_vector(127 downto 0);
         DONE : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clock : std_logic := '0';
   signal reset : std_logic := '0';
   signal ENC_DEC_B : std_logic := '0';
   signal DATA_LOAD : std_logic := '0';
   signal CV_LOAD : std_logic := '0';
   signal CV_SIZE : std_logic_vector(1 downto 0) := (others => '0');

 	--Outputs
   signal DATA_OUT : std_logic_vector(127 downto 0);
   signal DONE : std_logic;

   -- Clock period definitions
   constant clock_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: RIJNDAEL_TOP_ITER PORT MAP (
          clock => clock,
          reset => reset,
          ENC_DEC_B => ENC_DEC_B,
          DATA_LOAD => DATA_LOAD,
          CV_LOAD => CV_LOAD,
          CV_SIZE => CV_SIZE,
          DATA_OUT => DATA_OUT,
          DONE => DONE
        );

   -- Clock process definitions
   clock_process :process
   begin
		clock <= '0';
		wait for clock_period/2;
		clock <= '1';
		wait for clock_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
		reset <= '1';
      wait for 90 ns;	
		reset <= '0';
		ENC_DEC_B <= '1';
		CV_SIZE <= "10";
		
		CV_LOAD <= '1';
		wait for 20 ns;
--		DATA_LOAD <= '1';
--		
--		wait for 20 ns;



		CV_LOAD <= '0';
		
		wait for 320 ns;
		DATA_LOAD <='1';
		wait for 20 ns;
		DATA_LOAD <= '0';
		wait for 40 ns;
      wait for clock_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
