class Move

	#This class contains all of the move logic for all of the pieces

	def initialize(squares, from, to)
		@squares = squares
		@from = from
		@to = to
	end


	#check if a given move is legal
	def is_this_move_legal
		current_piece = @squares[@from]
		possible_target_squares = identify_legal_moves(@from, @squares[@from].owner)
		unless possible_target_squares.include?(@to)
			return false
		else
			return true
		end
	end



	#create an array of legal moves for a given piece from a given square
	#array elements are the keys of legal squares
	#check direction, length, and if any pieces (yours or theirs) are in the way
	def identify_legal_moves(current_square, current_player)
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
			 if is_this_piece_in_danger(move, current_player) == []
			 	check_free_king_moves.push(move)
			 end
		end


		return check_free_king_moves


	end

	def is_this_piece_in_danger(square_to_test, current_player)
		#returns the coordinates of pieces that can attack
		pieces_that_can_attack = []
		

		pawn_could_kill_from_here = current_player.color == "White" ? [[square_to_test[0] + 1, square_to_test[1] + 1]] : [square_to_test[0] + 1, square_to_test[1] - 1]
		pawn_could_kill_from_here.each do |square|
			if square[0].between?(1, 8) && square[1].between?(1, 8)
				if @squares[square]
					if @squares[square].owner != current_player && @squares[square].rank == "Pawn"
						pieces_that_can_attack.push(square)
					end
				end
			end
		end

		rook_could_kill_from_here = find_rook_move(square_to_test, current_player)
		rook_could_kill_from_here.each do |square|
			if @squares[square]
				if @squares[square].owner != current_player && @squares[square].rank == "Rook"
					pieces_that_can_attack.push(square)
				end
			end
		end

		knight_could_kill_from_here = find_knight_move(square_to_test, current_player)
		knight_could_kill_from_here.each do |square|
			if @squares[square]
				if @squares[square].owner != current_player && @squares[square].rank == "Knight"
					pieces_that_can_attack.push(square)
				end
			end
		end

		bishop_could_kill_from_here = find_bishop_move(square_to_test, current_player)
		bishop_could_kill_from_here.each do |square|
			if @squares[square]
				if @squares[square].owner != current_player && @squares[square].rank == "Bishop"
					pieces_that_can_attack.push(square)
				end
			end
		end

		queen_could_kill_from_here = find_queen_move(square_to_test, current_player)
		queen_could_kill_from_here.each do |square|
			if @squares[square]
				if @squares[square].owner != current_player && @squares[square].rank == "Queen"
					pieces_that_can_attack.push(square)
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
					pieces_that_can_attack.push(square)
				end
			end
		end

		return pieces_that_can_attack

		#thought of another edge case!
		#king moves farther down line of attack.  Would this show up?
		#I don't think so because the king blocks it for now
	end

	def identify_checkmate(king_location, current_player, attacking_player)
		#check if king can move using is_this_piece_in_danger
		can_king_move = false
		can_attacker_be_captured = false
		can_attacker_be_blocked = false

		#attacking pieces is an array of coordinates of pieces that can attack
		attacking_pieces = is_this_piece_in_danger(king_location, current_player)
		if attacking_pieces == []
			can_king_move == true
		
		else #neither of the following are relevant unless there are attackers
		
			#check if attacker can be captured
			attacking_pieces.each do |attacker|
				can_kill_attacker = is_this_piece_in_danger(attacker, attacking_player)
				if can_kill_attacker.any?
					can_attacker_be_captured = true
				end 
			end
			
			#check if attacker can be blocked
			attackers_that_cannot_be_blocked = []
			attacking_pieces.each do |attacker|
				attacker_moves = identify_legal_moves(attacker, attacking_player)

				#copy piece to king location, test, put king back
				king_placeholder = @squares[king_location]
				@squares[king_location] = @squares[attacker]
				moves_from_king = identify_legal_moves(king_location, attacking_player)
				@squares[king_location] = king_placeholder

				#make an array of all squares in both groups
				between_squares = []
				attacker_moves.each do |between|
					if moves_from_king.include?(between)
						between_squares.push(between)
					end
				end

				#test all between squares
				between_squares.each do |between|
					pieces_that_can_block = is_this_piece_in_danger(between, attacking_player)
					if pieces_that_can_block.any?
						can_attacker_be_blocked = true
					end
					#not perfect because for example the queen could have the same
					#move show up on both in another direction
					#direction is so fragmented across pieces though
				end
			end
		end
		
		if can_king_move || can_attacker_be_captured || can_attacker_be_blocked
			return true
		else
			return false
		end

	end

end