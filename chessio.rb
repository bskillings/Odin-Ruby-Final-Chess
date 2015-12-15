

class ChessIO

	attr_accessor :test
	#this will include getting moves from the player, 
	#showing the current state of the board
	#outputting "you can't move there", etc
	#announcing the winner
	def initialize
		@game = ChessGame.new
	end


end
