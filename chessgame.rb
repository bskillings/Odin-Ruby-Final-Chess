class ChessGame
	attr_accessor :current_player, :board, :white_player, :black_player

	def initialize
		@white_player = HumanPlayer.new("White")
		@black_player = HumanPlayer.new("Black")
		@current_player = @white_player
		@board = Chessboard.new(@white_player, @black_player)
		@game_over = false

	end

	def start_game
		take_turn
	end

	#moving a piece from one square to another
	#will need to check if move is legal
	#will need to capture piece if applicable

	#not sure how to connect the situations here to the output, you can't move there, captured a piece, etc
	#ugh I figured it out it's probably event handlers ugh ugh ugh
	def take_turn

		while @game_over == false
			puts @board.create_chessboard_string
			from = @current_player.get_from(@board)
			to = @current_player.get_to(@board, from)
			while to == [0]
				from = @current_player.get_from(@board)
				to = @current_player.get_to(@board, from)
			end
			move_piece(from, to)
			@current_player = (@current_player == @white_player) ? @black_player : @white_player
			opponent_king_location = []
			@board.squares.each do|k, v| 
				unless v == nil
					if v.owner == @current_player && v.rank == "King"
						opponent_king_location.push(k)
					end
				end
			end
			if @board.check_for_check(opponent_king_location[0], @current_player) == false
				puts "#{@current_player.color} King is in check!"
			end
			#if something something, game_over = true
		end

	end

		#piece moving logic has been moved to ChessBoard
	def move_piece(from, to)
		moving_piece = @board.squares[from]
		puts "Moved #{moving_piece.owner.color} #{moving_piece.rank} from #{from} to #{to}"
		if @board.squares[to]
			captured_piece = @board.squares[to]
			puts "Captured #{captured_piece.owner.color} #{captured_piece.rank}"
		end
		@board.squares[to] = moving_piece
		@board.squares[from] = nil
	end

end
