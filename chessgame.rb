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


	def take_turn

		while @game_over == false
			puts @board.create_chessboard_string

			from = @current_player.get_from(@board)
			#if from is game, go to game functions, else go on and get to
			while from == "game"
				file_actions
				from = @current_player.get_from(@board)
			end

			to = @current_player.get_to(@board, from)
			while to == [0]
				from = @current_player.get_from(@board)
				to = @current_player.get_to(@board, from)
			end

			move_piece(from, to)
			@opposing_player = @current_player
			@current_player = (@current_player == @white_player) ? @black_player : @white_player
			#find out if this move puts the king in check
			opponent_king_location = []
			@board.squares.each do|k, v| 
				unless v == nil
					if v.owner == @current_player && v.rank == "King"
						opponent_king_location.push(k)
					end
				end
			end
			if @opposing_player.chosen_move.is_this_piece_in_danger(opponent_king_location[0], @current_player) == false
				puts "#{@current_player.color} King is in check!"
			end
			if @opposing_player.chosen_move.identify_checkmate(opponent_king_location[0], @current_player, @opposing_player) == true
				@game_over = true
				puts "#{current_player.color} King is in checkmate!"
				puts "Game over!"
			end
		end
		#I don't like how the current player swaps

	end

	#identifying legal moves happens while player in inputting their move
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

	def file_actions
		puts "Type \"save\", \"load\", or \"exit\""
		action = gets.chomp.downcase
		case action
		when "save"
			save_game
		when "load"
			load_game
		when "exit"
			puts "Please press Ctrl-C to exit"
			dummy = gets
		else
			puts "Did not understand, returning to game"
		end
	end

	def save_game 
		puts "Name your savegame"
		filename = gets.chomp
		save_array = Array.new [@board, @current_player]
		File.open("#{filename}.yaml", "w") {|f| f.write(YAML::dump(save_array))}
		puts "#{filename}.yaml saved"
	end

	def load_game
		puts "Type the name of your savegame"
		filename = gets.chomp
		file_to_load = File.new("#{filename}.yaml")
		load_array = YAML::load(file_to_load)
		puts "#{filename}.yaml loaded"
		@board = load_array[0]
		@current_player = load_array[1]
		puts @board.create_chessboard_string
	end


end
