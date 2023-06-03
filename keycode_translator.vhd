library ieee;
use ieee.std_logic_1164.all;

entity keycode_translator is
    port (
        clk, nrst   : in  std_logic;
        filxcol_def : in  std_logic_vector(7 downto 0);
        led_array   : out std_logic_vector(15 downto 0);
        key_read    : in std_logic
    );
end keycode_translator;

architecture behavior of keycode_translator is
begin
    process (clk,key_read, filxcol_def)
    begin
    if nrst = '0' then 
		led_array <= (others => '0');
		
        elsif clk'event and clk = '1' then

            if key_read = '1' then
                led_array <= (others => '0');
                case filxcol_def is
                    when "00010001" => led_array(0) <= '1';
                    when "00010010" => led_array(1) <= '1';
                    when "00010011" => led_array(2) <= '1';
                    when "00010100" => led_array(3) <= '1';
                    when "00100001" => led_array(4) <= '1';
                    when "00100010" => led_array(5) <= '1';
                    when "00100011" => led_array(6) <= '1';
                    when "00100100" => led_array(7) <= '1';
                    when "00110001" => led_array(8) <= '1';
                    when "00110010" => led_array(9) <= '1';
                    when "00110011" => led_array(10) <= '1';
                    when "00110100" => led_array(11) <= '1'; 
                    when "01000001" => led_array(12) <= '1';
                    when "01000010" => led_array(13) <= '1';
                    when "01000011" => led_array(14) <= '1';
                    when "01000100" => led_array(15) <= '1'; 

                    when others => null;
                end case;
            else 
                led_array <= (others => '0');
            end if;
        end if;
    end process;
end behavior;