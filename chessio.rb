class ChessIO

	attr_accessor :test
	#this will include getting moves from the player, 
	#showing the current state of the board
	#outputting "you can't move there", etc
	#announcing the winner
	def initialize
		@game = ChessGame.new
		puts @game.board.create_chessboard_string
	end

#I hate everything

=begin
	def get_move
		puts "#{@game.current_player.color}, it's your move."
		puts "Please enter the coordinates of the piece you want to move (vertical coordinate first) like this 1, 2"
		from_okay = false
		from_string = gets.chomp.split(", ")
		from = from_string.map do |coordinate|
			coordinate.to_i
		end
		while from_okay == false
			if (from[0] < 1 || from[0] > 8) || (from[1] < 1 || from[1] > 8)
				puts "That's not a space"
				puts "Please enter the coordinates of the piece you want to move (vertical coordinate first) like this 1, 2"
			from_string = gets.chomp.split(", ")
			from = from_string.map do |coordinate|
				coordinate.to_i
			end
			elsif @game.board.squares[from] == nil || @game.board.squares[from].owner != @game.current_player
				puts "You don't have a piece there"
				puts "Please enter the coordinates of the piece you want to move (vertical coordinate first) like this 1, 2"
			from_string = gets.chomp.split(", ")
			from = from_string.map do |coordinate|
				coordinate.to_i
			end
			else
				from_okay = true
			end
		end
		puts "Where would you like to move your #{@game.current_player.color} #{@game.board.squares[from].rank}?"
		to_okay = false
		to_string = gets.chomp.split(", ")
		to = to_string.map do |coordinate|
			coordinate.to_i
		end
		while to_okay == false
			if (to[0] < 1 || to[0] > 8) || (to[1] < 1 || to[1] > 8)
				puts "That's not a space"
				puts "Where would you like to move your #{@game.current_player.color} #{@game.board.squares[from].rank}?"
				to = gets.chomp.split(", ")
			else
				move_message = @game.move_piece(from, to)
				case move_message 
				when "not allowed"
					puts "That move is not allowed"
					puts "Where would you like to move your #{@game.current_player.color} #{@game.board.squares[from].rank}?"
					to = gets.chomp.split(", ")
				when "moved"
					puts "Moved your #{@game.current_player.color} #{@game.board.squares[from].rank} to square #{to}" 
					to_okay = true
				when "captured"
				end
			end
		end
	end
=end
end
