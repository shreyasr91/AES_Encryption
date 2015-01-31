--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   17:38:10 12/17/2014
-- Design Name:   
-- Module Name:   C:/Users/Shreyas/Desktop/vhdl_prj/vini_proj/display_unit_test.vhd
-- Project Name:  vini_proj
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: DISPLAY_UNIT
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
 
ENTITY display_unit_test IS
END display_unit_test;
 
ARCHITECTURE behavior OF display_unit_test IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT DISPLAY_UNIT
    PORT(
         TXD : OUT  std_logic;
         RXD : IN  std_logic;
         clk : IN  std_logic;
         RST : IN  std_logic;
         ENC_DEC_B : IN  std_logic;
         DONE : OUT  std_logic;
         led : OUT  std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal RXD : std_logic := '0';
   signal clk : std_logic := '0';
   signal RST : std_logic := '0';
   signal ENC_DEC_B : std_logic := '0';

 	--Outputs
   signal TXD : std_logic;
   signal DONE : std_logic;
   signal led : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: DISPLAY_UNIT PORT MAP (
          TXD => TXD,
          RXD => RXD,
          clk => clk,
          RST => RST,
          ENC_DEC_B => ENC_DEC_B,
          DONE => DONE,
          led => led
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for clk_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
