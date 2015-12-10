class Chesspiece

	attr_accessor :owner, :rank, :icon

	def initialize(owner, rank, icon = nil)
		@owner = owner #owner is a Player object
		@rank = rank #string
		@icon = icon #string for now
	end

end
