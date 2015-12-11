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
	#ugh I figured it out it's probably event handlers ugh ugh ugh


		#piece moving logic has been moved to ChessBoard
		#realistically event handlers would replace the status messages
		def move_piece(from, to)
		current_piece = @board.squares[from]
		possible_target_squares = @board.identify_legal_moves(from, @current_player)
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

	#move to a square and capture a piece
	def capture_piece(current_square, target_square)

	end

end
