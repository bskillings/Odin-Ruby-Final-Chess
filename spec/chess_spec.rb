require "spec_helper"

describe ChessGame do 

	before(:each) do
		@game = ChessGame.new
	end

	context "when evaluating possible moves" do

		it "pawn locates correct moves" do
			@game.move_piece([7, 1], [3, 2])
			legal_pawn_moves = @game.find_pawn_move([2, 3])
			expect(legal_pawn_moves).to eq [[3, 3], [4, 3], [3, 2]]
		end

	end
	
end