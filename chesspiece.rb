class Chesspiece

	attr_accessor :owner, :rank, :icon

	def initialize(owner, rank, icon = nil)
		@owner = owner #owner is a Player object
		@rank = rank #string
		@icon = icon #string for now
	end

end

#the problem with putting piece move rules here is that it needs to know the status of the 
#rest of the pieces, and it seems inefficient to pass that in

#figure out how to get info from calling class into here