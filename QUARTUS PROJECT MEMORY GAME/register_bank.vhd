library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity register_bank is
    port(
        clk50, nrst, bcd, ast, new_code: in std_logic;
        keycode: in std_logic_vector(3 downto 0);
        filxcol_def: out std_logic_vector (7 downto 0);
        key_read, done: out std_logic 
    );
end register_bank;

architecture arc of register_bank is
    type state_type is (
        s0_wait,
        s1_wait_asterisk1,
        s2_get_fil,
        s2_store_fil,
        s2_update_fil, -- New state to update the entered row value
        s3_wait_asterisk2,
        s4_get_col,
        s4_update_col, -- New state to update the entered column value
        s5_wait_asterisk3,
        s6_store_keycode
    );
    signal state: state_type;
    signal filxcol: std_logic_vector(7 downto 0);
begin
    process(clk50, nrst)
    begin
        if nrst = '0' then
            state <= s0_wait;
            filxcol <= (others => '0');
        elsif clk50'event and clk50 = '1' then
            case state is
                when s0_wait =>
                    if new_code = '1' then
                        state <= s1_wait_asterisk1;
                        filxcol <= (others => '0');
               
                    end if;
                
                when s1_wait_asterisk1 =>
                    if ast = '1' then
                        state <= s2_get_fil;
                    end if;
                
                when s2_get_fil =>
                    if bcd = '1' then -- Only consider BCD inputs
                        filxcol(7 downto 4) <= keycode;
                        state <= s2_store_fil;
                    end if;
                    
                when s2_store_fil =>
                    if ast = '1' then
                        state <= s3_wait_asterisk2;
                    else
                        state <= s2_update_fil;
                    end if;

                when s2_update_fil => -- New state for updating last entered row value
                    if bcd = '1' then -- Only consider BCD inputs
                        filxcol(7 downto 4) <= keycode;
                        state <= s2_store_fil;
                    elsif ast = '1' then
                        state <= s3_wait_asterisk2;
                    end if;
                
                when s3_wait_asterisk2 =>
                    if ast = '1' then
                        state <= s4_get_col;
                    end if;
                
                when s4_get_col =>
                    if bcd = '1' then -- Only consider BCD inputs
                        filxcol(3 downto 0) <= keycode;
                        state <= s4_update_col;
                    end if;

                when s4_update_col => -- New state for updating entered column value
                    if bcd = '1' then -- Only consider BCD inputs
                        filxcol(3 downto 0) <= keycode;
                    elsif ast = '1' then
                        state <= s5_wait_asterisk3;
                    end if;
                
                when s5_wait_asterisk3 =>
                    if ast = '1' then
                        state <= s6_store_keycode;
                    end if;

                when s6_store_keycode =>
                    state <= s0_wait;
                  

            end case;
        end if;
    end process;

    filxcol_def <= filxcol;
    key_read <= '1' when state = s6_store_keycode or state = s2_get_fil or state = s4_get_col else '0';
	done <= '1' when state = s6_store_keycode else '0';
end arc;

                    
                    
                    
                    
                    
                    
                    
				