#Okay, how am i even going to think about this?

#What are some things I need

#I need to keep track of the pieces and who they belong to
#and what moves they can make, both in general and from the square they're on

#I need to keep track of the king's relative location for check and checkmate

#I need to keep they players separate, and have a visual representation of whose piece

# so I will need:

class Player

	attr_accessor :color, :location_of_king

	def initialize(color)
		@color = color
		@location_of_king = nil
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
				new_key = [i, j]
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
		@squares[[row_to_fill, 1]] = Chesspiece.new(owner, "Rook", "#{color}R")
		@squares[[row_to_fill, 2]] = Chesspiece.new(owner, "Knight", "#{color}N")
		@squares[[row_to_fill, 3]] = Chesspiece.new(owner, "Bishop", "#{color}B")
		@squares[[row_to_fill, 6]] = Chesspiece.new(owner, "Bishop", "#{color}B")
		@squares[[row_to_fill, 7]] = Chesspiece.new(owner, "Knight", "#{color}N")
		@squares[[row_to_fill, 8]] = Chesspiece.new(owner, "Rook", "#{color}R")

		#creating king and queen on correct side
		if owner == @white_player
			@squares[[row_to_fill, 4]] = Chesspiece.new(owner, "King", "#{color}K")
			owner.location_of_king = "#{row_to_fill}-4"
			@squares[[row_to_fill, 5]] = Chesspiece.new(owner, "Queen", "#{color}Q")
		else
			@squares[[row_to_fill, 5]] = Chesspiece.new(owner, "King", "#{color}Q")
			owner.location_of_king = "#{row_to_fill}-5"
			@squares[[row_to_fill, 4]] = Chesspiece.new(owner, "Queen", "#{color}K")
		end

		#create pawns
		row_to_fill = owner == @white_player ? 2 : 7
		j = 1
		while j < 9
			@squares[[row_to_fill, j]] = Chesspiece.new(owner, "Pawn", "#{color}P")
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
				current_key = [i, j]
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
	#will need to check if move is legal
	#will need to capture piece if applicable
	def move_piece(from, to)
		moving_piece = @board.squares[from]
		@board.squares[to] = moving_piece
		@board.squares[from] = nil
	end

	#create an array of legal moves for a given piece from a given square
	#array elements are the keys of legal squares
	#check direction, length, and if any pieces (yours or theirs) are in the way
	def identify_legal_moves(current_square)
		current_piece_rank = @board.squares[current_square].rank
		legal_moves = []

		case current_piece_rank
		when "Pawn"
			legal_moves = find_pawn_move(current_square)
		when "Rook"
			legal_moves = find_rook_move(current_square)
		when "Knight"
			legal_moves = find_knight_move(current_square)
		when "Bishop"
			legal_moves = find_bishop_move(current_square)
		when "Queen"
			legal_moves = find_queen_move(current_square)
		when "King"
			legal_moves = find_king_move(current_square)
		else 
			return
		end
		#it seems like cases would come in handy here
		#figuring out where the king can move is going to be a pain
	end

	#forward one if blank, diagonal if full.  Forgot to put two forward on first turn
	def find_pawn_move(current_square)
		legal_pawn_moves = []
		if @board.squares[current_square].owner.color == "White"
			starting_row = 2
			forward = 1
		else
			starting_row = 7
			forward = -1
		end 
		current_key = current_square
		try_this_square_key = [current_key[0] + forward, current_key[1]]
		if @board.squares[try_this_square_key] == nil && try_this_square_key[0] > 0 && try_this_square_key[0] < 9
			legal_pawn_moves.push(try_this_square_key)
		end

		if current_key[0] == starting_row
			first_move_square_key = [current_key[0] + (forward * 2), current_key[1]]
			if @board.squares[first_move_square_key] == nil && first_move_square_key[0] > 0 && first_move_square_key[0] < 9
				legal_pawn_moves.push(first_move_square_key)
			end
		end
test_capture_keys = [[current_key[0] + 1, current_key[1] - 1], [current_key[0] + 1, current_key[1] + 1]]
		test_capture_keys.each do |square|
			unless @board.squares[square] == nil 
				if square[0].between?(1, 8) && square[1].between?(1, 8)
					if @board.squares[square].owner != @current_player 
						legal_pawn_moves.push(square)
					end
				end
			end 
		end
		capture_right_key = [current_key[0] + 1, current_key[1] + 1]
		unless @board.squares[capture_right_key] == nil 
			if capture_right_key[0].between?(1, 8) && capture_right_key[1].between?(1, 8)
				if @board.squares[capture_right_key].owner == @current_player 
					puts "That's your piece" 
					#placeholder
				else
					legal_pawn_moves.push(capture_right_key)
				end
				
			end 
		end
		return legal_pawn_moves
	end

	#four cardinal directions, all squares until you capture or are blocked by own color
	def find_rook_move(current_square)

	end

	#find eight places for knights to go, not off board or on same color piece
	def find_knight_move(current_square)

	end

	#Four diagonal directions, all squares until you capture or are blocked by own color
	def find_bishop_move(current_square)

	end

	#eight directions, all squares until you capture or are blocked by own color
	def find_queen_move(current_square)

	end

	#eight directions unless same color or moving into check
	def find_king_move(current_square)

	end

	#move to a square and capture a piece
	def capture_piece(current_square, target_square)

	end

end

start = ChessIO.new

#after I have the piece moves defined I can start testing the logic
#Then I will implement the io