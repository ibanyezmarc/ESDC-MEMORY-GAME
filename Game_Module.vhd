library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.ALL;

entity Game_Module is
    Port (
        clk : in std_logic;
        nrst : in std_logic;
		read_card: in std_logic;
		read_new_card: in std_logic;
        keycode_in : in std_logic_vector(7 downto 0);
        can_read: in std_logic;
        keycode_out : out std_logic_vector(7 downto 0);
        counter_taulell : in std_logic_vector(2 downto 0);
        consult : out std_logic;
        card : in std_logic_vector(2 downto 0);
        new_card : in std_logic_vector(2 downto 0);
        sweep: in std_logic;
        Hide : out std_logic;
        card_1 : out std_logic_vector(2 downto 0);
        card_2 : out std_logic_vector(2 downto 0);
        Card_1_sent : out std_logic;
        Card_2_sent : out std_logic;
        Incorrect : out std_logic;
        correct : out std_logic;
        delay_done:  in std_logic
    );
end Game_Module;

architecture Behavioral of Game_Module is
    -- State machine states
    type state_type is (init, first_card, consult_first, second_card, consult_second,wait_for_second_card, compare_cards,second_sweep, hide_cards, match);
    signal current_state : state_type := init;
    
    -- Internal signals for handling state machine logic
    signal keycode_int : std_logic_vector(7 downto 0);
    signal card_1_int, card_2_int : std_logic_vector(2 downto 0);
    
begin
    process (clk, nrst)
    begin
        if nrst = '0' then
            current_state <= init;
            Hide <= '0';
            Card_1_sent <= '0';
            Card_2_sent <= '0';
            Incorrect <= '0';
            correct <= '0';
            consult <= '0';
            keycode_out <= (others => '0');
            card_1_int <= (others => '0');
            card_2_int <= (others => '0');
            keycode_int <= (others => '0');
        elsif clk'event and clk = '1' then
            case current_state is
                when init =>
					Hide <= '0';
					Card_1_sent <= '0';
					Card_2_sent <= '0';
					Incorrect <= '0';
					correct <= '0';
					consult <= '0';
					keycode_out <= (others => '0');
					card_1_int <= (others => '0');
					card_2_int <= (others => '0');
					keycode_int <= (others => '0');
                    if keycode_in /= "00000000" and can_read = '1' then
                        keycode_int <= keycode_in;
                        keycode_out <= keycode_in;
                        consult <= '1';
                        current_state <= consult_first;
                    end if;
                    
                when consult_first =>
                    consult <= '0';
                    if read_card = '1' then
						card_1_int <= card;
						Card_1_sent <= '1';
						current_state <= second_card;
					end if;
                    
                when second_card =>
                    if keycode_in /= "00000000" and keycode_in /= keycode_int and can_read = '1' then
                        keycode_out <= keycode_in;
                        consult <= '1';
                        current_state <= consult_second;
                    end if;

                when consult_second =>
					
                    consult <= '0';
                    if read_new_card = '1' then
						card_2_int <= new_card;
						Card_2_sent <= '1';
						current_state <= wait_for_second_card;
                    end if;
                when wait_for_second_card =>
					
					if read_new_card = '1' then
						
						current_state <= compare_cards;
					end if;
                when compare_cards =>
					consult <= '1';
                    if card_1_int = card_2_int then
                        current_state <= match;
                    elsif sweep ='1' then
                        current_state <= second_sweep;
                    end if;
						
				when second_sweep =>
					if sweep = '1' then
						current_state <= hide_cards;
					end if;
                when hide_cards =>
					consult <= '0';
                    Hide <= '1';
                    Incorrect <= '1';
					correct <= '0';
					Card_1_sent <= '0';
					Card_2_sent <= '0';
				if delay_done = '1' then
					Hide <= '0';	
						current_state <= init;
				end if;

                when match =>
					consult <= '0';
                    Hide <= '0';
                    Incorrect <= '0';
                    correct <= '1';
                    Card_1_sent <= '0';
					Card_2_sent <= '0';
					if delay_done = '1' then
						current_state <= init;
					end if;

                when others =>
                    null;

            end case;
        end if;
    end process;
card_1 <= card_1_int;
card_2 <= card_2_int;
end Behavioral;
