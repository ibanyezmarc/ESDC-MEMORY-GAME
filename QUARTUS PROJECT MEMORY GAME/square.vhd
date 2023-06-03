-----------------------------------------------------------------------------------------
-- Block square : indicates to WRITE MEMORY where a new square must be plotted in the VGA screen
-- x_t: left top column coordinate. 8 MSB of the 10 bits needed.
-- y_t: left top row coordinate. 7 MSB of the 9 bitw needed.
-- color_t: RGB components of the square to plot. 3 bits
-- Start: order to start writing the memory.
-- Inputs: status of the board LEDS.
-- Author: Josep Altet. 
-- Version 1.0 : Date: 12-02-2019.
-- Version 2.0 : Date: 25-02-2020 (Adapted to Theory lecture).
-- Version 3.0 : Date: 08-09-2021 Adapted to Design 1.
-- Electronic System Design for Communications - ESDC - ETSTB. UPC. Barcelona.
----------------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.ALL;

entity square is
  port( clk_d1, nrst: in std_logic;
        Sync: in std_logic_vector(15 downto 0);
        Sync_value_card1: in std_logic_vector(2 downto 0);
        Sync_value_card2: in std_logic_vector(2 downto 0);
        x_t: out integer range 0 to 160;
        y_t: out integer range 0 to 120;
        color_t: out integer range 0 to 15;
        start: out std_logic;
        done: in std_logic;
        leds: out std_logic_vector(15 downto 0);
        sweep: out std_logic
        );

end square;

architecture functional of square is
  -- Coordinates of the squares that represent the different LEDs on the VGA
  type coord_array_type is array (0 to 15) of integer;
  constant X_coord_array: coord_array_type := (21, 53, 85, 117, 21, 53, 85, 117, 21, 53, 85, 117, 21, 53, 85, 117);
  constant Y_coord_array: coord_array_type := (3, 3, 3, 3, 33, 33, 33, 33, 63, 63, 63, 63, 93, 93, 93, 93);
  signal taulell_int : std_logic_vector(47 downto 0);
  signal LG0_INT: integer range 0 to 8;
  signal LG1_INT: integer range 0 to 8;
  signal LG2_INT: integer range 0 to 8;
  signal LG3_INT: integer range 0 to 8;
  signal LG4_INT: integer range 0 to 8;
  signal LG5_INT: integer range 0 to 8;
  signal LG6_INT: integer range 0 to 8;
  signal LG7_INT: integer range 0 to 8;
  signal LG8_INT: integer range 0 to 8;
  signal LG9_INT: integer range 0 to 8;
  signal LG10_INT: integer range 0 to 8;
  signal LG11_INT: integer range 0 to 8;
  signal LG12_INT: integer range 0 to 8;
  signal LG13_INT: integer range 0 to 8;
  signal LG14_INT: integer range 0 to 8;
  signal LG15_INT: integer range 0 to 8;

  -- Possible colors of the squares
  constant TURNED: integer := 8;
  constant BROWN: integer := 7;
  constant WHITE: integer := 6;
  constant BLACK: integer := 5;
  constant YELLOW: integer := 4;
  constant ORANGE: integer := 3;
  constant RED: integer := 2;
  constant GREEN: integer := 1;
  constant BLUE: integer := 0;

  -- Assign each LED bit from led_array
  signal LG0, LG1, LG2, LG3, LG4, LG5, LG6, LG7, LG8, LG9, LG10, LG11, LG12, LG13, LG14, LG15: std_logic;
	
  -- State definition
  type state_square is (s_aux, sLG0a, sLG0b, sLG0c, sLG1a, sLG1b, sLG1c, sLG2a, sLG2b, sLG2c, sLG3a, sLG3b, sLG3c, sLG4a, sLG4b, sLG4c, sLG5a, sLG5b, sLG5c, sLG6a, sLG6b, sLG6c, sLG7a, sLG7b, sLG7c, sLG8a, sLG8b, sLG8c, sLG9a, sLG9b, sLG9c, sLG10a, sLG10b, sLG10c, sLG11a, sLG11b, sLG11c, sLG12a, sLG12b, sLG12c, sLG13a, sLG13b, sLG13c, sLG14a, sLG14b, sLG14c, sLG15a, sLG15b, sLG15c);
  signal st_square: state_square;

  function count_ones(input : std_logic_vector) return integer is
    variable count : integer := 0;
	begin
		for i in input'range loop
		  if input(i) = '1' then
			count := count + 1;
		  end if;
		end loop;
		return count;
     end function count_ones;

