library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity clkdivide is
    Port (clkin: in std_logic;
			--Scan_Dav : in std_logic;
            clkout:out std_logic );
end clkdivide;

architecture Behavioral of clkdivide is
    signal int_clock:std_logic := '0';
    begin
        clkout<=int_clock;
    process(clkin)
        variable var:integer range 0 to 17 :=0;
        begin
            if (clkin'event and clkin = '1')then
                int_clock <= not int_clock; 
            end if;
    end process;
end Behavioral;