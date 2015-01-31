library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity Circuit17 is
    Port ( TE: in STD_LOGIC;
			  G1 : in  STD_LOGIC;
           G2 : in  STD_LOGIC;
           G3 : in  STD_LOGIC;
           G6 : in  STD_LOGIC;
           G7 : in  STD_LOGIC;
           G22 : out  STD_LOGIC;
           G23 : out  STD_LOGIC);
end Circuit17;

architecture Behavioral of Circuit17 is
signal ring_delay1      : std_logic;
signal ring_delay2      : std_logic;
--signal ring_delay3      : std_logic;
--signal ring_delay4      : std_logic;
--signal ring_delay5      : std_logic;
--signal ring_delay6      : std_logic;
--signal ring_delay7      : std_logic;
--signal ring_delay8      : std_logic;

signal G10,G11,G16,G19,G1t,G3t,sel1,sel3,G19t: STD_LOGIC;

attribute KEEP : string;
attribute KEEP of ring_delay1 : signal is "true";
attribute KEEP of ring_delay2 : signal is "true";
--attribute KEEP of ring_delay3 : signal is "true";
--attribute KEEP of ring_delay4 : signal is "true";
--attribute KEEP of ring_delay5 : signal is "true";
--attribute KEEP of ring_delay6 : signal is "true";
--attribute KEEP of ring_delay7 : signal is "true";
--attribute KEEP of ring_delay8 : signal is "true";

attribute INIT : string;
attribute INIT of delay1_lut            : label is "3";
attribute INIT of delay2_lut            : label is "3";
--attribute INIT of delay3_lut            : label is "3";
--attribute INIT of delay4_lut            : label is "3";
--attribute INIT of delay5_lut            : label is "3";
--attribute INIT of delay6_lut            : label is "3";
--attribute INIT of delay7_lut            : label is "3";
--attribute INIT of delay8_lut            : label is "3";

begin

sel1<= TE;
sel3<= TE;

G10<= G1t nand G3;
G11<= G3t nand G6;
G16<= G11 nand G2;
G19<= G11 nand G7;
G22<= G16 nand G10;
G23<= G19 nand G16;
--G19t<= G19 and G10;
process(sel1)
Begin
Case sel1 is
when '0' => G1t<= G1;
when '1' => G1t<= ring_delay2;
When others=> G1t <= G1;
end case;
end process; 

process(sel3)
Begin
Case sel3 is
when '0' => G3t<= G3;
when '1' => G3t<= G10;
When others=> G3t <= G3;
end case;
end process; 
----------------------------------- EXTRA INV---
delay1_lut: LUT2
    generic map (INIT => X"3")
  port map( I0 => TE,
            I1 => G19,
             O => ring_delay1 );

delay2_lut: LUT2
    generic map (INIT => X"3")
  port map( I0 => TE,
            I1 => ring_delay1,
             O => ring_delay2 );

--delay3_lut: LUT2
--    generic map (INIT => X"3") port map( I0 => TE,I1 => ring_delay2,O => ring_delay3 );

--delay4_lut: LUT2
--    generic map (INIT => X"3") port map( I0 => TE,I1 => ring_delay3,O => ring_delay4 );

--delay5_lut: LUT2
--    generic map (INIT => X"3") port map( I0 => TE,I1 => ring_delay4,O => ring_delay5 );

--delay6_lut: LUT2
--    generic map (INIT => X"3") port map( I0 => TE,I1 => ring_delay5,O => ring_delay6 );

--delay7_lut: LUT2
--    generic map (INIT => X"3") port map( I0 => TE,I1 => ring_delay6,O => ring_delay7 );

--delay8_lut: LUT2
--    generic map (INIT => X"3") port map( I0 => TE,I1 => ring_delay7,O => ring_delay8 );

end Behavioral;

