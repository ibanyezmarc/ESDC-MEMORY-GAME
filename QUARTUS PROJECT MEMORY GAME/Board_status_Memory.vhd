
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.ALL;

entity Board_status_Memory is
    Port (
        clk : in std_logic;
        nrst : in std_logic;
        Hide : in std_logic;
        correct : in std_logic;
        Card_1_sent : in std_logic;
        Card_2_sent : in std_logic;
        Card_1 : in std_logic_vector(2 downto 0);
        Card_2 : in std_logic_vector(2 downto 0);
        keycode : in std_logic_vector(7 downto 0);
        SYNC : out std_logic_vector(15 downto 0);
        SYNC_value_c1 : out std_logic_vector(2 downto 0);
        SYNC_value_c2 : out std_logic_vector(2 downto 0);
        delay_done : out std_logic
    );
end Board_status_Memory;

architecture Behavioral of Board_status_Memory is

-- Internal signals
signal Card_1_number : std_logic_vector(15 downto 0);
signal Card_2_number : std_logic_vector(15 downto 0);
signal Card_1_bit_position : integer range 0 to 16;
signal Card_2_bit_position : integer range 0 to 16;
signal delay_counter : integer range 0 to 100000000;
signal hide_int: std_logic;

-- State machine states
type state_type is (init, wait_for_card1, card1_received, card2_received, update_sync, check_success, delay_state, s_assign_sync, reset_internal);
signal current_state: state_type;

begin

