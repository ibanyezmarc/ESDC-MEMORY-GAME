library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use ieee.numeric_std.ALL;

entity random_selector is
    port (
        clk: in std_logic;
        nrst: in std_logic;
        --init_game: in std_logic;
        num_tauler: out integer range 0 to 7
    );
end entity;

architecture Behavioral of random_selector is

    signal counter : integer range 0 to 7 := 0;

begin

    process (clk, nrst)
    begin
        if nrst = '0' then
            counter <= 0;
            num_tauler <= 0;
        elsif clk'event and clk = '1' then
            if counter = 7 then
                counter <= 0;
                num_tauler <= counter;
            else
                counter <= counter + 1;
                num_tauler <= counter;
            end if;
--            if init_game = '1' then
--                num_tauler <= counter;
--            end if;
        end if;
    end process;

end architecture;
