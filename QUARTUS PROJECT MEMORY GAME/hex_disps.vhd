library ieee;
use ieee.std_logic_1164.all;

entity hex_disps is
  port ( filxcol : in std_logic_vector (7 downto 0);
         HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7 : out std_logic_vector (6 downto 0));
end hex_disps;

architecture struct of hex_disps is

  component BCD7seg
    port ( num  : in std_logic_vector (3 downto 0);
           HEX  : out std_logic_vector (6 downto 0));
  end component;

begin

	display0: BCD7seg
		port map(filxcol(3 downto 0), HEX0); -- Most significant 4 bits of filxcol

	display1: BCD7seg
		port map("1111", HEX1); -- Least significant 4 bits of filxcol

	display2: BCD7seg
		port map(filxcol(7 downto 4),HEX2);
	display3: BCD7seg
		port map("1111",HEX3);
	display4: BCD7seg
		port map("1111",HEX4);
	display5: BCD7seg
		port map("1111",HEX5);
	display6: BCD7seg
		port map("1111",HEX6);
	display7: BCD7seg
		port map("1111",HEX7); 

end struct;