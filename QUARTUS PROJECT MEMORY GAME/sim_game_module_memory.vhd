-- Copyright (C) 1991-2010 Altera Corporation
-- Your use of Altera Corporation's design tools, logic functions 
-- and other software and tools, and its AMPP partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Altera Program License 
-- Subscription Agreement, Altera MegaCore Function License 
-- Agreement, or other applicable license agreement, including, 
-- without limitation, that your use is for the sole purpose of 
-- programming logic devices manufactured by Altera and sold by 
-- Altera or its authorized distributors.  Please refer to the 
-- applicable agreement for further details.

-- PROGRAM		"Quartus II"
-- VERSION		"Version 9.1 Build 350 03/24/2010 Service Pack 2 SJ Web Edition"
-- CREATED		"Wed May 10 19:24:07 2023"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY sim_game_module_memory IS 
	PORT
	(
		clk :  IN  STD_LOGIC;
		nrst :  IN  STD_LOGIC;
		counter_taulell :  IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		keycode :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		Incorrect :  OUT  STD_LOGIC;
		consult :  OUT  STD_LOGIC;
		Card_1_sent_out :  OUT  STD_LOGIC;
		Card_2_sent_out2 :  OUT  STD_LOGIC;
		card_1 :  OUT  STD_LOGIC_VECTOR(2 DOWNTO 0);
		card_2 :  OUT  STD_LOGIC_VECTOR(2 DOWNTO 0);
		card_rom :  OUT  STD_LOGIC_VECTOR(2 DOWNTO 0);
		new_card_rom :  OUT  STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
END sim_game_module_memory;

ARCHITECTURE bdf_type OF sim_game_module_memory IS 

COMPONENT boards_memory
	PORT(clk : IN STD_LOGIC;
		 nrst : IN STD_LOGIC;
		 consult : IN STD_LOGIC;
		 counter_taulell : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 keycode : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 card : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		 new_card : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
END COMPONENT;

COMPONENT game_module
	PORT(clk : IN STD_LOGIC;
		 nrst : IN STD_LOGIC;
		 card : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 counter_taulell : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 keycode_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 new_card : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 consult : OUT STD_LOGIC;
		 Hide : OUT STD_LOGIC;
		 Card_1_sent : OUT STD_LOGIC;
		 Card_2_sent : OUT STD_LOGIC;
		 Incorrect : OUT STD_LOGIC;
		 card_1 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		 card_2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		 keycode_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	Card_1_sent :  STD_LOGIC;
SIGNAL	Card_2_sent :  STD_LOGIC;
SIGNAL	consult_ALTERA_SYNTHESIZED :  STD_LOGIC;
SIGNAL	hide :  STD_LOGIC;
SIGNAL	SYNTHESIZED_WIRE_0 :  STD_LOGIC_VECTOR(7 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_1 :  STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL	SYNTHESIZED_WIRE_2 :  STD_LOGIC_VECTOR(2 DOWNTO 0);


BEGIN 
card_rom <= SYNTHESIZED_WIRE_1;
new_card_rom <= SYNTHESIZED_WIRE_2;



b2v_inst : boards_memory
PORT MAP(clk => clk,
		 nrst => nrst,
		 consult => consult_ALTERA_SYNTHESIZED,
		 counter_taulell => counter_taulell,
		 keycode => SYNTHESIZED_WIRE_0,
		 card => SYNTHESIZED_WIRE_1,
		 new_card => SYNTHESIZED_WIRE_2);


b2v_inst1 : game_module
PORT MAP(clk => clk,
		 nrst => nrst,
		 card => SYNTHESIZED_WIRE_1,
		 counter_taulell => counter_taulell,
		 keycode_in => keycode,
		 new_card => SYNTHESIZED_WIRE_2,
		 consult => consult_ALTERA_SYNTHESIZED,
		 Card_1_sent => Card_1_sent,
		 Card_2_sent => Card_2_sent,
		 Incorrect => Incorrect,
		 card_1 => card_1,
		 card_2 => card_2,
		 keycode_out => SYNTHESIZED_WIRE_0);

consult <= consult_ALTERA_SYNTHESIZED;
Card_1_sent_out <= Card_1_sent;
Card_2_sent_out2 <= Card_2_sent;

END bdf_type;