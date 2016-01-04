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
		#if possible moves for king is empty, and if no one can block, 
			#and if no one can kill the attacking piece, checkmate

	#implement save and load

	#implement randomized computer moves	

	#implement sockets

	#also I would really love to split out the gets and puts
	#I think it would be tidier, but I don't know how to do that