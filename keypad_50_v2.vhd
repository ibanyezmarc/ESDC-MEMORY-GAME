-- 4x4 keypad analyser
-- Designed by Josep Altet, based on previous design by Joan Pons and Juan Chavez.
-- Date: May 2023
-- This IP works at 50 MHz.


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity keypad_50_v2 is
  port (
    clk, nrst    : in  std_logic;
    key          : out std_logic;
    keycode, row : out std_logic_vector(3 downto 0);
    col          : in  std_logic_vector(3 downto 0)
    );
    
end keypad_50_v2;

architecture arc_keypad of keypad_50_v2 is
  
  type   states is (wait0, check_All0, srow_1st, srow_2st, srow_3st, srow_4st, skey, wait1, check1);
  signal current_state 			   : states;
  signal colq                      : std_logic_vector(3 downto 0);
  signal kpressed                  : std_logic;
  signal keycodeq				   : std_logic_vector(3 downto 0);
  
  --- Signals for the Wait generator to stabilize internal signals
  signal enable_out : std_logic;
  --constant M : integer :=65536;
  constant M : integer :=1024;
  signal q_wait : integer range 0 to M-1;

----- Signals for the bounce prevention register.
constant N : integer := 15;
type reg_bouncing is array (0 to N) of std_logic_vector(3 downto 0);
signal regs 		: reg_bouncing;
signal col_int 		: std_logic_vector(3 downto 0);
---- Signals for the 
begin  -- arc_keypad
---REgister to prevent bouncing

process(clk,nrst) 
variable ireg : std_logic_vector(3 downto 0);

Begin
	if (nrst = '0') then
		initialization: for k in 0 to N loop
			regs(k) <= x"0";
		end loop initialization;
	elsif (clk'event and clk='1') then
		regs(0) <= col;
		for k in 1 to N loop
			regs(k) <= regs(k-1);
		end loop;
		
		ireg := regs(0);
		for k in 1 to N loop
			if (regs(k) /= ireg) then
				ireg := x"F";
			end if;
		end loop;
		colq <= ireg;
	end if;
end process;

kpressed <= not (colq(3) and colq(2) and colq(1) and colq(0));

----Counter to delay state transitions
 process(clk,nrst) begin
     if nrst='0' then q_wait <= 0;
     elsif clk'event and clk='1' then 
         if q_wait < M-1 then q_wait <= q_wait+1; 
            else q_wait <= 0; end if;
     end if;
  end process;
  
  
  enable_out <= '1' when q_wait = M-1 else '0';
  
  
  --whatkey state machine declaration, made with a synchronous state register, plus
--two combinational blocs, one generates the next state and the other the outputs
  --state register definition
  whatkey : process (clk, nrst)
  begin  -- process keyanal
    if nrst = '0' then
      current_state <= wait0;
    elsif clk'event and clk = '1' then
      case current_state is
		when wait0 =>
			if (enable_out = '1') then current_state <= check_All0; end if;
		when check_All0 =>
			if enable_out = '1' then
				if kpressed = '1' then current_state <= srow_1st;
				else current_state <= wait0;
				end if;
			end if;
		when srow_1st =>
			if enable_out = '1' then
				if kpressed = '1' then current_state <= skey;
									keycode <= keycodeq;
				else current_state <= srow_2st;
				end if;
			end if;
		when srow_2st =>
			if enable_out = '1' then
				if kpressed = '1' then current_state <= skey;
									keycode <= keycodeq;
				else current_state <= srow_3st;
				end if;
			end if;
		when srow_3st =>
			if enable_out = '1' then
				if kpressed = '1' then current_state <= skey;
									keycode <= keycodeq;
				else current_state <= srow_4st;
				end if;
			end if;
		when srow_4st =>
			if enable_out = '1' then
				if kpressed = '1' then current_state <= skey;
									keycode <= keycodeq;
				else current_state <= wait0;
				end if;
			end if;
		when skey =>
			current_state <= wait1;
		when wait1 =>
			if (enable_out = '1') then current_state <= check1; end if;
		when check1 =>
			if enable_out = '1' then
				if kpressed = '1' then current_state <= wait1;
				else current_state <= wait0;
				end if;
			end if;
		End Case;
		
    end if;
  end process whatkey;

  --output functions
   with current_state select
     row <= "0000" when check_All0 | check1,
			"ZZZ0" when srow_1st,
			"ZZ0Z" when srow_2st,
			"Z0ZZ" when srow_3st,
			"0ZZZ" when srow_4st,
			"ZZZZ" when others;
    
  key <= '1' when (current_state = skey) else '0';
  keycodeq <= x"1" when (current_state = srow_1st and colq(0) = '0') else
             x"2" when (current_state = srow_1st and colq(1) = '0') else
             x"3" when (current_state = srow_1st and colq(2) = '0') else
             x"a" when (current_state = srow_1st and colq(3) = '0') else
             x"4" when (current_state = srow_2st and colq(0) = '0') else
             x"5" when (current_state = srow_2st and colq(1) = '0') else
             x"6" when (current_state = srow_2st and colq(2) = '0') else
             x"b" when (current_state = srow_2st and colq(3) = '0') else
             x"7" when (current_state = srow_3st and colq(0) = '0') else
             x"8" when (current_state = srow_3st and colq(1) = '0') else
             x"9" when (current_state = srow_3st and colq(2) = '0') else
             x"c" when (current_state = srow_3st and colq(3) = '0') else
             x"e" when (current_state = srow_4st and colq(0) = '0') else
             x"0" when (current_state = srow_4st and colq(1) = '0') else
             x"f" when (current_state = srow_4st and colq(2) = '0') else
             x"d" when (current_state = srow_4st and colq(3) = '0') else
             x"0";
  --keyanal end


end arc_keypad;

