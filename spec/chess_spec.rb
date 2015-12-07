require "spec_helper"

describe ChessGame do 

	before(:each) do
		@game = ChessGame.new
	end

	context "when evaluating possible moves" do

		it "pawn locates correct moves" do
			@game.move_piece([7, 1], [3, 2])
			legal_pawn_moves = @game.find_pawn_move([2, 3])
			expect(legal_pawn_moves).to contain_exactly([3, 3], [4, 3], [3, 2])
		end

		it "rook locates correct moves" do
			@game.board.squares.each do |k, v|
				@game.board.squares[k] = nil
			end
			@game.board.squares[[4, 4]] = Chesspiece.new(@game.white_player, "Rook", "WR")
			@game.board.squares[[4, 6]] = Chesspiece.new(@game.white_player, "Rook", "WR")
			@game.board.squares[[1, 4]] = Chesspiece.new(@game.black_player, "Rook", "BR")
			legal_rook_moves = @game.find_rook_move([4, 4])
			expect(legal_rook_moves).to contain_exactly([3, 4], [2, 4], [1, 4], [4, 5], [5, 4], [6, 4], [7, 4], [8, 4], [4, 3], [4, 2], [4, 1])

		end

		it "bishop locates correct moves" do
			@game.board.squares.each do |k, v|
				@game.board.squares[k] = nil
			end
			@game.board.squares[[4, 4]] = Chesspiece.new(@game.white_player, "Bishop", "WB")
			@game.board.squares[[7, 7]] = Chesspiece.new(@game.white_player, "Rook", "WR")
			@game.board.squares[[3, 5]] = Chesspiece.new(@game.black_player, "Rook", "BR")
			legal_bishop_moves = @game.find_bishop_move([4, 4])
			expect(legal_bishop_moves).to contain_exactly([3, 5], [5, 5], [6, 6], [5, 3], [6, 2], [7, 1], [3, 3], [2, 2], [1, 1])
		end
		
		it "queen locates correct moves" do
			@game.board.squares.each do |k, v|
				@game.board.squares[k] = nil
			end
			@game.board.squares[[4, 4]] = Chesspiece.new(@game.white_player, "Queen", "WB")
			@game.board.squares[[7, 7]] = Chesspiece.new(@game.white_player, "Rook", "WR")
			@game.board.squares[[3, 5]] = Chesspiece.new(@game.black_player, "Rook", "BR")
			@game.board.squares[[4, 6]] = Chesspiece.new(@game.white_player, "Rook", "WR")
			@game.board.squares[[1, 4]] = Chesspiece.new(@game.black_player, "Rook", "BR")
			legal_queen_moves = @game.find_queen_move([4, 4])
			expect(legal_queen_moves). to contain_exactly([3, 4], [2, 4], [1, 4], [3, 5], [5, 5], [6, 6], [4, 5], [5, 3], [6, 2], [7, 1], [5, 4], [6, 4], [7, 4], [8, 4], [3, 3], [2, 2], [1, 1], [4, 3], [4, 2], [4, 1])

		end

	end
	
end