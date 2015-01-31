-------------------------------------------------------------------------------
-- Copyright (c) 2014 Xilinx, Inc.
-- All Rights Reserved
-------------------------------------------------------------------------------
--   ____  ____
--  /   /\/   /
-- /___/  \  /    Vendor     : Xilinx
-- \   \   \/     Version    : 14.1
--  \   \         Application: XILINX CORE Generator
--  /   /         Filename   : ICON.vhd
-- /___/   /\     Timestamp  : Wed Dec 17 17:48:23 Eastern Standard Time 2014
-- \   \  /  \
--  \___\/\___\
--
-- Design Name: VHDL Synthesis Wrapper
-------------------------------------------------------------------------------
-- This wrapper is used to integrate with Project Navigator and PlanAhead

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
ENTITY ICON IS
  port (
    CONTROL0: inout std_logic_vector(35 downto 0));
END ICON;

ARCHITECTURE ICON_a OF ICON IS
BEGIN

END ICON_a;
