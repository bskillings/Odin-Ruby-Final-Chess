require_relative "human_player"
require_relative "computer_player"
require_relative "chesspiece"
require_relative "chessboard"
require_relative "chessgame"
require_relative "move"
require "yaml"




start = ChessGame.new
start.start_game

#list of optional things to do:

	#mess around with coordinates to make them more intuitive

	#implement randomized computer moves	

	#implement sockets