process (clk, nrst)
begin
    if nrst = '0' then
        current_state <= init; 
    elsif rising_edge(clk) then
    if Hide='1' then
		 hide_int<=Hide;
	end if;
        case current_state is
            when init =>
                -- Reset all internal signals and wait for the first card to be sent
                Card_1_number <= (others => '0');
                Card_2_number <= (others => '0');
                SYNC <= (others => '0');
                SYNC_value_c1 <= (others => '0');
                SYNC_value_c2 <= (others => '0');
                delay_done <= '0';
                Card_1_bit_position <= 16;
                Card_1_bit_position <= 16;
                current_state <= wait_for_card1;
            
        when wait_for_card1 =>
            if Card_1_sent = '1' and Card_2_sent = '0' and Card_1_number = "0000000000000000" then
				hide_int <= '0';
				current_state <= card1_received;
			elsif Card_2_sent = '1' then 
				current_state <= card2_received;
			else
				current_state <= wait_for_card1;
			end if;
        
        when card1_received =>
        Card_1_number <= "0000000000000000";
         if keycode = "00010001" or keycode = "00010010" or keycode = "00010011" or
               keycode = "00010100" or keycode = "00100001" or keycode = "00100010" or
               keycode = "00100011" or keycode = "00100100" or keycode = "00110001" or
               keycode = "00110010" or keycode = "00110011" or keycode = "00110100" or
               keycode = "01000001" or keycode = "01000010" or keycode = "01000011" or
               keycode = "01000100" then
            case keycode is
				when "00010001" =>
					if Card_2_sent = '0' then
						Card_1_number <= "0000000000000001";
					else
						Card_2_number <= "0000000000000001";
					end if;
				when "00010010" =>
					if Card_2_sent = '0' then
						Card_1_number <= "0000000000000010";
					else
						Card_2_number <= "0000000000000010";
					end if;
				when "00010011" =>
					if Card_2_sent = '0' then
						Card_1_number <= "0000000000000100";
					else
						Card_2_number <= "0000000000000100";
					end if;
				when "00010100" =>
					if Card_2_sent = '0' then
						Card_1_number <= "0000000000001000";
					else
						Card_2_number <= "0000000000001000";
					end if;
				when "00100001" =>
					if Card_2_sent = '0' then
						Card_1_number <= "0000000000010000";
					else
						Card_2_number <= "0000000000010000";
					end if;
				when "00100010" =>
					if Card_2_sent = '0' then
						Card_1_number <= "0000000000100000";
					else
						Card_2_number <= "0000000000100000";
					end if;
				when "00100011" =>
					if Card_2_sent = '0' then
						Card_1_number <= "0000000001000000";
					else
						Card_2_number <= "0000000001000000";
					end if;
				when "00100100" =>
					if Card_2_sent = '0' then
						Card_1_number <= "0000000010000000";
					else
						Card_2_number <= "0000000010000000";
					end if;
				when "00110001" =>
					if Card_2_sent = '0' then
						Card_1_number <= "0000000100000000";
					else
						Card_2_number <= "0000000100000000";
					end if;
				when "00110010" =>
					if Card_2_sent = '0' then
						Card_1_number <= "0000001000000000";
					else
						Card_2_number <= "0000001000000000";
					end if;
				when "00110011" =>
					if Card_2_sent = '0' then
						Card_1_number <= "0000010000000000";
					else
						Card_2_number <= "0000010000000000";
					end if;
				when "00110100" =>
					if Card_2_sent = '0' then
						Card_1_number <= "0000100000000000";
					else
						Card_2_number <= "0000100000000000";
					end if;
				when "01000001" =>
					if Card_2_sent = '0' then
						Card_1_number <= "0001000000000000";
					else
						Card_2_number <= "0001000000000000";
					end if;
				when "01000010" =>
					if Card_2_sent = '0' then
						Card_1_number <= "0010000000000000";
					else
						Card_2_number <= "0010000000000000";
					end if;
				when "01000011" =>
					if Card_2_sent = '0' then
						Card_1_number <= "0100000000000000";
					else
						Card_2_number <= "0100000000000000";
					end if;
				when "01000100" =>
					if Card_2_sent = '0' then
						Card_1_number <= "1000000000000000";
					else
						Card_2_number <= "1000000000000000";
					end if;
				when others =>
					null; -- Do nothing for any other keycode
				end case;
				
				else
					null; -- Do nothing for any other keycode
				end if;
				
				current_state <= update_sync;

				
				when card2_received =>
					Card_2_number <= "0000000000000000";
					if keycode = "00010001" or keycode = "00010010" or keycode = "00010011" or
					   keycode = "00010100" or keycode = "00100001" or keycode = "00100010" or
					   keycode = "00100011" or keycode = "00100100" or keycode = "00110001" or
					   keycode = "00110010" or keycode = "00110011" or keycode = "00110100" or
					   keycode = "01000001" or keycode = "01000010" or keycode = "01000011" or
					   keycode = "01000100" then
						
						case keycode is
							when "00010001" =>
								Card_2_number <= "0000000000000001";
							when "00010010" =>
								Card_2_number <= "0000000000000010";
							when "00010011" =>
								Card_2_number <= "0000000000000100";
							when "00010100" =>
								Card_2_number <= "0000000000001000";
							when "00100001" =>
								Card_2_number <= "0000000000010000";
							when "00100010" =>
								Card_2_number <= "0000000000100000";
							when "00100011" =>
								Card_2_number <= "0000000001000000";
							when "00100100" =>
								Card_2_number <= "0000000010000000";
							when "00110001" =>
								Card_2_number <= "0000000100000000";
							when "00110010" =>
								Card_2_number <= "0000001000000000";
							when "00110011" =>
								Card_2_number <= "0000010000000000";
							when "00110100" =>
								Card_2_number <= "0000100000000000";
							when "01000001" =>
								Card_2_number <= "0001000000000000";
							when "01000010" =>
								Card_2_number <= "0010000000000000";
							when "01000011" =>
								Card_2_number <= "0100000000000000";
							when "01000100" =>
								Card_2_number <= "1000000000000000";
							when others =>
								null; -- Do nothing for any other keycode
						end case;
						
						current_state <= update_sync;
						
					else
						current_state <= wait_for_card1;
					end if;
					
				when update_sync =>
					if Card_1_number /= "0000000000000000" and Card_2_number = "0000000000000000" then
						SYNC_value_c1 <= Card_1(2 downto 0);
						for i in 0 to 15 loop
							if Card_1_number(i) = '1' then
								SYNC(i) <= '1';
								Card_1_bit_position <= i;
								exit;
							end if;
							end loop;
						if Card_2_sent = '1' and Card_1_bit_position /= 16 then
							current_state <= card2_received;
						elsif Card_1_bit_position /= 16 then
							current_state <= wait_for_card1;
						end if;
					elsif Card_1_number /= "0000000000000000" and Card_2_number /= "0000000000000000" then					
						SYNC_value_c2 <= Card_2(2 downto 0);
						for i in 0 to 15 loop
							if Card_2_number(i) = '1' then
								SYNC(i) <= '1';
								Card_2_bit_position <= i;
								exit;
							end if;
							end loop;
						if Card_2_bit_position /= 16 then
						current_state <= s_assign_sync;
						end if;
					end if;
					
				when s_assign_sync=>
				-- Check whether the player found a match or not
					delay_done <= '0';
					current_state <= delay_state;
					
				when delay_state =>
					if delay_counter < 99999999 then
						delay_counter <= delay_counter + 1;
						current_state <= delay_state;
					else
						delay_counter <= 0;
						current_state <= check_success;
					end if;
				when check_success =>
					delay_done <= '1';
					if hide_int = '1' then
						-- If the two cards do not match, hide them again
						SYNC_value_c1 <= (others => '0');
						SYNC_value_c2 <= (others => '0');
						SYNC(Card_1_bit_position) <= '0';
						SYNC(Card_2_bit_position) <= '0';
						hide_int <= '0';
						current_state <= reset_internal;
					elsif correct = '1' then
						SYNC_value_c1 <= (others => '0');
						SYNC_value_c2 <= (others => '0');
												-- If the two cards match, keep them visible and wait for the next play
						current_state <= reset_internal; -- Els valors se queden ja que hem fet match.
					end if;
				when reset_internal =>
					Card_1_number <= (others => '0');
					Card_2_number <= (others => '0');
					Card_1_bit_position <= 16;
					Card_2_bit_position <= 16;
					delay_done <= '0';	
					current_state <= wait_for_card1;
								
				when others =>
					null; -- Do nothing for any other state
    end case;
    end if;
end process;

end Behavioral;

