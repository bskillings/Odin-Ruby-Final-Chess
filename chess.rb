#Okay, how am i even going to think about this?

#What are some things I need

#I need to keep track of the pieces and who they belong to
#and what moves they can make, both in general and from the square they're on

#I need to keep track of the king's relative location for check and checkmate

#I need to keep they players separate, and have a visual representation of whose piece

# so I will need:

class Player

	attr_accessor :color

	def initialize(color)
		@color = color
	end

end

class Chesspiece

	attr_accessor :owner, :rank, :icon

	def initialize(owner, rank, icon = nil)
		@owner = owner #owner is a Player object
		@rank = rank
		@icon = icon
		#I may run the locations through Gameboard instead.  I'll see which needs it more
	end

end

class Chessboard

	attr_accessor :squares

	#squares is a hash with string keys denoting location of squares
	#each element is one square
	#square "1-1" is at the top left, "1-2" is to its right, "2-1" is below
	#the value of the hash element is the piece that's currently there, or nil
	
	def initialize(w_player, b_player)
		@white_player = w_player
		@black_player = b_player
		@squares = create_game_board
		populate_game_board
	end

	#create the hash of locations
	def create_game_board
		empty_chessboard = {}
		i = 1
		while i < 9 do
			j = 1
			while j < 9 do
				new_key = "#{i}-#{j}"
				empty_chessboard[new_key] = nil
				j += 1
			end
			i += 1
		end
		return empty_chessboard
	end

	#fill hash with inital pieces in their initial locations
	def populate_game_board
		set_up_pieces(@white_player)
		set_up_pieces(@black_player)
	end

	#set up one player's pieces
	def set_up_pieces(owner)
		if owner == @white_player 
			row_to_fill = 1
			color = "W"
		else
			row_to_fill = 8
			color = "B"
		end
		
		#Creating back row
		@squares["#{row_to_fill}-1"] = Chesspiece.new(owner, "Rook", "#{color}R")
		@squares["#{row_to_fill}-2"] = Chesspiece.new(owner, "Knight", "#{color}N")
		@squares["#{row_to_fill}-3"] = Chesspiece.new(owner, "Bishop", "#{color}B")
		@squares["#{row_to_fill}-6"] = Chesspiece.new(owner, "Bishop", "#{color}B")
		@squares["#{row_to_fill}-7"] = Chesspiece.new(owner, "Knight", "#{color}N")
		@squares["#{row_to_fill}-8"] = Chesspiece.new(owner, "Rook", "#{color}R")

		#creating king and queen on correct side
		if owner == @white_player
			@squares["#{row_to_fill}-4"] = Chesspiece.new(owner, "King", "#{color}K")
			@squares["#{row_to_fill}-5"] = Chesspiece.new(owner, "Queen", "#{color}Q")
		else
			@squares["#{row_to_fill}-5"] = Chesspiece.new(owner, "King", "#{color}Q")
			@squares["#{row_to_fill}-4"] = Chesspiece.new(owner, "Queen", "#{color}K")
		end

		#create pawns
		row_to_fill = owner == @white_player ? 2 : 7
		j = 1
		while j < 9
			@squares["#{row_to_fill}-#{j}"] = Chesspiece.new(owner, "Pawn", "#{color}P")
			j += 1
		end
	end

	#build a string that the io can print out on the command line
	def create_chessboard_string

		chessboard_string = "\r\n     1   2   3   4   5   6   7   8"
		i = 1
		while i < 9
			chessboard_string.concat("\r\n")
			chessboard_string.concat(" #{i}  ")
			j = 1
			while j < 9
				add_me = ""
				current_key = "#{i}-#{j}"
				if @squares[current_key] == nil
					add_me = " -- "
				else
					add_me = " #{@squares[current_key].icon} "
				end
				chessboard_string.concat(add_me)
				j += 1
			end
			i += 1
		end
		return chessboard_string
	end
end

class ChessIO

	#this will include getting moves from the player, 
	#showing the current state of the board
	#outputting "you can't move there", etc
	#announcing the winner
	def initialize
		@game = ChessGame.new
		puts @game.board.create_chessboard_string
	end

end

class ChessGame
	attr_accessor :current_player, :board

	def initialize
		@white_player = Player.new("White")
		@black_player = Player.new("Black")
		@current_player = @white_player
		@board = Chessboard.new(@white_player, @black_player)
	end

	#moving a piece from one square to another
	def move_piece(from, to)
		moving_piece = @board.squares[from]
		@board.squares[to] = moving_piece
		@board.squares[from] = nil
	end

end

start = ChessIO.new