require "spec_helper"

describe Chessboard do 

	before(:each) do
		@board = Chessboard.new(HumanPlayer.new("White"), HumanPlayer.new("Black"))
	end

	context "when moving" do

		context "pawns" do

			it "locate acceptable moves" do
				@board.squares.each do |k, v|
					@board.squares[k] = nil
				end
				@board.squares[[2, 3]] = Chesspiece.new(@board.white_player, "Pawn", "WP")
				@board.squares[[3, 2]] = Chesspiece.new(@board.black_player, "Rook", "BR")
				legal_pawn_moves = @board.find_pawn_move([2, 3], @board.white_player)
				expect(legal_pawn_moves).to contain_exactly([3, 3], [4, 3], [3, 2])
			end
		
		end

		context "rooks" do

			it "locate acceptable moves" do
				@board.squares.each do |k, v|
					@board.squares[k] = nil
				end
				@board.squares[[4, 4]] = Chesspiece.new(@board.white_player, "Rook", "WR")
				@board.squares[[4, 6]] = Chesspiece.new(@board.white_player, "Rook", "WR")
				@board.squares[[1, 4]] = Chesspiece.new(@board.black_player, "Rook", "BR")
				legal_rook_moves = @board.find_rook_move([4, 4], @board.white_player)
				expect(legal_rook_moves).to contain_exactly([3, 4], [2, 4], [1, 4], [4, 5], [5, 4], [6, 4], [7, 4], [8, 4], [4, 3], [4, 2], [4, 1])

			end

		end

		context "bishops" do

			it "locate acceptable moves" do
				@board.squares.each do |k, v|
					@board.squares[k] = nil
				end
				@board.squares[[4, 4]] = Chesspiece.new(@board.white_player, "Bishop", "WB")
				@board.squares[[7, 7]] = Chesspiece.new(@board.white_player, "Rook", "WR")
				@board.squares[[3, 5]] = Chesspiece.new(@board.black_player, "Rook", "BR")
				legal_bishop_moves = @board.find_bishop_move([4, 4], @board.white_player)
				expect(legal_bishop_moves).to contain_exactly([3, 5], [5, 5], [6, 6], [5, 3], [6, 2], [7, 1], [3, 3], [2, 2], [1, 1])
			end

		end

		context "knights" do

			it "locate acceptable moves" do
				@board.squares.each do |k, v|
					@board.squares[k] = nil
				end
				@board.squares[[2, 5]] = Chesspiece.new(@board.white_player, "Knight", "WN")
				@board.squares[[4, 4]] = Chesspiece.new(@board.white_player, "Rook", "WR")
				@board.squares[[3, 7]] = Chesspiece.new(@board.black_player, "Rook", "BR")
				legal_knight_moves = @board.find_knight_move([2, 5], @board.white_player)
				expect(legal_knight_moves).to contain_exactly([1, 3], [3, 3], [4, 6], [1, 7], [3, 7])
			end
			
		end

		context "queens" do

			it "locate acceptable moves" do
				@board.squares.each do |k, v|
					@board.squares[k] = nil
				end
				@board.squares[[4, 4]] = Chesspiece.new(@board.white_player, "Queen", "WB")
				@board.squares[[7, 7]] = Chesspiece.new(@board.white_player, "Rook", "WR")
				@board.squares[[3, 5]] = Chesspiece.new(@board.black_player, "Rook", "BR")
				@board.squares[[4, 6]] = Chesspiece.new(@board.white_player, "Rook", "WR")
				@board.squares[[1, 4]] = Chesspiece.new(@board.black_player, "Rook", "BR")
				legal_queen_moves = @board.find_queen_move([4, 4], @board.white_player)
				expect(legal_queen_moves). to contain_exactly([3, 4], [2, 4], [1, 4], [3, 5], [5, 5], [6, 6], [4, 5], [5, 3], [6, 2], [7, 1], [5, 4], [6, 4], [7, 4], [8, 4], [3, 3], [2, 2], [1, 1], [4, 3], [4, 2], [4, 1])
			end

		end

		context "kings" do

			it "locate acceptable moves" do
				@board.squares.each do |k, v|
					@board.squares[k] = nil
				end
				@board.squares[[1, 5]] = Chesspiece.new(@board.white_player, "King", "WK")
				@board.squares[[1, 4]] = Chesspiece.new(@board.white_player, "Rook", "WR")
				@board.squares[[2, 5]] = Chesspiece.new(@board.black_player, "Knight", "BN")
				legal_king_moves = @board.find_king_move([1, 5], @board.white_player)
				expect(legal_king_moves).to contain_exactly([1, 6], [2, 4], [2, 5], [2, 6])
			end
			
			it "will not move into check" do
				@board.squares.each do |k, v|
					@board.squares[k] = nil
				end
				@board.squares[[1, 5]] = Chesspiece.new(@board.white_player, "King", "WK")
				@board.squares[[1, 4]] = Chesspiece.new(@board.white_player, "Rook", "WR")
				@board.squares[[2, 5]] = Chesspiece.new(@board.black_player, "Knight", "BN")
				@board.squares[[3, 2]] = Chesspiece.new(@board.black_player, "Knight", "BN")
				@board.squares[[4, 7]] = Chesspiece.new(@board.black_player, "Bishop", "BB")
				legal_king_moves = @board.find_king_move([1, 5], @board.white_player)
				expect(legal_king_moves).to contain_exactly([1, 6], [2, 6])
			end

		end

	end

end


describe ChessGame do

	before(:each) do
		@game = ChessGame.new
	end

	context "when moving" do

		context "pawns" do

			it "move correctly" do
				this_pawn = @game.board.squares[[2, 1]]
				@game.move_piece([2, 1], [3, 1])
				expect(@game.board.squares[[3, 1]]).to eq(this_pawn)
			end

		end

		context "rooks" do

			it "move correctly" do
				@game.board.squares[[2, 1]] = nil
				this_rook = @game.board.squares[[1, 1]]
				@game.move_piece([1, 1], [4, 1])
				expect(@game.board.squares[[4, 1]]).to eq(this_rook)
			end

		end

		context "bishops" do

			it "move correctly" do
				@game.board.squares[[2, 2]] = nil
				this_bishop = @game.board.squares[[1, 3]]
				@game.move_piece([1, 3], [3, 1])
				expect(@game.board.squares[[3, 1]]).to eq(this_bishop)
			end

		end

		context "knights" do

			it "move correctly" do
				@game.board.squares[[2, 2]] = nil
				this_knight = @game.board.squares[[1, 3]]
				@game.move_piece([1, 3], [3, 1])
				expect(@game.board.squares[[3, 1]]).to eq(this_knight)
			end
		end

		context "queens" do

			it "move correctly" do
				@game.board.squares[[2, 2]] = nil
				this_queen = @game.board.squares[[1, 3]]
				@game.move_piece([1, 3], [3, 1])
				expect(@game.board.squares[[3, 1]]).to eq(this_queen)
			end

		end

		context "kings" do

			it "move correctly" do
				@game.board.squares[[2, 4]] = nil
				this_king = @game.board.squares[[1, 4]]
				@game.move_piece([1, 4], [2, 4])
				expect(@game.board.squares[[2, 4]]).to eq(this_king)
			end

		end

	end

end
