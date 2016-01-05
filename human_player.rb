
class HumanPlayer

	attr_accessor :color

	def initialize(color)
		@color = color
	end

		#ask for piece to move, accept only if owned by current player
		def get_from(board)
		
			#somewhere in here allow an option for game saving
		puts "#{color}, it's your move."
		puts "Please enter the coordinates of the piece you want to move (vertical coordinate first) like this 1, 2"
		puts "or type \"game\" to save, load, or exit"
		from_okay = false
		from_string = gets.chomp.split(", ")
		if from_string[0] == "game"
			return "game"
		end
		from = from_string.map do |coordinate|
			coordinate.to_i
		end
		while from_okay == false
			if (from[0] < 1 || from[0] > 8) || (from[1] < 1 || from[1] > 8)
				puts "That's not a space"
				puts "Please enter the coordinates of the piece you want to move (vertical coordinate first) like this 1, 2"
				puts "or type \"game\" to save, load, or exit"
				from_string = gets.chomp.split(", ")
				if from_string[0] == "game"
					return "game"
				end
				from = from_string.map do |coordinate|
				coordinate.to_i
			end
			elsif board.squares[from] == nil || board.squares[from].owner != self
				puts "You don't have a piece there"
				puts "Please enter the coordinates of the piece you want to move (vertical coordinate first) like this 1, 2"
				puts "or type \"game\" to save, load, or exit"
				from_string = gets.chomp.split(", ")
				if from_string[0] == "game"
					return "game"
				end
				from = from_string.map do |coordinate|
				coordinate.to_i
			end
			else
				from_okay = true
			end
		end
		return from
	end

	#ask where to move to, accept only if legal move
	def get_to(board, from)
		moving_piece = board.squares[from]
		puts "Where would you like to move your #{moving_piece.owner.color} #{moving_piece.rank}? (0 to move different piece)"
		to_okay = false
		to_string = gets.chomp.split(", ")
		to = to_string.map do |coordinate|
			coordinate.to_i
		end
		while to_okay == false
			if to[0] == 0
				return to
			elsif (to[0] < 1 || to[0] > 8) || (to[1] < 1 || to[1] > 8)
				puts "That's not a space"
				puts "Where would you like to move your ##{moving_piece.owner.color} #{moving_piece.rank}? (0 to move different piece)"
				to_string = gets.chomp.split(", ")
				to = to_string.map do |coordinate|
					coordinate.to_i
				end
			else
				legal_move = board.is_this_move_legal(from, to)
				if legal_move == false
					puts "You can't move there"
					puts "Where would you like to move your ##{moving_piece.owner.color} #{moving_piece.rank}? (0 to move different piece)"
					to_string = gets.chomp.split(", ")
					to = to_string.map do |coordinate|
						coordinate.to_i
					end
				else
					to_okay = true
				end
			end
		end
		return to
	end


end

