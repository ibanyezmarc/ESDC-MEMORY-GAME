library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.ALL;

entity Boards_Memory is
    Port (
        clk : in std_logic;
        nrst : in std_logic;
        consult : in std_logic;
        correct : in std_logic;
        incorrect : in std_logic;
        keycode : in std_logic_vector(7 downto 0);
        counter_taulell : in std_logic_vector(2 downto 0);
		read_card: out std_logic;
		read_new_card: out std_logic;
        card : out std_logic_vector(2 downto 0);
        new_card : out std_logic_vector(2 downto 0)
    );
end Boards_Memory;

architecture Behavioral of Boards_Memory is
    -- Internal signal for storing the current game board
    signal current_counter_taulell : std_logic_vector(2 downto 0);
	signal keycode_anterior : std_logic_vector(7 downto 0);

    -- Define a ROM_type to store 8 different game boards
    type ROM_type is array (0 to 7) of std_logic_vector(47 downto 0);
    signal ROM : ROM_type := (
			"000000001001010010011011100100101101110110111111",
			"000001000001010011010011100101100101110111110111",
			"000001010000001010011100101011110111110111100101",
			"000001010011100101110111000001010011100101110111",
			"111111110110101101100100011011010010001001000000",
			"111110111110101100101100011010011010001000001000",
			"101100111110111110011101100010001000010001000011",
			"111110101100011010001000111110101100011010001000"
    );

    -- State machine states
    type state_type is (init, read_first_card,retrieve_first_card, read_second_card, retrieve_second_card, reset, wait_new_move);
    signal current_state : state_type;

    -- Additional signals
    signal row_int, col_int: std_logic_vector(3 downto 0);
    signal row_2, col_2: integer;
   

begin
    -- Synchronous process for handling state transitions, row_2 and col_2 conversion, and output assignments
    process (clk, nrst)
    variable index : integer;    
    begin
        if nrst = '0' then
            current_state <= init;
            row_2 <= 0;
            col_2 <= 0;
            card <= "000";
			new_card <= "000";
            read_card <= '0';
			read_new_card <= '0';
        elsif clk'event and clk = '1' then
            case current_state is
                -- Initialization state
                when init =>
					row_2 <= 0;
					col_2 <= 0;
					row_int <= "0000";
					col_int <= "0000";
					read_card <= '0';
					read_new_card <= '0';
					card <= "000";
					new_card <= "000";
                    current_counter_taulell <= counter_taulell; -- Store the current board number
                    if consult = '1' then
                        current_state <= read_first_card;
                    end if;

                -- First card retrieval state
				when read_first_card =>
					if  keycode /= "00000000" then
						keycode_anterior <= keycode;
						row_int <= keycode(7 downto 4); -- Extract row from keycode
						col_int <= keycode(3 downto 0); -- Extract column from keycode
						row_2 <= to_integer(unsigned(row_int));
						col_2 <= to_integer(unsigned(col_int));
						if row_2 /= 0 and col_2 /= 0 then
							current_state <= retrieve_first_card;
						end if;
					else 
						current_state <= read_first_card;
					end if;
				when retrieve_first_card =>


					index := (row_2 - 1) * 4 + (col_2 - 1); -- Calculate the index of the card in the ROM
					-- Calculate the index of the card in the ROM
					card <= ROM(to_integer(unsigned(current_counter_taulell)))(47 - index * 3 downto 47 - index * 3 - 2); -- Retrieve the card type from the ROM
					read_card <= '1';
					if consult = '1' then
						current_state <= reset;
					end if;
				when reset =>
					row_2 <= 0;
					col_2 <= 0;
					row_int <= "0000";
					col_int <= "0000";
					current_state <= read_second_card;
				when read_second_card =>
					if  keycode /= "00000000" and keycode /= keycode_anterior then
						row_int <= keycode(7 downto 4); -- Extract row from keycode
						col_int <= keycode(3 downto 0); -- Extract column from keycode
						row_2 <= to_integer(unsigned(row_int));
						col_2 <= to_integer(unsigned(col_int));
						if row_2 /= 0 and col_2 /= 0 then
							current_state <= retrieve_second_card;
						end if;
					end if;
				when retrieve_second_card =>	
					
					index := (row_2 - 1) * 4 + (col_2 - 1); 

					-- Calculate the index of the card in the ROM
					-- Calculate the index of the card in the ROM
					new_card <= ROM(to_integer(unsigned(counter_taulell)))(47 - index * 3 downto 47 - index * 3 - 2); -- Retrieve the card type from the ROM
					read_new_card <= '1';
					if consult = '1' then
						current_state <= wait_new_move;
					end if;
				when wait_new_move =>
					if correct = '1' then
						current_state <= init;
					elsif incorrect = '1' then
						current_state <= init;  
					end if;         
            end case;
        end if;
    end process;
end Behavioral;   
