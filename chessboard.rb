
class Chessboard

	attr_accessor :squares

	#squares is a hash with string keys denoting location of squares
	#each element is one square
	#square "1-1" is at the top left, "1-2" is to its right, "2-1" is below
	#the value of the hash element is the piece that's currently there, or nil
	
	def initialize(w_player, b_player)
		@white_player = w_player #player object
		@black_player = b_player #player object
		@squares = create_game_board #hash, see above
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
			@squares[[row_to_fill, 5]] = Chesspiece.new(owner, "Queen", "#{color}Q")
		else
			@squares[[row_to_fill, 5]] = Chesspiece.new(owner, "King", "#{color}Q")
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

		def is_this_move_legal(from, to)
		current_piece = squares[from]
		possible_target_squares = identify_legal_moves(from, squares[from].owner)
		unless possible_target_squares.include?(to)
			return false
		else
			return true
		end
	end



	#create an array of legal moves for a given piece from a given square
	#array elements are the keys of legal squares
	#check direction, length, and if any pieces (yours or theirs) are in the way
	def identify_legal_moves(current_square, current_player)
		#this is being hit twice, and the second time is nil so it barfs
		#am I seriously going to have to copy this into chess.rb so the debugger will work??
		current_piece = @squares[current_square]
		current_piece_rank = current_piece.rank
		legal_moves = []

		case current_piece_rank
		when "Pawn"
			legal_moves = find_pawn_move(current_square, current_player)
		when "Rook"
			legal_moves = find_rook_move(current_square, current_player)
		when "Knight"
			legal_moves = find_knight_move(current_square, current_player)
		when "Bishop"
			legal_moves = find_bishop_move(current_square, current_player)
		when "Queen"
			legal_moves = find_queen_move(current_square, current_player)
		when "King"
			legal_moves = find_king_move(current_square, current_player)
		else 
			print legal_moves
			return legal_moves
		end
	end

	#forward one if blank, diagonal if full.  Forgot to put two forward on first turn
	def find_pawn_move(current_square, current_player)
		potential_pawn_moves = []
		
		#determine which direction is "forward"
		if current_player.color == "White"
			starting_row = 2
			forward = 1
		else
			starting_row = 7
			forward = -1
		end 
		
		#move forward one square if empty
		current_key = current_square
		try_this_square_key = [current_key[0] + forward, current_key[1]]
		if @squares[try_this_square_key] == nil 
			potential_pawn_moves.push(try_this_square_key)
		end

		#move forward two squares if first time moving
		if current_key[0] == starting_row
			first_move_square_key = [current_key[0] + (forward * 2), current_key[1]]
			if @squares[first_move_square_key] == nil 
				potential_pawn_moves.push(first_move_square_key)
			end
		end
		
		#move forward diagonally if capturing
		test_capture_keys = [[current_key[0] + 1, current_key[1] - 1], [current_key[0] + 1, current_key[1] + 1]]
		test_capture_keys.each do |square|
			unless @squares[square] == nil 
				if @squares[square].owner != current_player 
					potential_pawn_moves.push(square)
				end
			end 
		end
		
		#testing to make sure moves do not go off board
		legal_pawn_moves = []
		potential_pawn_moves.each do |move|
			if move[0].between?(1, 8) && move[1].between?(1, 8)
				legal_pawn_moves.push(move)
			end
		end
		
		#return array of possible moves
		return legal_pawn_moves
	end

	#four cardinal directions, all squares until you capture or are blocked by own color
	def find_rook_move(current_square, current_player)
		legal_rook_moves = []
		direction = 1 #up, then will go clockwise

		test_this_square = current_square
		while direction < 5 
			while test_this_square[0].between?(1, 8) && test_this_square[1].between?(1, 8)
				#determine which direction you're traveling
				case direction
				when 1
					test_this_square = [test_this_square[0] - 1, test_this_square[1]]
				when 2
					test_this_square = [test_this_square[0], test_this_square[1] + 1]
				when 3
					test_this_square = [test_this_square[0] + 1, test_this_square[1]]
				when 4
					test_this_square = [test_this_square[0], test_this_square[1] - 1]
				end

				#change direction if owned or edge of board
				if test_this_square[0].between?(1, 8) && test_this_square[1].between?(1, 8)
					#if there is not a piece here
					if @squares[test_this_square] == nil 
						#add to the array of possible moves
						legal_rook_moves.push(test_this_square)
					#if there is a piece here
					else 
						#add to the array only if it's the opposite color
						if @squares[test_this_square].owner != current_player 
							legal_rook_moves.push(test_this_square)
						end
						#if there is any piece here, break out of the loop so you can change direction
						test_this_square = [100, 100]

					#add to possible moves if blank
					end
				end
			end
			direction += 1
			test_this_square = current_square
		end
		return legal_rook_moves
	end

	#find eight places for knights to go, not off board or on same color piece
	def find_knight_move(current_square, current_player)
		#find all possible knight moves
		potential_knight_moves = []
		potential_knight_moves.push([current_square[0] + 1, current_square[1] + 2])
		potential_knight_moves.push([current_square[0] + 2, current_square[1] + 1])
		potential_knight_moves.push([current_square[0] + 2, current_square[1] - 1])
		potential_knight_moves.push([current_square[0] + 1, current_square[1] - 2])
		potential_knight_moves.push([current_square[0] - 1, current_square[1] - 2])
		potential_knight_moves.push([current_square[0] - 2, current_square[1] - 1])
		potential_knight_moves.push([current_square[0] - 2, current_square[1] + 1])
		potential_knight_moves.push([current_square[0] - 1, current_square[1] + 2])

		legal_knight_moves = []
		potential_knight_moves.each do |move|
			#check if square is actually on the board
			if move[0].between?(1, 8) && move[1].between?(1, 8)
				if @squares[move] == nil || @squares[move].owner != current_player 
					legal_knight_moves.push(move)
				end
			end
		end
		return legal_knight_moves
	end

	#Four diagonal directions, all squares until you capture or are blocked by own color
	def find_bishop_move(current_square, current_player)
		legal_bishop_moves = []
		direction = 1 #northeast, then will go clockwise

		test_this_square = current_square
		while direction < 5 
			while test_this_square[0].between?(1, 8) && test_this_square[1].between?(1, 8)
				#determine which direction you're traveling
				case direction
				when 1
					test_this_square = [test_this_square[0] - 1, test_this_square[1] + 1]
				when 2
					test_this_square = [test_this_square[0] + 1, test_this_square[1] + 1]
				when 3
					test_this_square = [test_this_square[0] + 1, test_this_square[1] - 1]
				when 4
					test_this_square = [test_this_square[0] - 1, test_this_square[1] - 1]
				end

				#change direction if owned or edge of board
				if test_this_square[0].between?(1, 8) && test_this_square[1].between?(1, 8)
					#if there is not a piece here
					if @squares[test_this_square] == nil 
						#add to the array of possible moves
						legal_bishop_moves.push(test_this_square)
					#if there is a piece here
					else 
						#add to the array only if it's the opposite color
						if @squares[test_this_square].owner != current_player 
							legal_bishop_moves.push(test_this_square)
						end
						#if there is any piece here, break out of the loop so you can change direction
						test_this_square = [100, 100]

					#add to possible moves if blank
					end
				end
			end
			direction += 1
			test_this_square = current_square
		end
		return legal_bishop_moves

	end

	#eight directions, all squares until you capture or are blocked by own color
	def find_queen_move(current_square, current_player)
		legal_queen_moves = []
		direction = 1 #up, then will go clockwise

		test_this_square = current_square
		while direction < 9 
			while test_this_square[0].between?(1, 8) && test_this_square[1].between?(1, 8)
				#determine which direction you're traveling
				case direction
				when 1
					test_this_square = [test_this_square[0] - 1, test_this_square[1]]
				when 2
					test_this_square = [test_this_square[0] - 1, test_this_square[1] + 1]
				when 3
					test_this_square = [test_this_square[0], test_this_square[1] + 1]
				when 4
					test_this_square = [test_this_square[0] + 1, test_this_square[1] + 1]
				when 5
					test_this_square = [test_this_square[0] + 1, test_this_square[1]]
				when 6
					test_this_square = [test_this_square[0] + 1, test_this_square[1] - 1]
				when 7
					test_this_square = [test_this_square[0], test_this_square[1] - 1]
				when 8
					test_this_square = [test_this_square[0] - 1, test_this_square[1] - 1]
				end

				#change direction if owned or edge of board
				if test_this_square[0].between?(1, 8) && test_this_square[1].between?(1, 8)
					#if there is not a piece here
					if @squares[test_this_square] == nil 
						#add to the array of possible moves
						legal_queen_moves.push(test_this_square)
					#if there is a piece here
					else 
						#add to the array only if it's the opposite color
						if @squares[test_this_square].owner != current_player 
							legal_queen_moves.push(test_this_square)
						end
						#if there is any piece here, break out of the loop so you can change direction
						test_this_square = [100, 100]

					#add to possible moves if blank
					end
				end
			end
			direction += 1
			test_this_square = current_square
		end
		return legal_queen_moves

	end

	#eight directions unless same color or moving into check
	def find_king_move(current_square, current_player)
		potential_king_moves = []
		potential_king_moves.push([current_square[0] + 1, current_square[1]])
		potential_king_moves.push([current_square[0] + 1, current_square[1] + 1])
		potential_king_moves.push([current_square[0], current_square[1] + 1])
		potential_king_moves.push([current_square[0] - 1, current_square[1] + 1])
		potential_king_moves.push([current_square[0] - 1, current_square[1]])
		potential_king_moves.push([current_square[0] - 1, current_square[1] - 1])
		potential_king_moves.push([current_square[0], current_square[1] - 1])
		potential_king_moves.push([current_square[0] + 1, current_square[1] - 1])

		legal_king_moves = []
		potential_king_moves.each do |move|
			#check if square is actually on the board
			if move[0].between?(1, 8) && move[1].between?(1, 8)
				#check if it is empty or contains another piece
				if @squares[move] == nil || @squares[move].owner != @squares[current_square].owner
					legal_king_moves.push(move)
				end
			end
		end

		#omit moves that would result in check
		check_free_king_moves = []
		legal_king_moves.each do |move|
			 if check_for_check(move, current_player)
			 	check_free_king_moves.push(move)
			 end
		end


		return check_free_king_moves


	end

	def check_for_check(square_to_test, current_player)
		move_is_okay = true
		

		pawn_could_kill_from_here = current_player.color == "White" ? [[square_to_test[0] + 1, square_to_test[1] + 1]] : [square_to_test[0] + 1, square_to_test[1] - 1]
		pawn_could_kill_from_here.each do |square|
			if square[0].between?(1, 8) && square[1].between?(1, 8)
				if @squares[square]
					if @squares[square].owner != current_player && @squares[square].rank == "Pawn"
						move_is_okay = false
					end
				end
			end
		end

		rook_could_kill_from_here = find_rook_move(square_to_test, current_player)
		rook_could_kill_from_here.each do |square|
			if @squares[square]
				if @squares[square].owner != current_player && @squares[square].rank == "Rook"
					move_is_okay = false
				end
			end
		end

		knight_could_kill_from_here = find_knight_move(square_to_test, current_player)
		knight_could_kill_from_here.each do |square|
			if @squares[square]
				if @squares[square].owner != current_player && @squares[square].rank == "Knight"
					move_is_okay = false
				end
			end
		end

		bishop_could_kill_from_here = find_bishop_move(square_to_test, current_player)
		bishop_could_kill_from_here.each do |square|
			if @squares[square]
				if @squares[square].owner != current_player && @squares[square].rank == "Bishop"
					move_is_okay = false
				end
			end
		end

		queen_could_kill_from_here = find_queen_move(square_to_test, current_player)
		queen_could_kill_from_here.each do |square|
			if @squares[square]
				if @squares[square].owner != current_player && @squares[square].rank == "Queen"
					move_is_okay = false
				end
			end
		end

		king_could_kill_from_here = []
		one_space_from_king = []
		one_space_from_king.push([square_to_test[0] + 1, square_to_test[1] + 1])
		one_space_from_king.push([square_to_test[0] + 1, square_to_test[1]])
		one_space_from_king.push([square_to_test[0] + 1, square_to_test[1] - 1])
		one_space_from_king.push([square_to_test[0], square_to_test[1] - 1])
		one_space_from_king.push([square_to_test[0] - 1, square_to_test[1] - 1])
		one_space_from_king.push([square_to_test[0] - 1, square_to_test[1]])
		one_space_from_king.push([square_to_test[0] - 1, square_to_test[1] + 1])
		one_space_from_king.push([square_to_test[0], square_to_test[1] + 1])

		one_space_from_king.each do |space|
			if space[0].between?(1, 8) && space[1].between?(1, 8)
				king_could_kill_from_here.push(space)
			end
		end

		king_could_kill_from_here.each do |square|
			if @squares[square]
				if @squares[square].owner != current_player && @squares[square].rank == "King"
					move_is_okay = false
				end
			end
		end

		return move_is_okay
	end


end