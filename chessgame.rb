class ChessGame
	attr_accessor :current_player, :board, :white_player, :black_player

	def initialize
		@white_player = HumanPlayer.new("White")
		@black_player = HumanPlayer.new("Black")
		@current_player = @white_player
		@board = Chessboard.new(@white_player, @black_player)
		@game_over = false
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
			move_piece(from, to)
			#if something something, game_over = true
			@current_player = (@current_player == @white_player) ? @black_player : @white_player
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
