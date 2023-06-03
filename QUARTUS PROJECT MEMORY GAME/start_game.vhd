library ieee;
use ieee.std_logic_1164.all;

entity start_game is
    port (
        clk        : in std_logic;
        nrst       : in std_logic;
        hash_key   : in std_logic;
        confirm    : in std_logic;
        end_game   : in std_logic;
        key_read   : out std_logic;
        RDY        : out std_logic;
        init_game  : out std_logic;
        acknow  : out std_logic;
        PLAYING_LED  : out std_logic;
        CONFIRMATION_LED  : out std_logic
    );
end start_game;

architecture behavior of start_game is
    type state_type is (init, waiting, situation1, situation2, confirmation,after_confirmation, wait_hash,delay_state, play_game_init, play_game, results);
    signal state: state_type;
	--signal delay_counter: integer range 0 to 500; -- 10us delay at 50MHzbegin
	signal delay_counter: integer range 0 to 250000; -- 5ms delay at 50MHzbegin
	begin
    process (clk, nrst)
    begin
        if nrst = '0' then
            state <= init;
        elsif clk'event and clk = '1' then
            case state is
                when init =>
                    state <= waiting;
                    
                when waiting =>
                    if hash_key = '1' then
                        state <= situation1;
                    elsif confirm = '1' then
                        state <= situation2;
                     
                    end if;
                    
                when situation1 =>
                    state <= confirmation;
                    RDY <= '1';
                    
                when confirmation =>
					RDY <= '0';
                    if confirm = '1' then
                        state <= after_confirmation;
                    end if;
                    
                when after_confirmation =>    
					state <= play_game_init;
					
                when situation2 =>
                    state <= wait_hash;
                    
                when wait_hash =>
                    if hash_key = '1' then
						state <= delay_state;
						delay_counter <= 0;
                    end if;
                    
                when delay_state=>
                    if delay_counter = 250000 then
                        RDY <= '1';
                        state <= play_game_init;
                    else
                        delay_counter <= delay_counter + 1;
                    end if;
                    
                when play_game_init =>
					delay_counter <= 0;
                    state <= play_game;
                    
                when play_game =>
					RDY <= '0';
                    if end_game = '1' then
                        state <= results;
                    end if;
                 when results =>

                    if end_game = '1' then
                        state <= init;
                    end if;    
            end case;
        end if;
    end process;

    key_read <= '1' when (state = situation1) or (state = situation2) else '0';
    init_game <= '1' when state = play_game_init else '0';
	acknow <= '1' when state = situation2 or state = after_confirmation else '0';
	CONFIRMATION_LED   <= '1' when state = wait_hash or state = confirmation else '0';
	PLAYING_LED  <= '1' when state = play_game else '0';
end behavior;    
