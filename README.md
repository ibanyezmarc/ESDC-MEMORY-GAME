# ESDC MEMORY GAME
Final Project done by Marc Ibànyez i Torres, Eneko Ibarlucea Sòria i Gerard Sant Muniesa
General description:
	- Our memory game system is designed to be a two-player game that runs on two separate FPGA boards, with a VGA monitor connected to each board and a keyboard for each player to input their moves. 
	
	- The game consists of one round where you don’t see the cards the other player selects, and the winner is determined by the one finishing the board earlier or by the one with more paired cards.
	
	- The user has to select two different cards (choosing row and column) and check if they are a pair until all the cards are paired.
	
	- We will use a ROM memory to store the different board combinations and select one randomly for each match. 
	
	- The board will display a grid of 4x4. We will store 8 different board combinations and choose one of them randomly each match.
	
	- The game ends when one of the players manages to win completing the board or in case of a tie, the amount of pairs made by each user will be the factor determining the winner.
	
	- A player is considered to have won if he manages to discover all the pairs before his opponent (STOP_TIMER flag active high) or if the number of pairs found at the end of the 90 second timer is greater than that of his opponent.