begin
  -- Assign each LED bit from led_array
  (LG15, LG14, LG13, LG12, LG11, LG10, LG9, LG8, LG7, LG6, LG5, LG4, LG3, LG2, LG1, LG0) <= Sync;

  process(clk_d1, nrst)
  begin
    if (nrst = '0') then
      st_square <= sLG0a;
      
    elsif (clk_d1'event and clk_d1 = '1') then
      case st_square is
      
--		when s_init =>
--		  LG0_INT <= TURNED;
--		  LG1_INT <= TURNED;
--		  LG2_INT <= TURNED;
--		  LG3_INT <= TURNED;
--		  LG4_INT <= TURNED;
--		  LG5_INT <= TURNED;
--		  LG6_INT <= TURNED;
--		  LG7_INT <= TURNED;
--		  LG8_INT <= TURNED;
--		  LG9_INT <= TURNED;
--		  LG10_INT <= TURNED;
--		  LG11_INT <= TURNED;
--		  LG12_INT <= TURNED;
--		  LG13_INT <= TURNED;
--		  LG14_INT <= TURNED;
--		  LG15_INT <= TURNED;          
--		  st_square <= sLG0a;

        when sLG0a =>
          x_t <= X_coord_array(0);
          y_t <= Y_coord_array(0);
--          if LG0 = '0' and LG1 = '0' and LG2 = '0' and LG3 = '0' and LG4 = '0' and LG5 = '0' and LG6 = '0' and LG7 = '0'and LG8 = '0' and LG9 = '0' and LG10 = '0' and LG11 = '0' and LG12 = '0' and LG13 = '0' and LG14 = '0' and LG15 = '0' then 
--		  LG0_INT <= TURNED;
--		  LG1_INT <= TURNED;
--		  LG2_INT <= TURNED;
--		  LG3_INT <= TURNED;
--		  LG4_INT <= TURNED;
--		  LG5_INT <= TURNED;
--		  LG6_INT <= TURNED;
--		  LG7_INT <= TURNED;
--		  LG8_INT <= TURNED;
--		  LG9_INT <= TURNED;
--		  LG10_INT <= TURNED;
--		  LG11_INT <= TURNED;
--		  LG12_INT <= TURNED;
--		  LG13_INT <= TURNED;
--		  LG14_INT <= TURNED;
--		  LG15_INT <= TURNED;     
          if LG0 = '1' and LG0_INT /= TURNED then 
			LG0_INT <= LG0_INT;
          elsif LG0 = '1' and (count_ones(Sync) mod 2) = 1 then 
			LG0_INT <= to_integer(unsigned(Sync_value_card1));
          elsif LG0 = '1' and (count_ones(Sync) mod 2) = 0 then 
			LG0_INT <= to_integer(unsigned(Sync_value_card2));
          elsif LG0 = '0' then 
			LG0_INT <= TURNED;
		  end if;
		if LG0_INT = 0 then
			color_t <= 12;
		else
			color_t <= LG0_INT;
		end if;
          st_square <= sLG0b;
        when sLG0b =>
          st_square <= sLG0c;
        when sLG0c =>
          if done = '1' then
            st_square <= sLG1a;
          end if;
          
        when sLG1a =>
          x_t <= X_coord_array(1);
          y_t <= Y_coord_array(1);
          if LG1 = '1' and LG1_INT /= TURNED then 
			LG1_INT <= LG1_INT;
          elsif LG1 = '1' and (count_ones(Sync) mod 2) = 1 then 
			LG1_INT <= to_integer(unsigned(Sync_value_card1));
          elsif LG1 = '1' and (count_ones(Sync) mod 2) = 0 then 
			LG1_INT <= to_integer(unsigned(Sync_value_card2));
          elsif LG1 = '0' then 
			LG1_INT <= TURNED;
		  end if;
		  if LG1_INT = 0 then
			color_t <= 12;
		else
			color_t <= LG1_INT;
		end if;
          st_square <= sLG1b;
        when sLG1b =>
          st_square <= sLG1c;
        when sLG1c =>
          if done = '1' then
            st_square <= sLG2a;
          end if;
        
        when sLG2a =>
		  x_t <= X_coord_array(2);
		  y_t <= Y_coord_array(2);
		  if LG2 = '1' and LG2_INT /= TURNED then 
			LG2_INT <= LG2_INT;
		  elsif LG2 = '1' and (count_ones(Sync) mod 2) = 1 then 
			LG2_INT <= to_integer(unsigned(Sync_value_card1));
          elsif LG2 = '1' and (count_ones(Sync) mod 2) = 0 then 
			LG2_INT <= to_integer(unsigned(Sync_value_card2));
          elsif LG2 = '0' then 
			LG2_INT <= TURNED;
		  end if;
		  if LG2_INT = 0 then
			color_t <= 12;
		else
			color_t <= LG2_INT;
		end if;
		  st_square <= sLG2b;
		when sLG2b =>
		  st_square <= sLG2c;
		when sLG2c =>
		  if done = '1' then
			st_square <= sLG3a;
		  end if;

		when sLG3a =>
		  x_t <= X_coord_array(3);
		  y_t <= Y_coord_array(3);
		  if LG3 = '1' and LG3_INT /= TURNED then 
			LG3_INT <= LG3_INT;
		  elsif LG3 = '1' and (count_ones(Sync) mod 2) = 1 then 
			LG3_INT <= to_integer(unsigned(Sync_value_card1));
          elsif LG3 = '1' and (count_ones(Sync) mod 2) = 0 then 
			LG3_INT <= to_integer(unsigned(Sync_value_card2));
          elsif LG3 = '0' then 
			LG3_INT <= TURNED;
		  end if;
		  if LG3_INT = 0 then
			color_t <= 12;
		else
			color_t <= LG3_INT;
		end if;
		  st_square <= sLG3b;
		when sLG3b =>
		  st_square <= sLG3c;
		when sLG3c =>
		  if done = '1' then
			st_square <= sLG4a;
		  end if;

		when sLG4a =>
		  x_t <= X_coord_array(4);
		  y_t <= Y_coord_array(4);
		  if LG4 = '1' and LG4_INT /= TURNED then 
			LG4_INT <= LG4_INT;
		  elsif LG4 = '1' and (count_ones(Sync) mod 2) = 1 then 
			LG4_INT <= to_integer(unsigned(Sync_value_card1));
          elsif LG4 = '1' and (count_ones(Sync) mod 2) = 0 then 
			LG4_INT <= to_integer(unsigned(Sync_value_card2));
          elsif LG4 = '0' then 
			LG4_INT <= TURNED;
		  end if;
		  if LG4_INT = 0 then
			color_t <= 12;
		else
			color_t <= LG4_INT;
		end if;
		  st_square <= sLG4b;
		when sLG4b =>
		  st_square <= sLG4c;
		when sLG4c =>
		  if done = '1' then
			st_square <= sLG5a;
		  end if;

		when sLG5a =>
		  x_t <= X_coord_array(5);
		  y_t <= Y_coord_array(5);
		  if LG5 = '1' and LG5_INT /= TURNED then 
			LG5_INT <= LG5_INT;
		  elsif LG5 = '1' and (count_ones(Sync) mod 2) = 1 then 
			LG5_INT <= to_integer(unsigned(Sync_value_card1));
          elsif LG5 = '1' and (count_ones(Sync) mod 2) = 0 then 
			LG5_INT <= to_integer(unsigned(Sync_value_card2));
          elsif LG5 = '0' then 
			LG5_INT <= TURNED;
		  end if;
		  if LG5_INT = 0 then
			color_t <= 12;
		else
			color_t <= LG5_INT;
		end if;
		  st_square <= sLG5b;
		when sLG5b =>
		  st_square <= sLG5c;
		when sLG5c =>
		  if done = '1' then
			st_square <= sLG6a;
		  end if;

		when sLG6a =>
		  x_t <= X_coord_array(6);
		  y_t <= Y_coord_array(6);
		  if LG6 = '1' and LG6_INT /= TURNED then 
			LG6_INT <= LG6_INT;
		  elsif LG6 = '1' and (count_ones(Sync) mod 2) = 1 then 
			LG6_INT <= to_integer(unsigned(Sync_value_card1));
          elsif LG6 = '1' and (count_ones(Sync) mod 2) = 0 then 
			LG6_INT <= to_integer(unsigned(Sync_value_card2));
          elsif LG6 = '0' then 
			LG6_INT <= TURNED;
		  end if;
		if LG6_INT = 0 then
			color_t <= 12;
		else
			color_t <= LG6_INT;
		end if;
		  st_square <= sLG6b;
		when sLG6b =>
		  st_square <= sLG6c;
		when sLG6c =>
		  if done = '1' then
			st_square <= sLG7a;
		  end if;

		when sLG7a =>
		  x_t <= X_coord_array(7);
		  y_t <= Y_coord_array(7);
		  if LG7 = '1' and LG7_INT /= TURNED then 
			LG7_INT <= LG7_INT;
		  elsif LG7 = '1' and (count_ones(Sync) mod 2) = 1 then 
			LG7_INT <= to_integer(unsigned(Sync_value_card1));
          elsif LG7 = '1' and (count_ones(Sync) mod 2) = 0 then 
			LG7_INT <= to_integer(unsigned(Sync_value_card2));
          elsif LG7 = '0' then 
			LG7_INT <= TURNED;
		  end if;
		 if LG7_INT = 0 then
			color_t <= 12;
		else
			color_t <= LG7_INT;
		end if;
		  st_square <= sLG7b;
		when sLG7b =>
		  st_square <= sLG7c;
		when sLG7c =>
		  if done = '1' then
			st_square <= sLG8a;
		  end if;

		when sLG8a =>
		  x_t <= X_coord_array(8);
		  y_t <= Y_coord_array(8);
		  if LG8 = '1' and LG8_INT /= TURNED then 
			LG8_INT <= LG8_INT;
		  elsif LG8 = '1' and (count_ones(Sync) mod 2) = 1 then 
			LG8_INT <= to_integer(unsigned(Sync_value_card1));
          elsif LG8 = '1' and (count_ones(Sync) mod 2) = 0 then 
			LG8_INT <= to_integer(unsigned(Sync_value_card2));
          elsif LG8 = '0' then 
			LG8_INT <= TURNED;
		  end if;
		  if LG8_INT = 0 then
			color_t <= 12;
		else
			color_t <= LG8_INT;
		end if;
		  st_square <= sLG8b;
		when sLG8b =>
			st_square <= sLG8c;
		  when sLG8c =>
		  if done = '1' then
			st_square <= sLG9a;
		  end if;

		when sLG9a =>
		  x_t <= X_coord_array(9);
		  y_t <= Y_coord_array(9);
		  if LG9 = '1' and LG9_INT /= TURNED then 
			LG9_INT <= LG9_INT;
		  elsif LG9 = '1' and (count_ones(Sync) mod 2) = 1 then 
			LG9_INT <= to_integer(unsigned(Sync_value_card1));
          elsif LG9 = '1' and (count_ones(Sync) mod 2) = 0 then 
			LG9_INT <= to_integer(unsigned(Sync_value_card2));
          elsif LG9 = '0' then 
			LG9_INT <= TURNED;
		  end if;
		  if LG9_INT = 0 then
			color_t <= 12;
		else
			color_t <= LG9_INT;
		end if;
		  st_square <= sLG9b;
		when sLG9b =>
		  st_square <= sLG9c;
		when sLG9c =>
		  if done = '1' then
			st_square <= sLG10a;
		  end if;

		when sLG10a =>
		  x_t <= X_coord_array(10);
		  y_t <= Y_coord_array(10);
		  if LG10 = '1' and LG10_INT /= TURNED then 
			LG10_INT <= LG10_INT;
		  elsif LG10 = '1' and (count_ones(Sync) mod 2) = 1 then 
			LG10_INT <= to_integer(unsigned(Sync_value_card1));
          elsif LG10 = '1' and (count_ones(Sync) mod 2) = 0 then 
			LG10_INT <= to_integer(unsigned(Sync_value_card2));
          elsif LG10 = '0' then 
			LG10_INT <= TURNED;
		  end if;
		  if LG10_INT = 0 then
			color_t <= 12;
		else
			color_t <= LG10_INT;
		end if;
		  st_square <= sLG10b;
		when sLG10b =>
		  st_square <= sLG10c;
		when sLG10c =>
		  if done = '1' then
			st_square <= sLG11a;
		  end if;

		when sLG11a =>
		  x_t <= X_coord_array(11);
		  y_t <= Y_coord_array(11);
		  if LG11 = '1' and LG11_INT /= TURNED then 
			LG11_INT <= LG11_INT;
		  elsif LG11 = '1' and (count_ones(Sync) mod 2) = 1 then 
			LG11_INT <= to_integer(unsigned(Sync_value_card1));
          elsif LG11 = '1' and (count_ones(Sync) mod 2) = 0 then 
			LG11_INT <= to_integer(unsigned(Sync_value_card2));
          elsif LG11 = '0' then 
			LG11_INT <= TURNED;
		  end if;
		  if LG11_INT = 0 then
			color_t <= 12;
		else
			color_t <= LG11_INT;
		end if;
		  st_square <= sLG11b;
		when sLG11b =>
		  st_square <= sLG11c;
		when sLG11c =>
		  if done = '1' then
			st_square <= sLG12a;
		  end if;

		when sLG12a =>
		  x_t <= X_coord_array(12);
		  y_t <= Y_coord_array(12);
		  if LG12 = '1' and LG12_INT /= TURNED then 
			LG12_INT <= LG12_INT;
		  elsif LG12 = '1' and (count_ones(Sync) mod 2) = 1 then 
			LG12_INT <= to_integer(unsigned(Sync_value_card1));
          elsif LG12 = '1' and (count_ones(Sync) mod 2) = 0 then 
			LG12_INT <= to_integer(unsigned(Sync_value_card2));
          elsif LG12 = '0' then 
			LG12_INT <= TURNED;
		  end if;
		  if LG12_INT = 0 then
			color_t <= 12;
		else
			color_t <= LG12_INT;
		end if;
		  st_square <= sLG12b;
		when sLG12b =>
		  st_square <= sLG12c;
		when sLG12c =>
		  if done = '1' then
			st_square <= sLG13a;
		  end if;

		when sLG13a =>
		  x_t <= X_coord_array(13);
		  y_t <= Y_coord_array(13);
		  if LG13 = '1' and LG13_INT /= TURNED then 
			LG13_INT <= LG13_INT;
		  elsif LG13 = '1' and (count_ones(Sync) mod 2) = 1 then 
			LG13_INT <= to_integer(unsigned(Sync_value_card1));
          elsif LG13 = '1' and (count_ones(Sync) mod 2) = 0 then 
			LG13_INT <= to_integer(unsigned(Sync_value_card2));
          elsif LG13 = '0' then 
			LG13_INT <= TURNED;
		  end if;
		  if LG13_INT = 0 then
			color_t <= 12;
		else
			color_t <= LG13_INT;
		end if;
		  st_square <= sLG13b;
		when sLG13b =>
		  st_square <= sLG13c;
		when sLG13c =>
		  if done = '1' then
			st_square <= sLG14a;
		  end if;

		when sLG14a =>
		  x_t <= X_coord_array(14);
		  y_t <= Y_coord_array(14);
		  if LG14 = '1' and LG14_INT /= TURNED then 
			LG14_INT <= LG14_INT;
		  elsif LG14 = '1' and (count_ones(Sync) mod 2) = 1 then 
			LG14_INT <= to_integer(unsigned(Sync_value_card1));
          elsif LG14 = '1' and (count_ones(Sync) mod 2) = 0 then 
			LG14_INT <= to_integer(unsigned(Sync_value_card2));
          elsif LG14 = '0' then 
			LG14_INT <= TURNED;
		  end if;
		  if LG14_INT = 0 then
			color_t <= 12;
		else
			color_t <= LG14_INT;
		end if;
		  st_square <= sLG14b;
		when sLG14b =>
		  st_square <= sLG14c;
		when sLG14c =>
		  if done = '1' then
			st_square <= sLG15a;
		  end if;

		when sLG15a =>
		  x_t <= X_coord_array(15);
		  y_t <= Y_coord_array(15);
		  if LG15 = '1' and LG15_INT /= TURNED then 
			LG15_INT <= LG15_INT;
		  elsif LG15 = '1' and (count_ones(Sync) mod 2) = 1 then 
			LG15_INT <= to_integer(unsigned(Sync_value_card1));
          elsif LG15 = '1' and (count_ones(Sync) mod 2) = 0 then 
			LG15_INT <= to_integer(unsigned(Sync_value_card2));
          elsif LG15 = '0' then 
			LG15_INT <= TURNED;
		  end if;
		  if LG15_INT = 0 then
			color_t <= 12;
		else
			color_t <= LG15_INT;
		end if;
		  st_square <= sLG15b;
		when sLG15b =>
		  st_square <= sLG15c;
		when sLG15c =>
		  if done = '1' then
			st_square <= s_aux; -- Return to the first LED state
		  end if;
		 when s_aux =>
			st_square <= sLG0a;
		when others =>
			--st_square <= sLG0a;

      end case;
    end if;
  end process;
  start <= '1' when (st_square = sLG0b) or (st_square = sLG1b) or (st_square = sLG2b) or (st_square = sLG3b) or
                (st_square = sLG4b) or (st_square = sLG5b) or (st_square = sLG6b) or
                (st_square = sLG7b) or (st_square = sLG8b) or (st_square = sLG9b) or
                (st_square = sLG10b) or (st_square = sLG11b) or (st_square = sLG12b) or
                (st_square = sLG13b) or (st_square = sLG14b) or (st_square = sLG15b) else '0';
	sweep <= '1' when st_square = s_aux else '0';
end functional;
