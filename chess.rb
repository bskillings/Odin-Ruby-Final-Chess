require_relative "human_player"
require_relative "computer_player"
require_relative "chesspiece"
require_relative "chessboard"
require_relative "chessgame"



start = ChessGame.new
start.start_game

#list of things to do:

	#mess around with coordinates to make them more intuitive

	#figure out and implement check and checkmate
		#maybe at the first of every turn, check for check to see if check
		#if possible moves for king is empty, and if no one can block, checkmate

	#implement save and load

	#implement randomized computer moves	

	#implement sockets