class ChessGame
	attr_accessor :current_player, :board, :white_player, :black_player

	def initialize
		@white_player = Player.new("White")
		@black_player = Player.new("Black")
		@current_player = @white_player
		@board = Chessboard.new(@white_player, @black_player)
	end

	#moving a piece from one square to another
	#will need to check if move is legal
	#will need to capture piece if applicable

	#not sure how to connect the situations here to the output, you can't move there, captured a piece, etc
	def move_piece(from, to)
		status_message = ""
		possible_target_squares = identify_legal_moves(from)
		if possible_target_squares.include?(to)
			if board.squares[to] != nil
				status_message = "captured"
			else
				status_message = "moved"
			end
			moving_piece = @board.squares[from]
			@board.squares[to] = moving_piece
			@board.squares[from] = nil
		else
			status_message = "not allowed"
		end
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
			return legal_moves
		end
	end

	#forward one if blank, diagonal if full.  Forgot to put two forward on first turn
	def find_pawn_move(current_square)
		potential_pawn_moves = []
		
		#determine which direction is "forward"
		if @current_player .color == "White"
			starting_row = 2
			forward = 1
		else
			starting_row = 7
			forward = -1
		end 
		
		#move forward one square if empty
		current_key = current_square
		try_this_square_key = [current_key[0] + forward, current_key[1]]
		if @board.squares[try_this_square_key] == nil 
			potential_pawn_moves.push(try_this_square_key)
		end

		#move forward two squares if first time moving
		if current_key[0] == starting_row
			first_move_square_key = [current_key[0] + (forward * 2), current_key[1]]
			if @board.squares[first_move_square_key] == nil 
				potential_pawn_moves.push(first_move_square_key)
			end
		end
		
		#move forward diagonally if capturing
		test_capture_keys = [[current_key[0] + 1, current_key[1] - 1], [current_key[0] + 1, current_key[1] + 1]]
		test_capture_keys.each do |square|
			unless @board.squares[square] == nil 
				if @board.squares[square].owner != @current_player 
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
	def find_rook_move(current_square)
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
					if @board.squares[test_this_square] == nil 
						#add to the array of possible moves
						legal_rook_moves.push(test_this_square)
					#if there is a piece here
					else 
						#add to the array only if it's the opposite color
						if @board.squares[test_this_square].owner != @current_player 
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
	def find_knight_move(current_square)
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
				if @board.squares[move] == nil || @board.squares[move].owner != @current_player 
					legal_knight_moves.push(move)
				end
			end
		end
		return legal_knight_moves
	end

	#Four diagonal directions, all squares until you capture or are blocked by own color
	def find_bishop_move(current_square)
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
					if @board.squares[test_this_square] == nil 
						#add to the array of possible moves
						legal_bishop_moves.push(test_this_square)
					#if there is a piece here
					else 
						#add to the array only if it's the opposite color
						if @board.squares[test_this_square].owner != @current_player 
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
	def find_queen_move(current_square)
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
					if @board.squares[test_this_square] == nil 
						#add to the array of possible moves
						legal_queen_moves.push(test_this_square)
					#if there is a piece here
					else 
						#add to the array only if it's the opposite color
						if @board.squares[test_this_square].owner != @current_player 
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
	def find_king_move(current_square)
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
				if @board.squares[move] == nil || @board.squares[move].owner != @board.squares[current_square].owner
					legal_king_moves.push(move)
				end
			end
		end

		#omit moves that would result in check
		check_free_king_moves = []
		legal_king_moves.each do |move|
			 if check_for_check(move)
			 	check_free_king_moves.push(move)
			 end
		end


		return check_free_king_moves


	end

	def check_for_check(square_to_test)
		move_is_okay = true
		

		pawn_could_kill_from_here = @current_player.color == "White" ? [[square_to_test[0] + 1, square_to_test[1] + 1]] : [square_to_test[0] + 1, square_to_test[1] - 1]
		pawn_could_kill_from_here.each do |square|
			if square[0].between?(1, 8) && square[1].between?(1, 8)
				if @board.squares[square]
					if @board.squares[square].owner != @current_player && @board.squares[square].rank == "Pawn"
						move_is_okay = false
					end
				end
			end
		end

		rook_could_kill_from_here = find_rook_move(square_to_test)
		rook_could_kill_from_here.each do |square|
			if @board.squares[square]
				if @board.squares[square].owner != @current_player && @board.squares[square].rank == "Rook"
					move_is_okay = false
				end
			end
		end

		knight_could_kill_from_here = find_knight_move(square_to_test)
		knight_could_kill_from_here.each do |square|
			if @board.squares[square]
				if @board.squares[square].owner != @current_player && @board.squares[square].rank == "Knight"
					move_is_okay = false
				end
			end
		end

		bishop_could_kill_from_here = find_bishop_move(square_to_test)
		bishop_could_kill_from_here.each do |square|
			if @board.squares[square]
				if @board.squares[square].owner != @current_player && @board.squares[square].rank == "Bishop"
					move_is_okay = false
				end
			end
		end

		queen_could_kill_from_here = find_queen_move(square_to_test)
		queen_could_kill_from_here.each do |square|
			if @board.squares[square]
				if @board.squares[square].owner != @current_player && @board.squares[square].rank == "Queen"
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
			if @board.squares[square]
				if @board.squares[square].owner != @current_player && @board.squares[square].rank == "King"
					move_is_okay = false
				end
			end
		end

		return move_is_okay
	end

	#move to a square and capture a piece
	def capture_piece(current_square, target_square)

	end

end
