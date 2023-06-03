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
-- CREATED		"Wed May 10 17:30:58 2023"

LIBRARY ieee;
USE ieee.std_logic_1164.all; 

LIBRARY work;

ENTITY sim_logica_game IS 
	PORT
	(
		clk :  IN  STD_LOGIC;
		nrst :  IN  STD_LOGIC;
		counter_taulell :  IN  STD_LOGIC_VECTOR(2 DOWNTO 0);
		keycode :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		Incorrect :  OUT  STD_LOGIC;
		card_1 :  OUT  STD_LOGIC_VECTOR(2 DOWNTO 0);
		card_2 :  OUT  STD_LOGIC_VECTOR(2 DOWNTO 0);
		SYNC :  OUT  STD_LOGIC_VECTOR(15 DOWNTO 0);
		SYNC_value_c1 :  OUT  STD_LOGIC_VECTOR(2 DOWNTO 0);
		SYNC_value_c2 :  OUT  STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
END sim_logica_game;

ARCHITECTURE bdf_type OF sim_logica_game IS 

COMPONENT board_status_memory
	PORT(clk : IN STD_LOGIC;
		 nrst : IN STD_LOGIC;
		 Hide : IN STD_LOGIC;
		 Card_1_sent : IN STD_LOGIC;
		 Card_2_sent : IN STD_LOGIC;
		 Card_1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 Card_2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 keycode : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 SYNC : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		 SYNC_value_c1 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		 SYNC_value_c2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
END COMPONENT;

COMPONENT game_module
	PORT(clk : IN STD_LOGIC;
		 nrst : IN STD_LOGIC;
		 counter_taulell : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		 keycode : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		 Hide : OUT STD_LOGIC;
		 Card_1_sent : OUT STD_LOGIC;
		 Card_2_sent : OUT STD_LOGIC;
		 Incorrect : OUT STD_LOGIC;
		 card_1 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		 card_2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
END COMPONENT;

SIGNAL	Card_1_sent :  STD_LOGIC;
SIGNAL	Card_2_sent :  STD_LOGIC;
SIGNAL	card_ALTERA_SYNTHESIZED1 :  STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL	card_ALTERA_SYNTHESIZED2 :  STD_LOGIC_VECTOR(2 DOWNTO 0);
SIGNAL	hide :  STD_LOGIC;


BEGIN 



b2v_inst : board_status_memory
PORT MAP(clk => clk,
		 nrst => nrst,
		 Hide => hide,
		 Card_1_sent => Card_1_sent,
		 Card_2_sent => Card_2_sent,
		 Card_1 => card_ALTERA_SYNTHESIZED1,
		 Card_2 => card_ALTERA_SYNTHESIZED2,
		 keycode => keycode,
		 SYNC => SYNC,
		 SYNC_value_c1 => SYNC_value_c1,
		 SYNC_value_c2 => SYNC_value_c2);


b2v_inst3 : game_module
PORT MAP(clk => clk,
		 nrst => nrst,
		 counter_taulell => counter_taulell,
		 keycode => keycode,
		 Hide => hide,
		 Card_1_sent => Card_1_sent,
		 Card_2_sent => Card_2_sent,
		 Incorrect => Incorrect,
		 card_1 => card_ALTERA_SYNTHESIZED1,
		 card_2 => card_ALTERA_SYNTHESIZED2);

card_1 <= card_ALTERA_SYNTHESIZED1;
card_2 <= card_ALTERA_SYNTHESIZED2;

END bdf_type;